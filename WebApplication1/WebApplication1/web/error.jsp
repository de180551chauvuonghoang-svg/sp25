<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lỗi hệ thống - PRJ301</title>
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
            width: 600px;
            text-align: center;
        }
        .error-icon {
            font-size: 64px;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-title {
            color: #dc3545;
            font-size: 28px;
            margin-bottom: 10px;
            font-weight: bold;
        }
        .error-code {
            color: #6c757d;
            font-size: 18px;
            margin-bottom: 20px;
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
        .error-details {
            margin-top: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
            border-left: 4px solid #dc3545;
            text-align: left;
        }
        .error-details h4 {
            margin-top: 0;
            color: #dc3545;
        }
        .error-details code {
            background-color: #e9ecef;
            padding: 2px 4px;
            border-radius: 3px;
            font-family: monospace;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        
        <div class="error-title">
            <c:choose>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    Trang không tìm thấy
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 500}">
                    Lỗi máy chủ nội bộ
                </c:when>
                <c:otherwise>
                    Có lỗi xảy ra
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="error-code">
            <c:if test="${not empty pageContext.errorData.statusCode}">
                Mã lỗi: ${pageContext.errorData.statusCode}
            </c:if>
        </div>
        
        <div class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 404}">
                    Trang bạn đang tìm kiếm không tồn tại hoặc đã được di chuyển.
                </c:when>
                <c:when test="${pageContext.errorData.statusCode == 500}">
                    Đã xảy ra lỗi trong quá trình xử lý yêu cầu của bạn. Vui lòng thử lại sau.
                </c:when>
                <c:otherwise>
                    Đã xảy ra lỗi không mong muốn. Vui lòng thử lại hoặc liên hệ với quản trị viên.
                </c:otherwise>
            </c:choose>
        </div>
        
        <div>
            <a href="javascript:history.back()" class="btn btn-secondary">Quay lại</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Về trang chủ</a>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Đăng nhập</a>
        </div>
        
        <c:if test="${not empty pageContext.errorData}">
            <div class="error-details">
                <h4>🔧 Thông tin chi tiết (Development Mode)</h4>
                <p><strong>Requested URI:</strong> <code>${pageContext.errorData.requestURI}</code></p>
                <c:if test="${not empty pageContext.errorData.throwable}">
                    <p><strong>Exception:</strong> <code>${pageContext.errorData.throwable.class.name}</code></p>
                    <p><strong>Message:</strong> <code>${pageContext.errorData.throwable.message}</code></p>
                </c:if>
            </div>
        </c:if>
        
        <!-- Quick Links -->
        <div style="margin-top: 30px; padding: 20px; background-color: #e7f3ff; border-radius: 5px;">
            <h4 style="margin-top: 0; color: #007bff;">🔗 Liên kết hữu ích</h4>
            <div style="display: flex; justify-content: center; gap: 15px; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/testDatabase.jsp">Test Database</a> |
                <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a> |
                <a href="${pageContext.request.contextPath}/viewAllProduct.jsp">Xem sản phẩm</a>
            </div>
        </div>
    </div>
</body>
</html>