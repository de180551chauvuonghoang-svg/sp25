# HƯỚNG DẪN SETUP EMAIL SERVICE ĐỂ GỬI MAIL THẬT

## ✅ **ĐÃ HOÀN THÀNH:**

1. **📧 EmailService.java** - Đã tạo lại hoàn toàn với javax.mail
2. **📦 javax.mail-1.6.2.jar** - Đã tải và thêm vào classpath
3. **⚙️ SMTP Configuration** - Đã cấu hình Gmail SMTP

## 🔧 **BƯỚC QUAN TRỌNG - BẠN CẦN LÀM:**

### Bước 1: Cập nhật thông tin email trong EmailService.java

Mở file `EmailService.java` và thay đổi dòng 14-15:

```java
// Dòng 14: Thay thành email Gmail thật của bạn
private final String EMAIL_USERNAME = "your-real-email@gmail.com";

// Dòng 15: Thay thành App Password từ Google
private final String EMAIL_PASSWORD = "abcd efgh ijkl mnop";
```

### Bước 2: Tạo App Password trong Gmail

1. **Đăng nhập Gmail** → Settings → Security
2. **Bật 2-Step Verification** (bắt buộc)
3. **Tạo App Password:**
   - Vào **App passwords**
   - Chọn **Mail** và **Other (custom name)**
   - Nhập "SP25 Demo Store"
   - **Copy 16 ký tự** được tạo (ví dụ: `abcd efgh ijkl mnop`)
4. **Paste vào EMAIL_PASSWORD** trong EmailService.java

### Bước 3: Test Email

1. **Restart Tomcat Server**
2. **Login và checkout** một đơn hàng
3. **Kiểm tra console** - sẽ thấy:
   - ✅ `Email sent successfully to: user@example.com` (nếu thành công)
   - ❌ `Failed to send email` (nếu thất bại)
4. **Kiểm tra email** trong hộp thư của khách hàng

## 📧 **TÍNH NĂNG EMAIL:**

✅ **Gửi email HTML** với thông tin đơn hàng chi tiết
✅ **Gửi email text** đơn giản  
✅ **Test connection** để kiểm tra cấu hình
✅ **Fallback logging** khi gửi email thất bại
✅ **Error handling** robust

## 🛠️ **TROUBLESHOOTING:**

**Nếu không gửi được email:**
1. Kiểm tra EMAIL_USERNAME và EMAIL_PASSWORD đúng chưa
2. Đảm bảo 2-Step Verification đã bật
3. Kiểm tra App Password 16 ký tự chính xác
4. Xem console log để debug

**Nếu vẫn lỗi:**
- Email sẽ fallback thành development mode (chỉ log)
- Checkout vẫn hoạt động bình thường
- Không ảnh hưởng đến chức năng mua hàng

## 📝 **CẤU TRÚC EMAIL GỬI:**

```
Subject: Xác nhận đơn hàng #123

Content:
- Cảm ơn khách hàng
- Thông tin đơn hàng (ID, ngày, tổng tiền)
- Chi tiết sản phẩm (tên, số lượng, giá)
- Thông tin liên hệ
```

## 🚀 **READY TO USE:**

Sau khi cập nhật email/password và restart server, **email service sẽ gửi mail thật!** 📧✨