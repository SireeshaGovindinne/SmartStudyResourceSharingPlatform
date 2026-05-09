<%-- view.jsp - just 4 lines --%>
<%
    String id = request.getParameter("id");
    if (id != null) {
        response.sendRedirect(request.getContextPath() + "/ViewServlet?id=" + id);
    } else {
        response.sendRedirect("dashboard.jsp");
    }
%>