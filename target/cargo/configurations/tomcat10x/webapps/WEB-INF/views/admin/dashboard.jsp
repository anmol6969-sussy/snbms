<%--
  admin/dashboard.jsp — Admin Dashboard Overview
  Route: /admin/dashboard  (ADMIN role)
  Request scope attributes:
    ${totalNotices}    — Integer
    ${totalCategories} — Integer
    ${totalStudents}   — Integer
    ${recentNotices}   — List<Notice>  (up to 5; fields: id, title, postedDate, categoryName, categoryBadgeClass, isPinned)
  Session scope:
    ${sessionScope.username} — String (logged-in username)
    ${sessionScope.role}     — String ("ADMIN" | "STUDENT")
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"     prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"      prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>

<%-- Role guard --%>
<c:if test="${sessionScope.role != 'ADMIN'}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Admin Dashboard — School Notice Board Management System." />
  <title>Dashboard — SNBMS Admin</title>

  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
        crossorigin="anonymous" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css" />
</head>
<body>
<div class="app-wrapper">

  <!-- ══ NAVBAR ══════════════════════════════════════════════ -->
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

  <!-- Sidebar overlay (mobile) -->
  <div class="sidebar-overlay" id="sidebarOverlay"></div>

  <div class="layout-body">

    <!-- ══ SIDEBAR ══════════════════════════════════════════ -->
    <aside class="snbms-sidebar" id="snbmsSidebar">
      <p class="sidebar-section-label">Menu</p>
      <ul class="sidebar-nav">
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-link" id="nav-dashboard">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-chart-line"></i></span>
            <span class="sidebar-label">Dashboard</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link" id="nav-notices">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span>
            <span class="sidebar-label">All Notices</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/notices/new" class="sidebar-nav-link" id="nav-add-notice">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-plus"></i></span>
            <span class="sidebar-label">Add Notice</span>
          </a>
        </li>

        <li class="sidebar-nav-item">
            <a href="${pageContext.request.contextPath}/about" class="sidebar-nav-link" id="nav-about">
                <span class="sidebar-dot"></span><span class="sidebar-icon"><i class="fas fa-info-circle"></i></span><span class="sidebar-label">About</span>
            </a>
        </li>
        <li class="sidebar-nav-item">
            <a href="${pageContext.request.contextPath}/contact" class="sidebar-nav-link" id="nav-contact">
                <span class="sidebar-dot"></span><span class="sidebar-icon"><i class="fas fa-envelope"></i></span><span class="sidebar-label">Contact</span>
            </a>
        </li>

      </ul>

      <p class="sidebar-section-label">Manage</p>
      <ul class="sidebar-nav">
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-nav-link" id="nav-categories">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-tags"></i></span>
            <span class="sidebar-label">Categories</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-link" id="nav-users">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-users"></i></span>
            <span class="sidebar-label">Users</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/complaints" class="sidebar-nav-link" id="nav-complaints">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-exclamation-triangle"></i></span>
            <span class="sidebar-label">Complaints</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/profile" class="sidebar-nav-link" id="nav-profile">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-user-circle"></i></span>
            <span class="sidebar-label">My Profile</span>
          </a>
        </li>
      </ul>
    </aside>

    <!-- ══ MAIN CONTENT ═════════════════════════════════════ -->
    <main class="main-content" id="mainContent">

      <!-- Page Title Bar -->
      <div class="page-title-bar">
        <div>
          <h1>Dashboard Overview</h1>
          <div class="page-subtitle">
            <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, d MMMM yyyy" />
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/notices/new" class="btn-small-navy" id="addNoticeTopBtn">
          + Add Notice
        </a>
      </div>

      <!-- Stats Row -->
      <div class="stats-row" id="statsRow">

        <div class="stat-card" id="statTotalNotices">
          <div class="stat-icon"><i class="fas fa-clipboard-list"></i></div>
          <div class="stat-number blue">${not empty totalNotices ? totalNotices : '0'}</div>
          <div class="stat-label">Total Notices</div>
        </div>

        <div class="stat-card" id="statCategories">
          <div class="stat-icon"><i class="fas fa-tags"></i></div>
          <div class="stat-number teal">${not empty totalCategories ? totalCategories : '0'}</div>
          <div class="stat-label">Categories</div>
        </div>

        <div class="stat-card" id="statStudents">
          <div class="stat-icon"><i class="fas fa-users"></i></div>
          <div class="stat-number amber">${not empty totalStudents ? totalStudents : '0'}</div>
          <div class="stat-label">Students</div>
        </div>

      </div>

      <!-- Recent Notices -->
      <div class="section-label">Recent Notices</div>
      <div id="recentNoticesList">

        <c:choose>
          <c:when test="${not empty recentNotices}">
            <c:forEach var="notice" items="${recentNotices}">
              <div class="notice-row ${notice.isPinned ? 'pinned' : ''}"
                   data-search-title="${fn:escapeXml(notice.title)}">
                <div class="notice-row-left">
                  <div class="notice-title-text" title="${fn:escapeXml(notice.title)}">
                    ${fn:escapeXml(notice.title)}
                  </div>
                  <div class="notice-meta-row">
                    <span class="notice-date-text">
                      <fmt:formatDate value="${notice.postedDate}" pattern="d MMM yyyy" />
                    </span>
                    <span class="badge-custom ${notice.categoryBadgeClass}">
                      ${fn:escapeXml(notice.categoryName)}
                    </span>
                  </div>
                </div>
                <div class="notice-row-right">
                          <a href="${pageContext.request.contextPath}/admin/notices/edit?id=${notice.id}" class="btn-edit" id="editNotice${notice.id}">Edit</a>
                </div>
              </div>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <div style="font-size:12px; color:var(--gray400); padding:20px 0; text-align:center;">
              No notices yet. <a href="${pageContext.request.contextPath}/admin/notices/new">Add the first one.</a>
            </div>
          </c:otherwise>
        </c:choose>

      </div>

    </main>
  </div><!-- /.layout-body -->
</div><!-- /.app-wrapper -->

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/jzmm1l5wFh+q+oiaCOaFLvqFOEHmb"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>

