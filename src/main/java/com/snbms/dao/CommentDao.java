package com.snbms.dao;

import com.snbms.model.Comment;
import com.snbms.config.DatabaseConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CommentDao {
    
    private static final String[] AVATAR_COLORS = {
        "avatar-blue", "avatar-green", "avatar-red", "avatar-purple", "avatar-teal"
    };

    // Constructor
    private Comment mapResultSetToComment(ResultSet rs, int cycleIndex) throws SQLException {
        Comment c = new Comment();
        c.setId(rs.getInt("id"));
        c.setNoticeId(rs.getInt("notice_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setContent(rs.getString("content"));
        
        int pId = rs.getInt("parent_id");
        if (!rs.wasNull()) {
            c.setParentId(pId);
        }
        
        Timestamp ts = rs.getTimestamp("posted_date");
        if (ts != null) {
            c.setPostedDate(new java.util.Date(ts.getTime()));
        }
        
        c.setAuthorName(rs.getString("full_name"));
        c.setAuthorRole(rs.getString("role"));
        c.setAuthorImage(rs.getString("profile_image"));
        
        String name = c.getAuthorName();
        if (name != null) {
            String[] parts = name.trim().split(" ");
            String initials = "";
            if (parts.length > 0 && !parts[0].isEmpty()) initials += parts[0].charAt(0);
            if (parts.length > 1 && !parts[parts.length-1].isEmpty()) initials += parts[parts.length-1].charAt(0);
            c.setAuthorInitials(initials.toUpperCase());
        }
        c.setAuthorColor(AVATAR_COLORS[cycleIndex % AVATAR_COLORS.length]);
        
        c.setReplies(new ArrayList<>());
        
        return c;
    }

    public boolean createComment(Comment c) {
        String sql = "INSERT INTO comments (notice_id, user_id, content, parent_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, c.getNoticeId());
            ps.setInt(2, c.getUserId());
            ps.setString(3, c.getContent());
            if (c.getParentId() != null && c.getParentId() > 0) {
                ps.setInt(4, c.getParentId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Comment> getCommentsForNotice(int noticeId) {
        List<Comment> allComments = new ArrayList<>();
        String sql = "SELECT c.*, u.full_name, u.role, u.profile_image " +
                     "FROM comments c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "WHERE c.notice_id = ? " +
                     "ORDER BY c.posted_date ASC";
                     
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, noticeId);
            ResultSet rs = ps.executeQuery();
            int index = 0;
            while (rs.next()) {
                allComments.add(mapResultSetToComment(rs, index++));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Build hierarchy
        List<Comment> rootComments = new ArrayList<>();
        Map<Integer, Comment> commentMap = new HashMap<>();
        
        for (Comment c : allComments) {
            commentMap.put(c.getId(), c);
        }
        
        for (Comment c : allComments) {
            if (c.getParentId() == null) {
                rootComments.add(c);
            } else {
                Comment parent = commentMap.get(c.getParentId());
                if (parent != null) {
                    parent.getReplies().add(c);
                }
            }
        }
        
        return rootComments;
    }
}
