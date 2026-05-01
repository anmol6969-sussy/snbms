package com.snbms.dao;

import com.snbms.model.Category;
import com.snbms.config.DatabaseConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao {
    
    // Map category name to style classes as specified in previous requirements
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
            default: return "badge-custom"; // fallback
        }
    }

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT c.*, (SELECT COUNT(id) FROM notices n WHERE n.category_id = c.id) as noticeCount " +
                     "FROM categories c ORDER BY c.id ASC";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setDescription(rs.getString("description"));
                
                int count = rs.getInt("noticeCount");
                c.setNoticeCount(count);
                c.setHasNotices(count > 0);
                c.setBadgeClass(getBadgeClassForName(c.getName()));
                
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCategories() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public boolean saveCategory(int id, String name, String description) {
        String sql;
        if (id > 0) {
            sql = "UPDATE categories SET name = ?, description = ? WHERE id = ?";
        } else {
            sql = "INSERT INTO categories (name, description) VALUES (?, ?)";
        }
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, description);
            if(id > 0) {
                ps.setInt(3, id);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean deleteCategory(int id) {
        // Double check no notices exist
        String checkSql = "SELECT COUNT(*) FROM notices WHERE category_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
             checkPs.setInt(1, id);
             ResultSet rs = checkPs.executeQuery();
             if (rs.next() && rs.getInt(1) > 0) {
                 return false; // Can't delete if has notices
             }
             
             String delSql = "DELETE FROM categories WHERE id = ?";
             try (PreparedStatement delPs = conn.prepareStatement(delSql)) {
                 delPs.setInt(1, id);
                 return delPs.executeUpdate() > 0;
             }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

