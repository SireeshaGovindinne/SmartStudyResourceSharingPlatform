<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.smartstudy.model.Resource" %>
<%@ page import="com.smartstudy.model.User" %>
<%
  String cp = request.getContextPath();
  User student = (User) session.getAttribute("user");
  if(student == null || !"student".equals(session.getAttribute("role"))) {
    response.sendRedirect(cp + "/jsp/login.jsp?role=student");
    return;
  }
  List<Resource> resources = (List<Resource>) request.getAttribute("resources");
  String successMsg = (String) request.getAttribute("successMsg");
  String errorMsg   = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SmartStudy &mdash; Dashboard</title>
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
  .layout { position: relative; z-index: 1; display: flex; min-height: 100vh; }

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
    border: none; background: none; width: 100%; text-align: left;
    transition: all 0.2s; margin-bottom: 4px;
    text-decoration: none; cursor: pointer;
    font-family: 'DM Sans', sans-serif;
  }
  .nav-item:hover { background: var(--sky-1); color: var(--navy); }
  .nav-item.active {
    background: rgba(58,123,213,0.10);
    color: var(--blue-mid); font-weight: 500;
    border: 0.5px solid rgba(58,123,213,0.18);
  }
  .nav-icon { font-size: 16px; width: 20px; text-align: center; }

  .sidebar-bottom {
    border-top: 0.5px solid var(--card-border);
    padding-top: 1.25rem; margin-top: 1rem;
  }
  .user-pill {
    display: flex; align-items: center; gap: 10px;
    padding: 10px 12px; border-radius: 12px;
    background: var(--sky-0);
    border: 0.5px solid var(--sky-2);
    margin-bottom: 12px;
  }
  .avatar {
    width: 34px; height: 34px; border-radius: 50%;
    background: var(--sky-1);
    display: flex; align-items: center; justify-content: center;
    font-size: 12px; font-weight: 600; color: var(--blue-mid);
    flex-shrink: 0; border: 1px solid var(--sky-2);
  }
  .user-name { font-size: 0.8rem; font-weight: 500; color: var(--text-primary); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .user-role { font-size: 0.7rem; color: var(--blue-mid); font-weight: 500; }

  .logout-btn {
    display: flex; align-items: center; gap: 8px;
    width: 100%; padding: 9px 14px; border-radius: 10px;
    font-size: 0.8rem; color: var(--text-muted);
    background: none; border: 0.5px solid transparent;
    cursor: pointer; transition: all 0.2s; text-decoration: none;
    font-family: 'DM Sans', sans-serif;
  }
  .logout-btn:hover {
    background: var(--danger-bg); color: var(--danger);
    border-color: var(--danger-border);
  }

  /* ── Main ── */
  .main {
    flex: 1; padding: 2.5rem 2.5rem;
    overflow-y: auto; max-width: calc(100vw - 248px);
  }

  .top-bar {
    display: flex; align-items: center;
    justify-content: space-between; margin-bottom: 2.5rem;
  }
  .page-title {
    font-family: 'Playfair Display', serif;
    font-size: 1.9rem; color: var(--navy);
  }
  .page-title em { font-style: italic; color: var(--blue-mid); }
  .page-sub { font-size: 0.875rem; color: var(--text-muted); margin-top: 2px; font-weight: 300; }

  /* ── Toast ── */
  .toast {
    display: none; border-radius: 10px;
    padding: 12px 16px; font-size: 0.875rem; margin-bottom: 1.5rem;
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

  /* ── Stats ── */
  .stats {
    display: grid; grid-template-columns: repeat(3, 1fr);
    gap: 1rem; margin-bottom: 2.5rem;
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
    font-size: 2.1rem; margin-top: 6px; color: var(--blue-mid);
  }
  .stat-desc { font-size: 0.75rem; color: var(--text-muted); margin-top: 2px; }

  /* ── Section Title ── */
  .section-title {
    font-size: 0.72rem; font-weight: 600; color: var(--text-muted);
    text-transform: uppercase; letter-spacing: 0.09em; margin-bottom: 1rem;
  }

  /* ── Upload Zone ── */
  .upload-zone {
    border: 1.5px dashed rgba(58,123,213,0.28);
    border-radius: 18px; padding: 2.5rem;
    text-align: center; cursor: pointer;
    transition: all 0.3s; margin-bottom: 1.25rem;
    background: rgba(58,123,213,0.02);
  }
  .upload-zone:hover, .upload-zone.drag {
    border-color: var(--blue-mid);
    background: rgba(58,123,213,0.05);
  }
  .upload-icon { font-size: 2.5rem; margin-bottom: 1rem; }
  .upload-title { font-weight: 500; color: var(--text-primary); margin-bottom: 0.5rem; }
  .upload-sub { font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.5rem; }

  .choose-label {
    display: inline-flex; align-items: center; gap: 8px;
    padding: 9px 22px;
    background: var(--white);
    border: 0.5px solid rgba(58,123,213,0.3);
    border-radius: 100px;
    font-size: 0.85rem; color: var(--blue-mid);
    cursor: pointer; transition: all 0.2s;
    font-family: 'DM Sans', sans-serif; font-weight: 500;
  }
  .choose-label:hover { background: var(--blue-mid); color: var(--white); border-color: var(--blue-mid); }

  .file-chosen {
    display: none;
    background: var(--sky-0);
    border: 0.5px solid var(--sky-2);
    border-radius: 10px; padding: 10px 14px;
    font-size: 0.85rem; margin-bottom: 1rem;
    color: var(--blue-mid); align-items: center; gap: 8px;
  }
  .file-chosen.show { display: flex; }

  /* ── Upload Form ── */
  .upload-form-row {
    display: grid; grid-template-columns: 1fr 1fr auto;
    gap: 1rem; align-items: end; margin-top: 1rem;
  }
  .field-label {
    display: block; font-size: 0.8rem;
    color: var(--text-muted); margin-bottom: 6px;
  }
  input[type=text], select {
    width: 100%;
    background: var(--white);
    border: 0.5px solid rgba(58,123,213,0.2);
    border-radius: 10px; padding: 10px 14px;
    color: var(--text-primary);
    font-family: 'DM Sans', sans-serif; font-size: 0.9rem;
    outline: none; transition: border-color 0.2s, box-shadow 0.2s;
  }
  input[type=text]:focus, select:focus {
    border-color: var(--blue-mid);
    box-shadow: 0 0 0 3px rgba(58,123,213,0.08);
  }
  input[type=text]::placeholder { color: var(--text-muted); }

  .upload-btn {
    padding: 10px 24px;
    background: var(--navy); color: var(--white);
    border: none; border-radius: 100px;
    font-family: 'DM Sans', sans-serif;
    font-size: 0.9rem; font-weight: 500;
    cursor: pointer; white-space: nowrap;
    transition: all 0.2s;
  }
  .upload-btn:hover { background: var(--blue-mid); transform: translateY(-1px); }

  /* ── Resources Card ── */
  .resources-card {
    background: var(--card);
    border: 0.5px solid var(--card-border);
    border-radius: 18px; overflow: hidden;
    backdrop-filter: blur(12px);
    box-shadow: 0 2px 20px rgba(58,123,213,0.05);
  }
  .card-header {
    padding: 1.25rem 1.5rem;
    border-bottom: 0.5px solid var(--card-border);
    display: flex; align-items: center;
    justify-content: space-between; gap: 1rem; flex-wrap: wrap;
    background: rgba(238,245,253,0.5);
  }
  .card-header-title { font-weight: 500; color: var(--navy); font-size: 0.9rem; }

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

  /* ── Filter Tabs ── */
  .filter-tabs { display: flex; gap: 6px; }
  .filter-tab {
    padding: 5px 16px; border-radius: 100px;
    font-size: 0.8rem; cursor: pointer;
    border: 0.5px solid var(--card-border);
    background: var(--white); color: var(--text-muted);
    transition: all 0.2s; font-family: 'DM Sans', sans-serif;
  }
  .filter-tab.active, .filter-tab:hover {
    background: rgba(58,123,213,0.08);
    color: var(--blue-mid); border-color: rgba(58,123,213,0.25);
  }

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
    padding: 14px 16px; font-size: 0.875rem;
    border-bottom: 0.5px solid rgba(58,123,213,0.06);
    color: var(--text-secondary);
  }
  tr:last-child td { border-bottom: none; }
  tr:hover td { background: var(--hover); }
  td strong { color: var(--text-primary); }

  /* ── File Tags ── */
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
  .tag-other {
    background: rgba(58,123,213,0.08); color: var(--blue-mid);
    border: 0.5px solid rgba(58,123,213,0.2);
  }

  /* ── Action Button ── */
  .action-btn {
    display: inline-flex; align-items: center; gap: 5px;
    padding: 5px 14px; border-radius: 100px;
    font-size: 0.8rem; cursor: pointer;
    border: 0.5px solid rgba(58,123,213,0.25);
    background: rgba(58,123,213,0.05); color: var(--blue-mid);
    text-decoration: none; transition: all 0.2s;
    font-family: 'DM Sans', sans-serif;
  }
  .action-btn:hover {
    background: var(--blue-mid); color: var(--white);
    border-color: var(--blue-mid);
  }

  /* ── Empty State ── */
  .empty-state {
    padding: 4rem; text-align: center; color: var(--text-muted);
    font-size: 0.9rem;
  }
  .empty-icon { font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; }

  @media (max-width: 900px) {
    .sidebar { display: none; }
    .main { max-width: 100vw; padding: 1.5rem; }
    .stats { grid-template-columns: 1fr 1fr; }
    .upload-form-row { grid-template-columns: 1fr; }
  }
</style>
</head>
<body>
<div class="layout">

  <!-- ── Sidebar ── -->
  <nav class="sidebar">
    <div class="logo">Smart<span>Study</span></div>
    <div class="logo-sub">Resource Platform</div>
    <div class="nav">
      <a href="<%= cp %>/jsp/dashboard.jsp" class="nav-item active">
        <span class="nav-icon">&#128218;</span> Dashboard
      </a>
      <a href="#upload" class="nav-item" onclick="scrollToUpload(event)">
        <span class="nav-icon">&#8679;</span> Upload
      </a>
      <a href="#resources" class="nav-item" onclick="scrollToResources(event)">
        <span class="nav-icon">&#8681;</span> Browse Files
      </a>
    </div>
    <div class="sidebar-bottom">
      <div class="user-pill">
        <div class="avatar"><%= student.getFirstName().charAt(0) %><%= student.getLastName().charAt(0) %></div>
        <div class="user-info">
          <div class="user-name"><%= student.getFirstName() %> <%= student.getLastName() %></div>
          <div class="user-role">🎓 Student</div>
        </div>
      </div>
      <a href="<%= cp %>/LogoutServlet" class="logout-btn">&#8592; Sign out</a>
    </div>
  </nav>

  <!-- ── Main Content ── -->
  <main class="main">
    <div class="top-bar">
      <div>
        <div class="page-title">Good day, <em><%= student.getFirstName() %></em></div>
        <div class="page-sub">Browse resources uploaded by your peers or share your own.</div>
      </div>
    </div>

    <% if(successMsg != null) { %><div class="toast success">&#10003; <%= successMsg %></div><% } %>
    <% if(errorMsg   != null) { %><div class="toast error">&#9888; <%= errorMsg %></div><% } %>

    <!-- Stats -->
    <div class="stats">
      <div class="stat-card">
        <div class="stat-label">Total Files</div>
        <div class="stat-value"><%= resources != null ? resources.size() : 0 %></div>
        <div class="stat-desc">Shared resources</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Your Uploads</div>
        <div class="stat-value" id="myUploads">0</div>
        <div class="stat-desc">Files you shared</div>
      </div>
      <div class="stat-card">
        <div class="stat-label">Subjects</div>
        <div class="stat-value" id="subjectCount">0</div>
        <div class="stat-desc">Covered topics</div>
      </div>
    </div>

    <!-- Upload Section -->
    <div id="upload">
      <div class="section-title">Upload New Resource</div>
      <div class="upload-zone" id="dropZone">
        <div class="upload-icon">&#128228;</div>
        <div class="upload-title">Drop your file here or click to browse</div>
        <div class="upload-sub">Supports PDF and PPT / PPTX files (max 50 MB)</div>
        <label class="choose-label">
          &#128193; Choose File
          <input type="file" id="fileInput" accept=".pdf,.ppt,.pptx" style="display:none">
        </label>
      </div>

      <div class="file-chosen" id="fileChosen">
        <span>&#128196;</span>
        <span id="fileName">No file selected</span>
      </div>

      <form action="<%= cp %>/UploadServlet" method="POST" enctype="multipart/form-data" id="uploadForm">
        <input type="file" name="file" id="hiddenFile" style="display:none">
        <div class="upload-form-row">
          <div>
            <label class="field-label">Title / Description</label>
            <input type="text" name="title" placeholder="e.g. Data Structures Notes Chapter 5" required>
          </div>
          <div>
            <label class="field-label">Subject</label>
            <input type="text" name="subject" placeholder="e.g. Computer Science">
          </div>
          <button type="submit" class="upload-btn">Upload</button>
        </div>
      </form>
    </div>

    <!-- Resources -->
    <div id="resources" style="margin-top:2.5rem;">
      <div class="section-title">All Resources</div>
      <div class="resources-card">
        <div class="card-header">
          <div class="card-header-title">Shared by the community</div>
          <div style="display:flex;gap:12px;align-items:center;flex-wrap:wrap;">
            <div class="filter-tabs">
              <button class="filter-tab active" onclick="filterFiles(event,'all')">All</button>
              <button class="filter-tab" onclick="filterFiles(event,'pdf')">PDF</button>
              <button class="filter-tab" onclick="filterFiles(event,'ppt')">PPT</button>
            </div>
            <input class="search-input" type="text" placeholder="Search files…" oninput="searchFiles(this.value)">
          </div>
        </div>

        <% if(resources == null || resources.isEmpty()) { %>
        <div class="empty-state">
          <div class="empty-icon">&#128237;</div>
          <div>No resources uploaded yet.</div>
          <div style="font-size:0.8rem;margin-top:0.5rem;">Be the first to share something!</div>
        </div>
        <% } else { %>
        <table>
          <thead>
            <tr><th>File Name</th><th>Subject</th><th>Uploaded By</th><th>Date</th><th>Type</th><th>Action</th></tr>
          </thead>
          <tbody id="resourcesTable">
          <% for(Resource r : resources) {
               String ext = r.getFileName().contains(".") ? r.getFileName().substring(r.getFileName().lastIndexOf('.')+1).toLowerCase() : "";
               String tagClass = ext.equals("pdf") ? "tag-pdf" : (ext.startsWith("ppt") ? "tag-ppt" : "tag-other");
          %>
            <tr data-type="<%= ext %>"
                data-name="<%= r.getTitle().toLowerCase() %>"
                data-subject="<%= r.getSubject() != null ? r.getSubject().toLowerCase() : "" %>"
                data-uploader="<%= r.getUploaderName().toLowerCase() %>">
              <td><strong><%= r.getTitle() %></strong></td>
              <td><%= r.getSubject() != null ? r.getSubject() : "N/A" %></td>
              <td><%= r.getUploaderName() %></td>
              <td><%= r.getUploadDate() %></td>
              <td><span class="file-tag <%= tagClass %>"><%= ext.toUpperCase() %></span></td>
              <td><a href="<%= cp %>/ViewServlet?id=<%= r.getId() %>" class="action-btn">&#8659; Download</a></td>
            </tr>
          <% } %>
          </tbody>
        </table>
        <% } %>
      </div>
    </div>
  </main>
</div>

<script>
var fileInput  = document.getElementById('fileInput');
var hiddenFile = document.getElementById('hiddenFile');
var fileChosen = document.getElementById('fileChosen');
var fileNameEl = document.getElementById('fileName');
var dropZone   = document.getElementById('dropZone');

fileInput.addEventListener('change', function() {
  if(fileInput.files[0]) {
    fileNameEl.textContent = fileInput.files[0].name;
    fileChosen.classList.add('show');
    var dt = new DataTransfer();
    dt.items.add(fileInput.files[0]);
    hiddenFile.files = dt.files;
  }
});

['dragenter','dragover'].forEach(function(e) {
  dropZone.addEventListener(e, function(ev){ ev.preventDefault(); dropZone.classList.add('drag'); });
});
['dragleave','drop'].forEach(function(e) {
  dropZone.addEventListener(e, function(ev){ ev.preventDefault(); dropZone.classList.remove('drag'); });
});
dropZone.addEventListener('drop', function(ev) {
  var f = ev.dataTransfer.files[0];
  if(f) {
    fileNameEl.textContent = f.name;
    fileChosen.classList.add('show');
    var dt = new DataTransfer();
    dt.items.add(f);
    hiddenFile.files = dt.files;
    fileInput.files  = dt.files;
  }
});

function scrollToUpload(e)    { e.preventDefault(); document.getElementById('upload').scrollIntoView({behavior:'smooth'}); }
function scrollToResources(e) { e.preventDefault(); document.getElementById('resources').scrollIntoView({behavior:'smooth'}); }

function filterFiles(e, type) {
  document.querySelectorAll('.filter-tab').forEach(function(t){ t.classList.remove('active'); });
  e.target.classList.add('active');
  document.querySelectorAll('#resourcesTable tr').forEach(function(r) {
    r.style.display = (type === 'all' || r.dataset.type === type || (type==='ppt' && (r.dataset.type==='ppt'||r.dataset.type==='pptx'))) ? '' : 'none';
  });
}

function searchFiles(q) {
  q = q.toLowerCase();
  document.querySelectorAll('#resourcesTable tr').forEach(function(r) {
    r.style.display = (r.dataset.name.includes(q) || r.dataset.subject.includes(q) || r.dataset.uploader.includes(q)) ? '' : 'none';
  });
}

// Stats
var subjects = new Set();
var myCount  = 0;
var myName   = '<%= student.getFirstName().toLowerCase() + " " + student.getLastName().toLowerCase() %>';
document.querySelectorAll('#resourcesTable tr').forEach(function(r) {
  if(r.dataset.subject) subjects.add(r.dataset.subject);
  if(r.dataset.uploader && r.dataset.uploader === myName) myCount++;
});
document.getElementById('subjectCount').textContent = subjects.size;
document.getElementById('myUploads').textContent    = myCount;
</script>
</body>
</html>