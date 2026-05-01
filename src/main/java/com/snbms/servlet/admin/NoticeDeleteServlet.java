package com.snbms.servlet.admin;

import com.snbms.dao.NoticeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/notices/delete")
public class NoticeDeleteServlet extends HttpServlet {
    private NoticeDao noticeDao = new NoticeDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                noticeDao.deleteNotice(id);
            } catch (Exception e) {}
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin/notices");
    }
}

