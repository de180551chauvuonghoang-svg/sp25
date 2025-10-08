<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>
<%@ page import="productDao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Kiểm tra session và user
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Lấy dữ liệu sản phẩm
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = null;
    String searchInfo = "";
    String errorMsg = "";
    
    try {
        // Xử lý search request - chỉ tìm kiếm theo giá tối thiểu
        String minPriceStr = request.getParameter("minPrice");
        
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                long minPrice = Long.parseLong(minPriceStr);
                products = productDAO.searchProductsByMinPrice(minPrice);
                searchInfo = "Tìm sản phẩm có giá lớn hơn " + String.format("%,d", minPrice) + " VND";
            } catch (NumberFormatException e) {
                errorMsg = "Giá phải là số hợp lệ!";
            }
        }
        
        // Nếu không có search, hiển thị sản phẩm theo role
        if (products == null) {
            if (currentUser.isAdmin()) {
                // Admin: hiển thị sản phẩm sắp xếp theo Category
                products = productDAO.getAllProductsSortedByCategory();
            } else {
                // User: hiển thị sản phẩm sắp xếp theo ngày nhập
                products = productDAO.getProductsSortedByImportDate(false);
            }
        }
        
    } catch (Exception e) {
        errorMsg = "Lỗi khi lấy dữ liệu: " + e.getMessage();
        products = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách sản phẩm - PRJ301</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .header {
            background-color: #007bff;
            color: white;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .role-badge {
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
        }
        .role-admin {
            background-color: #dc3545;
        }
        .role-user {
            background-color: #28a745;
        }
        .search-container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .search-form {
            display: flex;
            gap: 15px;
            align-items: end;
        }
        .form-group {
            display: flex;
            flex-direction: column;
        }
        .form-group label {
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 3px;
            font-size: 14px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
        .products-container {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .products-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }
        th {
            background-color: #f8f9fa;
            font-weight: bold;
            color: #495057;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .price {
            font-weight: bold;
            color: #007bff;
        }
        .category-badge {
            padding: 4px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
            color: white;
        }
        .category-samsung { background-color: #6f42c1; }
        .category-iphone { background-color: #fd7e14; }
        .category-xiaomi { background-color: #20c997; }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 3px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 3px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        .admin-controls {
            display: flex;
            gap: 5px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div>
            <h2>Quản lý sản phẩm</h2>
            <p>PRJ301 - Product Management System</p>
        </div>
        <div class="user-info">
            <span>Xin chào, <strong>${sessionScope.userName}</strong></span>
            <span class="role-badge ${sessionScope.role == 'admin' ? 'role-admin' : 'role-user'}">
                ${sessionScope.role == 'admin' ? 'ADMIN' : 'USER'}
            </span>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-secondary">🚪 Đăng xuất</a>
        </div>
    </div>

    <!-- Messages -->
    <% if (!errorMsg.isEmpty()) { %>
        <div class="error-message">
            <%= errorMsg %>
        </div>
    <% } %>
    
    <!-- Success/Error messages từ URL parameters -->
    <% 
        String successParam = request.getParameter("success");
        String errorParam = request.getParameter("error");
        String productNameParam = request.getParameter("productName");
    %>
    
    <% if (successParam != null) { %>
        <div class="success-message">
            <% if ("add".equals(successParam)) { %>
                ✅ Thêm sản phẩm "<%= productNameParam != null ? productNameParam : "" %>" thành công!
            <% } else if ("update".equals(successParam)) { %>
                ✅ Cập nhật sản phẩm "<%= productNameParam != null ? productNameParam : "" %>" thành công!
            <% } else if ("delete".equals(successParam)) { %>
                ✅ Xóa sản phẩm "<%= productNameParam != null ? productNameParam : "" %>" thành công!
            <% } %>
        </div>
    <% } %>
    
    <% if (errorParam != null) { %>
        <div class="error-message">
            <% if ("access_denied".equals(errorParam)) { %>
                ❌ Bạn không có quyền truy cập chức năng này!
            <% } else if ("invalid_product".equals(errorParam)) { %>
                ❌ Không tìm thấy sản phẩm!
            <% } else if ("delete_failed".equals(errorParam)) { %>
                ❌ Không thể xóa sản phẩm "<%= productNameParam != null ? productNameParam : "" %>"!
            <% } else { %>
                ❌ Có lỗi xảy ra trong quá trình xử lý!
            <% } %>
        </div>
    <% } %>

    <!-- Hiển thị thông tin tìm kiếm -->
    <% if (!searchInfo.isEmpty()) { %>
    <div style="background-color: #e3f2fd; color: #0d47a1; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #2196f3;">
        <strong>📊 <%= searchInfo %></strong>
    </div>
    <% } %>

    <!-- Search Form -->
    <div class="search-container">
        <h3>🔍 Tìm kiếm sản phẩm theo giá</h3>
        
        <form action="viewAllProduct.jsp" method="get" class="search-form">
            <div class="form-group">
                <label for="minPrice">Tìm sản phẩm có giá lớn hơn (VND):</label>
                <input type="number" id="minPrice" name="minPrice" 
                       value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>" 
                       placeholder="Ví dụ: 25000000" min="0">
                <small style="color: #6c757d;">Hiển thị tất cả sản phẩm có giá lớn hơn (không bằng) mức giá này</small>
            </div>
            
            <div class="form-group">
                <button type="submit" class="btn btn-primary">🔍 Tìm kiếm</button>
                <a href="viewAllProduct.jsp" class="btn btn-secondary">📋 Xem tất cả</a>
            </div>
        </form>
    </div>

    <!-- Products List -->
    <div class="products-container">
        <div class="products-header">
            <h3>
                📦 Danh sách sản phẩm 
                (<%= products != null ? products.size() : 0 %> sản phẩm)
                <% if (currentUser.isAdmin()) { %>
                    - Sắp xếp theo Danh mục (Category)
                <% } else { %>
                    - Sắp xếp theo ngày nhập mới nhất
                <% } %>
            </h3>
            
            <% if (currentUser.isAdmin()) { %>
                <div class="admin-controls">
                    <a href="${pageContext.request.contextPath}/addProduct.jsp" class="btn btn-success">➕ Thêm sản phẩm</a>
                </div>
            <% } %>
        </div>

        <% if (products == null || products.isEmpty()) { %>
            <div class="no-data">
                <h4>Không tìm thấy sản phẩm nào</h4>
                <p>Thử thay đổi tiêu chí tìm kiếm hoặc xem tất cả sản phẩm.</p>
            </div>
        <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Mã sản phẩm</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá</th>
                        <th>Ngày nhập</th>
                        <th>Danh mục</th>
                        <% if (currentUser.isAdmin()) { %>
                            <th>Thao tác</th>
                        <% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Product product : products) { %>
                        <tr>
                            <td><strong><%= product.getProductID() %></strong></td>
                            <td><%= product.getProductName() %></td>
                            <td class="price">
                                <%= String.format("%,d", product.getPrice()) %> VND
                            </td>
                            <td><%= product.getFormattedImportDate() %></td>
                            <td>
                                <span class="category-badge category-<%= product.getCategory().toLowerCase() %>">
                                    <%= product.getCategory() %>
                                </span>
                            </td>
                            <% if (currentUser.isAdmin()) { %>
                                <td>
                                    <div class="admin-controls">
                                        <a href="${pageContext.request.contextPath}/editProduct.jsp?id=<%= product.getProductID() %>" 
                                           class="btn btn-primary">✏️ Sửa</a>
                                        <a href="${pageContext.request.contextPath}/productManagement.jsp?action=delete&id=<%= product.getProductID() %>" 
                                           class="btn btn-danger" 
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm <%= product.getProductName() %>?')">🗑️ Xóa</a>
                                    </div>
                                </td>
                            <% } %>
                        </tr>
                    <% } %>
                </tbody>
            </table>
                
            <div style="padding: 15px; text-align: center; color: #6c757d;">
                Tổng cộng: <strong><%= products.size() %></strong> sản phẩm
            </div>
        <% } %>
    </div>

</body>
</html>