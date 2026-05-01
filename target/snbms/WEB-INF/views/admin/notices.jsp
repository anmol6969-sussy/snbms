<%--
  admin/notices.jsp — Manage All Notices (Admin)
  Route: /admin/notices  (ADMIN role)
  Request scope attributes:
    ${notices}       — List<Notice>  (fields: id, title, categoryName, categoryBadgeClass,
                       status, statusBadgeClass, postedDate, expiryDate, isPinned)
    ${categories}    — List<Category> (fields: id, name)
    ${currentPage}   — Integer
    ${totalPages}    — Integer
    ${totalNotices}  — Integer
    ${pageStart}     — Integer (first item index on this page)
    ${pageEnd}       — Integer (last item index on this page)
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

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Manage all school notices — Admin panel." />
  <title>${sessionScope.role == 'TEACHER' ? 'My Notices' : 'All Notices'} — SNBMS</title>

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
              <a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link active">
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
              <a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link active">
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

      <!-- Page Title Bar -->
      <div class="page-title-bar">
        <div>
          <h2>${sessionScope.role == 'TEACHER' ? 'My Notices' : 'All Notices'}</h2>
        </div>
        <a href="${pageContext.request.contextPath}/admin/notices/new"
           class="btn-small-navy" id="addNoticeBtn">+ Add Notice</a>
      </div>

      <!-- Filter Row -->
      <form method="GET" action="${pageContext.request.contextPath}/admin/notices" id="filterForm">
        <div class="filter-row">
          <input
            type="text"
            name="q"
            value="${fn:escapeXml(param.q)}"
            class="form-control-custom search-input"
            id="noticesSearchInput"
            placeholder="Search by title…"
            data-target="noticesTableBody"
            autocomplete="off"
          />

          <select name="categoryId" class="form-control-custom" id="categoryFilter"
                  onchange="document.getElementById('filterForm').submit()">
            <option value="">All Categories</option>
            <c:forEach var="cat" items="${categories}">
              <option value="${cat.id}"
                ${param.categoryId == cat.id ? 'selected' : ''}>
                ${fn:escapeXml(cat.name)}
              </option>
            </c:forEach>
          </select>

          <select name="status" class="form-control-custom" id="statusFilter"
                  onchange="document.getElementById('filterForm').submit()">
            <option value="">All Status</option>
            <option value="Published" ${param.status == 'Published' ? 'selected' : ''}>Published</option>
            <option value="Draft"     ${param.status == 'Draft'     ? 'selected' : ''}>Draft</option>
            <option value="Active"    ${param.status == 'Active'    ? 'selected' : ''}>Active</option>
            <option value="Inactive"  ${param.status == 'Inactive'  ? 'selected' : ''}>Inactive</option>
          </select>

          <button type="submit" class="btn-primary-custom" id="filterSubmitBtn"
                  style="padding:7px 12px; font-size:11px;">Filter</button>
        </div>
      </form>

      <!-- Notices Table -->
      <div class="data-table-wrapper">
        <table class="data-table" id="noticesTable">
          <thead>
            <tr>
              <th style="width:36px;">#</th>
              <th>Title</th>
              <th>Category</th>
              <th>Status</th>
              <th>Posted Date</th>
              <th>Expires</th>
              <th style="width:100px;">Actions</th>
            </tr>
          </thead>
          <tbody id="noticesTableBody">
            <c:choose>
              <c:when test="${not empty notices}">
                <c:forEach var="notice" items="${notices}" varStatus="loop">
                  <tr class="${notice.isPinned ? 'row-pinned' : ''}"
                      data-search-title="${fn:escapeXml(notice.title)}">
                    <td class="text-gray">${loop.index + 1}</td>
                    <td class="td-title" title="${fn:escapeXml(notice.title)}">
                      ${fn:escapeXml(fn:length(notice.title) > 40
                        ? fn:substring(notice.title, 0, 40).concat('…')
                        : notice.title)}
                    </td>
                    <td>
                      <span class="badge-custom ${notice.categoryBadgeClass}">
                        ${fn:escapeXml(notice.categoryName)}
                      </span>
                    </td>
                    <td>
                      <span class="badge-custom ${notice.statusBadgeClass}">
                        ${fn:escapeXml(notice.status)}
                      </span>
                    </td>
                    <td class="td-date">
                      <fmt:formatDate value="${notice.postedDate}" pattern="d MMM yyyy" />
                    </td>
                    <td class="td-date">
                      <c:choose>
                        <c:when test="${not empty notice.expiryDate}">
                          <fmt:formatDate value="${notice.expiryDate}" pattern="d MMM yyyy" />
                        </c:when>
                        <c:otherwise>—</c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <div class="td-actions">
                        <a href="${pageContext.request.contextPath}/admin/notices/edit?id=${notice.id}"
                           class="btn-edit" id="editBtn${notice.id}">Edit</a>
                        <form method="POST"
                                      action="${pageContext.request.contextPath}/admin/notices/delete"
                                      style="margin:0; display:inline;">
                                    <input type="hidden" name="id" value="${notice.id}" />
                                    <button type="submit"
                                            class="btn-delete"
                                            onclick="return confirm('Delete this notice? This cannot be undone.')">
                                        Delete
                                    </button>
                                </form>
                      </div>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <tr>
                  <td colspan="7" style="text-align:center; color:var(--gray400); padding:28px 0;">
                    No notices found.
                    <a href="${pageContext.request.contextPath}/admin/notices/new">Add one now.</a>
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
          Showing ${pageStart}–${pageEnd} of ${totalNotices} notices
        </span>
        <div class="pagination-btns" id="paginationBtns">
          <%-- Previous --%>
          <a href="${pageContext.request.contextPath}/admin/notices?page=${currentPage - 1}&q=${fn:escapeXml(param.q)}&categoryId=${param.categoryId}&status=${param.status}"
             class="page-btn ${currentPage <= 1 ? 'disabled' : ''}"
             id="prevPageBtn">&#8592;</a>

          <%-- Page numbers --%>
          <c:forEach begin="1" end="${totalPages}" var="p">
            <a href="${pageContext.request.contextPath}/admin/notices?page=${p}&q=${fn:escapeXml(param.q)}&categoryId=${param.categoryId}&status=${param.status}"
               class="page-btn ${p == currentPage ? 'active' : ''}"
               id="pageBtn${p}">${p}</a>
          </c:forEach>

          <%-- Next --%>
          <a href="${pageContext.request.contextPath}/admin/notices?page=${currentPage + 1}&q=${fn:escapeXml(param.q)}&categoryId=${param.categoryId}&status=${param.status}"
             class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}"
             id="nextPageBtn">&#8594;</a>
        </div>
      </div>

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
</body>
</html>

