# Chức năng Thanh toán VietQR

## Tổng quan
Chức năng thanh toán VietQR cho phép khách hàng thanh toán đơn hàng bằng cách quét mã QR thông qua ứng dụng ngân hàng hoặc ví điện tử.

## Cách hoạt động

### 1. Quy trình thanh toán
1. Khách hàng chọn sản phẩm và thêm vào giỏ hàng
2. Tại trang checkout, chọn phương thức thanh toán "VietQR - Thanh toán nhanh"
3. Click "Thanh toán VietQR" để tạo mã QR
4. Quét mã QR bằng ứng dụng ngân hàng
5. Hoàn tất thanh toán trên ứng dụng ngân hàng
6. Click "Đã thanh toán" để xác nhận và hoàn tất đơn hàng

### 2. Thông tin mã QR
- **Ngân hàng**: MB Bank (389366)
- **Tên tài khoản**: CHAU VUONG HOANG
- **Thời gian hiệu lực**: 20 phút
- **Format**: VietQR Standard

### 3. Cấu trúc URL mã QR
```
https://img.vietqr.io/image/389366-CHAU%20VUONG%20HOANG-compact2.png?amount=<AMOUNT>&addInfo=<DESCRIPTION>&accountName=<ACCOUNT_NAME>
```

## Thành phần kỹ thuật

### 1. Backend Components

#### VietQRService.java
- **Vị trí**: `src/java/service/VietQRService.java`
- **Chức năng**: 
  - Tạo URL mã QR VietQR
  - Quản lý thời gian hiệu lực (20 phút)
  - Xử lý thông tin thanh toán

#### CheckoutServlet.java
- **Cập nhật**: Thêm xử lý thanh toán VietQR
- **Chức năng**: 
  - Nhận request thanh toán VietQR
  - Tạo session tạm thời
  - Chuyển hướng đến trang QR

#### CompletePaymentServlet.java
- **Vị trí**: `src/java/controller/CompletePaymentServlet.java`
- **Chức năng**:
  - Xử lý xác nhận thanh toán
  - Hoàn tất đơn hàng
  - Gửi email xác nhận

### 2. Frontend Components

#### checkout.jsp
- **Cập nhật**: Thêm radio button cho VietQR
- **JavaScript**: Xử lý chọn phương thức thanh toán

#### qr-payment.jsp
- **Chức năng**:
  - Hiển thị mã QR
  - Countdown timer 20 phút
  - Thông tin thanh toán
  - Hướng dẫn sử dụng

#### qr-payment.css
- **Styling**: Giao diện đẹp cho trang QR payment

#### cart/success.jsp
- **Cập nhật**: Hiển thị phương thức thanh toán

## Cách sử dụng

### 1. Cho Khách hàng
1. Chọn sản phẩm và thêm vào giỏ hàng
2. Tại trang thanh toán, chọn "VietQR - Thanh toán nhanh"
3. Click nút "Thanh toán VietQR"
4. Quét mã QR hiển thị bằng app ngân hàng
5. Kiểm tra thông tin và xác nhận thanh toán
6. Sau khi thanh toán thành công, click "Đã thanh toán"

### 2. Cho Admin/Developer

#### Cấu hình thông tin ngân hàng
Chỉnh sửa trong `VietQRService.java`:
```java
private static final String BANK_CODE = "389366"; // Mã ngân hàng
private static final String ACCOUNT_NAME = "CHAU VUONG HOANG"; // Tên tài khoản
```

#### Thay đổi thời gian hiệu lực
```java
private static final int QR_VALIDITY_MINUTES = 20; // Đổi thành số phút mong muốn
```

#### Tùy chỉnh template QR
```java
private static final String QR_TEMPLATE = "compact2"; // Có thể thay thành "print", "compact", etc.
```

## Bảo mật

### 1. Validation
- Kiểm tra session hợp lệ
- Validate thông tin thanh toán
- Xác minh thời gian hiệu lực

### 2. Session Management
- Lưu trữ tạm thời thông tin thanh toán
- Xóa session sau khi hoàn tất
- Timeout tự động

### 3. Error Handling
- Xử lý lỗi tạo QR
- Xử lý timeout
- Xử lý lỗi mạng

## Limitations & Improvements

### 1. Hiện tại
- Chỉ hỗ trợ 1 tài khoản ngân hàng
- Xác nhận thanh toán thủ công
- Không tích hợp webhook từ ngân hàng

### 2. Cải tiến tương lai
- Tích hợp nhiều ngân hàng
- Auto-verify payment status
- Real-time payment notification
- Payment history tracking

## Troubleshooting

### 1. Mã QR không hiển thị
- Kiểm tra kết nối internet
- Verify URL parameters
- Check VietQR service availability

### 2. Session timeout
- Redirect về trang checkout
- Tạo QR mới
- Clear browser cache

### 3. Payment không được confirm
- Check server logs
- Verify database connection
- Check email service

## API Reference

### VietQR Image API
```
GET https://img.vietqr.io/image/{bankCode}-{accountName}-{template}.png
Parameters:
- amount: Số tiền (VND)
- addInfo: Nội dung chuyển khoản
- accountName: Tên tài khoản
```

### Servlet Endpoints
- `POST /checkout` - Tạo QR payment
- `GET /qr-payment.jsp` - Hiển thị QR
- `POST /complete-payment` - Hoàn tất thanh toán