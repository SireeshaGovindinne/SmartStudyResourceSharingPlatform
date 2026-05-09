package com.smartstudy.dao;

import com.smartstudy.db.DBConnection;
import com.smartstudy.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /** Register a new student. Returns true on success. */
    public boolean registerStudent(User user) throws SQLException {
        String sql = "INSERT INTO users (first_name, last_name, email, password, role, department) VALUES (?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword()); // store hashed in production
            ps.setString(5, "student");
            ps.setString(6, user.getDepartment());
            return ps.executeUpdate() > 0;
        }
    }

    /** Validate login. Returns User if valid, null otherwise. */
    public User validateLogin(String email, String password, String role) throws SQLException {
        String sql = "SELECT * FROM users WHERE email=? AND password=? AND role=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        }
        return null;
    }

    /** Check if email already registered. */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT id FROM users WHERE email=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    /** Get all students. */
    public List<User> getAllStudents() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role='student' ORDER BY id DESC";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapUser(rs));
        }
        return list;
    }

    /** Delete a student by ID. */
    public boolean deleteStudent(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id=? AND role='student'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));
        u.setDepartment(rs.getString("department"));
        Timestamp ts = rs.getTimestamp("created_at");
        u.setJoinedDate(ts != null ? ts.toLocalDateTime().toLocalDate().toString() : "—");
        return u;
    }
}
