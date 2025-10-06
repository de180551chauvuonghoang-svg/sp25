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
    <title>Thanh toán</title>
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
        .container { max-width: 800px; margin: 2rem auto; padding: 0 2rem; }
        .checkout-section { 
            background: white; 
            padding: 30px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
            margin-bottom: 20px; 
        }
        .order-summary { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
        }
        .total-amount { 
            font-size: 24px; 
            font-weight: bold; 
            color: #28a745; 
            text-align: center; 
            padding: 20px; 
            background: #e9ecef; 
            border-radius: 8px; 
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
        .back-btn { 
            background: #6c757d; 
            color: white; 
            padding: 10px 20px; 
            border: none; 
            border-radius: 8px; 
            text-decoration: none; 
            display: inline-block; 
        }
        .error-message { 
            background: #f8d7da; 
            color: #721c24; 
            padding: 15px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
        }
    </style>
</head>
<body>
<div class="header">
    <h1>💳 Thanh toán</h1>
    <div class="user-info">
        <span>Xin chào, ${sessionScope.loggedInUser.name}!</span>
        <a href="cart" class="logout-btn">🛒 Giỏ hàng</a>
        <a href="products" class="logout-btn">🛍️ Tiếp tục mua hàng</a>
        <a href="logout" class="logout-btn">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <h2>Xác nhận đơn hàng</h2>
    
    <c:if test="${not empty error}">
        <div class="error-message">
            <strong>Lỗi:</strong> ${error}
        </div>
    </c:if>
    
    <div class="checkout-section">
        <h3>Thông tin khách hàng</h3>
        <div class="row">
            <div class="col-md-6">
                <p><strong>Tên:</strong> ${sessionScope.loggedInUser.name}</p>
                <p><strong>Email:</strong> ${sessionScope.loggedInUser.email}</p>
            </div>
            <div class="col-md-6">
                <p><strong>Quốc gia:</strong> ${sessionScope.loggedInUser.country}</p>
                <p><strong>Ngày sinh:</strong> ${sessionScope.loggedInUser.dateofbirth}</p>
            </div>
        </div>
    </div>
    
    <div class="checkout-section">
        <h3>Chi tiết đơn hàng</h3>
        <div class="order-summary">
            <table class="table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                        <th>Tổng</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cart}">
                        <tr>
                            <td>${item.product.name}</td>
                            <td><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫"/></td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol="₫"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <div class="total-amount">
            Tổng thanh toán: <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫"/>
        </div>
    </div>
    
    <div class="checkout-section">
        <h3>Phương thức thanh toán</h3>
        <div class="form-check">
            <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="cod" checked>
            <label class="form-check-label" for="cod">
                💰 Thanh toán khi nhận hàng (COD)
            </label>
        </div>
        <div class="form-check">
            <input class="form-check-input" type="radio" name="paymentMethod" id="bank" value="bank">
            <label class="form-check-label" for="bank">
                🏦 Chuyển khoản ngân hàng
            </label>
        </div>
        <div class="form-check">
            <input class="form-check-input" type="radio" name="paymentMethod" id="card" value="card">
            <label class="form-check-label" for="card">
                💳 Thẻ tín dụng/ghi nợ
            </label>
        </div>
    </div>
    
    <div class="checkout-section">
        <div class="row">
            <div class="col-md-6">
                <a href="cart" class="back-btn">← Quay lại giỏ hàng</a>
            </div>
            <div class="col-md-6">
                <form action="checkout" method="post">
                    <button type="submit" class="checkout-btn" onclick="return confirm('Bạn có chắc chắn muốn đặt hàng?')">
                        ✅ Xác nhận đặt hàng
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>