package com.snbms.servlet.admin;

import com.snbms.dao.CategoryDao;
import com.snbms.dao.NoticeDao;
import com.snbms.model.Notice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/notices")
public class NoticeListServlet extends HttpServlet {
    private NoticeDao noticeDao = new NoticeDao();
    private CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        String categoryId = req.getParameter("categoryId");
        String status = req.getParameter("status");

        // Determine if teacher - teachers only see their own notices
        HttpSession session = req.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        Integer authorId = null;
        if ("TEACHER".equals(role)) {
            Object uid = session.getAttribute("userId");
            if (uid != null) authorId = (Integer) uid;
        }

        int page = 1;
        int pageSize = 10;
        try {
            if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception e) {}

        int total = noticeDao.countNotices(q, categoryId, status, authorId);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (page < 1) page = 1;
        if (page > totalPages && totalPages > 0) page = totalPages;

        List<Notice> notices = noticeDao.getNotices(q, categoryId, status, page, pageSize, authorId);

        req.setAttribute("notices", notices);
        req.setAttribute("categories", categoryDao.getAllCategories());
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalNotices", total);
        req.setAttribute("pageStart", total == 0 ? 0 : ((page - 1) * pageSize) + 1);
        req.setAttribute("pageEnd", Math.min(page * pageSize, total));

        req.getRequestDispatcher("/WEB-INF/views/admin/notices.jsp").forward(req, resp);
    }
}
