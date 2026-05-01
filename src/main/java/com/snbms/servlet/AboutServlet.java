package com.snbms.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet handling the About page request.
 * Provides information about the institution and the SNBMS system.
 * Accessible to all authenticated users regardless of role.
 */
@WebServlet("/about")
public class AboutServlet extends HttpServlet {

    /**
     * doGet: forwards the request to the about.jsp view.
     * No model data needed — page is static informational content.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/about.jsp").forward(req, resp);
    }
}
