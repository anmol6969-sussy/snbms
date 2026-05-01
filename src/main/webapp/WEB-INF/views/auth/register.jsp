<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — SNBMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
    <style>
        .auth-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: var(--bg-secondary, #f5f5f5);
            padding: 2rem 1rem;
        }
        .auth-card {
            background: #fff;
            border-radius: 12px;
            padding: 2.5rem;
            width: 100%;
            max-width: 460px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
        }
        .auth-card h1 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
            color: #1a1a2e;
        }
        .auth-card p.subtitle {
            color: #666;
            margin-bottom: 1.75rem;
            font-size: 0.9rem;
        }
        .form-group {
            margin-bottom: 1.1rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.4rem;
            font-weight: 500;
            font-size: 0.9rem;
            color: #333;
        }
        .form-group input {
            width: 100%;
            padding: 0.65rem 0.9rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 0.95rem;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4f46e5;
            box-shadow: 0 0 0 3px rgba(79,70,229,0.1);
        }
        .error-box {
            background: #fef2f2;
            border: 1px solid #fca5a5;
            color: #b91c1c;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            margin-bottom: 1.2rem;
            font-size: 0.9rem;
        }
        .btn-primary {
            width: 100%;
            padding: 0.75rem;
            background: #4f46e5;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 0.5rem;
        }
        .btn-primary:hover { background: #4338ca; }
        .auth-footer {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 0.9rem;
            color: #555;
        }
        .auth-footer a {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 500;
        }
        .hint {
            font-size: 0.8rem;
            color: #888;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <h1>Create Account</h1>
        <p class="subtitle">Register as a student on SNBMS</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="error-box">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/register" novalidate>

            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" placeholder="e.g. John Sharma"
                       value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>"
                       required>
                <div class="hint">Letters only — no numbers</div>
            </div>

            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="e.g. johns123"
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                       required>
                <div class="hint">3–30 characters, letters and numbers only</div>
            </div>

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="e.g. john@example.com"
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Minimum 6 characters" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       placeholder="Re-enter your password" required>
            </div>

            <button type="submit" class="btn-primary">Create Account</button>
        </form>

        <div class="auth-footer">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>
    </div>
</div>
</body>
</html>
