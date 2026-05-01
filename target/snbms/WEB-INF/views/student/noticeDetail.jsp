<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"  %>

<c:if test="${empty sessionScope.role}">
  <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>${fn:escapeXml(notice.title)} — SNBMS</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css" />
  <style>
    .comment-avatar {
      width: 38px; height: 38px; border-radius: 50%;
      object-fit: cover; flex-shrink: 0;
    }
    .comment-avatar-initial {
      width: 38px; height: 38px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 14px; font-weight: 700; color: white; flex-shrink: 0;
    }
    .teacher-badge { background: #0d6efd; color: white; font-size: 10px; padding: 2px 7px; border-radius: 20px; margin-left: 6px; }
    .comment-box { background: #f8f9fa; border-radius: 10px; padding: 14px 16px; }
    .reply-box { background: #edf2fb; border-radius: 8px; padding: 12px 14px; margin-left: 46px; }
    .reply-form-wrapper { display: none; }
    .reply-toggle { font-size: 12px; cursor: pointer; color: #0d6efd; border: none; background: none; padding: 0; }
    .avatar-blue { background-color: #3b82f6; }
    .avatar-green { background-color: #16a34a; }
    .avatar-red { background-color: #dc2626; }
    .avatar-purple { background-color: #7c3aed; }
    .avatar-teal { background-color: #0d9488; }
  </style>
</head>
<body>
<div class="app-wrapper">

  <!-- NAVBAR -->
  <nav class="snbms-navbar" id="snbmsNavbar">
    <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'TEACHER'}">
      <button class="sidebar-toggle-btn" id="sidebarToggle" aria-label="Toggle sidebar">&#9776;</button>
    </c:if>
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
          <c:when test="${sessionScope.role == 'ADMIN'}">
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-chart-line"></i></span><span class="sidebar-label">Dashboard</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span><span class="sidebar-label">Notices</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/users" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-users"></i></span><span class="sidebar-label">Users</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/complaints" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-exclamation-triangle"></i></span><span class="sidebar-label">Complaints</span></a></li>
          </c:when>
          <c:when test="${sessionScope.role == 'TEACHER'}">
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/teacher/dashboard" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-chart-line"></i></span><span class="sidebar-label">Dashboard</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/admin/notices" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span><span class="sidebar-label">Notices</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/teacher/complaints" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-exclamation-triangle"></i></span><span class="sidebar-label">Complaints</span></a></li>
          </c:when>
          <c:otherwise>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/student/dashboard" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span><span class="sidebar-label">Notice Board</span></a></li>
            <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/student/complaints/new" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-exclamation-triangle"></i></span><span class="sidebar-label">Submit Complaint</span></a></li>
          </c:otherwise>
        </c:choose>
        <li class="sidebar-nav-item"><a href="${pageContext.request.contextPath}/profile" class="sidebar-nav-link"><span class="sidebar-icon"><i class="fas fa-user-circle"></i></span><span class="sidebar-label">My Profile</span></a></li>
      </ul>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content" id="mainContent" style="padding: 0;">

      <!-- Back link -->
      <div style="padding:10px 14px; border-bottom:0.5px solid #e5e7eb;">
        <c:choose>
          <c:when test="${sessionScope.role == 'ADMIN'}"><a href="${pageContext.request.contextPath}/admin/notices" style="font-size:11px; color:#6b7280;">← Back to All Notices</a></c:when>
          <c:when test="${sessionScope.role == 'TEACHER'}"><a href="${pageContext.request.contextPath}/admin/notices" style="font-size:11px; color:#6b7280;">← Back to Notices</a></c:when>
          <c:otherwise><a href="${pageContext.request.contextPath}/student/dashboard" style="font-size:11px; color:#6b7280;">← Back to Notice Board</a></c:otherwise>
        </c:choose>
      </div>

      <c:if test="${notice.isPinned}">
        <div class="pinned-banner" id="noticePinnedBanner"><i class="fas fa-thumbtack"></i>&nbsp;&nbsp;This notice has been marked as important</div>
      </c:if>

      <div class="notice-detail-layout">
        <!-- Left: Notice body -->
        <div>
          <div class="notice-detail-header">
            <h1 class="notice-detail-title">${fn:escapeXml(notice.title)}</h1>
            <div class="notice-chips">
              <span class="badge-custom ${notice.categoryBadgeClass}">${fn:escapeXml(notice.categoryName)}</span>
              <span class="badge-custom ${notice.statusBadgeClass}">${fn:escapeXml(notice.status)}</span>
              <c:if test="${notice.isPinned}"><span class="badge-custom badge-pinned"><i class="fas fa-thumbtack text-danger"></i> Pinned</span></c:if>
            </div>
            <div class="notice-detail-meta">
              Posted: <fmt:formatDate value="${notice.postedDate}" pattern="d MMM yyyy" />
              &nbsp;·&nbsp;
              Expires: <c:choose><c:when test="${not empty notice.expiryDate}"><fmt:formatDate value="${notice.expiryDate}" pattern="d MMM yyyy" /></c:when><c:otherwise>N/A</c:otherwise></c:choose>
              &nbsp;·&nbsp;
              By: ${fn:escapeXml(notice.authorName)}
            </div>
          </div>

          <div class="notice-detail-body">
            <c:if test="${not empty notice.imageUrl}">
              <div style="margin-bottom: 20px; text-align: center;">
                <img src="${pageContext.request.contextPath}${notice.imageUrl}" style="max-width: 100%; max-height: 400px; object-fit: contain; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);" alt="Notice Image">
              </div>
            </c:if>
            <c:forTokens var="para" items="${notice.content}" delims="&#10;">
              <p style="margin-bottom:10px;">${fn:escapeXml(para)}</p>
            </c:forTokens>
          </div>

          <!-- Admin/Teacher edit footer -->
          <c:if test="${sessionScope.role == 'ADMIN' or sessionScope.role == 'TEACHER'}">
            <div class="notice-detail-footer">
              <a href="${pageContext.request.contextPath}/admin/notices/edit?id=${notice.id}" class="btn-edit" style="padding:6px 14px; font-size:11px; border-radius:5px;">Edit Notice</a>
              <c:if test="${sessionScope.role == 'ADMIN'}">
                <button type="button" class="btn-delete btn-confirm-delete" data-url="${pageContext.request.contextPath}/admin/notices/${notice.id}/delete" style="padding:6px 14px; font-size:11px; border-radius:5px;">Delete Notice</button>
              </c:if>
            </div>
          </c:if>

          <!-- =================== COMMENTS SECTION =================== -->
          <div id="comments" style="padding: 24px 28px 40px;">
            <h5 style="font-weight:700; margin-bottom:18px; color:#1f2937;">
              <i class="fas fa-comments me-2 text-primary"></i>Comments
              <span class="badge bg-secondary ms-1" style="font-size:12px;">${fn:length(comments)}</span>
            </h5>

            <!-- POST COMMENT (Students & Admins only) -->
            <c:if test="${sessionScope.role == 'STUDENT' or sessionScope.role == 'ADMIN'}">
              <div class="card border-0 shadow-sm mb-4" style="border-radius:10px;">
                <div class="card-body p-3">
                  <form action="${pageContext.request.contextPath}/notices/comment" method="post">
                    <input type="hidden" name="noticeId" value="${notice.id}">
                    <textarea class="form-control mb-2" name="content" rows="2" placeholder="Write a comment..." required style="border-radius:8px; resize:none;"></textarea>
                    <div class="text-end">
                      <button type="submit" class="btn btn-primary btn-sm px-4"><i class="fas fa-paper-plane me-1"></i>Post Comment</button>
                    </div>
                  </form>
                </div>
              </div>
            </c:if>

            <!-- COMMENTS LIST -->
            <c:choose>
              <c:when test="${empty comments}">
                <div class="text-center text-muted py-4">
                  <i class="fas fa-comment-slash fa-2x mb-2 opacity-50"></i>
                  <p class="mb-0">No comments yet.<c:if test="${sessionScope.role == 'STUDENT'}"> Be the first to comment!</c:if></p>
                </div>
              </c:when>
              <c:otherwise>
                <c:forEach var="comment" items="${comments}">
                  <div class="mb-3">
                    <!-- Top-level comment -->
                    <div class="d-flex gap-3 comment-box">
                      <c:choose>
                        <c:when test="${not empty comment.authorImage}">
                          <img src="${pageContext.request.contextPath}${comment.authorImage}" class="comment-avatar" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                          <div class="comment-avatar-initial ${comment.authorColor}">${comment.authorInitials}</div>
                        </c:otherwise>
                      </c:choose>
                      <div class="flex-grow-1">
                        <div class="d-flex align-items-center gap-2 mb-1">
                          <strong style="font-size:14px;">${fn:escapeXml(comment.authorName)}</strong>
                          <c:if test="${comment.authorRole == 'TEACHER'}"><span class="teacher-badge"><i class="fas fa-chalkboard-teacher me-1"></i>Teacher</span></c:if>
                          <c:if test="${comment.authorRole == 'ADMIN'}"><span class="teacher-badge" style="background:#6c757d;"><i class="fas fa-shield-alt me-1"></i>Admin</span></c:if>
                          <span class="text-muted" style="font-size:11px;"><fmt:formatDate value="${comment.postedDate}" pattern="MMM d, h:mm a"/></span>
                        </div>
                        <p class="mb-1" style="font-size:14px; color:#374151;">${fn:escapeXml(comment.content)}</p>

                        <!-- Reply button — visible to Teachers & Admins only -->
                        <c:if test="${sessionScope.role == 'TEACHER' or sessionScope.role == 'ADMIN'}">
                          <button class="reply-toggle mt-1" onclick="toggleReply('reply-form-${comment.id}')">
                            <i class="fas fa-reply me-1"></i>Reply
                          </button>
                          <div class="reply-form-wrapper mt-2" id="reply-form-${comment.id}">
                            <form action="${pageContext.request.contextPath}/notices/comment" method="post">
                              <input type="hidden" name="noticeId" value="${notice.id}">
                              <input type="hidden" name="parentId" value="${comment.id}">
                              <textarea class="form-control mb-2" name="content" rows="2" placeholder="Write a reply..." required style="border-radius:8px; resize:none; font-size:13px;"></textarea>
                              <button type="submit" class="btn btn-sm btn-outline-primary px-3"><i class="fas fa-paper-plane me-1"></i>Reply</button>
                              <button type="button" class="btn btn-sm btn-outline-secondary px-3 ms-1" onclick="toggleReply('reply-form-${comment.id}')">Cancel</button>
                            </form>
                          </div>
                        </c:if>
                      </div>
                    </div>

                    <!-- Replies -->
                    <c:forEach var="reply" items="${comment.replies}">
                      <div class="d-flex gap-3 reply-box mt-2">
                        <c:choose>
                          <c:when test="${not empty reply.authorImage}">
                            <img src="${pageContext.request.contextPath}${reply.authorImage}" class="comment-avatar" alt="Avatar" style="width:30px; height:30px;">
                          </c:when>
                          <c:otherwise>
                            <div class="comment-avatar-initial ${reply.authorColor}" style="width:30px; height:30px; font-size:11px;">${reply.authorInitials}</div>
                          </c:otherwise>
                        </c:choose>
                        <div class="flex-grow-1">
                          <div class="d-flex align-items-center gap-2 mb-1">
                            <strong style="font-size:13px;">${fn:escapeXml(reply.authorName)}</strong>
                            <c:if test="${reply.authorRole == 'TEACHER'}"><span class="teacher-badge"><i class="fas fa-chalkboard-teacher me-1"></i>Teacher</span></c:if>
                            <c:if test="${reply.authorRole == 'ADMIN'}"><span class="teacher-badge" style="background:#6c757d;">Admin</span></c:if>
                            <span class="text-muted" style="font-size:11px;"><fmt:formatDate value="${reply.postedDate}" pattern="MMM d, h:mm a"/></span>
                          </div>
                          <p class="mb-0" style="font-size:13px; color:#374151;">${fn:escapeXml(reply.content)}</p>
                        </div>
                      </div>
                    </c:forEach>
                  </div>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </div>
          <!-- =================== END COMMENTS =================== -->
        </div>

        <!-- Right: meta panel -->
        <div class="notice-meta-panel">
          <div class="section-label" style="margin-bottom:10px;">Notice Info</div>
          <div style="margin-bottom:10px;">
            <div style="font-size:10px; color:#9ca3af; margin-bottom:2px;">Category</div>
            <span class="badge-custom ${notice.categoryBadgeClass}">${fn:escapeXml(notice.categoryName)}</span>
          </div>
          <div style="margin-bottom:10px;">
            <div style="font-size:10px; color:#9ca3af; margin-bottom:2px;">Status</div>
            <span class="badge-custom ${notice.statusBadgeClass}">${fn:escapeXml(notice.status)}</span>
          </div>
          <div style="margin-bottom:10px;">
            <div style="font-size:10px; color:#9ca3af; margin-bottom:2px;">Posted</div>
            <div style="font-size:12px;"><fmt:formatDate value="${notice.postedDate}" pattern="d MMM yyyy" /></div>
          </div>
          <div style="margin-bottom:10px;">
            <div style="font-size:10px; color:#9ca3af; margin-bottom:2px;">Expires</div>
            <div style="font-size:12px;">
              <c:choose>
                <c:when test="${not empty notice.expiryDate}"><fmt:formatDate value="${notice.expiryDate}" pattern="d MMM yyyy" /></c:when>
                <c:otherwise>N/A</c:otherwise>
              </c:choose>
            </div>
          </div>
          <div style="margin-bottom:10px;">
            <div style="font-size:10px; color:#9ca3af; margin-bottom:2px;">Posted By</div>
            <div style="font-size:12px;">${fn:escapeXml(notice.authorName)}</div>
          </div>
          <c:if test="${notice.isPinned}">
            <div style="margin-top:8px;"><span class="badge-custom badge-pinned"><i class="fas fa-thumbtack text-danger"></i> Pinned</span></div>
          </c:if>
        </div>
      </div><!-- /.notice-detail-layout -->
    </main>
  </div>
</div>

<!-- Delete Confirmation Modal (Admin) -->
<c:if test="${sessionScope.role == 'ADMIN'}">
  <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:320px;">
      <div class="modal-content" style="border-radius:10px;">
        <div class="modal-header" style="padding:12px 16px;"><h5 class="modal-title" style="font-size:14px;">Confirm Delete</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
        <div class="modal-body" style="font-size:12px; padding:14px 16px; color:#6b7280;">Are you sure? This action cannot be undone.</div>
        <div class="modal-footer" style="padding:10px 16px; gap:8px;">
          <button type="button" class="btn-secondary-custom" data-bs-dismiss="modal" id="cancelDeleteBtn">Cancel</button>
          <button type="button" class="btn-delete" id="confirmDeleteBtn" style="padding:7px 14px; font-size:12px; border-radius:6px;">Delete</button>
        </div>
      </div>
    </div>
  </div>
</c:if>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
<script>
  function toggleReply(id) {
    var el = document.getElementById(id);
    el.style.display = el.style.display === 'none' || el.style.display === '' ? 'block' : 'none';
  }
</script>
</body>
</html>
