package com.snbms.servlet.admin;

import com.snbms.dao.UserDao;
import com.snbms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/users/new")
public class UserCreateServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/admin/userForm.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username  = req.getParameter("username");
        String password  = req.getParameter("password");
        String fullName  = req.getParameter("full_name");
        String email     = req.getParameter("email");
        String role      = req.getParameter("role");

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/WEB-INF/views/admin/userForm.jsp").forward(req, resp);
            return;
        }

        User u = new User();
        u.setUsername(username.trim());
        u.setPassword(com.snbms.util.PasswordUtil.encryptPassword(password.trim()));
        u.setFullName(fullName.trim());
        u.setEmail(email.trim());
        u.setRole(role != null && role.equals("TEACHER") ? "TEACHER" : "STUDENT");
        u.setStatus("Active");

        boolean created = userDao.createUser(u);
        if (created) {
            resp.sendRedirect(req.getContextPath() + "/admin/users?msg=created");
        } else {
            req.setAttribute("error", "Username or email already exists.");
            req.getRequestDispatcher("/WEB-INF/views/admin/userForm.jsp").forward(req, resp);
        }
    }
}
