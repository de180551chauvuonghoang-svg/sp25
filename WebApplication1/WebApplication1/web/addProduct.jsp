<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
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
    
    // Lấy danh sách categories có sẵn
    ProductDAO productDAO = new ProductDAO();
    List<String> categories = productDAO.getAllCategories();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm sản phẩm mới - PRJ301</title>
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
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div>
            <h2>➕ Thêm sản phẩm mới</h2>
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
                <c:when test="${param.error == 'duplicate_id'}">
                    Mã sản phẩm đã tồn tại! Vui lòng chọn mã khác.
                </c:when>
                <c:otherwise>
                    Có lỗi xảy ra khi thêm sản phẩm!
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <c:if test="${not empty param.success}">
        <div class="success-message">
            Thêm sản phẩm thành công!
        </div>
    </c:if>

    <!-- Add Product Form -->
    <div class="form-container">
        <h3>📝 Thông tin sản phẩm</h3>
        
        <form action="${pageContext.request.contextPath}/productManagement.jsp" method="post">
            <input type="hidden" name="action" value="add">
            
            <div class="form-group">
                <label for="productID">Mã sản phẩm <span class="required">*</span></label>
                <input type="text" id="productID" name="productID" 
                       value="${param.productID}" 
                       placeholder="Ví dụ: P001, P002..." 
                       required maxlength="10">
                <small style="color: #666;">Mã sản phẩm không được trùng với sản phẩm đã có</small>
            </div>
            
            <div class="form-group">
                <label for="productName">Tên sản phẩm <span class="required">*</span></label>
                <input type="text" id="productName" name="productName" 
                       value="${param.productName}" 
                       placeholder="Nhập tên sản phẩm" 
                       required maxlength="100">
            </div>
            
            <div class="form-group">
                <label for="price">Giá (VND) <span class="required">*</span></label>
                <input type="number" id="price" name="price" 
                       value="${param.price}" 
                       placeholder="Ví dụ: 25000000" 
                       required min="1" step="1000">
            </div>
            
            <div class="form-group">
                <label for="importDate">Ngày nhập <span class="required">*</span></label>
                <input type="date" id="importDate" name="importDate" 
                       value="${param.importDate}" 
                       required>
            </div>
            
            <div class="form-group">
                <label for="category">Danh mục <span class="required">*</span></label>
                <select id="category" name="category" required>
                    <option value="">-- Chọn danh mục --</option>
                    <% for (String category : categories) { %>
                        <option value="<%= category %>" 
                                <%= category.equals(request.getParameter("category")) ? "selected" : "" %>>
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
                <button type="submit" class="btn btn-primary">💾 Thêm sản phẩm</button>
                <a href="${pageContext.request.contextPath}/viewAllProduct.jsp" class="btn btn-secondary">❌ Hủy bỏ</a>
            </div>
        </form>
    </div>

    <script>
        // Set ngày hiện tại làm mặc định
        document.getElementById('importDate').valueAsDate = new Date();
        
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