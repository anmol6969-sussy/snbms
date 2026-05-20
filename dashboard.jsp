<%--
  student/dashboard.jsp — Student Notice Board Dashboard
  Route: /student/dashboard  (STUDENT role)
  Request scope attributes:
    ${pinnedNotices}  — List<Notice>  (fields: id, title, postedDate, expiryDate,
                        categoryName, categoryBadgeClass)
    ${latestNotices}  — List<Notice>  (non-pinned, active; same fields)
    ${categories}     — List<Category> (fields: id, name)
    ${currentPage}    — Integer
    ${totalPages}     — Integer
    ${pageStart}      — Integer
    ${pageEnd}        — Integer
    ${totalNotices}   — Integer
  Session scope:
    ${sessionScope.username}, ${sessionScope.role}
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"  %>

<%-- Role guard --%>
<c:if test="${sessionScope.role != 'STUDENT'}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description"
        content="Student notice board — view pinned and latest school announcements." />
  <title>Notice Board — SNBMS</title>

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

  <div class="sidebar-overlay" id="sidebarOverlay"></div>

  <div class="layout-body">

  <!-- ══ SIDEBAR ═══════════════════════════════════════════ -->
  <aside class="snbms-sidebar" id="snbmsSidebar">
    <p class="sidebar-section-label">Menu</p>
    <ul class="sidebar-nav">
      <li class="sidebar-nav-item">
        <a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-nav-link sidebar-nav-link--active">
          <span class="sidebar-dot"></span><span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span><span class="sidebar-label">Notice Board</span>
        </a>
      </li>
      <li class="sidebar-nav-item">
        <a href="${pageContext.request.contextPath}/student/complaints/new" class="sidebar-nav-link">
          <span class="sidebar-dot"></span><span class="sidebar-icon"><i class="fas fa-exclamation-triangle"></i></span><span class="sidebar-label">Submit Complaint</span>
        </a>
      </li>
      <li class="sidebar-nav-item">
        <a href="${pageContext.request.contextPath}/profile" class="sidebar-nav-link">
          <span class="sidebar-dot"></span><span class="sidebar-icon"><i class="fas fa-user-circle"></i></span><span class="sidebar-label">My Profile</span>
        </a>
      </li>
    </ul>
  </aside>

  <main class="main-content" id="mainContent" style="padding:14px;">

  <!-- ══ PINNED BANNER ════════════════════════════════════ -->
  <c:if test="${not empty pinnedNotices}">
    <div class="pinned-banner" id="pinnedBanner" style="margin: -14px -14px 14px -14px;">
      <i class="fas fa-thumbtack text-danger"></i>&nbsp;&nbsp;${fn:length(pinnedNotices)} pinned notice${fn:length(pinnedNotices) > 1 ? 's' : ''} —
      <strong>${fn:escapeXml(pinnedNotices[0].title)}</strong>
    </div>
  </c:if>

  <!-- Quick action -->  
  <c:if test="${param.msg == 'ComplaintSubmitted'}">
    <div style="background:#d1fae5; border:1px solid #6ee7b7; border-radius:8px; padding:10px 14px; margin-bottom:12px; font-size:12px; color:#065f46;">
      <i class="fas fa-check-circle"></i> Your complaint has been submitted successfully.
    </div>
  </c:if>

  <!-- ══ CONTENT WRAPPER ════════════════════════════════ -->
  <div style="padding:0;">

    <!-- Search + Category Filter Row -->
    <form method="GET" action="${pageContext.request.contextPath}/student/dashboard"
          id="filterForm" style="margin-bottom:16px;">
      <div class="filter-row">
        <input
          type="text"
          name="q"
          value="${fn:escapeXml(param.q)}"
          class="form-control-custom search-input"
          id="noticeSearchInput"
          placeholder="Search notices…"
          data-target="allNoticesContainer"
          autocomplete="off"
        />
        <select name="category" class="form-control-custom" id="categoryFilterSelect"
                style="min-width:160px; flex:0 0 auto;"
                onchange="document.getElementById('filterForm').submit()">
          <option value="">All Categories</option>
          <c:forEach var="cat" items="${categories}">
            <option value="${cat.id}"
              ${param.category == cat.id ? 'selected' : ''}>
              ${fn:escapeXml(cat.name)}
            </option>
          </c:forEach>
        </select>
      </div>
    </form>

    <!-- ══ PINNED NOTICES SECTION ══════════════════════════ -->
    <c:if test="${not empty pinnedNotices}">
      <div class="section-label"><i class="fas fa-thumbtack text-danger"></i> Pinned</div>
      <div id="pinnedNoticesContainer" style="margin-bottom:20px;">
        <c:forEach var="notice" items="${pinnedNotices}">
          <div class="notice-row pinned" data-search-title="${fn:escapeXml(notice.title)}">
            <div class="notice-row-left">
              <div class="notice-title-text" title="${fn:escapeXml(notice.title)}">
                ${fn:escapeXml(notice.title)}
              </div>
              <div class="notice-meta-row">
                <span class="notice-date-text">
                  Posted: <fmt:formatDate value="${notice.postedDate}" pattern="d MMM yyyy" />
                </span>
                <c:if test="${not empty notice.expiryDate}">
                  <span class="notice-date-text">
                    · Expires: <fmt:formatDate value="${notice.expiryDate}" pattern="d MMM yyyy" />
                  </span>
                </c:if>
                <span class="badge-custom ${notice.categoryBadgeClass}">
                  ${fn:escapeXml(notice.categoryName)}
                </span>
              </div>
            </div>
            <div class="notice-row-right">
              <a href="${pageContext.request.contextPath}/notices/${notice.id}"
                 class="btn-view" id="viewPinned${notice.id}">View</a>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:if>

    <!-- ══ LATEST NOTICES SECTION ══════════════════════════ -->
    <div class="section-label">Latest Notices</div>
    <div id="allNoticesContainer">
      <c:choose>
        <c:when test="${not empty latestNotices}">
          <c:forEach var="notice" items="${latestNotices}">
            <div class="notice-row"
                 data-search-title="${fn:escapeXml(notice.title)}">
              <div class="notice-row-left">
                <div class="notice-title-text" title="${fn:escapeXml(notice.title)}">
                  ${fn:escapeXml(notice.title)}
                </div>
                <div class="notice-meta-row">
                  <span class="notice-date-text">
                    Posted: <fmt:formatDate value="${notice.postedDate}" pattern="d MMM yyyy" />
                  </span>
                  <c:if test="${not empty notice.expiryDate}">
                    <span class="notice-date-text">
                      · Expires: <fmt:formatDate value="${notice.expiryDate}" pattern="d MMM yyyy" />
                    </span>
                  </c:if>
                  <span class="badge-custom ${notice.categoryBadgeClass}">
                    ${fn:escapeXml(notice.categoryName)}
                  </span>
                </div>
              </div>
              <div class="notice-row-right">
                <a href="${pageContext.request.contextPath}/notices/${notice.id}"
                   class="btn-view" id="viewLatest${notice.id}">View</a>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div style="font-size:12px; color:var(--gray400); padding:28px 0; text-align:center;">
            No notices available at this time.
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- ══ PAGINATION ══════════════════════════════════════ -->
    <c:if test="${totalPages > 1}">
      <div class="pagination-row" id="paginationRow">
        <span class="pagination-info" id="paginationInfo">
          Showing ${pageStart}–${pageEnd} of ${totalNotices} notices
        </span>
        <div class="pagination-btns" id="paginationBtns">
          <a href="${pageContext.request.contextPath}/student/dashboard?page=${currentPage - 1}&category=${param.category}&q=${fn:escapeXml(param.q)}"
             class="page-btn ${currentPage <= 1 ? 'disabled' : ''}"
             id="prevPageBtn">&#8592;</a>

          <c:forEach begin="1" end="${totalPages}" var="p">
            <a href="${pageContext.request.contextPath}/student/dashboard?page=${p}&category=${param.category}&q=${fn:escapeXml(param.q)}"
               class="page-btn ${p == currentPage ? 'active' : ''}"
               id="pageBtn${p}">${p}</a>
          </c:forEach>

          <a href="${pageContext.request.contextPath}/student/dashboard?page=${currentPage + 1}&category=${param.category}&q=${fn:escapeXml(param.q)}"
             class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}"
             id="nextPageBtn">&#8594;</a>
        </div>
      </div>
    </c:if>

  </div><%-- /.content-wrapper --%>
  </main>
  </div><%-- /.layout-body --%>
</div><%-- /.app-wrapper --%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/jzmm1l5wFh+q+oiaCOaFLvqFOEHmb"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>

