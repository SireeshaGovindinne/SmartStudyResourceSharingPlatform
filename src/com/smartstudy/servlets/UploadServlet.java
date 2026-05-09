package com.smartstudy.servlets;

import com.smartstudy.dao.ResourceDAO;
import com.smartstudy.model.Resource;
import com.smartstudy.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.List;
import java.util.UUID;

@WebServlet("/UploadServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize       = 50 * 1024 * 1024, // 50 MB
    maxRequestSize    = 55 * 1024 * 1024
)
public class UploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect("jsp/login.jsp?role=student");
            return;
        }

        User user = (User) session.getAttribute("user");
        String title   = req.getParameter("title");
        String subject = req.getParameter("subject");
        Part   filePart = req.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {
            req.setAttribute("errorMsg", "Please select a file to upload.");
            forwardToDashboard(req, resp, user);
            return;
        }

        String originalFileName = getFileName(filePart);
        if (originalFileName == null || originalFileName.isEmpty()) {
            req.setAttribute("errorMsg", "Could not read filename.");
            forwardToDashboard(req, resp, user);
            return;
        }

        // Validate file type
        String ext = originalFileName.contains(".")
                ? originalFileName.substring(originalFileName.lastIndexOf('.')+1).toLowerCase()
                : "";
        if (!ext.equals("pdf") && !ext.equals("ppt") && !ext.equals("pptx")) {
            req.setAttribute("errorMsg", "Only PDF and PPT/PPTX files are allowed.");
            forwardToDashboard(req, resp, user);
            return;
        }

        // Save file to disk
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String uniqueName = UUID.randomUUID().toString() + "_" + originalFileName;
        String filePath   = uploadPath + File.separator + uniqueName;

        try (InputStream is = filePart.getInputStream();
             FileOutputStream fos = new FileOutputStream(filePath)) {
            byte[] buf = new byte[4096];
            int read;
            while ((read = is.read(buf)) != -1) fos.write(buf, 0, read);
        }

        // Save metadata to DB
        try {
            Resource resource = new Resource();
            resource.setTitle(title != null && !title.isEmpty() ? title : originalFileName);
            resource.setFileName(originalFileName);
            resource.setFilePath(UPLOAD_DIR + "/" + uniqueName);
            resource.setFileType(ext);
            resource.setSubject(subject);
            resource.setUploadedBy(user.getId());

            new ResourceDAO().saveResource(resource);
            req.setAttribute("successMsg", "File uploaded successfully! It is now visible to all students.");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "File saved but database update failed: " + e.getMessage());
        }

        forwardToDashboard(req, resp, user);
    }

    private void forwardToDashboard(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        try {
            List<Resource> resources = new ResourceDAO().getAllResources();
            req.setAttribute("resources", resources);
        } catch (Exception e) { /* ignore */ }
        req.getRequestDispatcher("jsp/dashboard.jsp").forward(req, resp);
    }

    /** Extract the filename from the Content-Disposition header */
    private String getFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            String t = token.trim();
            if (t.startsWith("filename")) {
                return t.substring(t.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
