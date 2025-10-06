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
    <title>User List</title>
</head>
<body>
<h2>Danh sách User</h2>
<a href="users?action=new">➕ Thêm User</a>

<!-- Search Form -->
<form action="users" method="get" style="margin-bottom: 20px;">
    <input type="hidden" name="action" value="search"/>
    <label>Tìm kiếm theo tên:</label>
    <input type="text" name="searchName" value="${searchName}" placeholder="Nhập tên để tìm kiếm..."/>
    <input type="submit" value="Tìm kiếm"/>
    <a href="users">Hiển thị tất cả ||||</a>
    <a href="products">Nhấp zô đi là tới Product nha !</a>
</form>

<table border="1" cellpadding="10" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>Country</th>
        <th>Role</th>
        <th>Status</th>
        <th>Password</th>
        <th>Ngày sinh</th>
        <th>Action</th>
    </tr>
    <c:forEach var="user" items="${listUser}">
        <tr>
            <td>${user.id}</td>
            <td>${user.name}</td>
            <td>${user.email}</td>
            <td>${user.country}</td>
            <td>${user.role}</td>
            <td><c:choose>
                <c:when test="${user.status}">Active</c:when>
                <c:otherwise>Inactive</c:otherwise>
            </c:choose></td>
            <td>${user.password}</td>
            <td>${user.dateOfBirth}</td>
            <td>
                <a href="users?action=edit&id=${user.id}">Edit</a> |
                <a href="users?action=delete&id=${user.id}" onclick="return confirm('Delete this user?')">Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
