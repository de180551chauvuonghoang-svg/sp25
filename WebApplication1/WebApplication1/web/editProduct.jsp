<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="model.Product" %>
<%@ page import="productDao.ProductDAO" %>
<%@ page import="java.util.List" %>

<%
    // Kiểm tra session và quyền admin
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    if (!currentUser.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/viewAllProduct.jsp?error=access_denied");
        return;
    }
    
    // Lấy ID sản phẩm cần edit
    String productID = request.getParameter("id");
    if (productID == null || productID.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/viewAllProduct.jsp?error=invalid_product");
        return;
    }
    
    // Lấy thông tin sản phẩm và categories
    ProductDAO productDAO = new ProductDAO();
    Product product = productDAO.getProductByID(productID);
    List<String> categories = productDAO.getAllCategories();
    
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/viewAllProduct.jsp?error=product_not_found");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chỉnh sửa sản phẩm - PRJ301</title>
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
        .form-container {
            background-color: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            max-width: 600px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 0 2px rgba(0,123,255,0.25);
        }
        .form-group input[readonly] {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            margin-right: 10px;
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
        .btn:hover {
            opacity: 0.9;
        }
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        .form-actions {
            text-align: center;
            margin-top: 30px;
        }
        .required {
            color: red;
        }
        .product-info {
            background-color: #e3f2fd;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div>
            <h2>✏️ Chỉnh sửa sản phẩm</h2>
            <p>PRJ301 - Product Management System (Admin)</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/viewAllProduct.jsp" class="btn btn-secondary">📋 Quay lại danh sách</a>
            <a href="${pageContext.request.contextPath}/logout.jsp" class="btn btn-secondary">🚪 Đăng xuất</a>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty param.error}">
        <div class="error-message">
            <c:choose>
                <c:when test="${param.error == 'missing_fields'}">
                    Vui lòng điền đầy đủ thông tin bắt buộc!
                </c:when>
                <c:when test="${param.error == 'invalid_price'}">
                    Giá sản phẩm phải là số dương!
                </c:when>
                <c:otherwise>
                    Có lỗi xảy ra khi cập nhật sản phẩm!
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${not empty param.success}">
        <div class="success-message">
            Cập nhật sản phẩm thành công!
        </div>
    </c:if>

    <!-- Edit Product Form -->
    <div class="form-container">
        <div class="product-info">
            <h4>📦 Thông tin hiện tại</h4>
            <p><strong>Mã sản phẩm:</strong> <%= product.getProductID() %></p>
            <p><strong>Tên:</strong> <%= product.getProductName() %></p>
            <p><strong>Giá hiện tại:</strong> <%= String.format("%,d", product.getPrice()) %> VND</p>
        </div>
        
        <h3>📝 Cập nhật thông tin</h3>
        
        <form action="${pageContext.request.contextPath}/productManagement.jsp" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="originalProductID" value="<%= product.getProductID() %>">
            
            <div class="form-group">
                <label for="productID">Mã sản phẩm <span class="required">*</span></label>
                <input type="text" id="productID" name="productID" 
                       value="<%= product.getProductID() %>" 
                       readonly>
                <small style="color: #666;">Mã sản phẩm không thể thay đổi</small>
            </div>
            
            <div class="form-group">
                <label for="productName">Tên sản phẩm <span class="required">*</span></label>
                <input type="text" id="productName" name="productName" 
                       value="<%= product.getProductName() %>" 
                       placeholder="Nhập tên sản phẩm" 
                       required maxlength="100">
            </div>
            
            <div class="form-group">
                <label for="price">Giá (VND) <span class="required">*</span></label>
                <input type="number" id="price" name="price" 
                       value="<%= product.getPrice() %>" 
                       placeholder="Ví dụ: 25000000" 
                       required min="1" step="1000">
            </div>
            
            <div class="form-group">
                <label for="importDate">Ngày nhập <span class="required">*</span></label>
                <input type="date" id="importDate" name="importDate" 
                       value="<%= product.getImportDate() %>" 
                       required>
            </div>
            
            <div class="form-group">
                <label for="category">Danh mục <span class="required">*</span></label>
                <select id="category" name="category" required>
                    <option value="">-- Chọn danh mục --</option>
                    <% for (String category : categories) { %>
                        <option value="<%= category %>" 
                                <%= category.equals(product.getCategory()) ? "selected" : "" %>>
                            <%= category %>
                        </option>
                    <% } %>
                    <option value="OTHER">Danh mục khác</option>
                </select>
            </div>
            
            <div class="form-group" id="customCategoryGroup" style="display: none;">
                <label for="customCategory">Nhập danh mục mới:</label>
                <input type="text" id="customCategory" name="customCategory" 
                       placeholder="Nhập tên danh mục mới" 
                       maxlength="50">
            </div>
            
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">💾 Cập nhật sản phẩm</button>
                <a href="${pageContext.request.contextPath}/viewAllProduct.jsp" class="btn btn-secondary">❌ Hủy bỏ</a>
                <a href="${pageContext.request.contextPath}/productManagement.jsp?action=delete&id=<%= product.getProductID() %>" 
                   class="btn btn-danger" 
                   onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm <%= product.getProductName() %>?')">
                   🗑️ Xóa sản phẩm
                </a>
            </div>
        </form>
    </div>

    <script>
        // Xử lý custom category
        document.getElementById('category').addEventListener('change', function() {
            const customGroup = document.getElementById('customCategoryGroup');
            const customInput = document.getElementById('customCategory');
            
            if (this.value === 'OTHER') {
                customGroup.style.display = 'block';
                customInput.required = true;
            } else {
                customGroup.style.display = 'none';
                customInput.required = false;
                customInput.value = '';
            }
        });
        
        // Format số tiền khi nhập
        document.getElementById('price').addEventListener('input', function() {
            // Remove non-numeric characters except digits
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>