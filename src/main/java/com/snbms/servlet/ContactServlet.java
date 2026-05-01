package com.snbms.servlet;

import com.snbms.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet handling the Contact page.
 * GET  → displays the contact form with support details.
 * POST → processes the inquiry form submission with validation.
 */
@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    /**
     * doGet: displays the contact page with the inquiry form.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
    }

    /**
     * doPost: processes the contact form submission.
     * Validates name, email, subject and message fields.
     * On success: shows a confirmation message.
     * On failure: returns form with error and preserved input.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name    = ValidationUtil.sanitize(req.getParameter("name"));
        String email   = ValidationUtil.sanitize(req.getParameter("email"));
        String subject = ValidationUtil.sanitize(req.getParameter("subject"));
        String message = ValidationUtil.sanitize(req.getParameter("message"));

        // Validate inputs
        if (!ValidationUtil.isValidFullName(name)) {
            req.setAttribute("error", "Please enter a valid full name (letters only).");
        } else if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("error", "Please enter a valid email address.");
        } else if (ValidationUtil.isEmpty(subject)) {
            req.setAttribute("error", "Please enter a subject.");
        } else if (ValidationUtil.isEmpty(message)) {
            req.setAttribute("error", "Please enter your message.");
        } else {
            // Inquiry submitted successfully
            req.setAttribute("success", "Thank you, " + name + "! Your inquiry has been submitted. We will get back to you at " + email + " shortly.");
            req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
            return;
        }

        // Return to form with error and preserved values
        req.setAttribute("formName",    name);
        req.setAttribute("formEmail",   email);
        req.setAttribute("formSubject", subject);
        req.setAttribute("formMessage", message);
        req.getRequestDispatcher("/WEB-INF/views/contact.jsp").forward(req, resp);
    }
}
