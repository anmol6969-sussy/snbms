package com.snbms.servlet.admin;

import com.snbms.dao.CategoryDao;
import com.snbms.dao.NoticeDao;
import com.snbms.model.Notice;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/admin/notices/new", "/admin/notices/edit"})
public class NoticeFormServlet extends HttpServlet {
    private CategoryDao categoryDao = new CategoryDao();
    private NoticeDao noticeDao = new NoticeDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        
        if (uri.endsWith("/edit") || req.getParameter("id") != null) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    Notice notice = noticeDao.getNoticeById(id);
                    req.setAttribute("notice", notice);
                } catch (Exception e) {}
            }
        }
        
        req.setAttribute("categories", categoryDao.getAllCategories());
        req.getRequestDispatcher("/WEB-INF/views/admin/noticeForm.jsp").forward(req, resp);
    }
}

