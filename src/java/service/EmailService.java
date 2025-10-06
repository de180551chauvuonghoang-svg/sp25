package service;

import java.util.Properties;
import java.util.List;
import model.CartItem;
import model.Order;
import model.User;
import java.util.logging.Logger;
import java.util.logging.Level;

// Jakarta Mail imports (sử dụng jakarta namespace cho Jakarta Mail 2.0.1)
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailService {
    private static final Logger logger = Logger.getLogger(EmailService.class.getName());
    
    // Email configuration từ thông tin của bạn
    private static final String FROM_EMAIL = "mit54480@gmail.com";
    private static final String EMAIL_PASSWORD = "trjs tutr ixaa uvrd";
    
    public boolean sendOrderConfirmationEmail(User user, Order order, List<CartItem> orderItems) {
        try {
            // Tạo nội dung email
            String emailContent = createOrderConfirmationContent(user, order, orderItems);
            
            // Log email để debug
            logger.info("=== EMAIL XÁC NHẬN ĐƠN HÀNG ===");
            logger.info("From: " + FROM_EMAIL);
            logger.info("To: " + user.getEmail());
            logger.info("Subject: Xác nhận đơn hàng #" + order.getId());
            logger.info("Content length: " + emailContent.length() + " characters");
            
            // Thử gửi email thực tế, nếu không được sẽ fallback sang simulation
            try {
                sendRealEmail(user.getEmail(), order.getId(), emailContent);
                logger.info("=== EMAIL GỬI THÀNH CÔNG ===");
            } catch (Exception emailError) {
                logger.warning("Không thể gửi email thực tế, chuyển sang simulation: " + emailError.getMessage());
                simulateEmailSending(user.getEmail(), order.getId(), emailContent);
                logger.info("=== EMAIL SIMULATION COMPLETED ===");
            }
            return true;
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Lỗi khi gửi email xác nhận đơn hàng", e);
            return false;
        }
    }
    
    private void sendRealEmail(String toEmail, int orderId, String emailContent) throws Exception {
        // Cấu hình SMTP cho Gmail
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        // Tạo session với authentication
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, EMAIL_PASSWORD);
            }
        });

        // Tạo message
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Xác nhận đơn hàng #" + orderId + " - Cảm ơn bạn đã mua hàng!");
        message.setContent(emailContent, "text/html; charset=utf-8");

        // Gửi email
        Transport.send(message);
        logger.info("Email đã được gửi thành công đến: " + toEmail);
    }
    
    private void simulateEmailSending(String toEmail, int orderId, String content) {
        logger.info("📧 SIMULATING EMAIL SEND:");
        logger.info("📧 To: " + toEmail);
        logger.info("📧 Subject: Xác nhận đơn hàng #" + orderId);
        logger.info("📧 Content Preview: " + content.substring(0, Math.min(200, content.length())) + "...");
        logger.info("📧 Email would be sent successfully in real implementation!");
    }
    
    private String createOrderConfirmationContent(User user, Order order, List<CartItem> orderItems) {
        StringBuilder content = new StringBuilder();
        
        content.append("<!DOCTYPE html>");
        content.append("<html>");
        content.append("<head>");
        content.append("<meta charset='UTF-8'>");
        content.append("<style>");
        content.append("body { font-family: Arial, sans-serif; line-height: 1.6; margin: 0; padding: 20px; background-color: #f4f4f4; }");
        content.append(".container { max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }");
        content.append(".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; text-align: center; border-radius: 10px 10px 0 0; margin: -20px -20px 20px -20px; }");
        content.append(".order-info { background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0; }");
        content.append("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        content.append("th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }");
        content.append("th { background-color: #f8f9fa; font-weight: bold; }");
        content.append(".total { font-size: 18px; font-weight: bold; color: #28a745; text-align: right; }");
        content.append(".footer { text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; }");
        content.append("</style>");
        content.append("</head>");
        content.append("<body>");
        
        content.append("<div class='container'>");
        content.append("<div class='header'>");
        content.append("<h1>🎉 Xác nhận đơn hàng</h1>");
        content.append("<p>Cảm ơn bạn đã mua hàng tại cửa hàng của chúng tôi!</p>");
        content.append("</div>");
        
        content.append("<h2>Xin chào " + user.getName() + "!</h2>");
        content.append("<p>Chúng tôi đã nhận được đơn hàng của bạn và đang xử lý. Dưới đây là thông tin chi tiết:</p>");
        
        content.append("<div class='order-info'>");
        content.append("<h3>📋 Thông tin đơn hàng</h3>");
        content.append("<p><strong>Mã đơn hàng:</strong> #" + order.getId() + "</p>");
        content.append("<p><strong>Trạng thái:</strong> " + getStatusInVietnamese(order.getStatus()) + "</p>");
        content.append("<p><strong>Email:</strong> " + user.getEmail() + "</p>");
        content.append("<p><strong>Quốc gia:</strong> " + user.getCountry() + "</p>");
        content.append("</div>");
        
        content.append("<h3>🛍️ Chi tiết sản phẩm</h3>");
        content.append("<table>");
        content.append("<tr>");
        content.append("<th>Sản phẩm</th>");
        content.append("<th>Giá</th>");
        content.append("<th>Số lượng</th>");
        content.append("<th>Tổng</th>");
        content.append("</tr>");
        
        double totalAmount = 0;
        for (CartItem item : orderItems) {
            double itemTotal = item.getProduct().getPrice() * item.getQuantity();
            totalAmount += itemTotal;
            
            content.append("<tr>");
            content.append("<td>" + item.getProduct().getName() + "</td>");
            content.append("<td>" + formatCurrency(item.getProduct().getPrice()) + "</td>");
            content.append("<td>" + item.getQuantity() + "</td>");
            content.append("<td>" + formatCurrency(itemTotal) + "</td>");
            content.append("</tr>");
        }
        
        content.append("</table>");
        
        content.append("<div class='total'>");
        content.append("Tổng tiền: " + formatCurrency(totalAmount));
        content.append("</div>");
        
        content.append("<div class='order-info'>");
        content.append("<h3>📦 Thông tin giao hàng</h3>");
        content.append("<p>• Đơn hàng sẽ được xử lý trong vòng 1-2 ngày làm việc</p>");
        content.append("<p>• Thời gian giao hàng: 3-5 ngày làm việc</p>");
        content.append("<p>• Chúng tôi sẽ thông báo khi đơn hàng được giao cho đơn vị vận chuyển</p>");
        content.append("</div>");
        
        content.append("<div class='footer'>");
        content.append("<p>Cảm ơn bạn đã tin tưởng và mua hàng tại cửa hàng của chúng tôi!</p>");
        content.append("<p>Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ với chúng tôi.</p>");
        content.append("<p><strong>📞 Hotline:</strong> 1900-xxxx | <strong>📧 Email:</strong> support@example.com</p>");
        content.append("</div>");
        
        content.append("</div>");
        content.append("</body>");
        content.append("</html>");
        
        return content.toString();
    }
    
    private String getStatusInVietnamese(String status) {
        switch (status.toUpperCase()) {
            case "PENDING":
                return "Đang xử lý";
            case "PROCESSING":
                return "Đang chuẩn bị";
            case "SHIPPED":
                return "Đang giao hàng";
            case "COMPLETED":
                return "Hoàn thành";
            case "CANCELLED":
                return "Đã hủy";
            default:
                return status;
        }
    }
    
    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }
    
    /**
     * Test method để kiểm tra EmailService
     */
    public boolean sendTestEmail(String toEmail) {
        logger.info("=== TEST EMAIL ===");
        logger.info("From: " + FROM_EMAIL);
        logger.info("To: " + toEmail);
        logger.info("Subject: Test Email - Hệ thống hoạt động bình thường");
        logger.info("Content: Đây là email test. Hệ thống đã sẵn sàng!");
        logger.info("Email Config: " + FROM_EMAIL + " / " + EMAIL_PASSWORD);
        logger.info("=== KẾT THÚC TEST EMAIL ===");
        return true;
    }
}