<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Submit Complaint - SNBMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; box-shadow: 2px 0 5px rgba(0,0,0,0.1); background-color: white; }
        .nav-link { color: #555; padding: 12px 20px; margin-bottom: 5px; border-radius: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f8f9fa; color: #0d6efd; }
        .nav-link i { width: 20px; text-align: center; margin-right: 10px; }
        .main-content { padding: 30px; }
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
                        <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
                        <a href="${pageContext.request.contextPath}/profile" class="nav-link"><i class="fas fa-user"></i> My Profile</a>
                        <a href="${pageContext.request.contextPath}/student/complaints/new" class="nav-link active"><i class="fas fa-exclamation-circle"></i> Submit Complaint</a>
                        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger mt-5"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Submit a Complaint</h2>
                </div>

                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/student/complaints/new" method="post">
                                    <div class="mb-3">
                                        <label class="form-label">Title <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" name="title" required placeholder="Brief title of your complaint">
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Target Teacher (Optional)</label>
                                        <select name="teacherId" class="form-select">
                                            <option value="">-- General Complaint (No specific teacher) --</option>
                                            <c:forEach var="t" items="${teachers}">
                                                <option value="${t.id}">${t.fullName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label class="form-label">Description <span class="text-danger">*</span></label>
                                        <textarea class="form-control" name="description" rows="5" required placeholder="Describe your complaint in detail..."></textarea>
                                    </div>
                                    
                                    <div class="mb-4 form-check text-danger">
                                        <input class="form-check-input" type="checkbox" name="isAnonymous" value="true" id="isAnonymous">
                                        <label class="form-check-label fw-bold" for="isAnonymous">
                                            Submit Anonymously (Teachers will not see your name. Admin will still see your name.)
                                        </label>
                                    </div>
                                    
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary">Cancel</a>
                                        <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane me-1"></i> Submit Complaint</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
