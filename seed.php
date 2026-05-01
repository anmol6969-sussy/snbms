<?php
$mysqli = new mysqli("127.0.0.1", "root", "", "");

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

// Create database
$mysqli->query("DROP DATABASE IF EXISTS snbms");
$mysqli->query("CREATE DATABASE snbms");
$mysqli->select_db("snbms");

// Create users table
$table = "
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL,
    profile_image VARCHAR(255),
    joined_date DATETIME DEFAULT CURRENT_TIMESTAMP
)";
$mysqli->query($table);

// Insert data
$mysqli->query("INSERT INTO users (id, username, password, full_name, email, role, status) VALUES (1, 'admin', 'admin123', 'System Administrator', 'admin@snbms.local', 'ADMIN', 'Active')");
$mysqli->query("INSERT INTO users (id, username, password, full_name, email, role, status) VALUES (2, 'teacher1', 'teacher123', 'Jane Teacher', 'teacher1@snbms.local', 'TEACHER', 'Active')");
$mysqli->query("INSERT INTO users (id, username, password, full_name, email, role, status) VALUES (3, 'student1', 'student123', 'John Student', 'student1@snbms.local', 'STUDENT', 'Active')");

echo "Database seeded successfully using PHP!";
$mysqli->close();
?>
