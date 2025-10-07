<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<html>
<head>
    <title>Giỏ hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 0; 
            background-color: #f5f5f5; 
        }
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            padding: 1rem 2rem; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
        }
        .header h1 { margin: 0; }
        .user-info { display: flex; align-items: center; gap: 15px; }
        .logout-btn { 
            background: rgba(255,255,255,0.2); 
            color: white; 
            padding: 8px 16px; 
            border: none; 
            border-radius: 6px; 
            text-decoration: none; 
        }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }
        .cart-item { 
            background: white; 
            padding: 20px; 
            margin-bottom: 15px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
        }
        .product-info { flex: 1; }
        .quantity-controls { display: flex; align-items: center; gap: 10px; }
        .quantity-input { width: 80px; text-align: center; }
        .total-section { 
            background: white; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
            margin-top: 20px; 
        }
        .checkout-btn { 
            background: #28a745; 
            color: white; 
            padding: 15px 30px; 
            border: none; 
            border-radius: 8px; 
            font-size: 18px; 
            width: 100%; 
            cursor: pointer; 
        }
        .checkout-btn:hover { background: #218838; }
        .empty-cart { text-align: center; padding: 50px; }
        .out-of-stock { opacity: 0.6; background-color: #f8f9fa; }
        .out-of-stock-text { color: #dc3545; font-weight: bold; }
        .stock-warning { color: #ffc107; font-weight: bold; }
        .alert { 
            padding: 15px; 
            margin-bottom: 20px; 
            border: 1px solid transparent; 
            border-radius: 4px; 
        }
        .alert-danger { 
            color: #721c24; 
            background-color: #f8d7da; 
            border-color: #f5c6cb; 
        }
    </style>
</head>
<body>
<div class="header">
    <h1>🛒 Giỏ hàng của bạn</h1>
    <div class="user-info">
        <span>Xin chào, ${sessionScope.loggedInUser.name}!</span>
        <a href="products" class="logout-btn">🛍️ Tiếp tục mua hàng</a>
        <a href="dashboard" class="logout-btn">🏠 Dashboard</a>
        <a href="logout" class="logout-btn">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <h2>Giỏ hàng của bạn</h2>
    
    <c:choose>
        <c:when test="${empty cart}">
            <div class="empty-cart">
                <h3>Giỏ hàng trống</h3>
                <p>Bạn chưa có sản phẩm nào trong giỏ hàng.</p>
                <a href="products" class="btn btn-primary">Tiếp tục mua hàng</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:if test="${not empty error}">
                <div class="alert alert-danger" role="alert">
                    ${error}
                </div>
            </c:if>
            
            <c:forEach var="item" items="${cart}">
                <div class="cart-item ${(item.product.status == 'OUT_OF_STOCK' || item.product.stock == 0) ? 'out-of-stock' : ''}">
                    <div class="product-info">
                        <h4>${item.product.name}</h4>
                        <p>Giá: <fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫"/></p>
                        <p>Có sẵn: ${item.product.stock} sản phẩm</p>
                        <c:if test="${item.product.status == 'OUT_OF_STOCK' || item.product.stock == 0}">
                            <p class="out-of-stock-text">❌ Sản phẩm hiện đã hết hàng</p>
                        </c:if>
                        <c:if test="${item.quantity > item.product.stock}">
                            <p class="stock-warning">⚠️ Số lượng trong giỏ hàng vượt quá tồn kho</p>
                        </c:if>
                    </div>
                    
                    <div class="quantity-controls">
                        <form action="cart" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="cartId" value="${item.id}">
                            <input type="number" name="quantity" value="${item.quantity}" 
                                   min="1" max="${item.product.stock}" class="form-control quantity-input"
                                   ${(item.product.status == 'OUT_OF_STOCK' || item.product.stock == 0) ? 'disabled' : ''}>
                            <button type="submit" class="btn btn-sm btn-primary" 
                                    ${(item.product.status == 'OUT_OF_STOCK' || item.product.stock == 0) ? 'disabled' : ''}>Cập nhật</button>
                        </form>
                        
                        <form action="cart" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="cartId" value="${item.id}">
                            <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                        </form>
                    </div>
                    
                    <div class="item-total">
                        <strong>
                            <fmt:formatNumber value="${item.product.price * item.quantity}" 
                                            type="currency" currencySymbol="₫"/>
                        </strong>
                    </div>
                </div>
            </c:forEach>
            
            <div class="total-section">
                <h3>Tổng cộng</h3>
                <c:set var="totalPrice" value="0" />
                <c:forEach var="item" items="${cart}">
                    <c:set var="totalPrice" value="${totalPrice + (item.product.price * item.quantity)}" />
                </c:forEach>
                
                <table class="table">
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Tổng</th>
                    </tr>
                    <c:forEach var="item" items="${cart}">
                        <tr>
                            <td>${item.product.name}</td>
                            <td><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫"/></td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol="₫"/></td>
                        </tr>
                    </c:forEach>
                </table>
                
                <h4>Tổng tiền: <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫"/></h4>
                
                <form action="checkout" method="post">
                    <button type="submit" class="checkout-btn">Tiến hành thanh toán</button>
                </form>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>