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
    <title>Lịch sử đơn hàng</title>
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
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }
        .order-card { 
            background: white; 
            padding: 20px; 
            margin-bottom: 15px; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        .order-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            border-bottom: 1px solid #dee2e6; 
            padding-bottom: 15px; 
            margin-bottom: 15px; 
        }
        .order-id { 
            font-weight: bold; 
            font-size: 18px; 
        }
        .order-status { 
            padding: 5px 15px; 
            border-radius: 20px; 
            font-size: 14px; 
            font-weight: bold; 
        }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-processing { background: #d1ecf1; color: #0c5460; }
        .status-shipped { background: #d4edda; color: #155724; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        .empty-orders { 
            text-align: center; 
            padding: 50px; 
            background: white; 
            border-radius: 8px; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        table { 
            border-collapse: collapse; 
            width: 100%; 
            background: white; 
            border-radius: 8px; 
            overflow: hidden; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
        }
        th, td { 
            border: 1px solid #ddd; 
            padding: 12px; 
            text-align: left; 
        }
        th { 
            background-color: #f8f9fa; 
            font-weight: 600; 
        }
    </style>
</head>
<body>
<div class="header">
    <h1>📋 Lịch sử đơn hàng</h1>
    <div class="user-info">
        <span>Xin chào, ${sessionScope.loggedInUser.name}!</span>
        <a href="cart" class="logout-btn">🛒 Giỏ hàng</a>
        <a href="products" class="logout-btn">🛍️ Tiếp tục mua hàng</a>
        <a href="dashboard" class="logout-btn">🏠 Dashboard</a>
        <a href="logout" class="logout-btn">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <h2>Đơn hàng của bạn</h2>
    
    <c:choose>
        <c:when test="${empty orders}">
            <div class="empty-orders">
                <h3>Chưa có đơn hàng nào</h3>
                <p>Bạn chưa có đơn hàng nào. Hãy bắt đầu mua sắm!</p>
                <a href="products" class="btn btn-primary">🛍️ Bắt đầu mua sắm</a>
            </div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td class="order-id">#${order.id}</td>
                            <td>User ID: ${order.userId}</td>
                            <td>
                                <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="₫"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 'PENDING'}">
                                        <span class="order-status status-pending">Đang xử lý</span>
                                    </c:when>
                                    <c:when test="${order.status == 'PROCESSING'}">
                                        <span class="order-status status-processing">Đang chuẩn bị</span>
                                    </c:when>
                                    <c:when test="${order.status == 'SHIPPED'}">
                                        <span class="order-status status-shipped">Đang giao</span>
                                    </c:when>
                                    <c:when test="${order.status == 'COMPLETED'}">
                                        <span class="order-status status-completed">Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${order.status == 'CANCELLED'}">
                                        <span class="order-status status-cancelled">Đã hủy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="order-status status-pending">${order.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="orders?action=detail&id=${order.id}" class="btn btn-sm btn-primary">
                                    👁️ Xem chi tiết
                                </a>
                                <c:if test="${order.status == 'PENDING'}">
                                    <a href="orders?action=cancel&id=${order.id}" class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                        ❌ Hủy đơn
                                    </a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
    
    <div class="mt-4">
        <a href="products" class="btn btn-success">🛍️ Tiếp tục mua hàng</a>
        <a href="dashboard" class="btn btn-secondary">🏠 Về Dashboard</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>