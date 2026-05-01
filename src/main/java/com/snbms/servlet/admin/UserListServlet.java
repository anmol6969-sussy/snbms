package com.snbms.servlet.admin;

import com.snbms.dao.UserDao;
import com.snbms.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class UserListServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        String status = req.getParameter("status");
        
        int page = 1;
        int pageSize = 10;
        try {
            if(req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception e) {}
        
        int total = userDao.countStudents(q, status);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if(page < 1) page = 1;
        if(page > totalPages && totalPages > 0) page = totalPages;
        
        List<User> users = userDao.getStudents(q, status, page, pageSize);
        
        req.setAttribute("users", users);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalUsers", total);
        req.setAttribute("pageStart", total == 0 ? 0 : ((page - 1) * pageSize) + 1);
        req.setAttribute("pageEnd", Math.min(page * pageSize, total));
        
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }
}

