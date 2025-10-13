package service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * Service để tạo VietQR Quick Link cho thanh toán online
 */
public class VietQRService {
    
    // Thông tin ngân hàng mặc định
    private static final String BANK_CODE = "970422"; // MB Bank
    private static final String ACCOUNT_NUMBER = "0763593290"; // Số tài khoản MB Bank
    private static final String ACCOUNT_NAME = "CHAU VUONG HOANG";
    private static final String QR_TEMPLATE = "compact2";
    
    // Base URL của VietQR API
    private static final String VIETQR_BASE_URL = "https://img.vietqr.io/image";
    
    // Thời gian hiệu lực của mã QR (20 phút)
    private static final int QR_VALIDITY_MINUTES = 20;
    
    // Map để lưu trữ các QR code đang hiệu lực
    private static Map<String, LocalDateTime> activeQRCodes = new HashMap<>();
    
    /**
     * Tạo URL mã QR cho thanh toán
     * @param amount Số tiền thanh toán
     * @param orderId ID đơn hàng
     * @param customerName Tên khách hàng
     * @return URL mã QR
     */
    public static String generateQRCodeURL(double amount, String orderId, String customerName) {
        try {
            // Format số tiền (làm tròn lên số nguyên gần nhất vì VietQR không hỗ trợ số thập phân)
            long roundedAmount = Math.round(amount);
            String formattedAmount = String.valueOf(roundedAmount);
            
            System.out.println("🔢 VietQR Amount Debug:");
            System.out.println("   Original amount: " + amount);
            System.out.println("   Rounded amount: " + roundedAmount);
            System.out.println("   Formatted amount: " + formattedAmount);
            
            // Tạo nội dung chuyển tiền với thông tin đầy đủ
            String description = String.format("Thanh toan don hang %s - %s - %s VND", 
                orderId, customerName, formattedAmount);
            
            // Encode các tham số URL
            String encodedDescription = URLEncoder.encode(description, StandardCharsets.UTF_8);
            String encodedAccountName = URLEncoder.encode(ACCOUNT_NAME, StandardCharsets.UTF_8);
            
            // Tạo URL QR code theo format VietQR chuẩn
            // Format: https://img.vietqr.io/image/{BANK_CODE}-{ACCOUNT_NUMBER}-{TEMPLATE}.png?amount={AMOUNT}&addInfo={DESCRIPTION}&accountName={ACCOUNT_NAME}
            String qrUrl = String.format("%s/%s-%s-%s.png?amount=%s&addInfo=%s&accountName=%s",
                    VIETQR_BASE_URL,
                    BANK_CODE,
                    ACCOUNT_NUMBER,
                    QR_TEMPLATE,
                    formattedAmount,
                    encodedDescription,
                    encodedAccountName
            );
            
            System.out.println("🔗 Generated QR URL: " + qrUrl);
            
            // Lưu thông tin QR code với thời gian tạo
            String qrKey = orderId + "_" + System.currentTimeMillis();
            activeQRCodes.put(qrKey, LocalDateTime.now());
            
            // Cleanup các QR code đã hết hạn
            cleanupExpiredQRCodes();
            
            return qrUrl;
            
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Tạo thông tin thanh toán QR bao gồm URL và thời gian hết hạn
     * @param amount Số tiền thanh toán
     * @param orderId ID đơn hàng
     * @param customerName Tên khách hàng
     * @return Map chứa thông tin QR
     */
    public static Map<String, Object> generateQRPaymentInfo(double amount, String orderId, String customerName) {
        Map<String, Object> qrInfo = new HashMap<>();
        
        // Tạo URL QR
        String qrUrl = generateQRCodeURL(amount, orderId, customerName);
        
        if (qrUrl != null) {
            // Tính thời gian hết hạn
            LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(QR_VALIDITY_MINUTES);
            
            // Làm tròn số tiền để hiển thị
            long roundedAmount = Math.round(amount);
            
            qrInfo.put("qrUrl", qrUrl);
            qrInfo.put("amount", roundedAmount); // Sử dụng số nguyên cho hiển thị
            qrInfo.put("originalAmount", amount); // Giữ số tiền gốc để tham khảo
            qrInfo.put("orderId", orderId);
            qrInfo.put("customerName", customerName);
            qrInfo.put("bankCode", BANK_CODE);
            qrInfo.put("accountName", ACCOUNT_NAME);
            qrInfo.put("expiryTime", expiryTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            qrInfo.put("validityMinutes", QR_VALIDITY_MINUTES);
            qrInfo.put("description", String.format("Thanh toan don hang %s - %s - %d VND", 
                orderId, customerName, roundedAmount));
            qrInfo.put("status", "active");
            
            // Tính thời gian còn lại tính bằng milliseconds
            long remainingTime = QR_VALIDITY_MINUTES * 60 * 1000; // 20 phút = 1200000 ms
            qrInfo.put("remainingTimeMs", remainingTime);
        }
        
        return qrInfo;
    }
    
    /**
     * Kiểm tra xem QR code có còn hiệu lực không
     * @param qrKey Key của QR code
     * @return true nếu còn hiệu lực, false nếu đã hết hạn
     */
    public static boolean isQRCodeValid(String qrKey) {
        if (!activeQRCodes.containsKey(qrKey)) {
            return false;
        }
        
        LocalDateTime createdTime = activeQRCodes.get(qrKey);
        LocalDateTime now = LocalDateTime.now();
        
        return createdTime.plusMinutes(QR_VALIDITY_MINUTES).isAfter(now);
    }
    
    /**
     * Xóa các QR code đã hết hạn
     */
    private static void cleanupExpiredQRCodes() {
        LocalDateTime now = LocalDateTime.now();
        activeQRCodes.entrySet().removeIf(entry -> 
            entry.getValue().plusMinutes(QR_VALIDITY_MINUTES).isBefore(now)
        );
    }
    
    /**
     * Hủy QR code trước thời hạn
     * @param qrKey Key của QR code cần hủy
     */
    public static void invalidateQRCode(String qrKey) {
        activeQRCodes.remove(qrKey);
    }
    
    /**
     * Lấy thông tin ngân hàng
     * @return Map chứa thông tin ngân hàng
     */
    public static Map<String, String> getBankInfo() {
        Map<String, String> bankInfo = new HashMap<>();
        bankInfo.put("bankCode", BANK_CODE);
        bankInfo.put("accountNumber", ACCOUNT_NUMBER);
        bankInfo.put("bankName", "MB Bank");
        bankInfo.put("accountName", ACCOUNT_NAME);
        return bankInfo;
    }
}