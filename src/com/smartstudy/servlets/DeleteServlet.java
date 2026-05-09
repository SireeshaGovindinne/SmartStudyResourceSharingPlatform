package com.smartstudy.servlets;

import com.smartstudy.dao.ResourceDAO;
import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.Resource;
import com.smartstudy.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.List;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect("index.html");
            return;
        }

        String type    = req.getParameter("type");
        String idParam = req.getParameter("id");

        if (type == null || idParam == null) {
            resp.sendRedirect("jsp/admin.jsp");
            return;
        }

        int id;
        try { id = Integer.parseInt(idParam); }
        catch (NumberFormatException e) { resp.sendRedirect("jsp/admin.jsp"); return; }

        try {
            if ("file".equals(type)) {
                ResourceDAO rDAO = new ResourceDAO();
                Resource resource = rDAO.getResourceById(id);
                if (resource != null) {
                    // Delete physical file
                    String filePath = getServletContext().getRealPath("") + File.separator
                            + resource.getFilePath().replace("/", File.separator);
                    File f = new File(filePath);
                    if (f.exists()) f.delete();
                    // Delete DB record
                    rDAO.deleteResource(id);
                }
                req.setAttribute("successMsg", "File deleted successfully.");

            } else if ("student".equals(type)) {
                new UserDAO().deleteStudent(id);
                req.setAttribute("successMsg", "Student removed successfully.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Delete failed: " + e.getMessage());
        }

        // Reload admin page with fresh data
        try {
            ResourceDAO rDAO = new ResourceDAO();
            UserDAO uDAO = new UserDAO();
            List<Resource> resources = rDAO.getAllResources();
            List<User> students = uDAO.getAllStudents();
            req.setAttribute("resources", resources);
            req.setAttribute("students", students);
        } catch (Exception e) { /* ignore */ }

        String tab = "file".equals(type) ? "files" : "students";
        req.getRequestDispatcher("jsp/admin.jsp?tab=" + tab).forward(req, resp);
    }
}
