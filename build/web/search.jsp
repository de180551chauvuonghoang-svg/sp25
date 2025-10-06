<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Kiểm tra đã đăng nhập chưa
    if (session.getAttribute("loggedInUser") == null) {
        response.sendRedirect("login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm sản phẩm</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f5f5f5; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center; }
        .header h1 { margin: 0; }
        .user-info { display: flex; align-items: center; gap: 15px; }
        .logout-btn { background: rgba(255,255,255,0.2); color: white; padding: 8px 16px; border: none; border-radius: 6px; text-decoration: none; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }
        
        .search-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-input {
            flex: 1;
            min-width: 300px;
            padding: 12px;
            border: 2px solid #e1e1e1;
            border-radius: 6px;
            font-size: 16px;
        }
        
        .search-btn {
            padding: 12px 24px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .search-btn:hover {
            background: #5a6fd8;
        }
        
        .results-section {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }
        
        .product-card {
            border: 1px solid #e1e5e9;
            border-radius: 8px;
            padding: 1.5rem;
            transition: all 0.3s;
            background: #f8f9fa;
        }
        
        .product-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-color: #667eea;
        }
        
        .product-name {
            font-size: 1.1rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
            color: #333;
        }
        
        .product-price {
            color: #28a745;
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }
        
        .product-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            line-height: 1.4;
        }
        
        .product-stock {
            font-size: 0.9rem;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .in-stock { background: #d4edda; color: #155724; }
        .low-stock { background: #fff3cd; color: #856404; }
        .out-of-stock { background: #f8d7da; color: #721c24; }
        
        .no-results {
            text-align: center;
            padding: 3rem;
            color: #666;
        }
        
        .back-btn {
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🔍 Tìm kiếm sản phẩm</h1>
        <div class="user-info">
            <span>Xin chào, ${sessionScope.loggedInUser.name}!</span>
            <a href="dashboard" class="logout-btn">🏠 Dashboard</a>
            <a href="logout" class="logout-btn">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <a href="dashboard" class="back-btn">← Về Dashboard</a>
        
        <div class="search-section">
            <h3>Tìm kiếm sản phẩm</h3>
            <form class="search-form" action="search" method="get">
                <input type="text" name="keyword" class="search-input" 
                       placeholder="Nhập tên sản phẩm cần tìm..." 
                       value="${param.keyword}">
                <button type="submit" class="search-btn">🔍 Tìm kiếm</button>
            </form>
        </div>

        <div class="results-section">
            <c:choose>
                <c:when test="${not empty param.keyword}">
                    <h3>Kết quả tìm kiếm cho: "${param.keyword}"</h3>
                    <c:choose>
                        <c:when test="${not empty searchResults}">
                            <p>Tìm thấy ${searchResults.size()} sản phẩm</p>
                            <div class="product-grid">
                                <c:forEach var="product" items="${searchResults}">
                                    <div class="product-card">
                                        <div class="product-name">${product.name}</div>
                                        <div class="product-price">
                                            <c:choose>
                                                <c:when test="${product.price >= 1000000}">
                                                    ${String.format("%.1f", product.price / 1000000)}M VNĐ
                                                </c:when>
                                                <c:otherwise>
                                                    ${String.format("%,.0f", product.price)} VNĐ
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="product-description">${product.description}</div>
                                        <div class="product-stock 
                                            <c:choose>
                                                <c:when test="${product.stock > 10}">in-stock</c:when>
                                                <c:when test="${product.stock > 0}">low-stock</c:when>
                                                <c:otherwise>out-of-stock</c:otherwise>
                                            </c:choose>
                                        ">
                                            <c:choose>
                                                <c:when test="${product.stock > 10}">✅ Còn hàng (${product.stock})</c:when>
                                                <c:when test="${product.stock > 0}">⚠️ Sắp hết (${product.stock})</c:when>
                                                <c:otherwise>❌ Hết hàng</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-results">
                                <h4>😔 Không tìm thấy sản phẩm nào</h4>
                                <p>Không có sản phẩm nào khớp với từ khóa "${param.keyword}"</p>
                                <p>Hãy thử tìm kiếm với từ khóa khác.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:otherwise>
                    <h3>📦 Gợi ý tìm kiếm</h3>
                    <p>Nhập tên sản phẩm vào ô tìm kiếm phía trên để bắt đầu tìm kiếm.</p>
                    <p><strong>Ví dụ:</strong> iPhone, Samsung, Laptop, iPad...</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>