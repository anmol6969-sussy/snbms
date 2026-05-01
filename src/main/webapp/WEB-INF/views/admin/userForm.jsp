<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:if test="${sessionScope.role != 'ADMIN' and sessionScope.role != 'TEACHER'}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Add User — SNBMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css"/>
</head>
<body>
<div class="app-wrapper">

  <!-- NAVBAR -->
  <nav class="snbms-navbar" id="snbmsNavbar">
    <button class="sidebar-toggle-btn" id="sidebarToggle" aria-label="Toggle sidebar">&#9776;</button>
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

  <div class="sidebar-overlay" id="sidebarOverlay"></div>
  <div class="layout-body">

    <!-- SIDEBAR -->
    <aside class="snbms-sidebar" id="snbmsSidebar">
      <p class="sidebar-section-label">Menu</p>
      <ul class="sidebar-nav">
        <c:choose>
          <c:when test="${sessionScope.role == 'TEACHER'}">
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/teacher/dashboard" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-chart-line"></i></span><span class="sidebar-label">Dashboard</span></a></li>
          </c:when>
          <c:otherwise>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-chart-line"></i></span><span class="sidebar-label">Dashboard</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-tags"></i></span><span class="sidebar-label">Categories</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/complaints" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-exclamation-triangle"></i></span><span class="sidebar-label">Complaints</span></a></li>
          </c:otherwise>
        </c:choose>
        <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span><span class="sidebar-label">Notices</span></a></li>
        <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-link sidebar-nav-link--active"><span class="sidebar-icon"><i class="fas fa-users"></i></span><span class="sidebar-label">Users</span></a></li>
        <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/profile" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-user-circle"></i></span><span class="sidebar-label">My Profile</span></a></li>
      </ul>
    </aside>

    <!-- MAIN -->
    <main class="main-content" id="mainContent">
      <div class="page-title-bar">
        <div>
          <h2>Add New User</h2>
          <div class="page-subtitle">Create a student or teacher account</div>
        </div>
      </div>

      <div style="max-width:560px;">
        <c:if test="${not empty error}">
          <div class="alert alert-danger" style="border-radius:8px; margin-bottom:16px; font-size:13px;">
            <i class="fas fa-exclamation-circle me-1"></i> ${error}
          </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/users/new" method="post" id="userForm">

          <div class="form-group">
            <label class="form-label-custom" for="fullName">Full Name <span class="req">*</span></label>
            <input type="text" id="fullName" name="full_name" class="form-control-custom" placeholder="e.g. John Smith" required/>
          </div>

          <div class="form-grid-2">
            <div class="form-group" style="margin-bottom:0;">
              <label class="form-label-custom" for="username">Username <span class="req">*</span></label>
              <input type="text" id="username" name="username" class="form-control-custom" placeholder="e.g. jsmith01" required/>
            </div>
            <div class="form-group" style="margin-bottom:0;">
              <label class="form-label-custom" for="password">Password <span class="req">*</span></label>
              <input type="password" id="password" name="password" class="form-control-custom" placeholder="Min 6 chars" required minlength="6"/>
            </div>
          </div>

          <div class="form-group">
            <label class="form-label-custom" for="email">Email Address <span class="req">*</span></label>
            <input type="email" id="email" name="email" class="form-control-custom" placeholder="e.g. jsmith@school.edu" required/>
          </div>

          <div class="form-group">
            <label class="form-label-custom" for="role">Role <span class="req">*</span></label>
            <select id="role" name="role" class="form-control-custom" required>
              <option value="STUDENT">Student</option>
              <c:if test="${sessionScope.role == 'ADMIN'}">
                <option value="TEACHER">Teacher</option>
              </c:if>
            </select>
          </div>

          <div class="form-actions">
            <button type="submit" class="btn-primary-custom" id="saveUserBtn">
              <i class="fas fa-user-plus me-1"></i> Create User
            </button>
            <a href="${pageContext.request.contextPath}/admin/users" class="btn-secondary-custom">Cancel</a>
          </div>
        </form>
      </div>
    </main>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>
