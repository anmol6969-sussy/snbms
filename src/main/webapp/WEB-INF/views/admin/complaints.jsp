<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Complaints - SNBMS Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; box-shadow: 2px 0 5px rgba(0,0,0,0.1); background-color: white; }
        .nav-link { color: #555; padding: 12px 20px; margin-bottom: 5px; border-radius: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f8f9fa; color: #0d6efd; }
        .nav-link i { width: 20px; text-align: center; margin-right: 10px; }
        .main-content { padding: 30px; }
        .complaint-card { border-left: 4px solid #0d6efd; }
        .complaint-card.anonymous { border-left-color: #dc3545; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 p-0 sidebar d-none d-md-block">
                <div class="p-3">
                    <h4 class="text-primary fw-bold text-center mb-4">
                        <i class="fas fa-graduation-cap border p-2 rounded-circle"></i><br/>SNBMS
                    </h4>
                    <div class="nav flex-column nav-pills mt-4">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
                        <a href="${pageContext.request.contextPath}/admin/notices" class="nav-link"><i class="fas fa-bullhorn"></i> Notices</a>
                        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link"><i class="fas fa-users"></i> Users</a>
                        <a href="${pageContext.request.contextPath}/admin/categories" class="nav-link"><i class="fas fa-tags"></i> Categories</a>
                        <a href="${pageContext.request.contextPath}/admin/complaints" class="nav-link active"><i class="fas fa-exclamation-circle"></i> Complaints</a>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Manage Complaints</h2>
                </div>

                <div class="row pt-2">
                    <c:forEach var="c" items="${complaints}">
                        <div class="col-md-12 mb-3">
                            <div class="card shadow-sm border-0 complaint-card ${c.anonymous ? 'anonymous' : ''}">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h5 class="fw-bold">${c.title}</h5>
                                            <div class="text-muted small mb-2">
                                                <i class="fas fa-user border p-1 rounded-circle me-1"></i> <strong>${c.studentName}</strong> 
                                                <c:if test="${c.anonymous}"><span class="badge bg-danger ms-1">Anonymized to Teachers</span></c:if>
                                                &nbsp;&nbsp;<i class="fas fa-calendar-alt ms-2 me-1"></i> <fmt:formatDate value="${c.submittedDate}" pattern="MMM dd, yyyy h:mm a"/>
                                            </div>
                                            <div class="text-muted small mb-3">
                                                <i class="fas fa-chalkboard-teacher border p-1 rounded-circle me-1"></i> Target: <strong>${not empty c.teacherName ? c.teacherName : 'General (All)'}</strong>
                                            </div>
                                            <p class="mb-0 bg-light p-3 rounded text-dark">${c.description}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty complaints}">
                        <div class="alert alert-info border-0 shadow-sm"><i class="fas fa-info-circle me-2"></i> No complaints found.</div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
