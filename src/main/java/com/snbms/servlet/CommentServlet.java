package com.snbms.servlet;

import com.snbms.dao.CommentDao;
import com.snbms.model.Comment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/notices/comment")
public class CommentServlet extends HttpServlet {
    private CommentDao commentDao = new CommentDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute("userId");
        String role = (String) req.getSession().getAttribute("role");
        
        String noticeIdStr = req.getParameter("noticeId");
        String content = req.getParameter("content");
        String parentIdStr = req.getParameter("parentId");
        
        if (noticeIdStr == null || content == null || content.trim().isEmpty()) {
            resp.sendRedirect(req.getHeader("Referer"));
            return;
        }
        
        int noticeId = Integer.parseInt(noticeIdStr);
        
        // Only STUDENT can post top-level comments; TEACHER can only reply
        // ADMIN can do both
        if ("TEACHER".equals(role) && (parentIdStr == null || parentIdStr.trim().isEmpty())) {
            // Teachers cannot post top-level comments, only replies
            resp.sendRedirect(req.getContextPath() + "/notices/" + noticeId + "?error=TeacherCannotComment");
            return;
        }
        
        Comment c = new Comment();
        c.setNoticeId(noticeId);
        c.setUserId(userId);
        c.setContent(content.trim());
        
        if (parentIdStr != null && !parentIdStr.trim().isEmpty()) {
            c.setParentId(Integer.parseInt(parentIdStr));
        }
        
        commentDao.createComment(c);
        resp.sendRedirect(req.getContextPath() + "/notices/" + noticeId + "#comments");
    }
}
