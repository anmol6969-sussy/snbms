package com.snbms.dao;

import com.snbms.model.Complaint;
import com.snbms.config.DatabaseConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDao {

    // Constructor
    private Complaint mapResultSetToComplaint(ResultSet rs, boolean hideIdentity) throws SQLException {
        Complaint c = new Complaint();
        c.setId(rs.getInt("id"));
        c.setTitle(rs.getString("title"));
        c.setDescription(rs.getString("description"));
        c.setStudentId(rs.getInt("student_id"));
        
        int tId = rs.getInt("teacher_id");
        if (!rs.wasNull()) {
            c.setTeacherId(tId);
        }
        
        c.setAnonymous(rs.getBoolean("is_anonymous"));
        c.setStatus(rs.getString("status"));
        
        Timestamp ts = rs.getTimestamp("submitted_date");
        if (ts != null) {
            c.setSubmittedDate(new java.util.Date(ts.getTime()));
        }
        
        // Handle identity masking
        String sName = rs.getString("student_name");
        if (hideIdentity && c.isAnonymous()) {
            c.setStudentName("Anonymous Student");
        } else {
            c.setStudentName(sName);
        }
        
        c.setTeacherName(rs.getString("teacher_name"));
        return c;
    }

    public boolean createComplaint(Complaint c) {
        String sql = "INSERT INTO complaints (title, description, student_id, teacher_id, is_anonymous, status) VALUES (?, ?, ?, ?, ?, 'Pending')";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getTitle());
            ps.setString(2, c.getDescription());
            ps.setInt(3, c.getStudentId());
            if (c.getTeacherId() != null && c.getTeacherId() > 0) {
                ps.setInt(4, c.getTeacherId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            ps.setBoolean(5, c.isAnonymous());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Complaint> getAllComplaintsForAdmin() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.full_name as student_name, t.full_name as teacher_name " +
                     "FROM complaints c " +
                     "JOIN users s ON c.student_id = s.id " +
                     "LEFT JOIN users t ON c.teacher_id = t.id " +
                     "ORDER BY c.submitted_date DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs, false)); // Admin sees all identities
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Complaint> getComplaintsForTeacher(int teacherId) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT c.*, s.full_name as student_name, t.full_name as teacher_name " +
                     "FROM complaints c " +
                     "JOIN users s ON c.student_id = s.id " +
                     "LEFT JOIN users t ON c.teacher_id = t.id " +
                     "WHERE c.teacher_id = ? OR c.teacher_id IS NULL " +
                     "ORDER BY c.submitted_date DESC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToComplaint(rs, true)); // Teachers cannot see anonymous names
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateComplaintStatus(int id, String status) {
        String sql = "UPDATE complaints SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
