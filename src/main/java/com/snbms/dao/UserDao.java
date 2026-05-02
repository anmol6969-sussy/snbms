package com.snbms.dao;

import com.snbms.model.User;
import com.snbms.config.DatabaseConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {
    
    private static final String[] AVATAR_COLORS = {
        "avatar-blue", "avatar-green", "avatar-red", "avatar-purple", "avatar-teal"
    };

    public User authenticate(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND status = 'Active'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs, 0); // using 0 for index because we only get 1
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getStudents(String searchTerm, String statusFilter, int page, int pageSize) {
        return getUsers(searchTerm, statusFilter, page, pageSize);
    }

    public List<User> getUsers(String searchTerm, String statusFilter, int page, int pageSize) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE role IN ('STUDENT','TEACHER')");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
        }
        
        sql.append(" ORDER BY role, joined_date DESC LIMIT ? OFFSET ?");
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchTerm + "%");
                ps.setString(paramIndex++, "%" + searchTerm + "%");
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setString(paramIndex++, statusFilter);
            }
            
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            
            ResultSet rs = ps.executeQuery();
            int index = 0;
            while (rs.next()) {
                list.add(mapResultSetToUser(rs, index++));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countStudents(String searchTerm, String statusFilter) {
        return countUsers(searchTerm, statusFilter);
    }

    public int countUsers(String searchTerm, String statusFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE role IN ('STUDENT','TEACHER')");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND status = ?");
        }
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
             
            int paramIndex = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchTerm + "%");
                ps.setString(paramIndex++, "%" + searchTerm + "%");
            }
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                ps.setString(paramIndex++, statusFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int getTotalStudents() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'STUDENT'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalTeachers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'TEACHER'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs, 0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean updateUserStatus(int id, String newStatus) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean createStudent(User user) {
        user.setRole("STUDENT");
        return createUser(user);
    }

    public boolean createUser(User user) {
        String sql = "INSERT INTO users (username, password, full_name, email, role, status) VALUES (?, ?, ?, ?, ?, 'Active')";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getRole() != null ? user.getRole() : "STUDENT");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProfile(int id, String fullName, String profileImage) {
        String sql = "UPDATE users SET full_name = ?, profile_image = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, profileImage);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getTeachers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'TEACHER' AND status = 'Active'";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            int index = 0;
            while (rs.next()) {
                list.add(mapResultSetToUser(rs, index++));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private User mapResultSetToUser(ResultSet rs, int cycleIndex) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setProfileImage(rs.getString("profile_image"));
        try {
            java.sql.Timestamp ts = rs.getTimestamp("joined_date");
            if (ts != null) {
                u.setJoinedDate(new java.util.Date(ts.getTime()));
            }
        } catch (Exception e) {}
        
        // initials logic
        String name = u.getFullName();
        if (name != null) {
            String[] parts = name.trim().split(" ");
            String initials = "";
            if (parts.length > 0 && !parts[0].isEmpty()) initials += parts[0].charAt(0);
            if (parts.length > 1 && !parts[parts.length-1].isEmpty()) initials += parts[parts.length-1].charAt(0);
            u.setInitials(initials.toUpperCase());
        }
        
        // avatar color cycling
        u.setAvatarColorClass(AVATAR_COLORS[cycleIndex % AVATAR_COLORS.length]);
        
        return u;
    }
}

