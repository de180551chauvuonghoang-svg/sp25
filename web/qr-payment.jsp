<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login");
        return;
    }
    
    if (session.getAttribute("qrPaymentInfo") == null) {
        response.sendRedirect("checkout");
        return;
    }
%>
<html>
<head>
    <title>Thanh toán VietQR</title>
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
        .container { max-width: 800px; margin: 2rem auto; padding: 0 2rem; }
        .qr-payment-section { 
            background: white; 
            padding: 40px; 
            border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.1); 
            text-align: center;
            margin-bottom: 20px; 
        }
        .qr-code-container {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 12px;
            margin: 20px 0;
            display: inline-block;
        }
        .qr-code-img {
            max-width: 300px;
            width: 100%;
            height: auto;
            border: 3px solid #667eea;
            border-radius: 8px;
        }
        .payment-info {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: left;
        }
        .timer-container {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 15px;
            border-radius: 8px;
            margin: 20px 0;
        }
        .timer {
            font-size: 2rem;
            font-weight: bold;
            color: #d63031;
            margin: 10px 0;
        }
        .btn-back {
            background: #6c757d;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            margin: 10px;
        }
        .btn-back:hover {
            background: #5a6268;
            color: white;
        }
        .btn-refresh {
            background: #28a745;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            margin: 10px;
        }
        .btn-refresh:hover {
            background: #218838;
        }
        .instructions {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            text-align: left;
        }
        .status-pending {
            color: #856404;
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 10px 15px;
            border-radius: 6px;
            margin: 10px 0;
        }
        .status-expired {
            color: #721c24;
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px 15px;
            border-radius: 6px;
            margin: 10px 0;
        }
        @media (max-width: 768px) {
            .container { padding: 0 1rem; }
            .qr-payment-section { padding: 20px; }
            .qr-code-img { max-width: 250px; }
            .timer { font-size: 1.5rem; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <h1><i class="bi bi-qr-code"></i> Thanh toán VietQR</h1>
        <div class="user-info">
            <span>Xin chào, ${sessionScope.loggedInUser.name}</span>
            <a href="logout" class="logout-btn">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="productList">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="cart">Giỏ hàng</a></li>
                <li class="breadcrumb-item"><a href="checkout">Thanh toán</a></li>
                <li class="breadcrumb-item active" aria-current="page">VietQR</li>
            </ol>
        </nav>

        <div class="qr-payment-section">
            <h2><i class="bi bi-qr-code-scan"></i> Quét mã QR để thanh toán</h2>
            
            <!-- Timer countdown -->
            <div class="timer-container">
                <div class="d-flex align-items-center justify-content-center">
                    <i class="bi bi-clock me-2"></i>
                    <span>Mã QR có hiệu lực trong:</span>
                </div>
                <div class="timer" id="countdown">20:00</div>
                <small>Vui lòng hoàn tất thanh toán trước khi hết thời gian</small>
            </div>

            <!-- QR Code Display -->
            <div class="qr-code-container">
                <img src="${sessionScope.qrPaymentInfo.qrUrl}" 
                     alt="VietQR Code" 
                     class="qr-code-img" 
                     id="qrCodeImg"
                     onerror="handleQRError(this)"
                     onload="handleQRLoad()">
                     
                <div id="qrErrorMessage" style="display: none; color: red; margin-top: 10px;">
                    ❌ Không thể tải mã QR. 
                    <button onclick="retryLoadQR()" style="margin-left: 10px; padding: 5px 10px;">Thử lại</button>
                </div>
                
                <div id="qrUrlDisplay" style="margin-top: 10px; font-size: 12px; color: #666; word-break: break-all;">
                    <strong>QR URL:</strong><br>
<!--                    <a href="${sessionScope.qrPaymentInfo.qrUrl}" target="_blank" style="color: #667eea;">
                        ${sessionScope.qrPaymentInfo.qrUrl}
                    </a>-->
                </div>
            </div>

            <!-- Payment Status -->
            <div id="paymentStatus" class="status-pending">
                <i class="bi bi-clock-history"></i> Đang chờ thanh toán...
            </div>

            <!-- Payment Information -->
            <div class="payment-info">
                <h5><i class="bi bi-info-circle"></i> Thông tin thanh toán</h5>
                <div class="row">
                    <div class="col-sm-4"><strong>Số tiền:</strong></div>
                    <div class="col-sm-8">
                        <fmt:formatNumber value="${sessionScope.qrPaymentInfo.amount}" pattern="#,##0" /> VND
                        <c:if test="${sessionScope.qrPaymentInfo.originalAmount != sessionScope.qrPaymentInfo.amount}">
                            <br><small class="text-muted">
                                (Làm tròn từ <fmt:formatNumber value="${sessionScope.qrPaymentInfo.originalAmount}" pattern="#,##0.00" /> VND)
                            </small>
                        </c:if>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-4"><strong>Mã đơn hàng:</strong></div>
                    <div class="col-sm-8">${sessionScope.qrPaymentInfo.orderId}</div>
                </div>
                <div class="row">
                    <div class="col-sm-4"><strong>Người nhận:</strong></div>
                    <div class="col-sm-8">${sessionScope.qrPaymentInfo.accountName}</div>
                </div>
                <div class="row">
                    <div class="col-sm-4"><strong>Ngân hàng:</strong></div>
                    <div class="col-sm-8">MB Bank (${sessionScope.qrPaymentInfo.bankCode})</div>
                </div>
                <div class="row">
                    <div class="col-sm-4"><strong>Số tài khoản:</strong></div>
                    <div class="col-sm-8">${sessionScope.qrPaymentInfo.accountNumber}</div>
                </div>
                <div class="row">
                    <div class="col-sm-4"><strong>Nội dung:</strong></div>
                    <div class="col-sm-8">${sessionScope.qrPaymentInfo.description}</div>
                </div>
            </div>

            <!-- Instructions -->
            <div class="instructions">
                <h6><i class="bi bi-list-check"></i> Hướng dẫn thanh toán:</h6>
                <ol>
                    <li>Mở ứng dụng ngân hàng hoặc ví điện tử trên điện thoại</li>
                    <li>Chọn chức năng "Quét mã QR" hoặc "Chuyển tiền bằng QR"</li>
                    <li>Quét mã QR hiển thị ở trên</li>
                    <li>Kiểm tra thông tin và xác nhận thanh toán</li>
                    <li>Hoàn tất giao dịch trên ứng dụng ngân hàng</li>
                </ol>
                <div class="alert alert-warning small">
                    <i class="bi bi-exclamation-triangle"></i>
                    <strong>Lưu ý:</strong> Vui lòng không thay đổi số tiền và nội dung chuyển khoản để đảm bảo giao dịch được xử lý chính xác.
                </div>
            </div>

        <!-- Debug Info (thêm ?debug=true vào URL để xem) -->
        <c:if test="${param.debug == 'true'}">
            <div style="background: #fff3cd; padding: 15px; border-radius: 8px; margin: 20px 0; border: 1px solid #ffeaa7;">
                <h5>🔧 Debug QR Payment Info:</h5>
                <p><strong>Amount:</strong> [${sessionScope.qrPaymentInfo.amount}]</p>
                <p><strong>Original Amount:</strong> [${sessionScope.qrPaymentInfo.originalAmount}]</p>
                <p><strong>QR URL:</strong> [${sessionScope.qrPaymentInfo.qrUrl}]</p>
                <p><strong>OrderId:</strong> [${sessionScope.qrPaymentInfo.orderId}]</p>
                <p><strong>Description:</strong> [${sessionScope.qrPaymentInfo.description}]</p>
            </div>
        </c:if>
        
            <!-- Action Buttons -->
            <div class="d-flex justify-content-center flex-wrap">
                <a href="checkout" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
                <button type="button" class="btn-refresh" onclick="checkPaymentStatus()">
                    <i class="bi bi-arrow-clockwise"></i> Kiểm tra thanh toán
                </button>
                <form style="display: inline;" method="post" action="complete-payment" onsubmit="return confirmPayment()">
                    <button type="submit" class="btn-refresh" style="background: #007bff;">
                        <i class="bi bi-check-circle"></i> Đã thanh toán
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Thời gian hiệu lực của QR code (20 phút = 1200 giây)
        let remainingTime = ${sessionScope.qrPaymentInfo.remainingTimeMs} / 1000;
        let countdownTimer;
        let paymentCheckInterval;

        // Khởi tạo countdown
        function startCountdown() {
            countdownTimer = setInterval(function() {
                if (remainingTime <= 0) {
                    // Hết thời gian
                    clearInterval(countdownTimer);
                    document.getElementById('countdown').textContent = '00:00';
                    document.getElementById('paymentStatus').className = 'status-expired';
                    document.getElementById('paymentStatus').innerHTML = 
                        '<i class="bi bi-x-circle"></i> Mã QR đã hết hạn';
                    
                    // Vô hiệu hóa QR code
                    document.getElementById('qrCodeImg').style.opacity = '0.3';
                    document.getElementById('qrCodeImg').style.filter = 'grayscale(100%)';
                    
                    // Dừng kiểm tra thanh toán
                    if (paymentCheckInterval) {
                        clearInterval(paymentCheckInterval);
                    }
                    
                    // Hiển thị thông báo
                    alert('Mã QR đã hết hạn. Vui lòng quay lại trang thanh toán để tạo mã QR mới.');
                    return;
                }

                // Cập nhật hiển thị
                let minutes = Math.floor(remainingTime / 60);
                let seconds = remainingTime % 60;
                document.getElementById('countdown').textContent = 
                    String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
                
                remainingTime--;
            }, 1000);
        }

        // Kiểm tra trạng thái thanh toán
        function checkPaymentStatus() {
            // Trong thực tế, bạn sẽ gọi AJAX đến server để kiểm tra
            // Hiện tại chỉ hiển thị thông báo
            const statusDiv = document.getElementById('paymentStatus');
            statusDiv.innerHTML = '<i class="bi bi-arrow-repeat spin"></i> Đang kiểm tra...';
            
            setTimeout(function() {
                statusDiv.className = 'status-pending';
                statusDiv.innerHTML = '<i class="bi bi-clock-history"></i> Đang chờ thanh toán...';
            }, 2000);
        }

        // Kiểm tra thanh toán định kỳ (mỗi 30 giây)
        function startPaymentCheck() {
            paymentCheckInterval = setInterval(function() {
                if (remainingTime > 0) {
                    // Gọi API kiểm tra thanh toán ở đây
                    console.log('Kiểm tra trạng thái thanh toán...');
                }
            }, 30000);
        }

        // Xác nhận đã thanh toán
        function confirmPayment() {
            return confirm('Bạn có chắc chắn đã hoàn tất thanh toán qua VietQR?\n\nVui lòng chỉ xác nhận khi giao dịch đã thành công trên ứng dụng ngân hàng của bạn.');
        }
        
        // Xử lý lỗi khi không load được QR
        function handleQRError(img) {
            console.error('❌ Failed to load QR image:', img.src);
            document.getElementById('qrErrorMessage').style.display = 'block';
            img.style.display = 'none';
        }
        
        // Xử lý khi QR load thành công
        function handleQRLoad() {
            console.log('✅ QR image loaded successfully');
            document.getElementById('qrErrorMessage').style.display = 'none';
        }
        
        // Thử lại load QR
        function retryLoadQR() {
            const img = document.getElementById('qrCodeImg');
            const originalSrc = img.src;
            img.style.display = 'block';
            img.src = '';
            setTimeout(() => {
                img.src = originalSrc + '&retry=' + Date.now();
            }, 100);
        }

        // Khởi tạo khi trang load
        document.addEventListener('DOMContentLoaded', function() {
            startCountdown();
            startPaymentCheck();
        });

        // CSS cho loading animation
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