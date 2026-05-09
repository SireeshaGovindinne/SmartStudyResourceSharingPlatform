package com.smartstudy.model;

public class User {
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String role;          // "student" or "admin"
    private String department;
    private String joinedDate;

    public User() {}

    public User(int id, String firstName, String lastName, String email,
                String role, String department, String joinedDate) {
        this.id = id;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.role = role;
        this.department = department;
        this.joinedDate = joinedDate;
    }

    // Getters
    public int    getId()         { return id; }
    public String getFirstName()  { return firstName; }
    public String getLastName()   { return lastName; }
    public String getEmail()      { return email; }
    public String getPassword()   { return password; }
    public String getRole()       { return role; }
    public String getDepartment() { return department; }
    public String getJoinedDate() { return joinedDate; }

    // Setters
    public void setId(int id)                   { this.id = id; }
    public void setFirstName(String firstName)  { this.firstName = firstName; }
    public void setLastName(String lastName)    { this.lastName = lastName; }
    public void setEmail(String email)          { this.email = email; }
    public void setPassword(String password)    { this.password = password; }
    public void setRole(String role)            { this.role = role; }
    public void setDepartment(String d)         { this.department = d; }
    public void setJoinedDate(String d)         { this.joinedDate = d; }
}
