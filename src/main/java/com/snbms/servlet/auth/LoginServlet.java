package com.snbms.servlet.auth;

import com.snbms.dao.UserDao;
import com.snbms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("role") != null) {
            String role = (String) session.getAttribute("role");
            if ("ADMIN".equals(role)) resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            else if ("TEACHER".equals(role)) resp.sendRedirect(req.getContextPath() + "/teacher/dashboard");
            else resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        
        User authenticatedUser = userDao.authenticate(user, pass);
        
        if (authenticatedUser != null) {
            HttpSession session = req.getSession();
            session.setAttribute("userId", authenticatedUser.getId());
            session.setAttribute("username", authenticatedUser.getFullName());
            session.setAttribute("role", authenticatedUser.getRole());
            
            // clear prev error
            session.removeAttribute("error");
            
            if ("ADMIN".equals(authenticatedUser.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if ("TEACHER".equals(authenticatedUser.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/teacher/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            }
        } else {
            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
        }
    }
}

