# 📧 HƯỚNG DẪN SETUP GỬI EMAIL THẬT

## ❌ Lý do email chưa được gửi:
- EmailService hiện tại chỉ SIMULATE (log ra console)
- Chưa có JavaMail library trong NetBeans project

## ✅ Cách fix để gửi email thật:

### Bước 1: Download JavaMail JAR
1. Tải file: `javax.mail-1.6.2.jar` 
2. Hoặc tại: https://mvnrepository.com/artifact/com.sun.mail/javax.mail

### Bước 2: Add vào NetBeans Project
1. Right-click project → Properties
2. Libraries → Classpath → Add JAR/Folder
3. Chọn `javax.mail-1.6.2.jar`
4. Apply → OK

### Bước 3: Update EmailService.java
Thêm imports và uncomment code gửi email:

```java
// Thêm imports
import javax.mail.*;
import javax.mail.internet.*;

// Trong method sendOrderConfirmationEmail, thay simulateEmailSending bằng:
Properties props = new Properties();
props.put("mail.smtp.host", "smtp.gmail.com");
props.put("mail.smtp.port", "587");
props.put("mail.smtp.auth", "true");
props.put("mail.smtp.starttls.enable", "true");

Session session = Session.getInstance(props, new Authenticator() {
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
    }
});

Message message = new MimeMessage(session);
message.setFrom(new InternetAddress(FROM_EMAIL));
message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(user.getEmail()));
message.setSubject("Xác nhận đơn hàng #" + order.getId());
message.setContent(emailContent, "text/html; charset=utf-8");

Transport.send(message);
```

## 🔍 Hiện tại test:
1. Đặt hàng → Check NetBeans Output window
2. Sẽ thấy log: "📧 SIMULATING EMAIL SEND"
3. Có đầy đủ thông tin email sẽ được gửi

## 🚀 Khi setup xong JavaMail:
- Email sẽ gửi thật đến `macdogiahuy123@gmail.com`
- User sẽ nhận email HTML đẹp với thông tin đơn hàng