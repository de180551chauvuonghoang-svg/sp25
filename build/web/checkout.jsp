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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
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
        .container { max-width: 1000px; margin: 2rem auto; padding: 0 2rem; }
        .checkout-section { 
            background: white; 
            padding: 30px; 
            border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.1); 
            margin-bottom: 20px; 
        }
        .order-summary { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 8px; 
            border: 1px solid #e9ecef;
        }
        .total-amount { 
            font-size: 1.5rem; 
            font-weight: bold; 
            text-align: right; 
            margin-top: 20px; 
            padding-top: 20px; 
            border-top: 2px solid #dee2e6; 
        }
        .checkout-btn { 
            background: linear-gradient(135deg, #28a745, #20c997); 
            color: white; 
            padding: 15px 30px; 
            border: none; 
            border-radius: 8px; 
            font-size: 1.1rem; 
            font-weight: bold; 
            width: 100%; 
            transition: all 0.3s ease;
        }
        .checkout-btn:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4); 
        }
        .back-btn { 
            background: #6c757d; 
            color: white; 
            padding: 12px 24px; 
            border: none; 
            border-radius: 8px; 
            text-decoration: none; 
            transition: all 0.3s ease;
        }
        .back-btn:hover { 
            background: #5a6268; 
            color: white; 
            transform: translateY(-2px); 
        }
        .error-message { 
            background: #f8d7da; 
            color: #721c24; 
            padding: 15px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
            border: 1px solid #f5c6cb;
        }
        .success-message { 
            background: #d4edda; 
            color: #155724; 
            padding: 15px; 
            border-radius: 8px; 
            margin-bottom: 20px; 
            border: 1px solid #c3e6cb;
        }
        
        /* Coupon Styles */
        .coupon-section {
            background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
        }
        .coupon-input-group {
            position: relative;
            margin-bottom: 15px;
        }
        .coupon-input {
            border-radius: 8px;
            border: 2px solid #e17055;
            padding: 12px 120px 12px 15px;
            font-size: 1rem;
            width: 100%;
        }
        .coupon-apply-btn {
            position: absolute;
            right: 5px;
            top: 5px;
            bottom: 5px;
            background: #e17055;
            color: white;
            border: none;
            border-radius: 6px;
            padding: 0 20px;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .coupon-apply-btn:hover {
            background: #d63031;
        }
        .coupon-list {
            max-height: 200px;
            overflow-y: auto;
        }
        .coupon-item {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 10px;
            border-left: 4px solid #00b894;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .coupon-item:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .coupon-code {
            font-weight: bold;
            color: #e17055;
            font-size: 1.1rem;
        }
        .coupon-description {
            color: #636e72;
            font-size: 0.9rem;
            margin-top: 5px;
        }
        .discount-info {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }
        .price-breakdown {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }
        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .price-row:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 1.2rem;
            color: #28a745;
        }
        .discount-row {
            color: #dc3545;
        }
        
        .loading {
            display: none;
        }
        .loading.show {
            display: inline-block;
        }
        
        @media (max-width: 768px) {
            .container { padding: 0 1rem; }
            .checkout-section { padding: 20px; }
            .row.checkout-actions { flex-direction: column; }
            .row.checkout-actions > div { margin-bottom: 10px; }
        }
    </style>
</head>
<body>

<div class="header">
    <h1><i class="bi bi-credit-card"></i> Thanh toán</h1>
    <div class="user-info">
        <span>Xin chào, ${sessionScope.loggedInUser.name}!</span>
        <a href="productList" class="logout-btn"><i class="bi bi-shop"></i> Tiếp tục mua hàng</a>
        <a href="dashboard" class="logout-btn"><i class="bi bi-speedometer2"></i> Dashboard</a>
        <a href="login" class="logout-btn">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <div class="row mb-3">
        <div class="col">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="productList">Sản phẩm</a></li>
                    <li class="breadcrumb-item"><a href="cart">Giỏ hàng</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Thanh toán</li>
                </ol>
            </nav>
        </div>
    </div>
    
    <h2><i class="bi bi-check-circle"></i> Xác nhận đơn hàng</h2>
    
    <c:if test="${not empty error}">
        <div class="error-message">
            <i class="bi bi-exclamation-triangle"></i> <strong>Lỗi:</strong> ${error}
        </div>
    </c:if>
    
    <c:if test="${not empty success}">
        <div class="success-message">
            <i class="bi bi-check-circle"></i> <strong>Thành công:</strong> ${success}
        </div>
    </c:if>

    <div class="row">
        <div class="col-lg-8">
            <!-- Thông tin khách hàng -->
            <div class="checkout-section">
                <h3><i class="bi bi-person-circle"></i> Thông tin khách hàng</h3>
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

            <!-- Chi tiết đơn hàng -->
            <div class="checkout-section">
                <h3><i class="bi bi-cart-check"></i> Chi tiết đơn hàng</h3>
                <div class="order-summary">
                    <table class="table table-striped">
                        <thead class="table-dark">
                            <tr>
                                <th><i class="bi bi-box"></i> Sản phẩm</th>
                                <th><i class="bi bi-currency-dollar"></i> Giá</th>
                                <th><i class="bi bi-hash"></i> Số lượng</th>
                                <th><i class="bi bi-calculator"></i> Tổng</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${cart}">
                                <tr>
                                    <td>
                                        <strong>${item.product.name}</strong><br>
                                        <small class="text-muted">${item.product.description}</small>
                                    </td>
                                    <td><fmt:formatNumber value="${item.product.price}" type="currency" currencySymbol="₫"/></td>
                                    <td>
                                        <span class="badge bg-primary">${item.quantity}</span>
                                    </td>
                                    <td>
                                        <strong><fmt:formatNumber value="${item.product.price * item.quantity}" type="currency" currencySymbol="₫"/></strong>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Phương thức thanh toán -->
            <div class="checkout-section">
                <h3><i class="bi bi-credit-card"></i> Phương thức thanh toán</h3>
                <div class="form-check mb-3">
                    <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="cod" checked>
                    <label class="form-check-label" for="cod">
                        <i class="bi bi-cash-coin"></i> <strong>Thanh toán khi nhận hàng (COD)</strong>
                        <br><small class="text-muted">Thanh toán bằng tiền mặt khi nhận được hàng</small>
                    </label>
                </div>
                <div class="form-check mb-3">
                    <input class="form-check-input" type="radio" name="paymentMethod" id="bank" value="bank">
                    <label class="form-check-label" for="bank">
                        <i class="bi bi-bank"></i> <strong>Chuyển khoản ngân hàng</strong>
                        <br><small class="text-muted">Chuyển khoản qua tài khoản ngân hàng</small>
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" id="card" value="card">
                    <label class="form-check-label" for="card">
                        <i class="bi bi-credit-card-2-front"></i> <strong>Thẻ tín dụng/ghi nợ</strong>
                        <br><small class="text-muted">Thanh toán bằng thẻ Visa, MasterCard</small>
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" id="vietqr" value="vietqr">
                    <label class="form-check-label" for="vietqr">
                        <i class="bi bi-qr-code"></i> <strong>VietQR - Thanh toán nhanh</strong>
                        <br><small class="text-muted">Quét mã QR để thanh toán qua ứng dụng ngân hàng</small>
                    </label>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <!-- Mã giảm giá -->
            <div class="coupon-section">
                <h4><i class="bi bi-ticket-perforated"></i> Mã giảm giá</h4>
                <div class="coupon-input-group">
                    <input type="text" id="couponCode" class="coupon-input" placeholder="Nhập mã giảm giá..." maxlength="50">
                    <button type="button" id="applyCouponBtn" class="coupon-apply-btn">
                        <span class="btn-text">Áp dụng</span>
                        <span class="loading"><i class="bi bi-arrow-repeat spin"></i></span>
                    </button>
                </div>
                
                <div id="couponMessage" class="mt-2"></div>
                
                <!-- Hiển thị coupon có sẵn -->
                <c:if test="${not empty availableCoupons}">
                    <div class="mt-3">
                        <h6><i class="bi bi-gift"></i> Mã giảm giá có sẵn:</h6>
                        <div class="coupon-list">
                            <c:forEach var="coupon" items="${availableCoupons}">
                                <div class="coupon-item" onclick="applyCouponCode('${coupon.code}')">
                                    <div class="coupon-code">${coupon.code}</div>
                                    <div class="coupon-description">
                                        ${coupon.description}
                                        <c:choose>
                                            <c:when test="${coupon.discountType == 'percentage'}">
                                                - Giảm ${coupon.discountValue}%
                                            </c:when>
                                            <c:otherwise>
                                                - Giảm <fmt:formatNumber value="${coupon.discountValue}" type="currency" currencySymbol="₫"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Tóm tắt thanh toán -->
            <div class="checkout-section">
                <h4><i class="bi bi-receipt"></i> Tóm tắt thanh toán</h4>
                <div class="price-breakdown">
                    <div class="price-row">
                        <span>Tạm tính:</span>
                        <span id="originalTotal"><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫"/></span>
                    </div>
                    <div id="discountRow" class="price-row discount-row" style="display: none;">
                        <span>Giảm giá:</span>
                        <span id="discountAmount">0₫</span>
                    </div>
                    <div class="price-row">
                        <span>Phí vận chuyển:</span>
                        <span>Miễn phí</span>
                    </div>
                    <div class="price-row">
                        <span><strong>Tổng cộng:</strong></span>
                        <span id="finalTotal"><strong><fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫"/></strong></span>
                    </div>
                </div>
            </div>

            <!-- Nút thanh toán -->
            <div class="checkout-section">
                <div class="row checkout-actions">
                    <div class="col-12 mb-2">
                        <a href="cart" class="back-btn d-block text-center">
                            <i class="bi bi-arrow-left"></i> Quay lại giỏ hàng
                        </a>
                    </div>
                    <div class="col-12">
                        <form id="checkoutForm" action="checkout" method="post">
                            <input type="hidden" id="appliedCouponCode" name="couponCode" value="">
                            <input type="hidden" id="finalAmount" name="finalAmount" value="${totalPrice}">
                            <input type="hidden" id="selectedPaymentMethod" name="paymentMethod" value="cod">
                            <button type="submit" class="checkout-btn" onclick="return confirmCheckout()">
                                <i class="bi bi-check-circle"></i> Xác nhận đặt hàng
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let originalTotal = parseFloat(${totalPrice});
    let currentDiscount = 0;
    let appliedCoupon = '';

    // Áp dụng mã coupon
    document.getElementById('applyCouponBtn').addEventListener('click', function() {
        applyCoupon();
    });

    // Enter key trong input
    document.getElementById('couponCode').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            applyCoupon();
        }
    });

    function applyCouponCode(code) {
        document.getElementById('couponCode').value = code;
        applyCoupon();
    }

    function applyCoupon() {
        const couponCode = document.getElementById('couponCode').value.trim();
        const btn = document.getElementById('applyCouponBtn');
        const btnText = btn.querySelector('.btn-text');
        const loading = btn.querySelector('.loading');
        const messageDiv = document.getElementById('couponMessage');

        if (!couponCode) {
            showMessage('Vui lòng nhập mã giảm giá', 'error');
            return;
        }

        // Show loading
        btnText.style.display = 'none';
        loading.classList.add('show');
        btn.disabled = true;

        // AJAX call to validate coupon
        fetch('coupon', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=validate&couponCode=' + encodeURIComponent(couponCode) + '&orderAmount=' + originalTotal
        })
        .then(response => response.json())
        .then(data => {
            if (data.valid) {
                applyDiscountToUI(data.discountAmount, couponCode);
                showMessage('Áp dụng mã giảm giá thành công!', 'success');
                appliedCoupon = couponCode;
                
                // Update hidden form fields
                document.getElementById('appliedCouponCode').value = couponCode;
                document.getElementById('finalAmount').value = originalTotal - data.discountAmount;
            } else {
                showMessage(data.message, 'error');
                resetDiscount();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Có lỗi xảy ra khi kiểm tra mã giảm giá', 'error');
            resetDiscount();
        })
        .finally(() => {
            // Hide loading
            btnText.style.display = 'inline';
            loading.classList.remove('show');
            btn.disabled = false;
        });
    }

    function applyDiscountToUI(discountAmount, couponCode) {
        currentDiscount = discountAmount;
        const finalTotal = originalTotal - discountAmount;

        // Update discount row
        document.getElementById('discountRow').style.display = 'flex';
        document.getElementById('discountAmount').textContent = '-' + formatCurrency(discountAmount);

        // Update final total
        document.getElementById('finalTotal').innerHTML = '<strong>' + formatCurrency(finalTotal) + '</strong>';

        // Add success styling to input
        document.getElementById('couponCode').style.borderColor = '#28a745';
        document.getElementById('couponCode').style.backgroundColor = '#d4edda';
    }

    function resetDiscount() {
        currentDiscount = 0;
        appliedCoupon = '';

        // Hide discount row
        document.getElementById('discountRow').style.display = 'none';

        // Reset final total
        document.getElementById('finalTotal').innerHTML = '<strong>' + formatCurrency(originalTotal) + '</strong>';

        // Reset input styling
        document.getElementById('couponCode').style.borderColor = '#e17055';
        document.getElementById('couponCode').style.backgroundColor = 'white';

        // Clear form fields
        document.getElementById('appliedCouponCode').value = '';
        document.getElementById('finalAmount').value = originalTotal;
    }

    function showMessage(message, type) {
        const messageDiv = document.getElementById('couponMessage');
        messageDiv.innerHTML = '<div class="alert alert-' + (type === 'error' ? 'danger' : 'success') + ' py-2 px-3 small">' +
                               '<i class="bi bi-' + (type === 'error' ? 'exclamation-triangle' : 'check-circle') + '"></i> ' + 
                               message + '</div>';
        
        // Auto-hide success messages
        if (type === 'success') {
            setTimeout(() => {
                messageDiv.innerHTML = '';
            }, 3000);
        }
    }

    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    }

    function confirmCheckout() {
        let message = 'Bạn có chắc chắn muốn đặt hàng?\\n\\n';
        message += 'Tổng tiền: ' + formatCurrency(originalTotal);
        
        if (currentDiscount > 0) {
            message += '\\nMã giảm giá: ' + appliedCoupon;
            message += '\\nGiảm giá: ' + formatCurrency(currentDiscount);
            message += '\\nThành tiền: ' + formatCurrency(originalTotal - currentDiscount);
        }

        return confirm(message);
    }

    // Xóa mã giảm giá khi thay đổi input
    document.getElementById('couponCode').addEventListener('input', function() {
        if (appliedCoupon && this.value !== appliedCoupon) {
            resetDiscount();
            document.getElementById('couponMessage').innerHTML = '';
        }
    });

    // Xử lý thay đổi phương thức thanh toán
    document.querySelectorAll('input[name="paymentMethod"]').forEach(function(radio) {
        radio.addEventListener('change', function() {
            document.getElementById('selectedPaymentMethod').value = this.value;
            
            // Cập nhật text nút submit dựa trên phương thức thanh toán
            const submitBtn = document.querySelector('.checkout-btn');
            const btnIcon = submitBtn.querySelector('i');
            const btnText = submitBtn.childNodes[submitBtn.childNodes.length - 1];
            
            if (this.value === 'vietqr') {
                btnIcon.className = 'bi bi-qr-code';
                btnText.textContent = ' Thanh toán VietQR';
            } else {
                btnIcon.className = 'bi bi-check-circle';
                btnText.textContent = ' Xác nhận đặt hàng';
            }
        });
    });

    // CSS for loading animation
    const style = document.createElement('style');
    style.textContent = `
        .spin {
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
    `;
    document.head.appendChild(style);
</script>

</body>
</html>