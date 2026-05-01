package com.snbms.servlet.student;

import com.snbms.dao.ComplaintDao;
import com.snbms.dao.UserDao;
import com.snbms.model.Complaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/student/complaints/new")
public class ComplaintFormServlet extends HttpServlet {
    private ComplaintDao complaintDao = new ComplaintDao();
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("teachers", userDao.getTeachers());
        req.getRequestDispatcher("/WEB-INF/views/student/complaintForm.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int studentId = (int) req.getSession().getAttribute("userId");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String teacherIdStr = req.getParameter("teacherId");
        boolean isAnonymous = "true".equals(req.getParameter("isAnonymous"));
        
        Complaint c = new Complaint();
        c.setStudentId(studentId);
        c.setTitle(title);
        c.setDescription(description);
        c.setAnonymous(isAnonymous);
        
        if (teacherIdStr != null && !teacherIdStr.trim().isEmpty()) {
            c.setTeacherId(Integer.parseInt(teacherIdStr));
        }
        
        complaintDao.createComplaint(c);
        resp.sendRedirect(req.getContextPath() + "/student/dashboard?msg=ComplaintSubmitted");
    }
}
