<%--
  admin/noticeForm.jsp — Add / Edit Notice
  Route: /admin/notices/new         (GET  → new notice)
         /admin/notices/{id}/edit   (GET  → edit existing)
  POST target: /admin/notices/save
  Request scope attributes:
    ${notice}     — Notice object (null for new); fields: id, title, content, categoryId,
                    status, postedDate (java.util.Date), expiryDate (java.util.Date),
                    isPinned (boolean)
    ${categories} — List<Category> (fields: id, name)
  Session scope:
    ${sessionScope.username}, ${sessionScope.role}
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"     prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"      prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>

<%-- Role guard --%>
<c:if test="${sessionScope.role != 'ADMIN' and sessionScope.role != 'TEACHER'}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<c:set var="isEdit" value="${not empty notice and not empty notice.id}" />

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="${isEdit ? 'Edit Notice' : 'Add New Notice'} — SNBMS Admin." />
  <title>${isEdit ? 'Edit Notice' : 'Add Notice'} — SNBMS Admin</title>

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
              <a href="${pageContext.request.contextPath}/admin/notices/new" class="sidebar-nav-link active">
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
              <a href="${pageContext.request.contextPath}/admin/notices/new" class="sidebar-nav-link active">
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
          <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-link">
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

      <!-- Page Title -->
      <div class="page-title-bar">
        <div>
          <h2>${isEdit ? 'Edit Notice' : 'Add New Notice'}</h2>
          <div class="page-subtitle">Fill in all required fields</div>
        </div>
      </div>

      <!-- Notice Form -->
      <form id="noticeForm"
            action="${pageContext.request.contextPath}/admin/notices/save"
            method="POST"
            enctype="multipart/form-data"
            novalidate
            style="max-width:640px;">

        <%-- Hidden notice ID (empty for new) --%>
        <input type="hidden" name="id" id="noticeId"
               value="${isEdit ? notice.id : ''}" />

        <!-- Title -->
        <div class="form-group">
          <label class="form-label-custom" for="noticeTitle">
            Notice Title <span class="req">*</span>
          </label>
          <input
            type="text"
            id="noticeTitle"
            name="title"
            class="form-control-custom"
            placeholder="Enter a clear, descriptive title"
            minlength="5"
            required
            value="${isEdit ? fn:escapeXml(notice.title) : ''}"
          />
          <div class="field-error" id="titleError"></div>
        </div>

        <!-- Category + Pin (2-column) -->
        <div class="form-grid-2">
          <div class="form-group" style="margin-bottom:0;">
            <label class="form-label-custom" for="categoryId">
              Category <span class="req">*</span>
            </label>
            <select id="categoryId" name="categoryId" class="form-control-custom" required>
              <option value="">— Select category —</option>
              <c:forEach var="cat" items="${categories}">
                <option value="${cat.id}"
                  ${isEdit and notice.categoryId == cat.id ? 'selected' : ''}>
                  ${fn:escapeXml(cat.name)}
                </option>
              </c:forEach>
            </select>
          </div>

          <div class="form-group" style="margin-bottom:0; display:flex; flex-direction:column; justify-content:flex-end;">
            <label class="form-label-custom" style="margin-bottom:8px;">&nbsp;</label>
            <label style="display:flex; align-items:center; gap:8px; font-size:12px; color:var(--gray600); cursor:pointer;">
              <input
                type="checkbox"
                id="pinnedCheck"
                name="pinned"
                value="true"
                ${isEdit and notice.isPinned ? 'checked' : ''}
                style="width:14px; height:14px; accent-color:var(--amber);"
              />
              Mark as Pinned / Important
            </label>
          </div>
        </div>

        <!-- Posted Date + Expiry Date (2-column) -->
        <div class="form-grid-2">
          <div class="form-group" style="margin-bottom:0;">
            <label class="form-label-custom" for="postedDate">
              Posted Date <span class="req">*</span>
            </label>
            <input
              type="date"
              id="postedDate"
              name="postedDate"
              class="form-control-custom"
              required
              value="${isEdit ? notice.postedDateStr : ''}"
            />
          </div>

          <div class="form-group" style="margin-bottom:0;">
            <label class="form-label-custom" for="expiryDate">Expiry Date</label>
            <input
              type="date"
              id="expiryDate"
              name="expiryDate"
              class="form-control-custom"
              value="${isEdit ? notice.expiryDateStr : ''}"
            />
            <div class="field-error" id="expiryDateError"></div>
          </div>
        </div>

        <!-- Content -->
        <div class="form-group" style="margin-top:12px;">
          <label class="form-label-custom" for="noticeContent">
            Notice Content <span class="req">*</span>
          </label>
          <textarea
            id="noticeContent"
            name="content"
            class="form-control-custom"
            placeholder="Write the full notice content here (minimum 20 characters)…"
            minlength="20"
            required
          >${isEdit ? fn:escapeXml(notice.content) : ''}</textarea>
          <div class="field-error" id="contentError"></div>
        </div>

        <div class="form-group">
          <label class="form-label-custom" for="noticeStatus">Status</label>
          <select id="noticeStatus" name="status" class="form-control-custom">
            <option value="Published" ${isEdit and notice.status == 'Published' ? 'selected' : ''}>Published</option>
            <option value="Draft"     ${isEdit and notice.status == 'Draft'     ? 'selected' : ''}>Draft</option>
          </select>
        </div>
        
        <!-- Image Upload -->
        <div class="form-group mt-3">
            <label class="form-label-custom" for="noticeImage">Notice Image (Optional)</label>
            <c:if test="${not empty notice.imageUrl}">
                <div class="mb-2">
                    <img src="${pageContext.request.contextPath}${notice.imageUrl}" alt="Notice Image" style="max-width: 200px; border-radius: 8px;">
                </div>
            </c:if>
            <input type="file" id="noticeImage" name="image_url" class="form-control-custom" accept="image/*">
        </div>

        <!-- Form Actions -->
        <div class="form-actions">
          <button type="submit" class="btn-primary-custom" id="saveNoticeBtn">Save Notice</button>
          <a href="${pageContext.request.contextPath}/admin/notices"
             class="btn-secondary-custom" id="cancelNoticeBtn">Cancel</a>
        </div>

      </form>

    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/jzmm1l5wFh+q+oiaCOaFLvqFOEHmb"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>

