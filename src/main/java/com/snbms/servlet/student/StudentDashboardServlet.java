package com.snbms.servlet.student;

import com.snbms.dao.CategoryDao;
import com.snbms.dao.NoticeDao;
import com.snbms.model.Notice;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {
    private NoticeDao noticeDao = new NoticeDao();
    private CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String q = req.getParameter("q");
        String categoryId = req.getParameter("category");
        
        // Pinned notices (always fetch the first page or all of them)
        List<Notice> pinnedNotices = noticeDao.getStudentNotices(true, categoryId, q);
        
        // Latest notices (non-pinned) with pagination
        // Since sqlite simple limit/offset is easy, we just fetch all non-pinned for simplicity
        // in a real app, pagination would be applied strictly here.
        // For MVP, applying same logic as admin but filtered for student
        int page = 1;
        int pageSize = 10;
        try {
            if(req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
        } catch (Exception e) {}
        
        List<Notice> latestNotices = noticeDao.getStudentNotices(false, categoryId, q);
        
        int total = latestNotices.size();
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if(page < 1) page = 1;
        if(page > totalPages && totalPages > 0) page = totalPages;
        
        int startIdx = (page - 1) * pageSize;
        int endIdx = Math.min(startIdx + pageSize, total);
        
        List<Notice> pageNotices = latestNotices.subList(startIdx, endIdx);
        
        req.setAttribute("pinnedNotices", pinnedNotices);
        req.setAttribute("latestNotices", pageNotices);
        req.setAttribute("categories", categoryDao.getAllCategories());
        
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalNotices", total);
        req.setAttribute("pageStart", total == 0 ? 0 : startIdx + 1);
        req.setAttribute("pageEnd", endIdx);
        
        req.getRequestDispatcher("/WEB-INF/views/student/dashboard.jsp").forward(req, resp);
    }
}

