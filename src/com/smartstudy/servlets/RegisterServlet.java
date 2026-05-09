package com.smartstudy.servlets;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String firstName       = req.getParameter("firstName").trim();
        String lastName        = req.getParameter("lastName").trim();
        String email           = req.getParameter("email").trim();
        String department      = req.getParameter("department").trim();
        String password        = req.getParameter("password").trim();
        String confirmPassword = req.getParameter("confirmPassword").trim();

        // Validation
        if (firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            req.setAttribute("errorMsg", "All fields are required.");
            req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("errorMsg", "Passwords do not match.");
            req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 6) {
            req.setAttribute("errorMsg", "Password must be at least 6 characters.");
            req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();

            if (userDAO.emailExists(email)) {
                req.setAttribute("errorMsg", "This email is already registered. Please log in.");
                req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
                return;
            }

            User newUser = new User();
            newUser.setFirstName(firstName);
            newUser.setLastName(lastName);
            newUser.setEmail(email);
            newUser.setPassword(password); // Hash in production: BCrypt.hashpw(password, BCrypt.gensalt())
            newUser.setRole("student");
            newUser.setDepartment(department);

            boolean created = userDAO.registerStudent(newUser);

            if (created) {
                req.setAttribute("successMsg", "Account created! You can now log in.");
                req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorMsg", "Registration failed. Please try again.");
                req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Server error: " + e.getMessage());
            req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("jsp/register.jsp").forward(req, resp);
    }
}
