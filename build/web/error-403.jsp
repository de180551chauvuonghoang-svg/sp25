<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Không có quyền truy cập</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .error-container {
            background: white;
            padding: 3rem;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        
        .error-icon {
            font-size: 5rem;
            color: #dc3545;
            margin-bottom: 1rem;
        }
        
        .error-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 1rem;
        }
        
        .error-message {
            color: #666;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">🚫</div>
        <h1 class="error-title">Không có quyền truy cập</h1>
        <p class="error-message">
            Xin lỗi, bạn không có quyền truy cập vào trang này. 
            Chức năng này chỉ dành cho quản trị viên (Admin).
            <br><br>
            <strong>Tài khoản hiện tại:</strong> ${sessionScope.loggedInUser.name}<br>
            <strong>Vai trò:</strong> ${sessionScope.userRole}
        </p>
        <div class="error-actions">
            <c:choose>
                <c:when test="${sessionScope.loggedInUser != null}">
                    <a href="dashboard" class="btn btn-primary">🏠 Về Dashboard</a>
                    <a href="products" class="btn btn-secondary">📦 Xem sản phẩm</a>
                    <a href="logout" class="btn btn-secondary">🚪 Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="login" class="btn btn-primary">🔑 Đăng nhập</a>
                    <a href="index.jsp" class="btn btn-secondary">🏠 Trang chủ</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>