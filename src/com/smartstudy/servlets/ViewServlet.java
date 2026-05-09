package com.smartstudy.servlets;

import com.smartstudy.dao.ResourceDAO;
import com.smartstudy.model.Resource;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet("/ViewServlet")
public class ViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Must be logged in
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("index.html");
            return;
        }

        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendError(400, "Missing file ID"); return; }

        int id;
        try { id = Integer.parseInt(idParam); }
        catch (NumberFormatException e) { resp.sendError(400, "Invalid ID"); return; }

        try {
            Resource resource = new ResourceDAO().getResourceById(id);
            if (resource == null) { resp.sendError(404, "File not found"); return; }

            String filePath = getServletContext().getRealPath("") + File.separator + resource.getFilePath().replace("/", File.separator);
            File file = new File(filePath);

            if (!file.exists()) { resp.sendError(404, "Physical file not found on server"); return; }

            String ext = resource.getFileType().toLowerCase();
            String contentType;
            switch (ext) {
                case "pdf":  contentType = "application/pdf"; break;
                case "ppt":  contentType = "application/vnd.ms-powerpoint"; break;
                case "pptx": contentType = "application/vnd.openxmlformats-officedocument.presentationml.presentation"; break;
                default:     contentType = "application/octet-stream";
            }

            resp.setContentType(contentType);
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + resource.getFileName() + "\"");
            resp.setContentLengthLong(file.length());

            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = resp.getOutputStream()) {
                byte[] buf = new byte[4096];
                int read;
                while ((read = fis.read(buf)) != -1) os.write(buf, 0, read);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Download error: " + e.getMessage());
        }
    }
}
