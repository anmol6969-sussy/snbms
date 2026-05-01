package com.snbms.servlet;

import com.snbms.dao.UserDao;
import com.snbms.model.User;
import java.io.File;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/profile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ProfileServlet extends HttpServlet {
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        User user = userDao.getUserById(userId);
        req.setAttribute("user", user);
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        int userId = (int) session.getAttribute("userId");
        User user = userDao.getUserById(userId);
        
        String fullName = req.getParameter("full_name");
        Part filePart = req.getPart("profile_image");
        String profileImage = user.getProfileImage();
        
        if (filePart != null && filePart.getSize() > 0) {
            String uploadPath = req.getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "profiles";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            
            String fileName = UUID.randomUUID().toString() + "_" + getFileName(filePart);
            filePart.write(uploadPath + File.separator + fileName);
            profileImage = "/uploads/profiles/" + fileName;
        }
        
        userDao.updateProfile(userId, fullName, profileImage);
        session.setAttribute("username", fullName);
        
        resp.sendRedirect(req.getContextPath() + "/profile?success=true");
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "default.jpg";
    }
}
