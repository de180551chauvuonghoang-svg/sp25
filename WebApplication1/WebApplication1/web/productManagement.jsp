<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>
<%@ page import="productDao.ProductDAO" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeParseException" %>

<%
    // Kiểm tra quyền admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!currentUser.isAdmin()) {
        request.setAttribute("errorMessage", "Bạn không có quyền truy cập!");
        request.getRequestDispatcher("/error.jsp").forward(request, response);
        return;
    }

    String action = request.getParameter("action");
    String message = "";
    String messageType = ""; // success or error
    
    ProductDAO productDAO = new ProductDAO();
    
    if ("add".equals(action) && "POST".equals(request.getMethod())) {
        // Xử lý thêm sản phẩm
        try {
            String productID = request.getParameter("productID");
            String productName = request.getParameter("productName");
            String priceStr = request.getParameter("price");
            String importDateStr = request.getParameter("importDate");
            String category = request.getParameter("category");
            
            // Validation
            if (productID == null || productID.trim().isEmpty()) {
                throw new Exception("Mã sản phẩm không được để trống");
            }
            if (productName == null || productName.trim().isEmpty()) {
                throw new Exception("Tên sản phẩm không được để trống");
            }
            
            long price = Long.parseLong(priceStr);
            LocalDate importDate = LocalDate.parse(importDateStr);
            
            // Kiểm tra trùng ID
            if (productDAO.getProductByID(productID.trim()) != null) {
                throw new Exception("Mã sản phẩm đã tồn tại!");
            }
            
            Product product = new Product(productID.trim(), productName.trim(), price, importDate, category);
            
            if (productDAO.addProduct(product)) {
                message = "Thêm sản phẩm thành công!";
                messageType = "success";
            } else {
                message = "Thêm sản phẩm thất bại!";
                messageType = "error";
            }
            
        } catch (NumberFormatException e) {
            message = "Giá sản phẩm phải là số hợp lệ!";
            messageType = "error";
        } catch (DateTimeParseException e) {
            message = "Ngày nhập không hợp lệ!";
            messageType = "error";
        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            messageType = "error";
        }
    }
    
    else if ("update".equals(action) && "POST".equals(request.getMethod())) {
        // Xử lý cập nhật sản phẩm
        try {
            String productID = request.getParameter("productID");
            String productName = request.getParameter("productName");
            String priceStr = request.getParameter("price");
            String importDateStr = request.getParameter("importDate");
            String category = request.getParameter("category");
            
            long price = Long.parseLong(priceStr);
            LocalDate importDate = LocalDate.parse(importDateStr);
            
            Product product = new Product(productID, productName, price, importDate, category);
            
            if (productDAO.updateProduct(product)) {
                message = "Cập nhật sản phẩm thành công!";
                messageType = "success";
            } else {
                message = "Cập nhật sản phẩm thất bại!";
                messageType = "error";
            }
            
        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            messageType = "error";
        }
    }
    
    else if ("delete".equals(action)) {
        // Xử lý xóa sản phẩm
        try {
            String productID = request.getParameter("id");
            
            if (productID != null && !productID.trim().isEmpty()) {
                if (productDAO.deleteProduct(productID.trim())) {
                    message = "Xóa sản phẩm thành công!";
                    messageType = "success";
                } else {
                    message = "Xóa sản phẩm thất bại!";
                    messageType = "error";
                }
            } else {
                message = "Mã sản phẩm không hợp lệ!";
                messageType = "error";
            }
            
        } catch (Exception e) {
            message = "Lỗi: " + e.getMessage();
            messageType = "error";
        }
    }
    
    // Set message vào session để hiển thị ở trang khác
    if (!message.isEmpty()) {
        if ("success".equals(messageType)) {
            session.setAttribute("successMessage", message);
        } else {
            session.setAttribute("errorMessage", message);
        }
        
        // Redirect về trang danh sách sản phẩm
        response.sendRedirect(request.getContextPath() + "/viewAllProduct.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Management - PRJ301</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .message {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin: 10px 5px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Product Management</h1>
        
        <% if (!message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>
        
        <p>Đang xử lý yêu cầu...</p>
        <p><a href="${pageContext.request.contextPath}/viewAllProduct.jsp" class="btn">Quay lại danh sách sản phẩm</a></p>
    </div>
</body>
</html>