<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Kiểm tra đã đăng nhập chưa
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Danh sách Product</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: rgb(60, 63, 65); }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { margin: 0; }
        .user-info { display: flex; align-items: center; gap: 15px; }
        .logout-btn { background: rgba(255,255,255,0.2); color: white; padding: 8px 16px; border: none; border-radius: 6px; text-decoration: none; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }
        .actions { margin-bottom: 20px; display: flex; gap: 10px; align-items: center; justify-content: space-between; }
        .btn { padding: 10px 20px; background: #667eea; color: white; text-decoration: none; border-radius: 5px; border: none; cursor: pointer; }
        .btn:hover { background: #5a6fd8; }
        .btn-secondary { background: #6c757d; }
        .btn-secondary:hover { background: #5a6268; }
        .btn-success { background: #28a745; }
        .btn-success:hover { background: #218838; }
        table { border-collapse: collapse; width: 100%; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f8f9fa; font-weight: 600; }
        .pagination { margin-top: 20px; text-align: center; }
        .pagination a { margin: 0 5px; padding: 8px 12px; text-decoration: none; border: 1px solid #ddd; border-radius: 4px; color: #667eea; }
        .pagination a.active { background-color: #667eea; color: white; }
        .pagination a:hover:not(.active) { background-color: #f8f9fa; }
        .cart-badge { 
            position: relative; 
            top: -8px; 
            background: #dc3545; 
            color: white; 
            border-radius: 50%; 
            padding: 2px 6px; 
            font-size: 0.8em; 
        }
        .stock-warning { color: #dc3545; font-weight: bold; }
        .stock-good { color: #28a745; }
        .stock-low { color: #ffc107; font-weight: bold; }
        .out-of-stock { 
            opacity: 0.6; 
            background-color: #f8f9fa; 
        }
        .out-of-stock-badge {
            background: #dc3545;
            color: white;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 0.8em;
        }
        .add-to-cart-form { display: inline-flex; align-items: center; gap: 5px; }
        .quantity-input { width: 60px; text-align: center; }
    </style>
</head>
<body>
<div class="header">
    <h1>📦 Quản lý sản phẩm</h1>
    <div class="user-info">
        <span>Xin chào, ${sessionScope.loggedInUser.name}!</span>
        <a href="${pageContext.request.contextPath}/cart" class="logout-btn">
            <i class="fas fa-shopping-cart"></i> Giỏ hàng 
            <span class="cart-badge" id="cart-count">0</span>
        </a>
        <a href="dashboard" class="logout-btn">🏠 Dashboard</a>
        <a href="logout" class="logout-btn">Đăng xuất</a>
    </div>
</div>

<div class="container">
<h2>Danh sách Product</h2>
<div class="actions">
    <div>
        <c:if test="${sessionScope.userRole == 'admin'}">
            <a href="products?action=new" class="btn">➕ Thêm Product</a>
            <a href="users" class="btn btn-secondary">👥 Quản lý User</a>
        </c:if>
    </div>
    <div>
        <a href="${pageContext.request.contextPath}/orders" class="btn btn-success">
            <i class="fas fa-history"></i> Lịch sử đơn hàng
        </a>
    </div>
</div>
    <a href="dashboard" class="btn btn-secondary">🏠 Về Dashboard</a>
</div>
<table>
    <tr>
        <th>ID</th>
        <th>Tên</th>
        <th>Giá</th>
        <th>Mô tả</th>
        <th>Tồn kho</th>
        <th>Ngày nhập</th>
        <th>Hành động</th>
    </tr>
    <c:forEach var="product" items="${listProduct}">
        <tr>
            <td>${product.id}</td>
            <td>${product.name}</td>
            <td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₫"/></td>
            <td>${product.description}</td>
            <td>
                <c:choose>
                    <c:when test="${product.status == 'OUT_OF_STOCK' || product.stock == 0}">
                        <span class="out-of-stock-badge">HẾT HÀNG</span>
                    </c:when>
                    <c:when test="${product.stock > 10}">
                        <span class="stock-good">${product.stock} sản phẩm</span>
                    </c:when>
                    <c:when test="${product.stock > 0}">
                        <span class="stock-low">${product.stock} sản phẩm (Sắp hết)</span>
                    </c:when>
                    <c:otherwise>
                        <span class="out-of-stock-badge">HẾT HÀNG</span>
                    </c:otherwise>
                </c:choose>
            </td>
            <td>${product.importDate}</td>
            <td class="${(product.status == 'OUT_OF_STOCK' || product.stock == 0) ? 'out-of-stock' : ''}">
                <c:if test="${sessionScope.userRole == 'admin'}">
                    <a href="products?action=edit&id=${product.id}" style="color: #28a745; text-decoration: none;">✏️ Sửa</a> |
                    <a href="products?action=confirmDelete&id=${product.id}" style="color: #dc3545; text-decoration: none;">🗑️ Xóa</a>
                    <br>
                </c:if>
                
                <!-- Add to Cart functionality -->
                <c:choose>
                    <c:when test="${product.status == 'AVAILABLE' && product.stock > 0}">
                        <div class="add-to-cart-form mt-2">
                            <input type="number" min="1" max="${product.stock}" value="1" 
                                   class="form-control quantity-input" id="qty-${product.id}">
                            <button class="btn btn-sm btn-success" onclick="addToCart('${product.id}')">
                                <i class="fas fa-cart-plus"></i> Thêm
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="mt-2">
                            <button class="btn btn-sm btn-secondary" disabled>
                                <i class="fas fa-times"></i> Hết hàng
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
</table>

<div class="pagination">
    <c:if test="${currentPage > 1}">
        <a href="products?page=${currentPage - 1}">Trước</a>
    </c:if>

    <c:forEach begin="1" end="${totalPages}" var="i">
        <c:choose>
            <c:when test="${currentPage eq i}">
                <a class="active" href="products?page=${i}">${i}</a>
            </c:when>
            <c:otherwise>
                <a href="products?page=${i}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <c:if test="${currentPage < totalPages}">
        <a href="products?page=${currentPage + 1}">Sau</a>
    </c:if>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Update cart count on page load
    window.addEventListener('load', function() {
        updateCartCount();
    });

    function addToCart(productId) {
        const quantityInput = document.getElementById('qty-' + productId);
        const quantity = parseInt(quantityInput.value);
        
        if (quantity < 1) {
            alert('Số lượng phải lớn hơn 0');
            return;
        }
        
        fetch('${pageContext.request.contextPath}/cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=add&productId=' + productId + '&quantity=' + quantity
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Cập nhật số lượng giỏ hàng và thông báo
                updateCartCount();
                alert(data.message || 'Đã thêm vào giỏ hàng thành công');
            } else {
                alert(data.message);
                if (data.availableStock !== undefined) {
                    quantityInput.max = data.availableStock;
                    quantityInput.value = Math.min(quantity, data.availableStock);
                    // Refresh page để cập nhật trạng thái sản phẩm
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                }
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra khi thêm vào giỏ hàng');
        });
    }
    
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart?action=count')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('cart-count').textContent = data.cartSize;
                }
            })
            .catch(error => console.log('Error updating cart count:', error));
    }
</script>
</body>
</html>
