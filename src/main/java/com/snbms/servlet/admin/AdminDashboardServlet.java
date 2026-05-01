package com.snbms.servlet.admin;

import com.snbms.dao.CategoryDao;
import com.snbms.dao.NoticeDao;
import com.snbms.dao.UserDao;
import com.snbms.model.Notice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private NoticeDao noticeDao = new NoticeDao();
    private CategoryDao categoryDao = new CategoryDao();
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("totalNotices", noticeDao.getTotalNotices());
        req.setAttribute("totalCategories", categoryDao.getTotalCategories());
        req.setAttribute("totalStudents", userDao.getTotalStudents());
        
        List<Notice> recentNotices = noticeDao.getRecentNotices(5);
        req.setAttribute("recentNotices", recentNotices);

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}

