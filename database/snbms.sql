-- ============================================
-- School Notice Board Management System (SNBMS)
-- Database Schema
-- Author: Dhawa Tamu Gurung
-- ============================================

CREATE DATABASE IF NOT EXISTS snbms;
USE snbms;

-- ============================================
-- TABLE 1: users
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    profile_image VARCHAR(255),
    joined_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE 2: categories
-- ============================================
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- ============================================
-- TABLE 3: notices
-- ============================================
CREATE TABLE IF NOT EXISTS notices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_url VARCHAR(255),
    category_id INT,
    status VARCHAR(20) NOT NULL,
    posted_date DATE NOT NULL,
    expiry_date DATE,
    is_pinned BOOLEAN DEFAULT FALSE,
    author_id INT,
    FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY(author_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================
-- TABLE 4: complaints
-- ============================================
CREATE TABLE IF NOT EXISTS complaints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    student_id INT NOT NULL,
    teacher_id INT,
    is_anonymous BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'Pending',
    submitted_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(student_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(teacher_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ============================================
-- TABLE 5: comments
-- ============================================
CREATE TABLE IF NOT EXISTS comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    notice_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    parent_id INT,
    posted_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(notice_id) REFERENCES notices(id) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY(parent_id) REFERENCES comments(id) ON DELETE CASCADE
);

-- ============================================
-- INDEXES for performance
-- ============================================
CREATE INDEX idx_notices_category ON notices(category_id);
CREATE INDEX idx_notices_author ON notices(author_id);
CREATE INDEX idx_notices_status ON notices(status);
CREATE INDEX idx_notices_pinned ON notices(is_pinned);
CREATE INDEX idx_comments_notice ON comments(notice_id);
CREATE INDEX idx_complaints_student ON complaints(student_id);

-- ============================================
-- SAMPLE DATA: users
-- ============================================
INSERT IGNORE INTO users (id, username, password, full_name, email, role, status) VALUES
(1, 'admin', 'admin123', 'System Administrator', 'admin@snbms.local', 'ADMIN', 'Active'),
(2, 'teacher1', 'teacher123', 'Ramesh Adhikari', 'teacher1@snbms.local', 'TEACHER', 'Active'),
(3, 'teacher2', 'teacher123', 'Sunita Sharma', 'teacher2@snbms.local', 'TEACHER', 'Active'),
(4, 'student1', 'student123', 'Aarav Thapa', 'student1@snbms.local', 'STUDENT', 'Active'),
(5, 'student2', 'student123', 'Priya Shrestha', 'student2@snbms.local', 'STUDENT', 'Active');

-- ============================================
-- SAMPLE DATA: categories
-- ============================================
INSERT IGNORE INTO categories (name, description) VALUES
('Exam Notice', 'Notices related to examinations and tests'),
('Holiday Notice', 'Notices about holidays and school closures'),
('Fee Notice', 'Notices regarding fee payments and deadlines'),
('Event Notice', 'Notices about school events and programs'),
('Result Notice', 'Notices about exam results and grades'),
('Scholarship Notice', 'Notices about scholarship opportunities'),
('Routine Notice', 'Notices about class routines and schedules'),
('Admission Notice', 'Notices about admissions and enrollments');

-- ============================================
-- SAMPLE DATA: notices
-- ============================================
INSERT IGNORE INTO notices (title, content, category_id, status, posted_date, expiry_date, is_pinned, author_id) VALUES
('Final Exam Schedule 2026', 'Final examinations will be held from May 20 to May 30, 2026. All students must bring their admit cards.', 1, 'Published', '2026-05-01', '2026-05-30', TRUE, 1),
('Eid Holiday Notice', 'School will remain closed on May 10, 2026 for Eid celebration. Classes will resume on May 11.', 2, 'Published', '2026-05-01', '2026-05-10', FALSE, 1),
('Fee Submission Deadline', 'Last date for fee submission is May 15, 2026. Late fee will be charged after the deadline.', 3, 'Published', '2026-05-01', '2026-05-15', TRUE, 1),
('Annual Sports Day', 'Annual sports day will be held on May 25, 2026. All students are encouraged to participate.', 4, 'Published', '2026-05-01', '2026-05-25', FALSE, 2),
('Scholarship Application Open', 'Applications for the 2026 merit scholarship are now open. Eligible students may apply before May 20.', 6, 'Published', '2026-05-01', '2026-05-20', FALSE, 2);

-- ============================================
-- SAMPLE DATA: complaints
-- ============================================
INSERT IGNORE INTO complaints (title, description, student_id, teacher_id, is_anonymous, status) VALUES
('Classroom Projector Not Working', 'The projector in room 201 has not been working for 2 weeks. It is affecting our studies.', 4, 2, FALSE, 'Pending'),
('Canteen Food Quality Issue', 'The food quality in the canteen has declined recently. Students are getting sick.', 5, NULL, TRUE, 'Pending'),
('Library Books Not Available', 'Many reference books in the library are missing. Please restock them before exams.', 4, 3, FALSE, 'Resolved');

-- ============================================
-- SAMPLE DATA: comments
-- ============================================
INSERT IGNORE INTO comments (notice_id, user_id, content) VALUES
(1, 4, 'Thank you for the exam schedule. Will there be any preparatory classes before the exams?'),
(1, 5, 'Please share the syllabus for each subject as well.'),
(1, 2, 'Preparatory classes will be announced soon. Stay tuned.'),
(3, 4, 'Can we pay fees online this time?'),
(3, 2, 'Yes, online payment option is available on the school portal.');