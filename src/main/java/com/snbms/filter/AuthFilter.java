package com.snbms.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication and Authorization filter applied to all requests.
 * Enforces session-based authentication and role-based access control.
 * Manages redirects for unauthorized access attempts.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException { }

    /**
     * doFilter: intercepts every request to enforce login and role checks.
     * Public paths (login, register, static files) are allowed through.
     * Authenticated users are checked against their role before access is granted.
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI()
                        .substring(req.getContextPath().length())
                        .replaceAll("/+$", "");

        // Root redirect
        if (path.isEmpty() || path.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Public paths — no login required
        if (path.startsWith("/static/")
                || path.equals("/login")
                || path.equals("/logout")
                || path.equals("/register")) {
            chain.doFilter(request, response);
            return;
        }

        // Check login session
        HttpSession session   = req.getSession(false);
        boolean     loggedIn  = (session != null && session.getAttribute("role") != null);

        if (!loggedIn) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Role-based authorization
        if (path.startsWith("/admin")) {
            if ("TEACHER".equals(role)) {
                // Teachers can access notice/user management but not categories or admin dashboard
                if (path.startsWith("/admin/categories") || path.equals("/admin/dashboard")) {
                    resp.sendRedirect(req.getContextPath() + getDashboardPath(role));
                    return;
                }
            } else if (!"ADMIN".equals(role)) {
                resp.sendRedirect(req.getContextPath() + getDashboardPath(role));
                return;
            }
        }

        if (path.startsWith("/teacher") && !"TEACHER".equals(role) && !"ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + getDashboardPath(role));
            return;
        }

        if (path.startsWith("/student") && !"STUDENT".equals(role) && !"ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + getDashboardPath(role));
            return;
        }

        chain.doFilter(request, response);
    }

    private String getDashboardPath(String role) {
        if ("ADMIN".equals(role))   return "/admin/dashboard";
        if ("TEACHER".equals(role)) return "/teacher/dashboard";
        return "/student/dashboard";
    }

    @Override
    public void destroy() { }
}
