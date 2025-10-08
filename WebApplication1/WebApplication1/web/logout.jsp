<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Logout logic
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/login.jsp");
%>