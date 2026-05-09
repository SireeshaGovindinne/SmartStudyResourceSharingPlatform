<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.smartstudy.model.Resource" %>
<%@ page import="com.smartstudy.model.User" %>
<%
  String cp = request.getContextPath();
  User admin = (User) session.getAttribute("user");
  if(admin == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect(cp + "/jsp/login.jsp?role=admin");
    return;
  }
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  List<Resource> resources = (List<Resource>) request.getAttribute("resources");
  List<User> students      = (List<User>) request.getAttribute("students");
  String successMsg = (String) request.getAttribute("successMsg");
  String errorMsg   = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SmartStudy &mdash; Admin Dashboard</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,700;1,700&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
  :root {
    --sky-0: #EEF5FD;
    --sky-1: #DAEAF9;
    --sky-2: #B8D4F3;
    --blue-mid: #3A7BD5;
    --blue-deep: #1A4A8C;
    --navy: #0F2245;
    --text-primary: #0F1D38;
    --text-secondary: #4A5E7A;
    --text-muted: #7A93B0;
    --white: #FFFFFF;
    --gold: #C68B2E;
    --gold-light: #E8A83E;
    --gold-bg: #FDF3E0;
    --gold-border: #E8C87A;
    --card: rgba(255,255,255,0.75);
    --card-border: rgba(58,123,213,0.13);
    --hover: rgba(58,123,213,0.04);
    --danger: #C0392B;
    --danger-bg: rgba(192,57,43,0.07);
    --danger-border: rgba(192,57,43,0.22);
    --success: #1A7A4A;
    --success-bg: rgba(26,122,74,0.07);
    --success-border: rgba(26,122,74,0.22);
  }

  html, body {
    min-height: 100%;
    font-family: 'DM Sans', sans-serif;
    background: linear-gradient(160deg, #EEF5FD 0%, #F5F9FF 40%, #EBF2FA 100%);
    color: var(--text-primary);
    overflow-x: hidden;
  }

  body::before {
    content: '';
    position: fixed; inset: 0;
    background:
      radial-gradient(ellipse 70% 50% at 15% 5%, rgba(58,123,213,0.10) 0%, transparent 55%),
      radial-gradient(ellipse 50% 60% at 85% 85%, rgba(26,74,140,0.07) 0%, transparent 55%);
    pointer-events: none; z-index: 0;
  }

  /* ── Layout ── */
  .layout {
    position: relative; z-index: 1;
    display: flex; min-height: 100vh;
  }

  /* ── Sidebar ── */
  .sidebar {
    width: 248px; flex-shrink: 0;
    background: rgba(255,255,255,0.72);
    backdrop-filter: blur(18px);
    border-right: 0.5px solid var(--card-border);
    display: flex; flex-direction: column;
    padding: 2rem 1.25rem;
    position: sticky; top: 0; height: 100vh;
    box-shadow: 2px 0 20px rgba(58,123,213,0.05);
  }

  .logo {
    font-family: 'Playfair Display', serif;
    font-size: 1.35rem; font-weight: 700;
    color: var(--navy); margin-bottom: 0.2rem;
  }
  .logo span { color: var(--blue-mid); font-style: italic; }
  .logo-sub {
    font-size: 0.72rem; color: var(--text-muted);
    font-weight: 500; letter-spacing: 0.08em;
    text-transform: uppercase; margin-bottom: 2.5rem;
  }

  .nav { flex: 1; }
  .nav-item {
    display: flex; align-items: center; gap: 10px;
    padding: 10px 14px; border-radius: 10px;
    font-size: 0.875rem; color: var(--text-secondary);
    cursor: pointer; border: none; background: none;
    width: 100%; text-align: left;
    transition: all 0.2s; margin-bottom: 4px;
    font-family: 'DM Sans', sans-serif;
  }
  .nav-item:hover {
    background: var(--sky-1); color: var(--navy);
  }
  .nav-item.active {
    background: rgba(58,123,213,0.10);
    color: var(--blue-mid); font-weight: 500;
    border: 0.5px solid rgba(58,123,213,0.18);
  }

  .sidebar-bottom {
    border-top: 0.5px solid var(--card-border);
    padding-top: 1.25rem; margin-top: 1rem;
  }
  .admin-pill {
    display: flex; align-items: center; gap: 10px;
    padding: 10px 12px; border-radius: 12px;
    background: var(--gold-bg);
    border: 0.5px solid var(--gold-border);
    margin-bottom: 12px;
  }
  .avatar {
    width: 34px; height: 34px; border-radius: 50%;
    background: rgba(198,139,46,0.15);
    display: flex; align-items: center; justify-content: center;
    font-size: 12px; font-weight: 600; color: var(--gold);
    flex-shrink: 0;
    border: 1px solid var(--gold-border);
  }
  .user-name { font-size: 0.8rem; font-weight: 500; color: var(--text-primary); }
  .user-role { font-size: 0.7rem; color: var(--gold); font-weight: 500; }

  .logout-btn {
    display: flex; align-items: center; gap: 8px;
    width: 100%; padding: 9px 14px; border-radius: 10px;
    font-size: 0.8rem; color: var(--text-muted);
    background: none; border: 0.5px solid transparent;
    cursor: pointer; transition: all 0.2s;
    font-family: 'DM Sans', sans-serif;
  }
  .logout-btn:hover {
    background: var(--danger-bg); color: var(--danger);
    border-color: var(--danger-border);
  }

  /* ── Main ── */
  .main {
    flex: 1; padding: 2.5rem 2.5rem;
    overflow-y: auto;
  }

  .page-header { margin-bottom: 2rem; }
  .page-title {
    font-family: 'Playfair Display', serif;
    font-size: 1.9rem; color: var(--navy);
    margin-bottom: 0.25rem;
  }
  .page-sub { font-size: 0.875rem; color: var(--text-muted); font-weight: 300; }

  /* ── Toast ── */
  .toast {
    display: none; border-radius: 10px;
    padding: 12px 16px; font-size: 0.875rem;
    margin-bottom: 1.5rem;
  }
  .toast.success {
    display: block;
    background: var(--success-bg);
    border: 0.5px solid var(--success-border);
    color: var(--success);
  }
  .toast.error {
    display: block;
    background: var(--danger-bg);
    border: 0.5px solid var(--danger-border);
    color: var(--danger);
  }

  /* ── Stat Cards ── */
  .stats {
    display: grid; grid-template-columns: repeat(4, 1fr);
    gap: 1rem; margin-bottom: 2rem;
  }
  .stat-card {
    background: var(--card);
    border: 0.5px solid var(--card-border);
    border-radius: 18px; padding: 1.25rem 1.5rem;
    backdrop-filter: blur(12px);
    box-shadow: 0 2px 16px rgba(58,123,213,0.05);
    transition: transform 0.2s, box-shadow 0.2s;
  }
  .stat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 28px rgba(58,123,213,0.10);
  }
  .stat-label {
    font-size: 0.7rem; color: var(--text-muted);
    font-weight: 500; text-transform: uppercase; letter-spacing: 0.07em;
  }
  .stat-value {
    font-family: 'Playfair Display', serif;
    font-size: 2.1rem; margin-top: 4px;
    color: var(--blue-mid);
  }
  .stat-desc { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; }

  /* ── Tabs ── */
  .tabs {
    display: flex; gap: 4px;
    margin-bottom: 1.5rem;
    border-bottom: 0.5px solid var(--card-border);
  }
  .tab-btn {
    padding: 10px 22px; border: none; background: none;
    font-family: 'DM Sans', sans-serif; font-size: 0.875rem;
    color: var(--text-muted); cursor: pointer;
    border-bottom: 2px solid transparent;
    margin-bottom: -1px; transition: all 0.2s;
  }
  .tab-btn.active { color: var(--blue-mid); border-bottom-color: var(--blue-mid); font-weight: 500; }
  .tab-btn:hover { color: var(--navy); }
  .tab-panel { display: none; }
  .tab-panel.active { display: block; }

  /* ── Panel Card ── */
  .panel-card {
    background: var(--card);
    border: 0.5px solid var(--card-border);
    border-radius: 18px; overflow: hidden;
    backdrop-filter: blur(12px);
    box-shadow: 0 2px 20px rgba(58,123,213,0.05);
  }
  .panel-header {
    padding: 1.25rem 1.5rem;
    border-bottom: 0.5px solid var(--card-border);
    display: flex; align-items: center;
    justify-content: space-between; gap: 1rem; flex-wrap: wrap;
    background: rgba(238,245,253,0.5);
  }
  .panel-title { font-weight: 500; color: var(--navy); font-size: 0.9rem; }

  .search-input {
    background: var(--white);
    border: 0.5px solid rgba(58,123,213,0.2);
    border-radius: 100px; padding: 7px 16px;
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif; font-size: 0.85rem;
    outline: none; width: 210px;
    transition: border-color 0.2s, box-shadow 0.2s;
  }
  .search-input:focus {
    border-color: var(--blue-mid);
    box-shadow: 0 0 0 3px rgba(58,123,213,0.08);
  }
  .search-input::placeholder { color: var(--text-muted); }

  /* ── Table ── */
  table { width: 100%; border-collapse: collapse; }
  th {
    padding: 11px 16px; text-align: left;
    font-size: 0.7rem; font-weight: 600;
    color: var(--text-muted); text-transform: uppercase;
    letter-spacing: 0.07em;
    border-bottom: 0.5px solid var(--card-border);
    background: rgba(238,245,253,0.3);
  }
  td {
    padding: 13px 16px; font-size: 0.875rem;
    border-bottom: 0.5px solid rgba(58,123,213,0.06);
    vertical-align: middle; color: var(--text-secondary);
  }
  tr:last-child td { border-bottom: none; }
  tr:hover td { background: var(--hover); }
  td strong { color: var(--text-primary); }

  /* ── Badges / Tags ── */
  .file-tag {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 3px 9px; border-radius: 6px;
    font-size: 0.72rem; font-weight: 600;
  }
  .tag-pdf {
    background: rgba(192,57,43,0.08); color: #A93226;
    border: 0.5px solid rgba(192,57,43,0.2);
  }
  .tag-ppt {
    background: rgba(198,139,46,0.10); color: var(--gold);
    border: 0.5px solid var(--gold-border);
  }

  .status-badge {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 3px 10px; border-radius: 20px;
    font-size: 0.72rem; font-weight: 500;
  }
  .status-active {
    background: rgba(26,122,74,0.08); color: var(--success);
    border: 0.5px solid var(--success-border);
  }

  /* ── Buttons ── */
  .btn-view {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 5px 13px; border-radius: 100px;
    font-size: 0.8rem; cursor: pointer;
    border: 0.5px solid rgba(58,123,213,0.25);
    background: rgba(58,123,213,0.05); color: var(--blue-mid);
    text-decoration: none; transition: all 0.2s; margin-right: 6px;
    font-family: 'DM Sans', sans-serif;
  }
  .btn-view:hover {
    background: var(--blue-mid); color: var(--white);
    border-color: var(--blue-mid);
  }
  .btn-delete {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 5px 13px; border-radius: 100px;
    font-size: 0.8rem; cursor: pointer;
    border: 0.5px solid var(--danger-border);
    background: var(--danger-bg); color: var(--danger);
    transition: all 0.2s; font-family: 'DM Sans', sans-serif;
  }
  .btn-delete:hover {
    background: var(--danger); color: var(--white);
    border-color: var(--danger);
  }

  .empty-state {
    padding: 4rem; text-align: center; color: var(--text-muted);
    font-size: 0.9rem;
  }

  /* ── Modals ── */
  .modal-wrap {
    display: none; position: fixed; inset: 0;
    background: rgba(15,34,69,0.45);
    backdrop-filter: blur(6px);
    z-index: 999; align-items: center; justify-content: center;
  }
  .modal-wrap.show { display: flex; }
  .modal-box {
    background: var(--white);
    border: 0.5px solid var(--card-border);
    border-radius: 20px; padding: 2rem;
    max-width: 360px; width: 90%; text-align: center;
    box-shadow: 0 20px 60px rgba(15,34,69,0.18);
    animation: fadeDown 0.25s ease both;
  }
  .modal-icon { font-size: 2.5rem; margin-bottom: 1rem; }
  .modal-title {
    font-family: 'Playfair Display', serif;
    font-size: 1.15rem; color: var(--navy);
    margin-bottom: 0.5rem;
  }
  .modal-sub { font-size: 0.875rem; color: var(--text-muted); margin-bottom: 1.5rem; }
  .modal-actions { display: flex; gap: 10px; justify-content: center; }
  .modal-cancel {
    padding: 9px 22px; border-radius: 100px;
    border: 0.5px solid var(--card-border);
    background: var(--sky-0); color: var(--text-secondary);
    cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.875rem;
    transition: all 0.2s;
  }
  .modal-cancel:hover { background: var(--sky-1); }
  .modal-confirm {
    padding: 9px 22px; border-radius: 100px; border: none;
    background: var(--danger); color: white; cursor: pointer;
    font-family: 'DM Sans', sans-serif; font-size: 0.875rem; font-weight: 500;
    transition: background 0.2s;
  }
  .modal-confirm:hover { background: #a93226; }

  @keyframes fadeDown { from{opacity:0;transform:translateY(-12px)} to{opacity:1;transform:translateY(0)} }

  @media(max-width:900px) {
    .sidebar { display: none; }
    .stats { grid-template-columns: 1fr 1fr; }
    .main { padding: 1.5rem 1.25rem; }
  }
</style>
</head>
<body>
<div class="layout">

  <!-- ── Sidebar ── -->
  <nav class="sidebar">
    <div class="logo">Smart<span>Study</span></div>
    <div class="logo-sub">Admin Panel</div>
    <div class="nav">
      <button class="nav-item active" id="nav-files" onclick="switchTab('files')">
        <span>&#128193;</span> Manage Files
      </button>
      <button class="nav-item" id="nav-students" onclick="switchTab('students')">
        <span>&#128101;</span> Manage Students
      </button>
    </div>
    <div class="sidebar-bottom">
      <div class="admin-pill">
        <div class="avatar">AD</div>
        <div>
          <div class="user-name">Administrator</div>
          <div class="user-role">⚙️ Admin</div>
        </div>
      </div>
      <button class="logout-btn" onclick="showLogoutConfirm()">&#8592; Sign out</button>
    </div>
  </nav>

  <!-- ── Main Content ── -->
  <main class="main">
    <div class="page-header">
      <div class="page-title">Admin Dashboard</div>
      <div class="page-sub">Manage files, resources, and student accounts.</div>
    </div>

    <% if(successMsg != null) { %><div class="toast success">&#10003; <%= successMsg %></div><% } %>
    <% if(errorMsg   != null) { %><div class="toast error">&#9888; <%= errorMsg %></div><% } %>

    <!-- Stats -->
    <div class="stats">
      <div class="stat-card">
        <div class="stat-label">Total Files</div>
        <div class="stat-value"><%= resources != null ? resources.size() : 0 %></div>
        <div class="stat-desc">Uploaded resources</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Students</div>
        <div class="stat-value"><%= students != null ? students.size() : 0 %></div>
        <div class="stat-desc">Registered accounts</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">PDF Files</div>
        <div class="stat-value" id="pdfCount">0</div>
        <div class="stat-desc">PDF documents</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">PPT Files</div>
        <div class="stat-value" id="pptCount">0</div>
        <div class="stat-desc">Presentations</div>
      </div>
    </div>

    <!-- Tabs -->
    <div class="tabs">
      <button class="tab-btn active" id="tabBtn-files"    onclick="switchTab('files')">Files</button>
      <button class="tab-btn"        id="tabBtn-students" onclick="switchTab('students')">Students</button>
    </div>

    <!-- Files Tab -->
    <div class="tab-panel active" id="tab-files">
      <div class="panel-card">
        <div class="panel-header">
          <div class="panel-title">All Uploaded Files</div>
          <input class="search-input" type="text" placeholder="Search files…" oninput="searchTable('filesTable', this.value)">
        </div>
        <% if(resources == null || resources.isEmpty()) { %>
        <div class="empty-state">No files uploaded yet.</div>
        <% } else { %>
        <table>
          <thead>
            <tr><th>#</th><th>Title</th><th>Subject</th><th>Uploaded By</th><th>Date</th><th>Type</th><th>Actions</th></tr>
          </thead>
          <tbody id="filesTable">
          <% int i = 1; for(Resource r : resources) {
               String ext = r.getFileName().contains(".") ? r.getFileName().substring(r.getFileName().lastIndexOf('.')+1).toLowerCase() : "";
               String tagClass = ext.equals("pdf") ? "tag-pdf" : "tag-ppt";
          %>
            <tr data-search="<%= r.getTitle().toLowerCase() + ' ' + (r.getSubject()!=null?r.getSubject().toLowerCase():"") + ' ' + r.getUploaderName().toLowerCase() %>">
              <td><%= i++ %></td>
              <td><strong><%= r.getTitle() %></strong></td>
              <td><%= r.getSubject() != null ? r.getSubject() : "N/A" %></td>
              <td><%= r.getUploaderName() %></td>
              <td><%= r.getUploadDate() %></td>
              <td><span class="file-tag <%= tagClass %>"><%= ext.toUpperCase() %></span></td>
              <td>
                <a href="<%= cp %>/ViewServlet?id=<%= r.getId() %>" class="btn-view" target="_blank">View</a>
                <button class="btn-delete" onclick="confirmDelete('<%= cp %>/DeleteServlet?type=file&id=<%= r.getId() %>', '<%= r.getTitle() %>')">Delete</button>
              </td>
            </tr>
          <% } %>
          </tbody>
        </table>
        <% } %>
      </div>
    </div>

    <!-- Students Tab -->
    <div class="tab-panel" id="tab-students">
      <div class="panel-card">
        <div class="panel-header">
          <div class="panel-title">Registered Students</div>
          <input class="search-input" type="text" placeholder="Search students…" oninput="searchTable('studentsTable', this.value)">
        </div>
        <% if(students == null || students.isEmpty()) { %>
        <div class="empty-state">No students registered yet.</div>
        <% } else { %>
        <table>
          <thead>
            <tr><th>#</th><th>Name</th><th>Email</th><th>Department</th><th>Joined</th><th>Status</th><th>Actions</th></tr>
          </thead>
          <tbody id="studentsTable">
          <% int j = 1; for(User s : students) { %>
            <tr data-search="<%= s.getFirstName().toLowerCase() + ' ' + s.getLastName().toLowerCase() + ' ' + s.getEmail().toLowerCase() %>">
              <td><%= j++ %></td>
              <td>
                <div style="display:flex;align-items:center;gap:10px;">
                  <div style="width:30px;height:30px;border-radius:50%;background:var(--sky-1);display:flex;align-items:center;justify-content:center;font-size:11px;color:var(--blue-mid);font-weight:600;flex-shrink:0;border:0.5px solid var(--sky-2);">
                    <%= s.getFirstName().charAt(0) %><%= s.getLastName().charAt(0) %>
                  </div>
                  <strong><%= s.getFirstName() %> <%= s.getLastName() %></strong>
                </div>
              </td>
              <td><%= s.getEmail() %></td>
              <td><%= s.getDepartment() != null ? s.getDepartment() : "N/A" %></td>
              <td><%= s.getJoinedDate() %></td>
              <td><span class="status-badge status-active">Active</span></td>
              <td>
                <button class="btn-delete" onclick="confirmDelete('<%= cp %>/DeleteServlet?type=student&id=<%= s.getId() %>', '<%= s.getFirstName() + " " + s.getLastName() %>')">Remove</button>
              </td>
            </tr>
          <% } %>
          </tbody>
        </table>
        <% } %>
      </div>
    </div>

  </main>
</div>

<!-- Delete Confirm Modal -->
<div class="modal-wrap" id="confirmModal">
  <div class="modal-box">
    <div class="modal-icon">🗑️</div>
    <div class="modal-title">Confirm Deletion</div>
    <div class="modal-sub" id="modalSub">Are you sure?</div>
    <div class="modal-actions">
      <button class="modal-cancel" onclick="closeModal()">Cancel</button>
      <button class="modal-confirm" id="modalConfirmBtn">Delete</button>
    </div>
  </div>
</div>

<!-- Logout Confirm Modal -->
<div class="modal-wrap" id="logoutModal">
  <div class="modal-box">
    <div class="modal-icon">🔒</div>
    <div class="modal-title">Sign out?</div>
    <div class="modal-sub">You will be returned to the login page.</div>
    <div class="modal-actions">
      <button class="modal-cancel" onclick="closeLogoutModal()">Stay</button>
      <button class="modal-confirm" style="background:var(--navy);color:#fff;" onclick="doLogout()">Sign out</button>
    </div>
  </div>
</div>

<script>
// Tab switching
function switchTab(tab) {
  document.querySelectorAll('.tab-panel').forEach(function(p){ p.classList.remove('active'); });
  document.querySelectorAll('.tab-btn').forEach(function(b){ b.classList.remove('active'); });
  document.querySelectorAll('.nav-item').forEach(function(n){ n.classList.remove('active'); });
  document.getElementById('tab-' + tab).classList.add('active');
  document.getElementById('tabBtn-' + tab).classList.add('active');
  document.getElementById('nav-' + tab).classList.add('active');
}

// Search
function searchTable(tableId, q) {
  q = q.toLowerCase();
  document.querySelectorAll('#' + tableId + ' tr').forEach(function(r) {
    r.style.display = (r.dataset.search && r.dataset.search.includes(q)) ? '' : 'none';
  });
}

// Delete modal
var deleteUrl = '';
function confirmDelete(url, name) {
  deleteUrl = url;
  document.getElementById('modalSub').textContent = 'Delete "' + name + '"? This cannot be undone.';
  document.getElementById('confirmModal').classList.add('show');
}
function closeModal() { document.getElementById('confirmModal').classList.remove('show'); }
document.getElementById('modalConfirmBtn').addEventListener('click', function() { window.location = deleteUrl; });
document.getElementById('confirmModal').addEventListener('click', function(e) { if(e.target === e.currentTarget) closeModal(); });

// Logout modal
function showLogoutConfirm() { document.getElementById('logoutModal').classList.add('show'); }
function closeLogoutModal()  { document.getElementById('logoutModal').classList.remove('show'); }
function doLogout()          { window.location.href = '<%= cp %>/LogoutServlet'; }
document.getElementById('logoutModal').addEventListener('click', function(e) { if(e.target === e.currentTarget) closeLogoutModal(); });

// Back button protection
history.pushState(null, null, window.location.href);
window.addEventListener('popstate', function() {
  history.pushState(null, null, window.location.href);
  showLogoutConfirm();
});

// File type counts
var pdfs = 0, ppts = 0;
document.querySelectorAll('#filesTable tr').forEach(function(r) {
  var tag = r.querySelector('.file-tag');
  if(tag) { var t = tag.textContent.trim().toLowerCase(); if(t === 'pdf') pdfs++; else ppts++; }
});
document.getElementById('pdfCount').textContent = pdfs;
document.getElementById('pptCount').textContent = ppts;
</script>
</body>
</html>