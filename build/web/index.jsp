<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chào mừng đến với hệ thống quản lý</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: rgb(60, 63, 65);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .header {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 1rem 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .nav {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 24px;
            font-weight: bold;
            color: white;
        }
        
        .nav-links {
            display: flex;
            gap: 20px;
        }
        
        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            transition: all 0.3s;
            background: rgba(255, 255, 255, 0.1);
        }
        
        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-2px);
        }
        
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        
        .hero {
            text-align: center;
            color: white;
            max-width: 800px;
        }
        
        .hero h1 {
            font-size: 3.5rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .hero p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            opacity: 0.9;
            line-height: 1.6;
        }
        
        .hero-buttons {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 15px 30px;
            font-size: 18px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            display: inline-block;
            font-weight: 500;
        }
        
        .btn-primary {
            background: white;
            color: #667eea;
        }
        
        .btn-primary:hover {
            background: #f8f9fa;
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }
        
        .btn-secondary {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid white;
        }
        
        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-3px);
        }
        
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 4rem;
        }
        
        .feature-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 2rem;
            border-radius: 12px;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .feature-card .icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .feature-card h3 {
            margin-bottom: 1rem;
            font-size: 1.3rem;
        }
        
        .feature-card p {
            opacity: 0.9;
            line-height: 1.5;
        }
        
        .footer {
            background: rgba(0, 0, 0, 0.2);
            color: white;
            text-align: center;
            padding: 2rem;
            margin-top: 4rem;
        }
        
        .user-status {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 1rem 2rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .user-status h3 {
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <nav class="nav">
            <div class="logo">🏢 Hệ thống quản lý</div>
            <div class="nav-links">
                <c:choose>
                    <c:when test="${sessionScope.loggedInUser != null}">
                        <a href="dashboard">🏠 Dashboard</a>
                        <a href="products">📦 Sản phẩm</a>
                        <a href="users">👥 Người dùng</a>
                        <a href="logout">🚪 Đăng xuất</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login">🔑 Đăng nhập</a>
                        <a href="register">📝 Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </nav>
    </div>
    
    <div class="main-content">
        <div class="hero">
            <c:choose>
                <c:when test="${sessionScope.loggedInUser != null}">
                    <div class="user-status">
                        <h3>Chào mừng trở lại, ${sessionScope.loggedInUser.name}! 👋</h3>
                        <p>Bạn đã đăng nhập với vai trò: <strong>${sessionScope.userRole}</strong></p>
                    </div>
                </c:when>
            </c:choose>
            
            <h1>Chào mừng đến với<br>Hệ thống quản lý</h1>
            <p>Một giải pháp hoàn chỉnh để quản lý sản phẩm, người dùng và nhiều tính năng khác. 
               Được xây dựng với công nghệ Java hiện đại và giao diện thân thiện.</p>
            
            <div class="hero-buttons">
                <c:choose>
                    <c:when test="${sessionScope.loggedInUser != null}">
                        <a href="dashboard" class="btn btn-primary">🏠 Vào Dashboard</a>
                        <a href="products" class="btn btn-secondary">📦 Xem sản phẩm</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login" class="btn btn-primary">🔑 Đăng nhập ngay</a>
                        <a href="register" class="btn btn-secondary">📝 Tạo tài khoản</a>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="features">
                <div class="feature-card">
                    <div class="icon">📦</div>
                    <h3>Quản lý sản phẩm</h3>
                    <p>Thêm, sửa, xóa và tìm kiếm sản phẩm một cách dễ dàng với hệ thống phân trang thông minh</p>
                </div>
                
                <div class="feature-card">
                    <div class="icon">👥</div>
                    <h3>Quản lý người dùng</h3>
                    <p>Quản lý tài khoản người dùng với phân quyền rõ ràng và bảo mật cao</p>
                </div>
                
                <div class="feature-card">
                    <div class="icon">🔒</div>
                    <h3>Bảo mật nâng cao</h3>
                    <p>Hệ thống đăng nhập an toàn với mã hóa mật khẩu và phân quyền chi tiết</p>
                </div>
                
                <div class="feature-card">
                    <div class="icon">📱</div>
                    <h3>Giao diện thân thiện</h3>
                    <p>Thiết kế responsive, hiện đại và dễ sử dụng trên mọi thiết bị</p>
                </div>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <p>&copy; 2025 Hệ thống quản lý. Được phát triển với ❤️ bằng Java & JSP</p>
       
    </div>
</body>
</html>