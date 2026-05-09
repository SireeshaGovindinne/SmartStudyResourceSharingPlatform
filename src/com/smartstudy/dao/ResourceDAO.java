package com.smartstudy.dao;

import com.smartstudy.db.DBConnection;
import com.smartstudy.model.Resource;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResourceDAO {

    /** Save an uploaded resource record. */
    public boolean saveResource(Resource r) throws SQLException {
        String sql = "INSERT INTO resources (title, file_name, file_path, file_type, subject, uploaded_by) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, r.getTitle());
            ps.setString(2, r.getFileName());
            ps.setString(3, r.getFilePath());
            ps.setString(4, r.getFileType());
            ps.setString(5, r.getSubject());
            ps.setInt(6, r.getUploadedBy());
            return ps.executeUpdate() > 0;
        }
    }

    /** Get all resources with uploader's name joined. */
    public List<Resource> getAllResources() throws SQLException {
        List<Resource> list = new ArrayList<>();
        String sql = "SELECT r.*, CONCAT(u.first_name, ' ', u.last_name) AS uploader_name " +
                     "FROM resources r JOIN users u ON r.uploaded_by = u.id " +
                     "ORDER BY r.id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapResource(rs));
        }
        return list;
    }

    /** Get a single resource by ID. */
    public Resource getResourceById(int id) throws SQLException {
        String sql = "SELECT r.*, CONCAT(u.first_name, ' ', u.last_name) AS uploader_name " +
                     "FROM resources r JOIN users u ON r.uploaded_by = u.id WHERE r.id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResource(rs);
        }
        return null;
    }

    /** Delete a resource. */
    public boolean deleteResource(int id) throws SQLException {
        String sql = "DELETE FROM resources WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Resource mapResource(ResultSet rs) throws SQLException {
        Resource r = new Resource();
        r.setId(rs.getInt("id"));
        r.setTitle(rs.getString("title"));
        r.setFileName(rs.getString("file_name"));
        r.setFilePath(rs.getString("file_path"));
        r.setFileType(rs.getString("file_type"));
        r.setSubject(rs.getString("subject"));
        r.setUploadedBy(rs.getInt("uploaded_by"));
        r.setUploaderName(rs.getString("uploader_name"));
        Timestamp ts = rs.getTimestamp("uploaded_at");
        r.setUploadDate(ts != null ? ts.toLocalDateTime().toLocalDate().toString() : "—");
        return r;
    }
}
