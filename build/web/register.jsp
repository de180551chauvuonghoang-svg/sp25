<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: rgb(60, 63, 65);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .register-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .register-header h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .register-header p {
            color: #666;
            font-size: 14px;
        }
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        
        .form-group {
            margin-bottom: 20px;
            flex: 1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group label .required {
            color: #e74c3c;
        }
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e1e1e1;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f1aeb5;
        }
        
        .form-footer {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e1e1e1;
        }
        
        .form-footer a {
            color: #667eea;
            text-decoration: none;
        }
        
        .form-footer a:hover {
            text-decoration: underline;
        }
        
        .password-requirements {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h2>Đăng ký tài khoản</h2>
            <p>Tạo tài khoản mới để bắt đầu sử dụng</p>
        </div>
        
        <!-- Hiển thị thông báo lỗi -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>
        
        <form action="register" method="post">
            <div class="form-group">
                <label for="name">Họ và tên <span class="required">*</span>:</label>
                <input type="text" id="name" name="name" required 
                       placeholder="Nhập họ và tên của bạn"
                       value="${param.name}">
            </div>
            
            <div class="form-group">
                <label for="email">Email <span class="required">*</span>:</label>
                <input type="email" id="email" name="email" required 
                       placeholder="Nhập email của bạn"
                       value="${param.email}">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="password">Mật khẩu <span class="required">*</span>:</label>
                    <input type="password" id="password" name="password" required 
                           placeholder="Nhập mật khẩu">
                    <div class="password-requirements">
                        Tối thiểu 6 ký tự
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu <span class="required">*</span>:</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required 
                           placeholder="Nhập lại mật khẩu">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="country">Quốc gia:</label>
                    <select id="country" name="country">
                        <option value="">Chọn quốc gia</option>
                        <option value="Vietnam" ${param.country == 'Vietnam' ? 'selected' : ''}>Việt Nam</option>
                        <option value="USA" ${param.country == 'USA' ? 'selected' : ''}>Hoa Kỳ</option>
                        <option value="Japan" ${param.country == 'Japan' ? 'selected' : ''}>Nhật Bản</option>
                        <option value="Korea" ${param.country == 'Korea' ? 'selected' : ''}>Hàn Quốc</option>
                        <option value="China" ${param.country == 'China' ? 'selected' : ''}>Trung Quốc</option>
                        <option value="Singapore" ${param.country == 'Singapore' ? 'selected' : ''}>Singapore</option>
                        <option value="Thailand" ${param.country == 'Thailand' ? 'selected' : ''}>Thái Lan</option>
                        <option value="Other" ${param.country == 'Other' ? 'selected' : ''}>Khác</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="dateOfBirth">Ngày sinh:</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth"
                           value="${param.dateOfBirth}">
                </div>
            </div>
            
            <button type="submit" class="btn">Đăng ký</button>
        </form>
        
        <div class="form-footer">
            <p>Đã có tài khoản? <a href="login">Đăng nhập ngay</a></p>
        </div>
    </div>

    <script>
        // Kiểm tra password match
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (password !== confirmPassword) {
                this.setCustomValidity('Mật khẩu xác nhận không khớp');
            } else {
                this.setCustomValidity('');
            }
        });
    </script>
</body>
</html>