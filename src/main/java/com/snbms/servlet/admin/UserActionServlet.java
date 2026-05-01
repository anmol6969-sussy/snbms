package com.snbms.servlet.admin;

import com.snbms.dao.UserDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet handling user account activation and deactivation.
 * Reads the user ID from either the request body or query string.
 * Maps to both /admin/users/activate and /admin/users/deactivate.
 */
@WebServlet({"/admin/users/activate", "/admin/users/deactivate"})
public class UserActionServlet extends HttpServlet {

    private UserDao userDao = new UserDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri    = req.getRequestURI();
        boolean activate = uri.endsWith("activate") && !uri.endsWith("deactivate");

        // Read id from form body first, then fall back to query string
        String idStr = req.getParameter("id");

        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                if (activate) {
                    userDao.updateUserStatus(id, "Active");
                } else {
                    userDao.updateUserStatus(id, "Inactive");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
