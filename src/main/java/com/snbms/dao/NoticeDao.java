package com.snbms.dao;

import com.snbms.model.Notice;
import com.snbms.config.DatabaseConfig;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class NoticeDao {
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    private String getBadgeClassForName(String name) {
        if(name == null) return "badge-custom";
        switch (name.trim()) {
            case "Exam Notice": return "badge-exam";
            case "Holiday Notice": return "badge-holiday";
            case "Fee Notice": return "badge-fee";
            case "Event Notice": return "badge-event";
            case "Result Notice": return "badge-result";
            case "Scholarship Notice": return "badge-scholarship";
            case "Routine Notice": return "badge-routine";
            case "Admission Notice": return "badge-admission";
            default: return "badge-custom";
        }
    }

    private Notice mapResultSetToNotice(ResultSet rs) throws SQLException {
        Notice n = new Notice();
        n.setId(rs.getInt("id"));
        n.setTitle(rs.getString("title"));
        n.setContent(rs.getString("content"));
        n.setCategoryId(rs.getInt("category_id"));
        n.setStatus(rs.getString("status"));
        n.setIsPinned(rs.getBoolean("is_pinned"));
        n.setAuthorId(rs.getInt("author_id"));
        n.setImageUrl(rs.getString("image_url"));
        
        try {
            String pDate = rs.getString("posted_date");
            if (pDate != null && !pDate.isEmpty()) n.setPostedDate(sdf.parse(pDate));
            String eDate = rs.getString("expiry_date");
            if (eDate != null && !eDate.isEmpty()) n.setExpiryDate(sdf.parse(eDate));
        } catch (Exception e) {}

        // Set View Model fields from JOINs
        n.setCategoryName(rs.getString("cat_name"));
        n.setCategoryBadgeClass(getBadgeClassForName(rs.getString("cat_name")));
        
        // Status Badge Logic
        String pStatus = rs.getString("status");
        if("Published".equalsIgnoreCase(pStatus)) n.setStatusBadgeClass("badge-published");
        else if("Draft".equalsIgnoreCase(pStatus)) n.setStatusBadgeClass("badge-draft");
        else if("Active".equalsIgnoreCase(pStatus)) n.setStatusBadgeClass("badge-active");
        else n.setStatusBadgeClass("badge-inactive");
        
        n.setAuthorName(rs.getString("author_name"));
        
        return n;
    }

    public int getTotalNotices() {
        String sql = "SELECT COUNT(*) FROM notices";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public List<Notice> getRecentNotices(int limit) {
        List<Notice> list = new ArrayList<>();
        String sql = "SELECT n.*, c.name as cat_name, u.full_name as author_name " +
                     "FROM notices n " +
                     "LEFT JOIN categories c ON n.category_id = c.id " +
                     "LEFT JOIN users u ON n.author_id = u.id " +
                     "ORDER BY n.id DESC LIMIT ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToNotice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Notice> getNotices(String q, String categoryId, String status, int page, int pageSize, Integer authorId) {
        List<Notice> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT n.*, c.name as cat_name, u.full_name as author_name " +
            "FROM notices n " +
            "LEFT JOIN categories c ON n.category_id = c.id " +
            "LEFT JOIN users u ON n.author_id = u.id " +
            "WHERE 1=1"
        );
        
        List<Object> params = new ArrayList<>();
        if (q != null && !q.trim().isEmpty()) {
            sql.append(" AND n.title LIKE ?");
            params.add("%" + q + "%");
        }
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append(" AND n.category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND n.status = ?");
            params.add(status);
        }
        if (authorId != null) {
            sql.append(" AND n.author_id = ?");
            params.add(authorId);
        }
        
        sql.append(" ORDER BY n.is_pinned DESC, n.posted_date DESC, n.id DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToNotice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public int countNotices(String q, String categoryId, String status, Integer authorId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM notices n WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (q != null && !q.trim().isEmpty()) {
            sql.append(" AND n.title LIKE ?");
            params.add("%" + q + "%");
        }
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append(" AND n.category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND n.status = ?");
            params.add(status);
        }
        if (authorId != null) {
            sql.append(" AND n.author_id = ?");
            params.add(authorId);
        }
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getInt(1);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Notice> getStudentNotices(boolean pinned, String categoryId, String q) {
        List<Notice> list = new ArrayList<>();
        // Student only sees 'Published' status notices that are not expired
        StringBuilder sql = new StringBuilder(
            "SELECT n.*, c.name as cat_name, u.full_name as author_name " +
            "FROM notices n " +
            "LEFT JOIN categories c ON n.category_id = c.id " +
            "LEFT JOIN users u ON n.author_id = u.id " +
            "WHERE n.status = 'Published' AND n.is_pinned = ? " +
            "AND (n.expiry_date IS NULL OR n.expiry_date = '0000-00-00' OR n.expiry_date >= CURDATE())"
        );
        
        List<Object> params = new ArrayList<>();
        params.add(pinned ? 1 : 0);
        
        if (categoryId != null && !categoryId.trim().isEmpty()) {
            sql.append(" AND n.category_id = ?");
            params.add(Integer.parseInt(categoryId));
        }
        if (q != null && !q.trim().isEmpty()) {
            sql.append(" AND n.title LIKE ?");
            params.add("%" + q + "%");
        }
        
        sql.append(" ORDER BY n.posted_date DESC, n.id DESC");
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToNotice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Notice getNoticeById(int id) {
        String sql = "SELECT n.*, c.name as cat_name, u.full_name as author_name " +
                     "FROM notices n " +
                     "LEFT JOIN categories c ON n.category_id = c.id " +
                     "LEFT JOIN users u ON n.author_id = u.id " +
                     "WHERE n.id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToNotice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean saveNotice(Notice n) {
        String sql;
        boolean isUpdate = n.getId() > 0;
        
        if (isUpdate) {
            sql = "UPDATE notices SET title=?, content=?, image_url=?, category_id=?, status=?, posted_date=?, expiry_date=?, is_pinned=? WHERE id=?";
        } else {
            sql = "INSERT INTO notices (title, content, image_url, category_id, status, posted_date, expiry_date, is_pinned, author_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        }
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, n.getTitle());
            ps.setString(2, n.getContent());
            ps.setString(3, n.getImageUrl());
            ps.setInt(4, n.getCategoryId());
            ps.setString(5, n.getStatus());
            ps.setString(6, n.getPostedDateStr());
            ps.setString(7, n.getExpiryDateStr());
            ps.setBoolean(8, n.getIsPinned());
            
            if (isUpdate) {
                ps.setInt(9, n.getId());
            } else {
                ps.setInt(9, n.getAuthorId());
            }
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteNotice(int id) {
        String sql = "DELETE FROM notices WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             ps.setInt(1, id);
             return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

