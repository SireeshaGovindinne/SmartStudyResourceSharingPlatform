<%-- upload.jsp - just 5 lines --%>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?role=student");
    } else {
        response.sendRedirect("dashboard.jsp");  // ← goes straight to dashboard
    }
%>