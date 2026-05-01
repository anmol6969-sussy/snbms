package com.snbms.config;

import com.snbms.util.PasswordUtil;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConfig {
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/snbms?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            initDatabase();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static void initDatabase() {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {

            // Users Table
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                         "id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "username VARCHAR(50) UNIQUE NOT NULL, " +
                         "password VARCHAR(255) NOT NULL, " +
                         "full_name VARCHAR(100) NOT NULL, " +
                         "email VARCHAR(100) UNIQUE NOT NULL, " +
                         "role VARCHAR(20) NOT NULL, " +
                         "status VARCHAR(20) NOT NULL DEFAULT 'Active', " +
                         "profile_image VARCHAR(255), " +
                         "joined_date DATETIME DEFAULT CURRENT_TIMESTAMP)");

            // Categories Table
            stmt.execute("CREATE TABLE IF NOT EXISTS categories (" +
                         "id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "name VARCHAR(50) UNIQUE NOT NULL, " +
                         "description TEXT)");

            // Notices Table
            stmt.execute("CREATE TABLE IF NOT EXISTS notices (" +
                         "id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "title VARCHAR(255) NOT NULL, " +
                         "content TEXT NOT NULL, " +
                         "image_url VARCHAR(255), " +
                         "category_id INT, " +
                         "status VARCHAR(20) NOT NULL, " +
                         "posted_date DATE NOT NULL, " +
                         "expiry_date DATE, " +
                         "is_pinned BOOLEAN DEFAULT FALSE, " +
                         "author_id INT, " +
                         "FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE SET NULL, " +
                         "FOREIGN KEY(author_id) REFERENCES users(id) ON DELETE CASCADE)");

            // Complaints Table
            stmt.execute("CREATE TABLE IF NOT EXISTS complaints (" +
                         "id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "title VARCHAR(255) NOT NULL, " +
                         "description TEXT NOT NULL, " +
                         "student_id INT NOT NULL, " +
                         "teacher_id INT, " +
                         "is_anonymous BOOLEAN DEFAULT FALSE, " +
                         "status VARCHAR(20) DEFAULT 'Pending', " +
                         "submitted_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                         "FOREIGN KEY(student_id) REFERENCES users(id) ON DELETE CASCADE, " +
                         "FOREIGN KEY(teacher_id) REFERENCES users(id) ON DELETE SET NULL)");

            // Comments Table
            stmt.execute("CREATE TABLE IF NOT EXISTS comments (" +
                         "id INT AUTO_INCREMENT PRIMARY KEY, " +
                         "notice_id INT NOT NULL, " +
                         "user_id INT NOT NULL, " +
                         "content TEXT NOT NULL, " +
                         "parent_id INT, " +
                         "posted_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
                         "FOREIGN KEY(notice_id) REFERENCES notices(id) ON DELETE CASCADE, " +
                         "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE, " +
                         "FOREIGN KEY(parent_id) REFERENCES comments(id) ON DELETE CASCADE)");

            // Seed users with ENCRYPTED passwords
            String adminPass   = PasswordUtil.encryptPassword("admin123");
            String teacherPass = PasswordUtil.encryptPassword("teacher123");
            String studentPass = PasswordUtil.encryptPassword("student123");

            stmt.execute("INSERT IGNORE INTO users (id, username, password, full_name, email, role, status) " +
                         "VALUES (1, 'admin', '" + adminPass + "', 'System Administrator', 'admin@snbms.local', 'ADMIN', 'Active')");

            stmt.execute("INSERT IGNORE INTO users (id, username, password, full_name, email, role, status) " +
                         "VALUES (2, 'teacher1', '" + teacherPass + "', 'John Doe', 'teacher1@snbms.local', 'TEACHER', 'Active')");

            stmt.execute("INSERT IGNORE INTO users (id, username, password, full_name, email, role, status) " +
                         "VALUES (3, 'student1', '" + studentPass + "', 'John Student', 'student1@snbms.local', 'STUDENT', 'Active')");

            // Seed Categories
            String[] categories = {
                "Exam Notice", "Holiday Notice", "Fee Notice", "Event Notice",
                "Result Notice", "Scholarship Notice", "Routine Notice", "Admission Notice"
            };
            for (String cat : categories) {
                stmt.execute("INSERT IGNORE INTO categories (name, description) VALUES ('" + cat + "', 'Default category')");
            }

        } catch (SQLException e) {
            System.err.println("Database initialization failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
