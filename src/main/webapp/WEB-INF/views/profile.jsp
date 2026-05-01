<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - SNBMS</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { min-height: 100vh; box-shadow: 2px 0 5px rgba(0,0,0,0.1); background-color: white; }
        .nav-link { color: #555; padding: 12px 20px; margin-bottom: 5px; border-radius: 5px; }
        .nav-link:hover, .nav-link.active { background-color: #f8f9fa; color: #0d6efd; }
        .nav-link i { width: 20px; text-align: center; margin-right: 10px; }
        .main-content { padding: 30px; }
        .profile-img-lg {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .avatar-placeholder-lg {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 64px;
            color: white;
            border: 4px solid white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            background-color: #0d6efd;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar Navigation based on Role -->
            <div class="col-md-2 p-0 sidebar d-none d-md-block">
                <div class="p-3">
                    <h4 class="text-primary fw-bold text-center mb-4">
                        <i class="fas fa-graduation-cap border p-2 rounded-circle"></i><br/>SNBMS
                    </h4>
                    <div class="nav flex-column nav-pills">
                        <c:choose>
                            <c:when test="${sessionScope.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
                            </c:when>
                            <c:when test="${sessionScope.role == 'TEACHER'}">
                                <a href="${pageContext.request.contextPath}/teacher/dashboard" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/student/dashboard" class="nav-link"><i class="fas fa-home"></i> Dashboard</a>
                            </c:otherwise>
                        </c:choose>
                        
                        <a href="${pageContext.request.contextPath}/profile" class="nav-link active"><i class="fas fa-user"></i> My Profile</a>
                        <a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger mt-5"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>Edit Profile</h2>
                </div>

                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">
                                <c:if test="${param.success == 'true'}">
                                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                                        <i class="fas fa-check-circle me-1"></i> Profile updated successfully!
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">
                                    <div class="text-center mb-4">
                                        <c:choose>
                                            <c:when test="${not empty user.profileImage}">
                                                <img src="${pageContext.request.contextPath}${user.profileImage}" class="profile-img-lg mb-3" alt="Profile">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="avatar-placeholder-lg mx-auto mb-3">
                                                    ${user.initials}
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <div>
                                            <label for="profile_image" class="form-label">Upload New Picture</label>
                                            <input class="form-control w-50 mx-auto" type="file" id="profile_image" name="profile_image" accept="image/*">
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Full Name</label>
                                            <input type="text" class="form-control" name="full_name" value="${user.fullName}" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Username</label>
                                            <input type="text" class="form-control" value="${user.username}" disabled>
                                            <div class="form-text">Username cannot be changed.</div>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Email Address</label>
                                            <input type="email" class="form-control" value="${user.email}" disabled>
                                             <div class="form-text">Email cannot be changed directly.</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Role</label>
                                            <input type="text" class="form-control" value="${user.role}" disabled>
                                        </div>
                                    </div>

                                    <hr>
                                    <div class="d-flex justify-content-end">
                                        <button type="submit" class="btn btn-primary px-4">
                                            <i class="fas fa-save me-1"></i> Save Changes
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
