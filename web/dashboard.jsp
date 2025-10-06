<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Kiểm tra đã đăng nhập chưa
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Trang chủ</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: rgb(60, 63, 65);
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            font-size: 24px;
        }
        
        .header .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .cart-icon {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            text-decoration: none;
            transition: background 0.3s;
            position: relative;
        }

        .cart-icon:hover {
            background: rgba(255,255,255,0.3);
        }

        .cart-count {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: bold;
        }
        
        .header .user-name {
            font-weight: 500;
        }
        
        .header .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }
        
        .header .logout-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }
        
        .welcome-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .welcome-section h2 {
            color: #333;
            margin-bottom: 1rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card .icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
        
        .stat-card h3 {
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .stat-card p {
            color: #666;
            font-size: 14px;
        }
        
        .actions-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .actions-section h3 {
            color: #333;
            margin-bottom: 1.5rem;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }
        
        .action-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem 1.5rem;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            transition: transform 0.3s;
            display: block;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            color: white;
        }
        
        .user-profile {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-top: 2rem;
        }
        
        .user-profile h3 {
            color: #333;
            margin-bottom: 1rem;
        }
        
        .profile-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
        }
        
        .profile-item {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .profile-item:last-child {
            border-bottom: none;
        }
        
        .profile-label {
            font-weight: 500;
            color: #333;
        }
        
        .profile-value {
            color: #666;
        }
        
        /* Styles cho phần hiển thị sản phẩm */
        .products-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .products-section h3 {
            color: #333;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        
        .product-card {
            border: 1px solid #e1e5e9;
            border-radius: 8px;
            padding: 1.5rem;
            transition: all 0.3s;
            background: #f8f9fa;
        }
        
        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-color: #667eea;
        }
        
        .product-card h4 {
            color: #333;
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }
        
        .product-price {
            color: #28a745;
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }
        
        .product-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            line-height: 1.4;
        }
        
        .product-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #e1e5e9;
        }
        
        .product-stock {
            font-size: 0.9rem;
            color: #666;
        }
        
        .product-stock.in-stock {
            color: #28a745;
        }
        
        .product-stock.low-stock {
            color: #ffc107;
        }
        
        .product-stock.out-of-stock {
            color: #dc3545;
        }
        
        .product-date {
            font-size: 0.8rem;
            color: #999;
        }

        .add-to-cart-form {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .quantity-input {
            width: 60px;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            text-align: center;
            margin-right: 10px;
        }

        .add-to-cart-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s;
        }

        .add-to-cart-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(40, 167, 69, 0.3);
        }

        .add-to-cart-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }
        
        .no-products {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .no-products .icon {
            font-size: 4rem;
            margin-bottom: 1rem;
        }
        
        .view-all-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            margin-top: 1rem;
            transition: transform 0.3s;
        }
        
        .view-all-btn:hover {
            transform: translateY(-2px);
            color: white;
        }
        
        .pagination {
            text-align: center;
            margin-top: 2rem;
        }
        
        .pagination a {
            margin: 0 5px;
            padding: 8px 12px;
            text-decoration: none;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #667eea;
        }
        
        .pagination a.active {
            background-color: #667eea;
            color: white;
        }
        
        .pagination a:hover:not(.active) {
            background-color: #f8f9fa;
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        
        /* Add to Cart Styles */
        .add-to-cart-form {
            display: flex;
            gap: 8px;
            align-items: center;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }
        
        .quantity-input {
            width: 50px;
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 3px;
            text-align: center;
        }
        
        .add-to-cart-btn {
            flex: 1;
            padding: 8px 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        .add-to-cart-btn:hover:not(:disabled) {
            background-color: #218838;
        }
        
        .add-to-cart-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏠 Dashboard</h1>
        <div class="user-info">
            <a href="products" class="logout-btn">🛍️ Sản phẩm</a>
            <a href="orders" class="logout-btn">📋 Đơn hàng</a>
            <a href="cart" class="cart-icon">
                🛒
                <c:if test="${not empty sessionScope.cart}">
                    <c:set var="totalCartItems" value="0" />
                    <c:forEach var="item" items="${sessionScope.cart}">
                        <c:set var="totalCartItems" value="${totalCartItems + item.quantity}" />
                    </c:forEach>
                    <span class="cart-count">${totalCartItems}</span>
                </c:if>
            </a>
            <span class="user-name">Xin chào, ${sessionScope.loggedInUser.name}!</span>
            <a href="logout" class="logout-btn">Đăng xuất</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-section">
            <h2>Chào mừng bạn đến với hệ thống quản lý!</h2>
            <p>Bạn đã đăng nhập thành công với tư cách <strong>${sessionScope.userRole}</strong>.</p>
            <c:choose>
                <c:when test="${sessionScope.userRole == 'admin'}">
                    <p style="color: #28a745; font-weight: bold;">🔧 Bạn có quyền quản trị đầy đủ: có thể thêm, sửa, xóa sản phẩm và quản lý người dùng.</p>
                </c:when>
                <c:otherwise>
                    <p style="color: #6c757d;">👁️ Bạn đang ở chế độ chỉ xem: có thể xem và tìm kiếm sản phẩm nhưng không thể chỉnh sửa.</p>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="icon">📦</div>
                <div class="stats-number">${productCount != null ? productCount : 0}</div>
                <h3>Sản phẩm</h3>
                <p>Tổng số sản phẩm trong hệ thống</p>
            </div>
            
            <c:if test="${sessionScope.userRole == 'admin'}">
                <div class="stat-card">
                    <div class="icon">👥</div>
                    <h3>Người dùng</h3>
                    <p>Quản lý thông tin người dùng</p>
                </div>
            </c:if>
            
            <div class="stat-card">
                <div class="icon">👤</div>
                <h3>Tài khoản</h3>
                <p>Thông tin tài khoản của bạn</p>
            </div>
            
            <div class="stat-card">
                <div class="icon">🔍</div>
                <h3>Tìm kiếm</h3>
                <p>Tìm kiếm sản phẩm nhanh chóng</p>
            </div>
        </div>
        
        <!-- Hiển thị danh sách sản phẩm -->
        <div class="products-section">
            <h3>
                📦 Sản phẩm mới nhất
                <c:if test="${sessionScope.userRole != 'admin'}">
                    <span style="font-size: 0.9rem; color: #666; font-weight: normal;">(Chế độ xem cho khách hàng)</span>
                </c:if>
            </h3>
            
            <c:choose>
                <c:when test="${not empty recentProducts}">
                    <div class="products-grid">
                        <c:forEach var="product" items="${recentProducts}">
                            <div class="product-card">
                                <h4>${product.name}</h4>
                                <div class="product-price">
                                    <c:choose>
                                        <c:when test="${product.price >= 1000000}">
                                            ${String.format("%.0f", product.price / 1000000)}M VNĐ
                                        </c:when>
                                        <c:otherwise>
                                            ${String.format("%,.0f", product.price)} VNĐ
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="product-description">
                                    ${product.description}
                                </div>
                                <div class="product-details">
                                    <div class="product-stock
                                        <c:choose>
                                            <c:when test="${product.stock > 20}">in-stock</c:when>
                                            <c:when test="${product.stock > 0}">low-stock</c:when>
                                            <c:otherwise>out-of-stock</c:otherwise>
                                        </c:choose>
                                    ">
                                        📦 Kho: ${product.stock} sản phẩm
                                        <c:if test="${product.stock == 0}"> (Hết hàng)</c:if>
                                        <c:if test="${product.stock > 0 && product.stock <= 10}"> (Sắp hết)</c:if>
                                    </div>
                                    <div class="product-date">
                                        📅 ${product.importDate}
                                    </div>
                                </div>
                                
                                <!-- Add to Cart Form (only for non-admin users) -->
                                <c:if test="${sessionScope.userRole != 'admin'}">
                                    <form action="cart" method="post" class="add-to-cart-form">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <input type="number" name="quantity" value="1" min="1" max="${product.stock}" 
                                               class="quantity-input" ${product.stock == 0 ? 'disabled' : ''}>
                                        <button type="submit" class="add-to-cart-btn" 
                                                ${product.stock == 0 ? 'disabled' : ''}>
                                            ${product.stock == 0 ? '🚫 Hết hàng' : '🛒 Thêm vào giỏ'}
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Phân trang cho dashboard -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a href="dashboard?page=${currentPage - 1}">‹ Trước</a>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages > 5 ? 5 : totalPages}" var="i">
                                <c:choose>
                                    <c:when test="${currentPage eq i}">
                                        <a class="active" href="dashboard?page=${i}">${i}</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="dashboard?page=${i}">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${totalPages > 5}">
                                <span>...</span>
                                <a href="dashboard?page=${totalPages}">${totalPages}</a>
                            </c:if>

                            <c:if test="${currentPage < totalPages}">
                                <a href="dashboard?page=${currentPage + 1}">Sau ›</a>
                            </c:if>
                        </div>
                    </c:if>
                    
                    <div style="text-align: center; margin-top: 1.5rem;">
                        <a href="products" class="view-all-btn">
                            🔍 Xem tất cả sản phẩm (${productCount})
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="no-products">
                        <div class="icon">📦</div>
                        <h4>Chưa có sản phẩm nào</h4>
                        <p>Hiện tại chưa có sản phẩm nào trong hệ thống.</p>
                        <c:if test="${sessionScope.userRole == 'admin'}">
                            <a href="products?action=new" class="view-all-btn">➕ Thêm sản phẩm đầu tiên</a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="actions-section">
            <h3>
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'admin'}">⚡ Hành động quản trị</c:when>
                    <c:otherwise>🚀 Hành động nhanh</c:otherwise>
                </c:choose>
            </h3>
            <div class="action-buttons">
                <c:choose>
                    <c:when test="${sessionScope.userRole == 'admin'}">
                        <a href="products" class="action-btn">📦 Quản lý sản phẩm</a>
                        <a href="users" class="action-btn">👥 Quản lý người dùng</a>
                        <a href="products?action=new" class="action-btn">➕ Thêm sản phẩm mới</a>
                        <a href="users?action=new" class="action-btn">👤 Thêm người dùng</a>
                    </c:when>
                    <c:otherwise>
                        <a href="products" class="action-btn">📦 Xem tất cả sản phẩm</a>
                        <a href="search" class="action-btn">� Tìm kiếm sản phẩm</a>
                        <a href="#" class="action-btn" onclick="window.location.reload()">� Làm mới trang</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <div class="user-profile">
            <h3>Thông tin tài khoản</h3>
            <div class="profile-info">
                <div class="profile-item">
                    <span class="profile-label">ID:</span>
                    <span class="profile-value">${sessionScope.loggedInUser.id}</span>
                </div>
                <div class="profile-item">
                    <span class="profile-label">Tên:</span>
                    <span class="profile-value">${sessionScope.loggedInUser.name}</span>
                </div>
                <div class="profile-item">
                    <span class="profile-label">Email:</span>
                    <span class="profile-value">${sessionScope.loggedInUser.email}</span>
                </div>
                <div class="profile-item">
                    <span class="profile-label">Quốc gia:</span>
                    <span class="profile-value">${sessionScope.loggedInUser.country}</span>
                </div>
                <div class="profile-item">
                    <span class="profile-label">Vai trò:</span>
                    <span class="profile-value">${sessionScope.loggedInUser.role}</span>
                </div>
                <div class="profile-item">
                    <span class="profile-label">Trạng thái:</span>
                    <span class="profile-value">
                        <c:choose>
                            <c:when test="${sessionScope.loggedInUser.status}">
                                ✅ Hoạt động
                            </c:when>
                            <c:otherwise>
                                ❌ Bị khóa
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
        </div>
    </div>
</body>
</html>