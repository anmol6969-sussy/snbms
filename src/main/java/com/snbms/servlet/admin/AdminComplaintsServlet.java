package com.snbms.servlet.admin;

import com.snbms.dao.ComplaintDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/complaints")
public class AdminComplaintsServlet extends HttpServlet {
    private ComplaintDao complaintDao = new ComplaintDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("complaints", complaintDao.getAllComplaintsForAdmin());
        req.getRequestDispatcher("/WEB-INF/views/admin/complaints.jsp").forward(req, resp);
    }
}
