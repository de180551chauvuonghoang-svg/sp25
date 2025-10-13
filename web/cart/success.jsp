<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("../login");
        return;
    }
%>
<html>
<head>
    <title>Đặt hàng thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 0; 
            background-color: #f5f5f5; 
        }
        .header { 
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%); 
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
        .success-section { 
            background: white; 
            padding: 50px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
            text-align: center; 
        }
        .success-icon { 
            font-size: 80px; 
            color: #28a745; 
            margin-bottom: 20px; 
        }
        .order-id { 
            font-size: 24px; 
            font-weight: bold; 
            color: #495057; 
            margin: 20px 0; 
        }
        .action-buttons { 
            margin-top: 30px; 
            display: flex; 
            gap: 15px; 
            justify-content: center; 
        }
        .btn-primary { 
            background: #007bff; 
            border: none; 
            padding: 12px 24px; 
            border-radius: 6px; 
            color: white; 
            text-decoration: none; 
        }
        .btn-success { 
            background: #28a745; 
            border: none; 
            padding: 12px 24px; 
            border-radius: 6px; 
            color: white; 
            text-decoration: none; 
        }
        .btn-secondary { 
            background: #6c757d; 
            border: none; 
            padding: 12px 24px; 
            border-radius: 6px; 
            color: white; 
            text-decoration: none; 
        }
    </style>
</head>
<body>
<div class="header">
    <h1>✅ Đặt hàng thành công!</h1>
    <div class="user-info">
        <span>Cảm ơn bạn đã mua sắm!</span>
        <a href="../logout" class="logout-btn">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <div class="success-section">
        <div class="success-icon">✅</div>
        <h2>Đơn hàng của bạn đã được ghi nhận!</h2>
        <p>Cảm ơn bạn đã đặt hàng tại cửa hàng của chúng tôi.</p>
        
        <div class="order-id">
            Mã đơn hàng: #${param.orderId}
        </div>
        
        <!-- Hiển thị thông tin thanh toán -->
        <c:if test="${not empty sessionScope.checkoutTotalPrice}">
            <div class="payment-summary" style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: left;">
                <h5 style="margin-top: 0; color: #495057;">💰 Chi tiết thanh toán</h5>
                <div class="d-flex justify-content-between">
                    <span>Tạm tính:</span>
                    <span><fmt:formatNumber value="${sessionScope.checkoutTotalPrice}" type="currency" currencySymbol="₫"/></span>
                </div>
                
                <c:if test="${not empty sessionScope.appliedCoupon and sessionScope.checkoutDiscountAmount > 0}">
                    <div class="d-flex justify-content-between text-success">
                        <span>Giảm giá (${sessionScope.appliedCoupon}):</span>
                        <span>-<fmt:formatNumber value="${sessionScope.checkoutDiscountAmount}" type="currency" currencySymbol="₫"/></span>
                    </div>
                </c:if>
                
                <hr>
                <div class="d-flex justify-content-between">
                    <strong>Tổng cộng:</strong>
                    <strong><fmt:formatNumber value="${sessionScope.checkoutFinalPrice}" type="currency" currencySymbol="₫"/></strong>
                </div>
                
                <!-- Hiển thị phương thức thanh toán -->
                <c:if test="${not empty sessionScope.paymentMethod}">
                    <div class="d-flex justify-content-between mt-2">
                        <span>Phương thức thanh toán:</span>
                        <span class="badge bg-success">
                            <c:choose>
                                <c:when test="${sessionScope.paymentMethod == 'VietQR'}">
                                    <i class="bi bi-qr-code"></i> VietQR - Đã thanh toán
                                </c:when>
                                <c:when test="${sessionScope.paymentMethod == 'vietqr'}">
                                    <i class="bi bi-qr-code"></i> VietQR - Đã thanh toán
                                </c:when>
                                <c:when test="${sessionScope.paymentMethod == 'cod'}">
                                    <i class="bi bi-cash-coin"></i> COD - Thanh toán khi nhận hàng
                                </c:when>
                                <c:when test="${sessionScope.paymentMethod == 'bank'}">
                                    <i class="bi bi-bank"></i> Chuyển khoản ngân hàng
                                </c:when>
                                <c:when test="${sessionScope.paymentMethod == 'card'}">
                                    <i class="bi bi-credit-card"></i> Thẻ tín dụng
                                </c:when>
                                <c:otherwise>
                                    ${sessionScope.paymentMethod}
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </c:if>
                
                <!-- Debug: hiển thị giá trị paymentMethod để kiểm tra -->
                <!-- PaymentMethod Debug: [${sessionScope.paymentMethod}] -->
                <c:if test="${empty sessionScope.paymentMethod}">
                    <div class="d-flex justify-content-between mt-2 text-muted">
                        <span>Phương thức thanh toán:</span>
                        <span><i class="bi bi-cash-coin"></i> COD (mặc định)</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty sessionScope.appliedCoupon and sessionScope.checkoutDiscountAmount > 0}">
                    <div class="mt-2">
                        <small class="text-success">
                            🎉 Bạn đã tiết kiệm được <fmt:formatNumber value="${sessionScope.checkoutDiscountAmount}" type="currency" currencySymbol="₫"/> với mã giảm giá!
                        </small>
                    </div>
                </c:if>
            </div>
        </c:if>
        
        <p>Chúng tôi sẽ xử lý đơn hàng của bạn trong thời gian sớm nhất và thông báo cho bạn về trạng thái giao hàng.</p>
        
        <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; margin: 20px 0;">
            <h4 style="color: #0066cc; margin-top: 0;">📧 Email xác nhận</h4>
            <p style="margin-bottom: 0;">Chúng tôi đã gửi email xác nhận đơn hàng đến địa chỉ email của bạn. Vui lòng kiểm tra hộp thư để xem chi tiết đơn hàng.</p>
        </div>
        
        <!-- Debug Info (thêm ?debug=true vào URL để xem) -->
        <c:if test="${param.debug == 'true'}">
            <div style="background: #fff3cd; padding: 15px; border-radius: 8px; margin: 20px 0; border: 1px solid #ffeaa7;">
                <h5>🔧 Debug Session Info:</h5>
                <p><strong>PaymentMethod:</strong> [${sessionScope.paymentMethod}]</p>
                <p><strong>CheckoutOrderId:</strong> [${sessionScope.checkoutOrderId}]</p>
                <p><strong>CheckoutFinalPrice:</strong> [${sessionScope.checkoutFinalPrice}]</p>
                <p><strong>PendingPayment:</strong> [${sessionScope.pendingPayment}]</p>
                <p><strong>URL Params:</strong> orderId=${param.orderId}, payment=${param.payment}</p>
            </div>
        </c:if>
        
        <div class="action-buttons">
            <a href="../products" class="btn-success">🛍️ Tiếp tục mua hàng</a>
            <a href="../orders" class="btn-primary">📋 Xem đơn hàng</a>
            <a href="../dashboard" class="btn-secondary">🏠 Về trang chủ</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>