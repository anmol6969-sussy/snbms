package com.snbms.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet responsible for serving uploaded files (notice images, profile photos).
 * Maps the /uploads/* URL pattern to the actual file system upload directory.
 */
@WebServlet("/uploads/*")
public class FileHandlerServlet extends HttpServlet {

    // Store uploads in user's home directory so it works on any PC
    private static final String UPLOAD_DIR = System.getProperty("user.home") + "/snbms-uploads";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String filename = req.getPathInfo();
        if (filename == null || filename.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Remove leading slash
        filename = filename.substring(1);
        File file = new File(UPLOAD_DIR, filename);

        if (file.exists() && !file.isDirectory()) {
            String mimeType = getServletContext().getMimeType(file.getName());
            if (mimeType == null) mimeType = "application/octet-stream";
            resp.setContentType(mimeType);
            resp.setContentLength((int) file.length());
            Files.copy(file.toPath(), resp.getOutputStream());
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
