<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập thất bại - PRJ301</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .error-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 500px;
            text-align: center;
        }
        .error-icon {
            font-size: 64px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-title {
            color: #dc3545;
            font-size: 24px;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .error-message {
            color: #6c757d;
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s;
            margin: 0 10px;
            display: inline-block;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
        .tips {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .tips h4 {
            margin-top: 0;
            color: #007bff;
        }
        .tips ul {
            text-align: left;
            color: #6c757d;
        }
        .tips li {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        
        <div class="error-title">Đăng nhập thất bại!</div>
        
        <div class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:otherwise>
                    Tên đăng nhập hoặc mật khẩu không đúng. Vui lòng kiểm tra lại thông tin và thử lại.
                </c:otherwise>
            </c:choose>
        </div>
        
        <div>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Thử lại</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Về trang chủ</a>
        </div>
        
        <div class="tips">
            <h4>💡 Gợi ý:</h4>
            <ul>
                <li>Kiểm tra lại tên đăng nhập và mật khẩu</li>
                <li>Đảm bảo không có khoảng trắng thừa</li>
                <li>Kiểm tra trạng thái Caps Lock</li>
                <li>Sử dụng tài khoản demo được cung cấp</li>
            </ul>
        </div>
        
        <div class="tips" style="border-left-color: #28a745;">
            <h4 style="color: #28a745;">📋 Tài khoản demo:</h4>
            <ul>
                <li><strong>Admin:</strong> sa / 123456</li>
                <li><strong>Admin:</strong> admin / abc@123</li>
                <li><strong>User:</strong> An Binh / 111</li>
                <li><strong>User:</strong> An / 222</li>
            </ul>
        </div>
    </div>
</body>
</html>