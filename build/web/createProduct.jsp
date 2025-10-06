<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <title>Thêm Product</title>
</head>
<body>
<h2>Thêm Product mới</h2>

<form action="products" method="post">
    <input type="hidden" name="action" value="insert"/>

    <label>Tên:</label><br/>
    <input type="text" name="name" required/><br/>

    <label>Giá:</label><br/>
    <input type="number" step="0.01" name="price" required/><br/>

    <label>Mô tả:</label><br/>
    <textarea name="description"></textarea><br/>

    <label>Tồn kho:</label><br/>
    <input type="number" name="stock" required/><br/>

    <label>Ngày nhập:</label><br/>
    <input type="date" name="importDate" required/><br/><br/>

    <input type="submit" value="Lưu"/>
    <a href="products">Hủy</a>
</form>
</body>
</html>
