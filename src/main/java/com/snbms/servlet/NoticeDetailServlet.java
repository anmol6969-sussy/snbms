package com.snbms.servlet;

import com.snbms.dao.NoticeDao;
import com.snbms.dao.CommentDao;
import com.snbms.model.Notice;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/notices/*")
public class NoticeDetailServlet extends HttpServlet {
    private NoticeDao noticeDao = new NoticeDao();
    private CommentDao commentDao = new CommentDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String[] parts = uri.split("/");
        
        try {
            int id = Integer.parseInt(parts[parts.length - 1]);
            Notice notice = noticeDao.getNoticeById(id);
            if (notice != null) {
                req.setAttribute("notice", notice);
                req.setAttribute("comments", commentDao.getCommentsForNotice(id));
                req.getRequestDispatcher("/WEB-INF/views/student/noticeDetail.jsp").forward(req, resp);
                return;
            }
        } catch (Exception e) {}
        
        // If not found or error, return to dashboard based on role
        String role = (String) req.getSession().getAttribute("role");
        if ("ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/admin/notices");
        } else if ("TEACHER".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/teacher/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}


