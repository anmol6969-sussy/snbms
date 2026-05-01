package com.snbms.servlet.admin;

import com.snbms.dao.NoticeDao;
import com.snbms.model.Notice;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.File;
import java.util.UUID;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

/**
 * Servlet handling creation and update of notices.
 * Processes the notice form submission including optional image upload.
 */
@WebServlet("/admin/notices/save")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize      = 1024 * 1024 * 10,
                 maxRequestSize   = 1024 * 1024 * 50)
public class NoticeSaveServlet extends HttpServlet {

    private NoticeDao noticeDao = new NoticeDao();

    // Fixed upload path - works on any PC
    private static final String UPLOAD_DIR =
            System.getProperty("user.home") + "/snbms-uploads/notices";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr       = req.getParameter("id");
        String title       = req.getParameter("title");
        String content     = req.getParameter("content");
        String categoryId  = req.getParameter("categoryId");
        String status      = req.getParameter("status");
        String postedDate  = req.getParameter("postedDate");
        String expiryDate  = req.getParameter("expiryDate");
        String pinned      = req.getParameter("pinned");

        Notice notice;
        if (idStr != null && !idStr.isEmpty()) {
            notice = noticeDao.getNoticeById(Integer.parseInt(idStr));
            if (notice == null) notice = new Notice();
        } else {
            notice = new Notice();
        }

        notice.setTitle(title);
        notice.setContent(content);
        notice.setCategoryId(Integer.parseInt(categoryId));
        notice.setStatus(status);

        try {
            notice.setPostedDate(
                new java.text.SimpleDateFormat("yyyy-MM-dd").parse(postedDate));
            if (expiryDate != null && !expiryDate.isEmpty()) {
                notice.setExpiryDate(
                    new java.text.SimpleDateFormat("yyyy-MM-dd").parse(expiryDate));
            } else {
                notice.setExpiryDate(null);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        notice.setIsPinned(pinned != null && "true".equals(pinned));
        if (notice.getId() == 0) {
            notice.setAuthorId((Integer) req.getSession().getAttribute("userId"));
        }

        // Image upload handling
        Part filePart = req.getPart("image_url");
        if (filePart != null && filePart.getSize() > 0) {
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
            filePart.write(UPLOAD_DIR + File.separator + fileName);
            notice.setImageUrl("/uploads/notices/" + fileName);
        }

        noticeDao.saveNotice(notice);
        resp.sendRedirect(req.getContextPath() + "/admin/notices");
    }

    private String getFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "default.jpg";
    }
}
