<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404 — Page Not Found</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
    <style>
        body { display:flex; align-items:center; justify-content:center; min-height:100vh; margin:0; background:#f5f5f5; font-family:sans-serif; }
        .error-box { text-align:center; padding:3rem; background:#fff; border-radius:12px; box-shadow:0 2px 16px rgba(0,0,0,0.08); max-width:400px; }
        h1 { font-size:4rem; margin:0; color:#4f46e5; }
        h2 { margin:0.5rem 0 1rem; color:#333; }
        p  { color:#666; margin-bottom:1.5rem; }
        a  { color:#4f46e5; text-decoration:none; font-weight:500; }
    </style>
</head>
<body>
<div class="error-box">
    <h1>404</h1>
    <h2>Page Not Found</h2>
    <p>The page you are looking for does not exist or has been moved.</p>
    <a href="${pageContext.request.contextPath}/login">Go to Login</a>
</div>
</body>
</html>
