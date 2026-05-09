package com.smartstudy.servlets;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.dao.ResourceDAO;
import com.smartstudy.model.User;
import com.smartstudy.model.Resource;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email").trim();
        String password = req.getParameter("password").trim();
        String role     = req.getParameter("role");

        if (email.isEmpty() || password.isEmpty()) {
            req.setAttribute("errorMsg", "Email and password are required.");
            req.getRequestDispatcher("jsp/login.jsp?role=" + role).forward(req, resp);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.validateLogin(email, password, role);

            if (user == null) {
                req.setAttribute("errorMsg", "Invalid credentials. Please try again.");
                req.getRequestDispatcher("jsp/login.jsp?role=" + role).forward(req, resp);
                return;
            }

            // Create session
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", role);
            session.setMaxInactiveInterval(30 * 60); // 30 min

            if ("admin".equals(role)) {
                // Load admin data
                ResourceDAO rDAO = new ResourceDAO();
                List<Resource> resources = rDAO.getAllResources();
                List<User> students = userDAO.getAllStudents();
                req.setAttribute("resources", resources);
                req.setAttribute("students", students);
                req.getRequestDispatcher("jsp/admin.jsp").forward(req, resp);
            } else {
                // Load student dashboard
                ResourceDAO rDAO = new ResourceDAO();
                List<Resource> resources = rDAO.getAllResources();
                req.setAttribute("resources", resources);
                req.getRequestDispatcher("jsp/dashboard.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Server error. Please try again.");
            req.getRequestDispatcher("jsp/login.jsp?role=" + role).forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.sendRedirect("index.html");
    }
}
