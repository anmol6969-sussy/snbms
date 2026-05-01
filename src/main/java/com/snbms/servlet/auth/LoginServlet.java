package com.snbms.servlet.auth;

import com.snbms.model.User;
import com.snbms.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling user login and session creation.
 * GET  → displays login form (with cookie-prefilled username)
 * POST → authenticates credentials and creates session
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserService userService = new UserService();

    /**
     * doGet: shows the login page.
     * Reads the "lastUsername" cookie to pre-fill the username field.
     * Redirects already-logged-in users to their dashboard.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            String role = (String) session.getAttribute("role");
            resp.sendRedirect(req.getContextPath() + getDashboardPath(role));
            return;
        }

        // Read cookie to pre-fill username
        String savedUsername = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("lastUsername".equals(c.getName())) {
                    savedUsername = c.getValue();
                }
            }
        }
        req.setAttribute("savedUsername", savedUsername);

        // Show success message if coming from registration
        if ("true".equals(req.getParameter("registered"))) {
            req.setAttribute("success", "Account created successfully! Please log in.");
        }

        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    /**
     * doPost: processes login form submission.
     * Uses UserService to authenticate (with password encryption).
     * On success: creates session and saves username cookie.
     * On failure: returns to login form with error message.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Authenticate via service layer (handles encryption)
        User authenticatedUser = userService.authenticate(username, password);

        if (authenticatedUser != null) {
            HttpSession session = req.getSession();
            session.setAttribute("userId",   authenticatedUser.getId());
            session.setAttribute("username", authenticatedUser.getFullName());
            session.setAttribute("role",     authenticatedUser.getRole());

            // Save username cookie (30 days)
            Cookie userCookie = new Cookie("lastUsername", username.trim());
            userCookie.setMaxAge(30 * 24 * 60 * 60);
            userCookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
            resp.addCookie(userCookie);

            resp.sendRedirect(req.getContextPath() + getDashboardPath(authenticatedUser.getRole()));
        } else {
            req.setAttribute("error", "Invalid username or password. Please try again.");
            req.setAttribute("savedUsername", username);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        }
    }

    private String getDashboardPath(String role) {
        if ("ADMIN".equals(role))   return "/admin/dashboard";
        if ("TEACHER".equals(role)) return "/teacher/dashboard";
        return "/student/dashboard";
    }
}
