<%--
  admin/users.jsp — Manage Students / Users
  Route: /admin/users  (ADMIN role)
  Request scope attributes:
    ${users}       — List<User>
                     fields: id, fullName, email, status ("Active"|"Inactive"),
                             joinedDate (java.util.Date), initials (String), avatarColorClass (String)
    ${totalUsers}  — Integer
    ${currentPage} — Integer
    ${totalPages}  — Integer
    ${pageStart}   — Integer
    ${pageEnd}     — Integer
  Session scope:
    ${sessionScope.username}, ${sessionScope.role}
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"  %>

<%-- Role guard --%>
<c:if test="${sessionScope.role != 'ADMIN' and sessionScope.role != 'TEACHER'}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Manage students and users — SNBMS." />
  <title>${sessionScope.role == 'TEACHER' ? 'Students' : 'Manage Students'} — SNBMS</title>

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
        <c:choose>
          <c:when test="${sessionScope.role == 'TEACHER'}">
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
          </c:when>
          <c:otherwise>
            <li class="sidebar-nav-item">
              <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-link">
                <span class="sidebar-dot"></span>
                <span class="sidebar-icon"><i class="fas fa-chart-line"></i></span>
                <span class="sidebar-label">Dashboard</span>
              </a>
            </li>
            <li class="sidebar-nav-item">
              <a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link">
                <span class="sidebar-dot"></span>
                <span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span>
                <span class="sidebar-label">All Notices</span>
              </a>
            </li>
            <li class="sidebar-nav-item">
              <a href="${pageContext.request.contextPath}/admin/notices/new" class="sidebar-nav-link">
                <span class="sidebar-dot"></span>
                <span class="sidebar-icon"><i class="fas fa-plus"></i></span>
                <span class="sidebar-label">Add Notice</span>
              </a>
            </li>
          </c:otherwise>
        </c:choose>
      </ul>
      <p class="sidebar-section-label">Manage</p>
      <ul class="sidebar-nav">
        <c:if test="${sessionScope.role == 'ADMIN'}">
          <li class="sidebar-nav-item">
            <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-nav-link">
              <span class="sidebar-dot"></span>
              <span class="sidebar-icon"><i class="fas fa-tags"></i></span>
              <span class="sidebar-label">Categories</span>
            </a>
          </li>
        </c:if>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-link active">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-users"></i></span>
            <span class="sidebar-label">${sessionScope.role == 'TEACHER' ? 'Students' : 'Users'}</span>
          </a>
        </li>
        <c:if test="${sessionScope.role == 'TEACHER'}">
          <li class="sidebar-nav-item">
            <a href="${pageContext.request.contextPath}/teacher/complaints" class="sidebar-nav-link">
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
        </c:if>
      </ul>
    </aside>

    <!-- ══ MAIN CONTENT ═════════════════════════════════════ -->
    <main class="main-content" id="mainContent">

      <!-- Page Title Bar -->
      <div class="page-title-bar">
        <div>
          <h2>Manage Students</h2>
          <div class="page-subtitle">${not empty totalUsers ? totalUsers : '0'} registered students</div>
        </div>
        <c:if test="${sessionScope.role == 'ADMIN'}">
          <a href="${pageContext.request.contextPath}/admin/users/new"
             class="btn-small-navy" id="addStudentBtn">+ Add Student</a>
        </c:if>
      </div>

      <!-- Search & Filter Row -->
      <form method="GET" action="${pageContext.request.contextPath}/admin/users" id="usersFilterForm">
        <div class="filter-row">
          <input
            type="text"
            name="q"
            value="${fn:escapeXml(param.q)}"
            class="form-control-custom"
            id="studentSearchInput"
            placeholder="Search by name or email…"
            autocomplete="off"
          />
          <select name="status" class="form-control-custom" id="statusFilter"
                  onchange="document.getElementById('usersFilterForm').submit()"
                  style="min-width:140px; flex:0 0 auto;">
            <option value="">All Status</option>
            <option value="Active"   ${param.status == 'Active'   ? 'selected' : ''}>Active</option>
            <option value="Inactive" ${param.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
          </select>
          <button type="submit" class="btn-primary-custom"
                  style="padding:7px 12px; font-size:11px;" id="usersSearchBtn">Search</button>
        </div>
      </form>

      <!-- Users Table -->
      <div class="data-table-wrapper">
        <table class="data-table" id="usersTable">
          <thead>
            <tr>
              <th style="width:36px;">#</th>
              <th>Name</th>
              <th>Email</th>
              <th style="width:90px;">Status</th>
              <th style="width:110px;">Joined</th>
              <c:if test="${sessionScope.role == 'ADMIN'}">
                <th style="width:110px;">Actions</th>
              </c:if>
            </tr>
          </thead>
          <tbody id="usersTableBody">
            <c:choose>
              <c:when test="${not empty users}">
                <c:forEach var="user" items="${users}" varStatus="loop">
                  <tr data-search-name="${fn:escapeXml(user.fullName)}"
                      data-search-email="${fn:escapeXml(user.email)}">
                    <td class="text-gray">${loop.index + 1}</td>
                    <td>
                      <div class="user-name-cell">
                        <div class="avatar-circle ${user.avatarColorClass}"
                             id="avatar${user.id}"
                             aria-label="${fn:escapeXml(user.initials)}">
                          ${fn:escapeXml(user.initials)}
                        </div>
                        <span style="font-size:13px; font-weight:500;">
                          ${fn:escapeXml(user.fullName)}
                        </span>
                      </div>
                    </td>
                    <td class="td-small">${fn:escapeXml(user.email)}</td>
                    <td>
                      <c:choose>
                        <c:when test="${user.status == 'Active'}">
                          <span class="badge-custom badge-active">Active</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge-custom badge-inactive">Inactive</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="td-date">
                      <fmt:formatDate value="${user.joinedDate}" pattern="d MMM yyyy" />
                    </td>
                    <c:if test="${sessionScope.role == 'ADMIN'}">
                      <td>
                        <div class="td-actions">
                          <c:choose>
                            <c:when test="${user.status == 'Active'}">
                              <%-- Deactivate button --%>
                              <form action="${pageContext.request.contextPath}/admin/users/deactivate"
                                    method="POST" style="margin:0;" id="deactivateForm${user.id}">
                                <input type="hidden" name="id" value="${user.id}" />
                                <button type="submit"
                                        class="btn-delete"
                                        id="deactivateBtn${user.id}"
                                        style="padding:3px 8px; font-size:10px; border-radius:4px;"
                                        onclick="return confirm('Deactivate this user?')">
                                  Deactivate
                                </button>
                              </form>
                            </c:when>
                            <c:otherwise>
                              <%-- Activate button --%>
                              <form action="${pageContext.request.contextPath}/admin/users/activate"
                                    method="POST" style="margin:0;" id="activateForm${user.id}">
                                <input type="hidden" name="id" value="${user.id}" />
                                <button type="submit"
                                        class="btn-edit"
                                        id="activateBtn${user.id}"
                                        style="padding:3px 8px; font-size:10px; border-radius:4px;">
                                  Activate
                                </button>
                              </form>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>
                    </c:if>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="6" style="text-align:center; color:var(--gray400); padding:28px 0;">
                    No students found.
                    <a href="${pageContext.request.contextPath}/admin/users/new">Add the first student.</a>
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div class="pagination-row">
        <span class="pagination-info" id="paginationInfo">
          Showing ${pageStart}–${pageEnd} of ${totalUsers} students
        </span>
        <div class="pagination-btns" id="paginationBtns">
          <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&q=${fn:escapeXml(param.q)}&status=${param.status}"
             class="page-btn ${currentPage <= 1 ? 'disabled' : ''}"
             id="prevPageBtn">&#8592;</a>

          <c:forEach begin="1" end="${totalPages}" var="p">
            <a href="${pageContext.request.contextPath}/admin/users?page=${p}&q=${fn:escapeXml(param.q)}&status=${param.status}"
               class="page-btn ${p == currentPage ? 'active' : ''}"
               id="pageBtn${p}">${p}</a>
          </c:forEach>

          <a href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&q=${fn:escapeXml(param.q)}&status=${param.status}"
             class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}"
             id="nextPageBtn">&#8594;</a>
        </div>
      </div>

    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/jzmm1l5wFh+q+oiaCOaFLvqFOEHmb"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>

