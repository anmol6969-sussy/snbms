<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Contact — SNBMS</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css"/>
    <style>
        .page-body { margin-top: 44px; padding: 2rem; max-width: 900px; margin-left: auto; margin-right: auto; }
        .page-hero {
            background: linear-gradient(135deg, var(--teal) 0%, var(--blue) 100%);
            color: white; border-radius: 12px; padding: 2.5rem 2rem;
            text-align: center; margin-bottom: 2rem;
        }
        .page-hero h1 { color: white; font-size: 1.8rem; margin-bottom: 0.5rem; }
        .page-hero p  { color: rgba(255,255,255,0.85); margin: 0; }
        .contact-grid {
            display: grid; grid-template-columns: 1fr 1.5fr;
            gap: 1.5rem; margin-bottom: 2rem;
        }
        @media (max-width: 640px) { .contact-grid { grid-template-columns: 1fr; } }
        .info-card {
            background: white; border-radius: 10px; padding: 1.75rem;
            box-shadow: 0 1px 6px rgba(0,0,0,0.06);
        }
        .info-card h2 { color: var(--navy); margin-bottom: 1.25rem; font-size: 1.1rem; }
        .contact-item {
            display: flex; align-items: flex-start; gap: 0.75rem;
            margin-bottom: 1.25rem;
        }
        .contact-icon {
            width: 36px; height: 36px; border-radius: 8px;
            background: var(--blue-light); color: var(--blue);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0; font-size: 0.85rem;
        }
        .contact-item h3 { font-size: 0.8rem; color: var(--gray400); margin-bottom: 0.1rem; text-transform: uppercase; letter-spacing: 0.05em; }
        .contact-item p  { font-size: 0.9rem; color: var(--gray800); margin: 0; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 500; color: var(--gray600); margin-bottom: 0.4rem; }
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%; padding: 0.6rem 0.85rem;
            border: 1px solid var(--gray200); border-radius: 8px;
            font-size: 0.9rem; font-family: inherit;
            transition: border-color 0.2s; box-sizing: border-box;
        }
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none; border-color: var(--blue);
            box-shadow: 0 0 0 3px var(--blue-light);
        }
        .form-group textarea { resize: vertical; min-height: 110px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        @media (max-width: 480px) { .form-row { grid-template-columns: 1fr; } }
        .btn-submit {
            width: 100%; padding: 0.7rem;
            background: var(--blue); color: white;
            border: none; border-radius: 8px;
            font-size: 0.95rem; font-weight: 500;
            cursor: pointer; transition: background 0.2s;
        }
        .btn-submit:hover { background: var(--navy); }
        .alert-error {
            background: var(--red-light); border: 1px solid #fca5a5;
            color: var(--red); padding: 0.75rem 1rem; border-radius: 8px;
            margin-bottom: 1rem; font-size: 0.875rem;
        }
        .alert-success {
            background: var(--green-light); border: 1px solid #6ee7b7;
            color: var(--green); padding: 0.75rem 1rem; border-radius: 8px;
            margin-bottom: 1rem; font-size: 0.875rem;
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
        <div class="page-hero">
            <h1><i class="fas fa-envelope"></i> Contact Us</h1>
            <p>Get in touch with the SNBMS support team</p>
        </div>

        <div class="contact-grid">

            <!-- Contact Details -->
            <div class="info-card">
                <h2><i class="fas fa-address-book" style="color:var(--blue);margin-right:0.5rem;"></i>Support Details</h2>

                <div class="contact-item">
                    <div class="contact-icon"><i class="fas fa-map-marker-alt"></i></div>
                    <div>
                        <h3>Address</h3>
                        <p>Itahari International College<br>Itahari, Sunsari, Nepal</p>
                    </div>
                </div>

                <div class="contact-item">
                    <div class="contact-icon"><i class="fas fa-envelope"></i></div>
                    <div>
                        <h3>Email</h3>
                        <p>support@snbms.edu.np</p>
                    </div>
                </div>

                <div class="contact-item">
                    <div class="contact-icon"><i class="fas fa-phone"></i></div>
                    <div>
                        <h3>Phone</h3>
                        <p>+977-025-586XXX</p>
                    </div>
                </div>

                <div class="contact-item">
                    <div class="contact-icon"><i class="fas fa-clock"></i></div>
                    <div>
                        <h3>Office Hours</h3>
                        <p>Sunday – Friday<br>9:00 AM – 5:00 PM</p>
                    </div>
                </div>
            </div>

            <!-- Inquiry Form -->
            <div class="info-card">
                <h2><i class="fas fa-paper-plane" style="color:var(--teal);margin-right:0.5rem;"></i>Send an Inquiry</h2>

                <c:if test="${not empty error}">
                    <div class="alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
                </c:if>

                <c:if test="${empty success}">
                <form method="post" action="${pageContext.request.contextPath}/contact">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" id="name" name="name" placeholder="Your name"
                                   value="${not empty formName ? formName : ''}" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" placeholder="your@email.com"
                                   value="${not empty formEmail ? formEmail : ''}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <select id="subject" name="subject">
                            <option value="">Select a subject...</option>
                            <option value="Technical Issue" ${formSubject == 'Technical Issue' ? 'selected' : ''}>Technical Issue</option>
                            <option value="Account Problem" ${formSubject == 'Account Problem' ? 'selected' : ''}>Account Problem</option>
                            <option value="Notice Complaint" ${formSubject == 'Notice Complaint' ? 'selected' : ''}>Notice Complaint</option>
                            <option value="General Inquiry" ${formSubject == 'General Inquiry' ? 'selected' : ''}>General Inquiry</option>
                            <option value="Other" ${formSubject == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="message">Message</label>
                        <textarea id="message" name="message"
                                  placeholder="Describe your inquiry in detail..."
                                  required>${not empty formMessage ? formMessage : ''}</textarea>
                    </div>

                    <button type="submit" class="btn-submit">
                        <i class="fas fa-paper-plane"></i> Submit Inquiry
                    </button>
                </form>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
</html>
