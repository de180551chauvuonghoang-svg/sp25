<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.DBConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>System Status - PRJ301</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; }
        .status { padding: 15px; margin: 10px 0; border-radius: 5px; }
        .success { background-color: #d4edda; color: #155724; }
        .error { background-color: #f8d7da; color: #721c24; }
        .btn { padding: 10px 20px; background-color: #007bff; color: white; text-decoration: none; border-radius: 5px; margin: 5px; display: inline-block; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 PRJ301 - System Status</h1>
        
        <!-- Database Status -->
        <div class="status <%= DBConnection.testConnection() ? "success" : "error" %>">
            <strong>Database:</strong> 
            <%= DBConnection.testConnection() ? "✅ Connected" : "❌ Disconnected" %>
        </div>
        
        <!-- Application Status -->
        <div class="status success">
            <strong>Application:</strong> ✅ Running
        </div>
        
        <div class="status success">
            <strong>Server Time:</strong> <%= new java.util.Date() %>
        </div>
        
        <h2>🚀 Quick Start</h2>
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn">🔐 Login</a>
        <a href="${pageContext.request.contextPath}/viewAllProduct.jsp" class="btn">📦 Products</a>
        
        <h2>📋 Final Structure</h2>
        <ul>
            <li>✅ Model Layer: User.java, Product.java</li>
            <li>✅ DAO Layer: UserDAO, ProductDAO</li>
            <li>✅ Service Layer: UserService, ProductService</li>
            <li>✅ View Layer: JSP files</li>
            <li>✅ CRUD Operations: All working</li>
            <li>✅ Role-based Access: Admin/User</li>
        </ul>
    </div>
</body>
</html>