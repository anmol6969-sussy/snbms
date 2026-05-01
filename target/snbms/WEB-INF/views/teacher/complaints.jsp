<%--
  teacher/complaints.jsp — Complaints directed at this teacher
  Route: /teacher/complaints  (TEACHER role)
  Request scope attributes:
    ${complaints} — List<Complaint>
  Session scope:
    ${sessionScope.username}, ${sessionScope.role}
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"     prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"      prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>

<%-- Role guard --%>
<c:if test="${sessionScope.role != 'TEACHER'}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="View complaints directed at you — SNBMS Teacher." />
  <title>Complaints — SNBMS Teacher</title>

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

    <!-- ══ SIDEBAR ═════════════════════════════════════════ -->
    <aside class="snbms-sidebar" id="snbmsSidebar">
      <p class="sidebar-section-label">Menu</p>
      <ul class="sidebar-nav">
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/teacher/dashboard" class="sidebar-nav-link">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-chart-line"></i></span>
            <span class="sidebar-label">Dashboard</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span>
            <span class="sidebar-label">My Notices</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/notices/new" class="sidebar-nav-link">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-plus"></i></span>
            <span class="sidebar-label">Add Notice</span>
          </a>
        </li>
      </ul>

      <p class="sidebar-section-label">Manage</p>
      <ul class="sidebar-nav">
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-link">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-users"></i></span>
            <span class="sidebar-label">Students</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/teacher/complaints" class="sidebar-nav-link active">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-exclamation-triangle"></i></span>
            <span class="sidebar-label">Complaints</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/profile" class="sidebar-nav-link">
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
          <h2>Complaints</h2>
          <div class="page-subtitle">Complaints directed at you by students</div>
        </div>
      </div>

      <!-- Complaints List -->
      <c:choose>
        <c:when test="${not empty complaints}">
          <c:forEach var="c" items="${complaints}">
            <div class="notice-row" style="border-left: 3px solid var(--amber);">
              <div class="notice-row-left">
                <div class="notice-title-text" title="${fn:escapeXml(c.title)}">
                  ${fn:escapeXml(c.title)}
                </div>
                <div class="notice-meta-row" style="margin-top:4px;">
                  <span class="badge-custom badge-active">${fn:escapeXml(c.studentName)}</span>
                  <span class="notice-date-text">
                    <fmt:formatDate value="${c.submittedDate}" pattern="d MMM yyyy, h:mm a" />
                  </span>
                  <span class="badge-custom ${c.status == 'Pending' ? 'badge-fee' : 'badge-active'}">
                    ${fn:escapeXml(c.status)}
                  </span>
                </div>
                <div style="margin-top:8px; font-size:12px; color:var(--gray600); background:var(--gray50); padding:10px 12px; border-radius:6px; line-height:1.6;">
                  ${fn:escapeXml(c.description)}
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div style="font-size:12px; color:var(--gray400); padding:28px 0; text-align:center;">
            No complaints directed at you.
          </div>
        </c:otherwise>
      </c:choose>

    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/jzmm1l5wFh+q+oiaCOaFLvqFOEHmb"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>
