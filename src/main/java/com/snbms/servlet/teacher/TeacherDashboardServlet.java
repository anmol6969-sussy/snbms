package com.snbms.servlet.teacher;

import com.snbms.dao.NoticeDao;
import com.snbms.dao.UserDao;
import com.snbms.model.Notice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/teacher/dashboard")
public class TeacherDashboardServlet extends HttpServlet {
    private NoticeDao noticeDao = new NoticeDao();
    private UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Integer teacherId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        // Total notices only by this teacher
        int myNotices = noticeDao.countNotices(null, null, null, teacherId);
        req.setAttribute("totalNotices", myNotices);
        req.setAttribute("totalStudents", userDao.getTotalStudents());
        req.setAttribute("totalTeachers", userDao.getTotalTeachers());

        // Recent notices only by this teacher
        List<Notice> recentNotices = noticeDao.getNotices(null, null, null, 1, 5, teacherId);
        req.setAttribute("recentNotices", recentNotices);

        req.getRequestDispatcher("/WEB-INF/views/teacher/dashboard.jsp").forward(req, resp);
    }
}
