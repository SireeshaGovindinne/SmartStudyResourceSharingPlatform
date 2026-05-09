<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<% String cp = request.getContextPath(); %>

<title>SmartStudy — Register</title>

<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">

<style>
* { margin:0; padding:0; box-sizing:border-box; }

:root {
  --blue-mid: #3A7BD5;
  --navy: #0F2245;
  --gold: #C68B2E;

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
  max-width:460px;
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
  color: var(--blue-mid);
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

/* Grid */
.row {
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:1rem;
}

/* Inputs */
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
  border-color: var(--blue-mid);
  box-shadow: 0 0 0 3px rgba(58,123,213,0.15);
}

/* Password strength */
.strength-bar {
  height:4px;
  border-radius:3px;
  background:#e0e8f5;
  margin-top:6px;
  overflow:hidden;
}

.strength-fill {
  height:100%;
  width:0%;
  transition:0.3s;
}

.strength-label {
  font-size:0.75rem;
  margin-top:4px;
}

/* Button */
.btn {
  width:100%;
  padding:12px;
  border:none;
  border-radius:12px;
  background: var(--blue-mid);
  color:#fff;
  font-weight:500;
  cursor:pointer;
  margin-top:10px;
}

.btn:hover { opacity:0.9; }

/* Links */
.login-link {
  text-align:center;
  margin-top:1.5rem;
  font-size:0.9rem;
}

.login-link a {
  color: var(--blue-mid);
  text-decoration:none;
}

/* Alerts */
.alert {
  padding:10px;
  border-radius:10px;
  margin-bottom:1rem;
}

.error { background:#ffe6e6; color:#cc0000; }
.success { background:#e6fff2; color:#00994d; }

@media(max-width:480px){
  .row { grid-template-columns:1fr; }
}
</style>
</head>

<body>

<div class="card">

  <a href="<%= cp %>/jsp/login.jsp?role=student" class="back-link">← Back</a>

  <div class="role-badge">Student Registration</div>

  <h1>Create account</h1>
  <p class="sub">Join SmartStudy and start sharing resources.</p>

  <% String errorMsg = (String) request.getAttribute("errorMsg");
     String successMsg = (String) request.getAttribute("successMsg");

     if(errorMsg != null) { %>
    <div class="alert error"><%= errorMsg %></div>
  <% } %>

  <% if(successMsg != null) { %>
    <div class="alert success"><%= successMsg %></div>
  <% } %>

  <form action="<%= cp %>/RegisterServlet" method="POST">

    <div class="row">
      <div class="field">
        <label>First Name</label>
        <input type="text" name="firstName" required>
      </div>
      <div class="field">
        <label>Last Name</label>
        <input type="text" name="lastName" required>
      </div>
    </div>

    <div class="field">
      <label>Email</label>
      <input type="email" name="email" required>
    </div>

    <div class="field">
      <label>Department</label>
      <input type="text" name="department" required>
    </div>

    <div class="field">
      <label>Password</label>
      <input type="password" id="pw" name="password" required>
      <div class="strength-bar"><div id="fill" class="strength-fill"></div></div>
      <div id="label" class="strength-label"></div>
    </div>

    <div class="field">
      <label>Confirm Password</label>
      <input type="password" name="confirmPassword" required>
    </div>

    <button class="btn">Create Account →</button>
  </form>

  <div class="login-link">
    Already have an account?
    <a href="<%= cp %>/jsp/login.jsp?role=student">Login</a>
  </div>

</div>

<script>
const pw = document.getElementById("pw");
const fill = document.getElementById("fill");
const label = document.getElementById("label");

pw.addEventListener("input", function() {
  let v = pw.value, s = 0;

  if(v.length > 5) s++;
  if(v.length > 8) s++;
  if(/[A-Z]/.test(v)) s++;
  if(/[0-9]/.test(v)) s++;

  const colors = ["", "red", "orange", "#3A7BD5", "green"];
  const text = ["", "Weak", "Fair", "Good", "Strong"];

  fill.style.width = (s * 25) + "%";
  fill.style.background = colors[s];
  label.innerText = text[s];
});
</script>

</body>
</html>