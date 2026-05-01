package com.snbms.servlet.teacher;

import com.snbms.dao.ComplaintDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/teacher/complaints")
public class TeacherComplaintsServlet extends HttpServlet {
    private ComplaintDao complaintDao = new ComplaintDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int teacherId = (int) req.getSession().getAttribute("userId");
        req.setAttribute("complaints", complaintDao.getComplaintsForTeacher(teacherId));
        req.getRequestDispatcher("/WEB-INF/views/teacher/complaints.jsp").forward(req, resp);
    }
}
