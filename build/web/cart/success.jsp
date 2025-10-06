<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        
        <p>Chúng tôi sẽ xử lý đơn hàng của bạn trong thời gian sớm nhất và thông báo cho bạn về trạng thái giao hàng.</p>
        
        <div style="background: #e7f3ff; padding: 15px; border-radius: 8px; margin: 20px 0;">
            <h4 style="color: #0066cc; margin-top: 0;">📧 Email xác nhận</h4>
            <p style="margin-bottom: 0;">Chúng tôi đã gửi email xác nhận đơn hàng đến địa chỉ email của bạn. Vui lòng kiểm tra hộp thư để xem chi tiết đơn hàng.</p>
        </div>
        
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