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
    <title>Xóa Product</title>
</head>
<body>
<h2>Xác nhận xóa Product</h2>

<p>Bạn có chắc chắn muốn xóa sản phẩm này?</p>

<table border="1" cellpadding="10" cellspacing="0">
    <tr>
        <th>ID</th>
        <td>${product.id}</td>
    </tr>
    <tr>
        <th>Tên</th>
        <td>${product.name}</td>
    </tr>
    <tr>
        <th>Giá</th>
        <td>${product.price}</td>
    </tr>
    <tr>
        <th>Mô tả</th>
        <td>${product.description}</td>
    </tr>
    <tr>
        <th>Tồn kho</th>
        <td>${product.stock}</td>
    </tr>
    <tr>
        <th>Ngày nhập</th>
        <td>${product.importDate}</td>
    </tr>
</table>

<br/>
<form action="products" method="post">
    <input type="hidden" name="action" value="delete"/>
    <input type="hidden" name="id" value="${product.id}"/>
    <input type="submit" value="Xóa"/>
    <a href="products">Hủy</a>
</form>
</body>
</html>
