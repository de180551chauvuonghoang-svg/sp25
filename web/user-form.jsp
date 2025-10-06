<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Kiểm tra đã đăng nhập và là admin
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login");
        return;
    }
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendError(403, "Bạn không có quyền truy cập trang này!");
        return;
    }
%>
<html>
<head>
    <title>User Form</title>
</head>
<body>
<h2><c:if test="${user != null}">Sửa User</c:if><c:if test="${user == null}">Thêm User</c:if></h2>

<form action="users" method="post">
    <input type="hidden" name="action" value="${user != null ? 'update' : 'insert'}"/>
    <c:if test="${user != null}">
        <input type="hidden" name="id" value="${user.id}"/>
    </c:if>

    <label>Username:</label><br/>
    <input type="text" name="name" value="${user.name}"/><br/>

    <label>Email:</label><br/>
    <input type="email" name="email" value="${user.email}"/><br/>

    <label>Country:</label><br/>
    <input type="text" name="country" value="${user.country}"/><br/>

    <label>Role:</label><br/>
    <input type="text" name="role" value="${user.role}"/><br/>

    <label>Status:</label><br/>
    <input type="checkbox" name="status" <c:if test="${user.status}">checked</c:if>/> Active<br/>

    <label>Password:</label><br/>
    <input type="password" name="password" value="${user.password}"/><br/>

    <label>Ngày sinh:</label><br/>
    <input type="date" name="dateOfBirth" value="${user.dateOfBirth}"/><br/><br/>

    <input type="submit" value="Save"/>
    <a href="users">Cancel</a>
</form>
</body>
</html>
