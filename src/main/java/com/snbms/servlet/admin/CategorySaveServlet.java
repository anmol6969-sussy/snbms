package com.snbms.servlet.admin;

import com.snbms.dao.CategoryDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/categories/save")
public class CategorySaveServlet extends HttpServlet {
    private CategoryDao categoryDao = new CategoryDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("categoryId");
        String name = req.getParameter("name");
        String description = req.getParameter("description");
        
        int id = 0;
        if (idStr != null && !idStr.isEmpty()) {
            try { id = Integer.parseInt(idStr); } catch (Exception e) {}
        }
        
        categoryDao.saveCategory(id, name, description);
        resp.sendRedirect(req.getContextPath() + "/admin/categories");
    }
}

