# HƯỚNG DẪN SỬA CHỨC NĂNG CHECKOUT VÀ EMAIL

## 🔧 CÁC BƯỚC CẦN THỰC HIỆN:

### Bước 1: Chạy Script SQL để tạo bảng Orders và OrderDetails

**QUAN TRỌNG:** Bạn cần chạy file `create_orders_tables.sql` trong SQL Server Management Studio:

1. Mở **SQL Server Management Studio**
2. Connect đến database server
3. Mở file `create_orders_tables.sql` 
4. Thực thi script để tạo 2 bảng:
   - `Orders` (lưu thông tin đơn hàng)
   - `OrderDetails` (lưu chi tiết sản phẩm trong đơn hàng)

### Bước 2: Restart Tomcat Server

Sau khi chạy script SQL thành công:
1. **Stop** Tomcat server
2. **Start** lại Tomcat server
3. Truy cập: `http://localhost:8080/SP25_Demo_MainController/login`

### Bước 3: Test chức năng Checkout

1. **Đăng nhập** với tài khoản user (không phải admin)
2. **Thêm sản phẩm** vào giỏ hàng bằng nút "🛒 Thêm vào giỏ"
3. **Ấn icon giỏ hàng** 🛒 ở header để xem giỏ hàng
4. **Ấn nút "Checkout"** để thanh toán
5. **Kiểm tra console** để xem email được gửi (hiện tại chỉ log, không gửi thật)

## 📧 TÌNH TRẠNG EMAIL SERVICE:

**Hiện tại:** EmailService chỉ **LOG email** ra console (development mode)
- ✅ Hoạt động: Log email content ra console
- ❌ Chưa hoạt động: Gửi email thật

**Để gửi email thật:**
1. Thêm `javax.mail.jar` vào classpath
2. Cập nhật EmailService với SMTP configuration thật
3. Cấu hình Gmail App Password

## 🛒 TÌNH TRẠNG CHECKOUT:

**Đã sửa:**
- ✅ EmailService không bị comment nữa
- ✅ OrderService.sendOrderConfirmationEmail() đã uncomment
- ✅ CartServlet và CheckoutServlet hoạt động

**Cần:**
- ⚠️ **Chạy script SQL** để tạo bảng Orders/OrderDetails
- ⚠️ **Restart server** sau khi chạy script

## 🔍 CÁCH TEST:

1. Login với user: `john@example.com` / password: `123456`
2. Thêm sản phẩm vào giỏ
3. Checkout 
4. Xem console log để thấy email được "gửi" (simulated)
5. Kiểm tra database xem đơn hàng có được tạo không

## 📋 TROUBLESHOOTING:

**Nếu checkout không hoạt động:**
- Kiểm tra bảng Orders/OrderDetails đã được tạo chưa
- Kiểm tra console log có lỗi SQL không
- Đảm bảo user đã đăng nhập

**Nếu email không log:**
- Kiểm tra OrderService.sendOrderConfirmationEmail() có được gọi không
- Xem console log có lỗi trong EmailService không