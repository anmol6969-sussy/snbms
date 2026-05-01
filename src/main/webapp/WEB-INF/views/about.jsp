<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>About — SNBMS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css"/>
    <style>
        .page-body { margin-top: 44px; padding: 2rem; max-width: 900px; margin-left: auto; margin-right: auto; }
        .about-hero {
            background: linear-gradient(135deg, var(--navy) 0%, var(--blue) 100%);
            color: white; border-radius: 12px; padding: 3rem 2rem;
            text-align: center; margin-bottom: 2rem;
        }
        .about-hero h1 { color: white; font-size: 2rem; margin-bottom: 0.5rem; }
        .about-hero p  { color: rgba(255,255,255,0.85); font-size: 1rem; margin: 0; }
        .info-card {
            background: white; border-radius: 10px; padding: 1.75rem;
            margin-bottom: 1.5rem; box-shadow: 0 1px 6px rgba(0,0,0,0.06);
        }
        .info-card h2 { color: var(--navy); margin-bottom: 1rem; font-size: 1.1rem; }
        .info-card p, .info-card li { color: var(--gray600); line-height: 1.8; }
        .info-card ul { padding-left: 1.2rem; }
        .feature-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem; margin-top: 1rem;
        }
        .feature-item {
            background: var(--gray50); border-radius: 8px; padding: 1rem;
            display: flex; align-items: flex-start; gap: 0.75rem;
        }
        .feature-icon {
            width: 36px; height: 36px; border-radius: 8px;
            background: var(--blue-light); color: var(--blue);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 0.9rem;
        }
        .feature-item h3 { font-size: 0.85rem; margin-bottom: 0.2rem; color: var(--gray800); }
        .feature-item p  { font-size: 0.8rem; color: var(--gray600); margin: 0; }
        .tech-badge {
            display: inline-block; background: var(--blue-light); color: var(--blue);
            padding: 0.3rem 0.75rem; border-radius: 20px; font-size: 0.8rem;
            font-weight: 500; margin: 0.25rem;
        }
        .back-btn {
            display: inline-flex; align-items: center; gap: 0.5rem;
            color: var(--blue); font-size: 0.9rem; margin-bottom: 1.5rem;
            text-decoration: none;
        }
        .back-btn:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="app-wrapper">

    <!-- NAVBAR -->
    <nav class="snbms-navbar">
        <div class="navbar-brand">
            <div class="brand-icon"><i class="fas fa-graduation-cap"></i></div>
            <span class="brand-text">School Notice Board</span>
        </div>
        <div class="navbar-right">
            <span class="nav-username">${sessionScope.username}</span>
            <form action="${pageContext.request.contextPath}/logout" method="POST" style="margin:0;">
                <button type="submit" class="btn-logout">Logout</button>
            </form>
        </div>
    </nav>

    <div class="page-body">

        <!-- Back button -->
        <c:choose>
            <c:when test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </c:when>
            <c:when test="${sessionScope.role == 'TEACHER'}">
                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/student/dashboard" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </c:otherwise>
        </c:choose>

        <!-- Hero -->
        <div class="about-hero">
            <h1><i class="fas fa-graduation-cap"></i> SNBMS</h1>
            <p>School Notice Board Management System</p>
        </div>

        <!-- About the System -->
        <div class="info-card">
            <h2><i class="fas fa-info-circle" style="color:var(--blue);margin-right:0.5rem;"></i>About the System</h2>
            <p>
                SNBMS (School Notice Board Management System) is a web-based platform designed to
                digitize and streamline the management and distribution of notices within educational
                institutions in Nepal. The system replaces traditional physical notice boards with a
                centralized, accessible, and efficient digital solution.
            </p>
            <p style="margin-top:0.75rem;">
                Students can view notices from anywhere at any time, while administrators and teachers
                can publish, categorize, and manage announcements with ease. The platform supports
                role-based access for administrators, teachers, and students, ensuring each user
                sees only what is relevant to them.
            </p>
        </div>

        <!-- Key Features -->
        <div class="info-card">
            <h2><i class="fas fa-star" style="color:var(--amber);margin-right:0.5rem;"></i>Key Features</h2>
            <div class="feature-grid">
                <div class="feature-item">
                    <div class="feature-icon"><i class="fas fa-bullhorn"></i></div>
                    <div>
                        <h3>Notice Management</h3>
                        <p>Create, publish, pin and manage notices with categories and expiry dates.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="fas fa-users"></i></div>
                    <div>
                        <h3>Role-Based Access</h3>
                        <p>Separate dashboards for Admin, Teacher, and Student roles.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="fas fa-search"></i></div>
                    <div>
                        <h3>Search & Filter</h3>
                        <p>Quickly find notices by keyword, category, or pinned status.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="fas fa-comment"></i></div>
                    <div>
                        <h3>Comments</h3>
                        <p>Students can comment on notices for clarification and discussion.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="fas fa-exclamation-circle"></i></div>
                    <div>
                        <h3>Complaints</h3>
                        <p>Students can submit complaints anonymously to teachers.</p>
                    </div>
                </div>
                <div class="feature-item">
                    <div class="feature-icon"><i class="fas fa-lock"></i></div>
                    <div>
                        <h3>Secure Authentication</h3>
                        <p>SHA-256 encrypted passwords with session and cookie management.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Technology Stack -->
        <div class="info-card">
            <h2><i class="fas fa-code" style="color:var(--teal);margin-right:0.5rem;"></i>Technology Stack</h2>
            <p style="margin-bottom:0.75rem;">This system was built using the following technologies:</p>
            <div>
                <span class="tech-badge"><i class="fab fa-java"></i> Java EE</span>
                <span class="tech-badge">JSP</span>
                <span class="tech-badge">MySQL</span>
                <span class="tech-badge">JDBC</span>
                <span class="tech-badge">Apache Tomcat 10</span>
                <span class="tech-badge">Maven</span>
                <span class="tech-badge">CSS3 Flexbox</span>
                <span class="tech-badge">MVC Architecture</span>
                <span class="tech-badge">SHA-256 Encryption</span>
                <span class="tech-badge">XAMPP</span>
            </div>
        </div>

        <!-- Institution Info -->
        <div class="info-card">
            <h2><i class="fas fa-university" style="color:var(--navy);margin-right:0.5rem;"></i>Institution</h2>
            <ul>
                <li>Module: <strong>CS5054NT — Advanced Programming and Technologies</strong></li>
                <li>Institution: <strong>Itahari International College</strong></li>
                <li>Affiliated to: <strong>London Metropolitan University</strong></li>
                <li>Academic Year: <strong>Spring Semester 2026</strong></li>
            </ul>
        </div>

    </div>
</div>
</body>
</html>
