<%--
  admin/categories.jsp — Manage Notice Categories
  Route: /admin/categories  (ADMIN role)
  Request scope attributes:
    ${categories}  — List<Category>
                     fields: id, name, noticeCount, description, badgeClass, hasNotices (boolean)
  Session scope:
    ${sessionScope.username}, ${sessionScope.role}
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn" %>

<%-- Role guard --%>
<c:if test="${sessionScope.role != 'ADMIN'}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Manage notice categories — SNBMS Admin." />
  <title>Categories — SNBMS Admin</title>

  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
        crossorigin="anonymous" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css" />

  <style>
    /* Category badge inline styles override (exact hex values) */
    .cat-badge-exam        { background:#DBEAFE; color:#1D4ED8; }
    .cat-badge-holiday     { background:#D1FAE5; color:#065F46; }
    .cat-badge-fee         { background:#FEF3C7; color:#92400E; }
    .cat-badge-event       { background:#EDE9FE; color:#5B21B6; }
    .cat-badge-result      { background:#FCE7F3; color:#9D174D; }
    .cat-badge-scholarship { background:#CCFBF1; color:#134E4A; }
    .cat-badge-routine     { background:#FEE2E2; color:#991B1B; }
    .cat-badge-admission   { background:#FEF9C3; color:#713F12; }
  </style>
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
      </ul>
      <p class="sidebar-section-label">Manage</p>
      <ul class="sidebar-nav">
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-nav-link">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-tags"></i></span>
            <span class="sidebar-label">Categories</span>
          </a>
        </li>
        <li class="sidebar-nav-item">
          <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-link">
            <span class="sidebar-dot"></span>
            <span class="sidebar-icon"><i class="fas fa-users"></i></span>
            <span class="sidebar-label">Users</span>
          </a>
        </li>
      </ul>
    </aside>

    <!-- ══ MAIN CONTENT ═════════════════════════════════════ -->
    <main class="main-content" id="mainContent">

      <!-- Page Title Bar -->
      <div class="page-title-bar">
        <div>
          <h2>Notice Categories</h2>
        </div>
        <button type="button" class="btn-small-navy" id="addCategoryBtn">
          + Add Category
        </button>
      </div>

      <!-- Inline Add-Category Form (hidden by default) -->
      <div class="inline-form-panel" id="inlineCategoryForm">
        <form action="${pageContext.request.contextPath}/admin/categories/save"
              method="POST" id="categoryAddForm">
          <input type="hidden" name="categoryId" id="editCategoryId" value="" />
          <div class="inline-form-row">
            <div class="form-group">
              <label class="form-label-custom" for="categoryName">
                Category Name <span class="req" style="color:var(--red);">*</span>
              </label>
              <input type="text" id="categoryName" name="name"
                     class="form-control-custom" placeholder="e.g. Event Notice"
                     required />
            </div>
            <div class="form-group">
              <label class="form-label-custom" for="categoryDesc">Description</label>
              <input type="text" id="categoryDesc" name="description"
                     class="form-control-custom" placeholder="Short description" />
            </div>
            <div style="display:flex; gap:8px; align-items:flex-end; padding-bottom:1px;">
              <button type="submit" class="btn-primary-custom"
                      style="padding:7px 14px;" id="saveCategoryBtn">Save</button>
              <button type="button" class="btn-secondary-custom"
                      id="cancelCategoryBtn">Cancel</button>
            </div>
          </div>
        </form>
      </div>

      <!-- Categories Table -->
      <div class="data-table-wrapper">
        <table class="data-table" id="categoriesTable">
          <thead>
            <tr>
              <th style="width:36px;">#</th>
              <th>Category</th>
              <th style="text-align:center; width:100px;">Notice Count</th>
              <th>Description</th>
              <th style="width:110px;">Actions</th>
            </tr>
          </thead>
          <tbody id="categoriesTableBody">
            <c:choose>
              <c:when test="${not empty categories}">
                <c:forEach var="cat" items="${categories}" varStatus="loop">
                  <tr data-search-title="${fn:escapeXml(cat.name)}">
                    <td class="text-gray">${loop.index + 1}</td>
                    <td>
                      <span class="badge-custom ${cat.badgeClass}">
                        ${fn:escapeXml(cat.name)}
                      </span>
                    </td>
                    <td style="text-align:center; font-size:12px;">
                      ${cat.noticeCount}
                    </td>
                    <td class="td-small">
                      ${not empty cat.description ? fn:escapeXml(cat.description) : '—'}
                    </td>
                    <td>
                      <div class="td-actions">
                        <%-- Edit: open inline form populated with this category --%>
                        <button
                          type="button"
                          class="btn-edit btn-edit-category"
                          id="editCatBtn${cat.id}"
                          data-id="${cat.id}"
                          data-name="${fn:escapeXml(cat.name)}"
                          data-desc="${fn:escapeXml(cat.description)}">
                          Edit
                        </button>

                        <%-- Delete: disabled if category has notices --%>
                        <c:choose>
                          <c:when test="${cat.hasNotices}">
                            <button type="button"
                                    class="btn-delete disabled"
                                    id="deleteCatBtn${cat.id}"
                                    disabled
                                    title="Cannot delete — category has notices">
                              Delete
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button
                              type="button"
                              class="btn-delete btn-confirm-delete"
                              id="deleteCatBtn${cat.id}"
                              data-url="${pageContext.request.contextPath}/admin/categories/delete?id=${cat.id}">
                              Delete
                            </button>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="5" style="text-align:center; color:var(--gray400); padding:28px 0;">
                    No categories found.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
          </tbody>
        </table>
      </div>

      <!-- Footer note -->
      <p style="font-size:10px; color:var(--gray400); margin-top:4px;">
        Categories with associated notices cannot be deleted.
      </p>

    </main>
  </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1"
     aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" style="max-width:320px;">
    <div class="modal-content" style="border-radius:10px; border:0.5px solid var(--gray200);">
      <div class="modal-header" style="border-bottom:0.5px solid var(--gray200); padding:12px 16px;">
        <h5 class="modal-title" id="deleteModalLabel" style="font-size:14px; font-weight:500;">
          Confirm Delete
        </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" style="font-size:12px; padding:14px 16px; color:var(--gray600);">
        Are you sure? This action cannot be undone.
      </div>
      <div class="modal-footer" style="border-top:0.5px solid var(--gray200); padding:10px 16px; gap:8px;">
        <button type="button" class="btn-secondary-custom" data-bs-dismiss="modal"
                id="cancelDeleteBtn">Cancel</button>
        <button type="button" class="btn-delete" id="confirmDeleteBtn"
                style="padding:7px 14px; font-size:12px; border-radius:6px;">Delete</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/jzmm1l5wFh+q+oiaCOaFLvqFOEHmb"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>

<script>
  /* Edit category — populate inline form */
  document.querySelectorAll('.btn-edit-category').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var panel = document.getElementById('inlineCategoryForm');
      document.getElementById('editCategoryId').value = btn.getAttribute('data-id');
      document.getElementById('categoryName').value   = btn.getAttribute('data-name');
      document.getElementById('categoryDesc').value   = btn.getAttribute('data-desc');
      panel.classList.add('visible');
      document.getElementById('categoryName').focus();
    });
  });

  /* Cancel resets hidden id field */
  document.getElementById('cancelCategoryBtn').addEventListener('click', function () {
    document.getElementById('editCategoryId').value = '';
    document.getElementById('categoryName').value   = '';
    document.getElementById('categoryDesc').value   = '';
  });
</script>
</body>
</html>

