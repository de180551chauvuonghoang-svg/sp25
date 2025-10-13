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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css" rel="stylesheet">
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
        
        /* Coupon Styles */
        .coupon-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .available-coupons {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border: 1px solid #e9ecef;
        }
        
        .coupon-item {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 8px 12px;
            margin: 5px 0;
            border-radius: 20px;
            font-size: 12px;
            display: inline-block;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .coupon-item:hover {
            transform: scale(1.05);
        }
        
        .price-summary {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-top: 20px;
        }
        
        .checkout-btn {
            width: 100%;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 15px;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            margin-top: 20px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .checkout-btn:hover {
            transform: translateY(-2px);
        }
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
        
        .payment-method-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        .payment-method-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
        }
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
                
                <!-- Coupon Section -->
                <div class="coupon-section mt-4 mb-4">
                    <div class="row">
                        <div class="col-md-8">
                            <div class="input-group">
                                <input type="text" id="couponCode" class="form-control" 
                                       placeholder="Nhập mã giảm giá" maxlength="20">
                                <button class="btn btn-outline-secondary" type="button" 
                                        id="applyCouponBtn" onclick="applyCoupon()">
                                    <i class="bi bi-check-circle"></i> Áp dụng
                                </button>
                                <button class="btn btn-outline-danger" type="button" 
                                        id="removeCouponBtn" onclick="removeCoupon()" style="display: none;">
                                    <i class="bi bi-x-circle"></i> Bỏ mã
                                </button>
                            </div>
                            <div id="couponMessage" class="mt-2"></div>
                        </div>
                        <div class="col-md-4">
                            <div id="availableCoupons" class="available-coupons">
                                <small class="text-muted">Mã giảm giá khả dụng:</small>
                                <div id="couponList" class="mt-1"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Price Summary -->
                <div class="price-summary">
                    <div class="d-flex justify-content-between">
                        <span>Tạm tính:</span>
                        <span id="subtotal"><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫"/></span>
                    </div>
                    <div class="d-flex justify-content-between" id="discountRow" style="display: none;">
                        <span>Giảm giá (<span id="couponName"></span>):</span>
                        <span id="discountAmount" class="text-success">-₫0</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between">
                        <h4>Tổng tiền:</h4>
                        <h4 id="finalTotal"><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫"/></h4>
                    </div>
                </div>
                
                <!-- Lựa chọn phương thức thanh toán -->
                <div class="payment-method-card">
                    <h4 style="margin-bottom: 15px; color: #333; text-align: center;">
                        <i class="bi bi-credit-card"></i> Chọn phương thức thanh toán
                    </h4>
                    
                    <!-- Thanh toán COD -->
                    <form action="checkout" method="post" style="margin-bottom: 15px;">
                        <input type="hidden" name="paymentMethod" value="cod">
                        <input type="hidden" name="finalAmount" value="${totalPrice}">
                        <button type="submit" class="checkout-btn" style="background: linear-gradient(135deg, #28a745, #20c997); width: 100%; margin-bottom: 10px;">
                            <i class="bi bi-cash-coin"></i> Thanh toán khi nhận hàng (COD)
                        </button>
                    </form>
                    
                    <!-- Thanh toán VietQR -->
                    <form action="checkout" method="post">
                        <input type="hidden" name="paymentMethod" value="vietqr">
                        <input type="hidden" name="finalAmount" value="${totalPrice}">
                        <button type="submit" class="checkout-btn" style="background: linear-gradient(135deg, #667eea, #764ba2); width: 100%;">
                            <i class="bi bi-qr-code"></i> Thanh toán VietQR (Quét mã QR)
                        </button>
                    </form>
                    
                    <div style="margin-top: 15px; padding: 15px; background: linear-gradient(135deg, #f8f9fa, #e9ecef); border-radius: 8px; font-size: 14px; color: #666;">
                        <strong>💡 Hướng dẫn:</strong><br>
                        • <strong>COD:</strong> Thanh toán bằng tiền mặt khi nhận hàng<br>
                        • <strong>VietQR:</strong> Quét mã QR bằng app ngân hàng để thanh toán ngay
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
let originalTotal = parseFloat('${totalPrice}');
let currentDiscount = 0;
let appliedCoupon = null;

// Load available coupons when page loads
document.addEventListener('DOMContentLoaded', function() {
    loadAvailableCoupons();
});

function loadAvailableCoupons() {
    fetch('coupon?action=getAvailable', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            displayAvailableCoupons(data.coupons);
        }
    })
    .catch(error => {
        console.error('Error loading coupons:', error);
    });
}

function displayAvailableCoupons(coupons) {
    const couponList = document.getElementById('couponList');
    couponList.innerHTML = '';
    
    if (coupons && coupons.length > 0) {
        coupons.forEach(coupon => {
            const couponItem = document.createElement('span');
            couponItem.className = 'coupon-item';
            
            // Simple display - just show discount value
            let discountText = '';
            if (coupon.discountType === 'PERCENTAGE') {
                discountText = coupon.discountValue + '%';
            } else {
                discountText = new Intl.NumberFormat('vi-VN').format(coupon.discountValue) + ' VNĐ';
            }
            
            couponItem.textContent = coupon.code + ' (-' + discountText + ')';
            couponItem.onclick = () => {
                document.getElementById('couponCode').value = coupon.code;
                applyCoupon();
            };
            couponList.appendChild(couponItem);
        });
    } else {
        couponList.innerHTML = '<small class="text-muted">Không có mã giảm giá khả dụng</small>';
    }
}

function applyCoupon() {
    const couponCode = document.getElementById('couponCode').value.trim();
    if (!couponCode) {
        showCouponMessage('Vui lòng nhập mã giảm giá', 'danger');
        return;
    }

    // Show loading
    document.getElementById('applyCouponBtn').disabled = true;
    document.getElementById('applyCouponBtn').innerHTML = '<i class="spinner-border spinner-border-sm"></i> Đang xử lý...';

    // Format order amount as VND (round to whole number, no decimals)
    const formattedOrderAmount = Math.round(originalTotal);

    fetch('coupon?action=validate', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'couponCode=' + encodeURIComponent(couponCode) + '&orderAmount=' + formattedOrderAmount
    })
    .then(response => response.json())
    .then(data => {
        console.log('Coupon validation response:', data); // Debug log
        if (data.valid) {
            appliedCoupon = data.coupon || { code: couponCode };
            currentDiscount = Math.round(parseFloat(data.discountAmount) || 0); // Round to VND
            updatePriceDisplay();
            showCouponMessage(data.message || 'Mã giảm giá đã được áp dụng!', 'success');
            
            // Update UI
            document.getElementById('applyCouponBtn').style.display = 'none';
            document.getElementById('removeCouponBtn').style.display = 'inline-block';
            document.getElementById('couponCode').disabled = true;
            
            // Update hidden fields with VND format (no decimals)
            document.getElementById('appliedCouponCode').value = couponCode;
            document.getElementById('finalAmount').value = Math.round(originalTotal - currentDiscount);
        } else {
            showCouponMessage(data.message || 'Mã giảm giá không hợp lệ', 'danger');
        }
    })
    .catch(error => {
        console.error('Error applying coupon:', error);
        showCouponMessage('Có lỗi xảy ra khi áp dụng mã giảm giá', 'danger');
    })
    .finally(() => {
        // Reset button
        document.getElementById('applyCouponBtn').disabled = false;
        document.getElementById('applyCouponBtn').innerHTML = '<i class="bi bi-check-circle"></i> Áp dụng';
    });
}

function removeCoupon() {
    appliedCoupon = null;
    currentDiscount = 0;
    updatePriceDisplay();
    
    // Reset UI
    document.getElementById('couponCode').value = '';
    document.getElementById('couponCode').disabled = false;
    document.getElementById('applyCouponBtn').style.display = 'inline-block';
    document.getElementById('removeCouponBtn').style.display = 'none';
    document.getElementById('couponMessage').innerHTML = '';
    
    // Update hidden fields with VND format (no decimals)
    document.getElementById('appliedCouponCode').value = '';
    document.getElementById('finalAmount').value = Math.round(originalTotal);
}

function updatePriceDisplay() {
    const discountRow = document.getElementById('discountRow');
    const couponName = document.getElementById('couponName');
    const discountAmount = document.getElementById('discountAmount');
    const finalTotal = document.getElementById('finalTotal');
    
    if (currentDiscount > 0) {
        discountRow.style.display = 'flex';
        couponName.textContent = appliedCoupon.code;
        
        // Format discount amount as VND (no decimals)
        const formattedDiscount = new Intl.NumberFormat('vi-VN').format(Math.round(currentDiscount)) + ' VNĐ';
        discountAmount.textContent = '-' + formattedDiscount;
        
        // Format final total as VND (no decimals)
        const finalAmount = Math.round(originalTotal - currentDiscount);
        const formattedFinal = new Intl.NumberFormat('vi-VN').format(finalAmount) + ' VNĐ';
        finalTotal.textContent = formattedFinal;
    } else {
        discountRow.style.display = 'none';
        
        // Format original total as VND (no decimals)
        const formattedOriginal = new Intl.NumberFormat('vi-VN').format(Math.round(originalTotal)) + ' VNĐ';
        finalTotal.textContent = formattedOriginal;
    }
}

function showCouponMessage(message, type) {
    const messageDiv = document.getElementById('couponMessage');
    messageDiv.innerHTML = '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
                          message +
                          '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>' +
                          '</div>';
}

// Handle Enter key in coupon input
document.getElementById('couponCode').addEventListener('keypress', function(e) {
    if (e.key === 'Enter') {
        applyCoupon();
    }
});
</script>
</body>
</html>