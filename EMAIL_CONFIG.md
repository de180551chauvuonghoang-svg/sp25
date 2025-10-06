# 📧 HƯỚNG DẪN SETUP EMAIL GMAIL CHO CHECKOUT

## ✅ **CHECKOUT ĐÃ HOẠT ĐỘNG!** 
✅ **VẤN ĐỀ CÒN LẠI**: Gửi email chưa được

## 🔧 **SETUP GMAIL APP PASSWORD:**

### Bước 1: Bật 2-Step Verification
1. **Đăng nhập Gmail**: `hoangcvde180551@fpt.edu.vn`
2. **Vào Google Account**: [myaccount.google.com](https://myaccount.google.com)
3. **Security** → **2-Step Verification**
4. **Turn on** 2-Step Verification (bắt buộc)

### Bước 2: Tạo App Password
1. **Vào Security** → **App passwords**
2. **Select app**: Mail
3. **Select device**: Other (custom name)
4. **Nhập tên**: "SP25 Demo Store"
5. **Generate** → **Copy 16 ký tự** (ví dụ: `abcd efgh ijkl mnop`)

### Bước 3: Cập nhật EmailService.java
**Thay dòng 15** trong `EmailService.java`:
```java
// Thay từ:
private final String EMAIL_PASSWORD = "your-gmail-app-password";

// Thành:
private final String EMAIL_PASSWORD = "abcd efgh ijkl mnop"; // App Password 16 ký tự
```

## 🚫 **GOOGLE OAUTH JSON KHÔNG DÙNG CHO EMAIL:**

File JSON bạn có là **OAuth credentials** cho Google API, **KHÔNG phải cho Gmail SMTP**:
```json
{
  "client_id": "...",
  "client_secret": "GOCSPX-...",
  "redirect_uris": ["..."]
}
```

**Để gửi email qua Gmail SMTP cần:**
- ✅ **Gmail account**: `hoangcvde180551@fpt.edu.vn` (đã có)
- ✅ **2-Step Verification**: Bật trong Google Account
- ✅ **App Password**: 16 ký tự từ Google (cần tạo)

## 🧪 **TEST EMAIL:**

Sau khi setup App Password:

1. **Restart server** (để load config mới)
2. **Add sản phẩm vào cart**
3. **Click checkout**
4. **Kiểm tra console log**:
   - ✅ `Email sent successfully to: customer@email.com`
   - ❌ `Failed to send email: ...`
5. **Kiểm tra email** trong hộp thư khách hàng

## 📱 **EMAIL CONTENT:**

Email sẽ chứa:
```
Subject: Xác nhận đơn hàng #123

Kính chào [Tên khách hàng],

Cảm ơn bạn đã đặt hàng tại SP25 Demo Store!

Thông tin đơn hàng:
- Mã đơn hàng: #123
- Ngày đặt: 06/10/2025
- Tổng tiền: $349.99

Chi tiết sản phẩm:
- Tai nghe Sony WH-1000XM5 x1 = $349.99

Cảm ơn bạn!
SP25 Demo Store
```

## 🔍 **TROUBLESHOOTING:**

**Nếu vẫn không gửi được:**
1. **Check console**: Xem error message chi tiết
2. **Verify App Password**: 16 ký tự, không có space
3. **Check 2-Step**: Phải bật trước khi tạo App Password
4. **Test connection**: Email service có test connectivity

## 🎯 **STEPS SUMMARY:**

1. **Bật 2-Step Verification** trong Gmail
2. **Tạo App Password** (16 ký tự)
3. **Update EmailService.java** (dòng 15)
4. **Restart server**
5. **Test checkout** → Check email

**📧 Sau đó email sẽ gửi thành công! ✨**
   - Chọn "Mail" và "Other (custom name)" → Nhập "SP25 Demo Store"
   - Copy App Password được tạo (16 ký tự)

### Bước 2: Cập nhật EmailService.java
Trong file `EmailService.java`, thay đổi:

```java
// Thay thành email Gmail thật của bạn
private final String EMAIL_USERNAME = "your-email@gmail.com";

// Thay thành App Password 16 ký tự từ Google  
private final String EMAIL_PASSWORD = "abcd efgh ijkl mnop";
```

### Bước 3: Google Cloud Console (Tùy chọn - cho OAuth2 đầy đủ)
Nếu muốn sử dụng OAuth2 đầy đủ:

1. Vào [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo project mới hoặc chọn project: `iron-decorator-474215-k5`
3. Enable **Gmail API** và **Google OAuth2 API**
4. Tạo **OAuth 2.0 Client IDs** với:
   - Application type: Web application
   - Authorized redirect URIs: `http://localhost:8080/SP25_Demo_MainController/`

### Bước 4: Test Email
Credentials hiện tại:
- **Client ID**: `62182492585-atm62aj2g86rklipkg3u672hvimos27d.apps.googleusercontent.com`
- **Client Secret**: `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`
- **Project ID**: `iron-decorator-474215-k5`

## 📧 Cấu hình Email Settings

### Gmail SMTP Settings (Đã cấu hình)
- **SMTP Server**: smtp.gmail.com
- **Port**: 587 (TLS)
- **Authentication**: Required
- **Security**: STARTTLS

## 🚀 Cách test Email

1. **Update EmailService.java** với thông tin thật
2. **Restart server**
3. **Thực hiện checkout** một đơn hàng
4. **Kiểm tra email** được gửi đến

## 📝 Log Messages
- ✅ `Email sent successfully to: user@example.com`
- ❌ `Failed to send email to: user@example.com`
- 📧 `EMAIL CONTENT (Development Mode)` - nếu không gửi được

## 🔒 Bảo mật
- Không commit App Password vào Git
- Sử dụng environment variables trong production
- Xem xét sử dụng Google Service Account cho production

## 📞 Troubleshooting
- Kiểm tra 2-Step Verification đã bật
- Đảm bảo App Password chính xác
- Kiểm tra firewall/network settings
- Xem console logs để debug