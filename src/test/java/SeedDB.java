import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class SeedDB {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Using 127.0.0.1 forces a TCP connection to XAMPP MySQL
        String URL = "jdbc:mysql://127.0.0.1:3306/?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        Connection conn = DriverManager.getConnection(URL, "root", "");
        Statement stmt = conn.createStatement();
        
        System.out.println("Connecting to XAMPP MySQL...");
        stmt.execute("DROP DATABASE IF EXISTS snbms");
        System.out.println("Dropped old database.");
        stmt.execute("CREATE DATABASE snbms");
        System.out.println("Created fresh snbms database.");
        stmt.execute("USE snbms");
        
        stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY, " +
                     "username VARCHAR(50) UNIQUE NOT NULL, " +
                     "password VARCHAR(255) NOT NULL, " +
                     "full_name VARCHAR(100) NOT NULL, " +
                     "email VARCHAR(100) UNIQUE NOT NULL, " +
                     "role VARCHAR(20) NOT NULL, " +
                     "status VARCHAR(20) NOT NULL, " +
                     "profile_image VARCHAR(255), " + 
                     "joined_date DATETIME DEFAULT CURRENT_TIMESTAMP)");

        // Admin
        stmt.execute("INSERT INTO users (id, username, password, full_name, email, role, status) " +
                     "VALUES (1, 'admin', 'admin123', 'System Administrator', 'admin@snbms.local', 'ADMIN', 'Active')");

        // Teacher
        stmt.execute("INSERT INTO users (id, username, password, full_name, email, role, status) " +
                     "VALUES (2, 'teacher1', 'teacher123', 'Jane Teacher', 'teacher1@snbms.local', 'TEACHER', 'Active')");

        // Student
        stmt.execute("INSERT INTO users (id, username, password, full_name, email, role, status) " +
                     "VALUES (3, 'student1', 'student123', 'John Student', 'student1@snbms.local', 'STUDENT', 'Active')");

        System.out.println("XAMPP DB seeded successfully with admin, teacher1, and student1 users.");
        conn.close();
    }
}
