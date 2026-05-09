<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<%
  String role = request.getParameter("role");
  if(role == null) role = "student";
  boolean isAdmin = "admin".equals(role);
  String pageTitle = isAdmin ? "Admin Login" : "Student Login";
  String cp = request.getContextPath();
%>

<title>SmartStudy — <%= pageTitle %></title>

<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

<style>
* { margin:0; padding:0; box-sizing:border-box; }

:root {
  --blue-mid: #3A7BD5;
  --navy: #0F2245;
  --gold: #C68B2E;

  --accent: <%= isAdmin ? "#C68B2E" : "#3A7BD5" %>;

  --bg: #EEF5FD;
  --white: #FFFFFF;
  --text: #0F1D38;
  --muted: #7A93B0;
}

/* Background */
body {
  font-family: 'DM Sans', sans-serif;
  background: linear-gradient(160deg, #EEF5FD, #F5F9FF);
  min-height: 100vh;
  display:flex;
  align-items:center;
  justify-content:center;
}

body::before {
  content:"";
  position:fixed;
  inset:0;
  background:
    radial-gradient(circle at 20% 20%, rgba(58,123,213,0.15), transparent 50%),
    radial-gradient(circle at 80% 80%, rgba(26,74,140,0.1), transparent 50%);
}

/* Card */
.card {
  position:relative;
  z-index:1;
  width:100%;
  max-width:420px;
  padding:3rem 2.5rem;

  background: rgba(255,255,255,0.7);
  backdrop-filter: blur(14px);

  border-radius:20px;
  border:1px solid rgba(58,123,213,0.2);

  box-shadow: 0 10px 40px rgba(58,123,213,0.1);
}

/* Back */
.back-link {
  font-size:0.85rem;
  color: var(--muted);
  text-decoration:none;
  margin-bottom:1.5rem;
  display:inline-block;
}
.back-link:hover { color: var(--blue-mid); }

/* Badge */
.role-badge {
  display:inline-block;
  padding:6px 16px;
  border-radius:50px;
  font-size:11px;
  margin-bottom:1.5rem;
  background: rgba(58,123,213,0.1);
  color: var(--accent);
}

/* Heading */
h1 {
  font-family: 'Playfair Display', serif;
  font-size:2rem;
  margin-bottom:0.5rem;
  color: var(--navy);
}

.sub {
  color: var(--muted);
  margin-bottom:2rem;
}

/* Input */
.field { margin-bottom:1.2rem; }

label {
  font-size:0.8rem;
  color: var(--muted);
  display:block;
  margin-bottom:5px;
}

input {
  width:100%;
  padding:12px;
  border-radius:12px;
  border:1px solid rgba(58,123,213,0.2);
  outline:none;
}

input:focus {
  border-color: var(--accent);
  box-shadow: 0 0 0 3px rgba(58,123,213,0.15);
}

/* Button */
.btn {
  width:100%;
  padding:12px;
  border:none;
  border-radius:12px;
  background: var(--accent);
  color:#fff;
  font-weight:500;
  cursor:pointer;
  margin-top:10px;
}

.btn:hover { opacity:0.9; }

/* Register */
.register-link {
  text-align:center;
  margin-top:1.5rem;
  font-size:0.9rem;
}

.register-link a {
  color: var(--accent);
  text-decoration:none;
}

/* Alert */
.alert {
  background:#ffe6e6;
  color:#cc0000;
  padding:10px;
  border-radius:10px;
  margin-bottom:1rem;
}
</style>
</head>

<body>

<div class="card">

  <a href="<%= cp %>/index.html" class="back-link">← Back</a>

  <div class="role-badge"><%= isAdmin ? "Admin" : "Student" %></div>

  <h1>Welcome back</h1>
  <p class="sub">Sign in to access your <%= isAdmin ? "admin dashboard" : "study resources" %>.</p>

  <% String errorMsg = (String) request.getAttribute("errorMsg");
     if(errorMsg != null && !errorMsg.isEmpty()) { %>
    <div class="alert"><%= errorMsg %></div>
  <% } %>

  <form action="<%= cp %>/LoginServlet" method="POST">
    <input type="hidden" name="role" value="<%= role %>">

    <div class="field">
      <label>Email</label>
      <input type="email" name="email" required>
    </div>

    <div class="field">
      <label>Password</label>
      <input type="password" name="password" required>
    </div>

    <button class="btn">Sign In →</button>
  </form>

  <% if (!isAdmin) { %>
  <div class="register-link">
    Don't have an account?
    <a href="<%= cp %>/jsp/register.jsp">Create one</a>
  </div>
  <% } %>

</div>

</body>
</html>