<%--
  login.jsp — Authentication page
  Route: /login  (GET shows form, POST handled by LoginServlet)
  Session attributes used: ${error} (String, set by servlet on failed login)
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="Sign in to the School Notice Board Management System — Admin &amp; Student Portal." />
  <title>Login — School Notice Board</title>

  <!-- Bootstrap 5 CSS -->
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
        crossorigin="anonymous" />
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />

  <!-- Custom styles -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css" />
</head>
<body>

<div class="login-page">
  <div class="login-card">

    <!-- Card Top — Brand -->
    <div class="login-card-top">
      <div class="login-card-icon"><i class="fas fa-graduation-cap"></i></div>
      <div class="login-card-title">School Notice Board</div>
      <div class="login-card-subtitle">Admin &amp; Student Portal</div>
    </div>

    <!-- Card Body — Login Form -->
    <div class="login-card-body">

      <%-- Display error message from servlet --%>
      <c:if test="${not empty error}">
        <div class="alert-error" id="loginError">${error}</div>
      </c:if>

      <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST" novalidate>

        <div class="form-group">
          <label class="form-label-custom" for="username">Username</label>
          <input
            type="text"
            id="username"
            name="username"
            class="form-control-custom"
            placeholder="Enter username"
            autocomplete="username"
            required
            value="${not empty param.username ? param.username : ''}"
          />
        </div>

        <div class="form-group">
          <label class="form-label-custom" for="password">Password</label>
          <input
            type="password"
            id="password"
            name="password"
            class="form-control-custom"
            placeholder="Enter password"
            autocomplete="current-password"
            required
          />
        </div>

        <button type="submit" id="loginBtn" class="login-btn">Login</button>

        <div class="auth-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Register here</a>
        </div>

      </form>

      <a href="#" class="forgot-link">Forgot password?</a>

    </div>
  </div>
</div>

<!-- Bootstrap 5 JS Bundle -->
<script
  src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
  integrity="sha384-YvpcrYf0tY3lHB60NNkmXc4s9bIOgUxi8T/jzmm1l5wFh+q+oiaCOaFLvqFOEHmb"
  crossorigin="anonymous">
</script>
<script src="${pageContext.request.contextPath}/static/js/app.js"></script>
</body>
</html>

