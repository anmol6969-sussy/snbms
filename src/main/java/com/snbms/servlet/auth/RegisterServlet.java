package com.snbms.servlet.auth;

import com.snbms.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;
import java.io.IOException;

/**
 * Servlet handling student self-registration.
 * GET  → displays the registration form
 * POST → validates input and creates a new student account
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserService userService = new UserService();

    /**
     * doGet method: displays the registration form.
     * If user is already logged in, redirects to their dashboard.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // If already logged in, redirect away
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }

        // Pre-fill username from cookie if returning user
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

        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    /**
     * doPost method: processes registration form submission.
     * Validates all fields, checks for duplicates, and creates the account.
     * On success: saves username cookie and redirects to login.
     * On failure: returns to form with error message and preserved input.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName       = req.getParameter("fullName");
        String username       = req.getParameter("username");
        String email          = req.getParameter("email");
        String password       = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");

        // Delegate validation and creation to service layer
        String errorMessage = userService.registerStudent(
                username, fullName, email, password, confirmPassword);

        if (errorMessage != null) {
            // Return to form with error, preserve entered values
            req.setAttribute("error", errorMessage);
            req.setAttribute("fullName", fullName);
            req.setAttribute("username", username);
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        // Save username in cookie for convenience (7 days)
        Cookie userCookie = new Cookie("lastUsername", username.trim());
        userCookie.setMaxAge(7 * 24 * 60 * 60);
        userCookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
        resp.addCookie(userCookie);

        // Redirect to login with success message
        resp.sendRedirect(req.getContextPath() + "/login?registered=true");
    }
}
