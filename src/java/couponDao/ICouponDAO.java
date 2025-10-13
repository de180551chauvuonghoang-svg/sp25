package couponDao;

import model.Coupon;
import model.CouponUsage;
import java.util.List;

/**
 * Interface định nghĩa các operations cho Coupon Data Access Object
 */
public interface ICouponDAO {
    
    /**
     * Validate coupon code và tính toán discount amount
     * @param couponCode Mã coupon
     * @param userId ID người dùng
     * @param orderAmount Tổng tiền đơn hàng
     * @return CouponValidationResult chứa thông tin validation
     */
    CouponValidationResult validateCoupon(String couponCode, int userId, double orderAmount);
    
    /**
     * Áp dụng coupon cho đơn hàng
     * @param couponId ID coupon
     * @param userId ID người dùng
     * @param orderId ID đơn hàng
     * @param discountAmount Số tiền giảm giá
     * @return CouponResult chứa kết quả
     */
    CouponResult applyCoupon(int couponId, int userId, int orderId, double discountAmount);
    
    /**
     * Lấy danh sách coupon có hiệu lực
     * @return List các Coupon có hiệu lực
     */
    List<Coupon> getActiveCoupons();
    
    /**
     * Lấy thông tin coupon theo code
     * @param code Mã coupon
     * @return Coupon object hoặc null nếu không tìm thấy
     */
    Coupon getCouponByCode(String code);
    
    /**
     * Lấy thông tin coupon theo ID
     * @param id ID coupon
     * @return Coupon object hoặc null nếu không tìm thấy
     */
    Coupon getCouponById(int id);
    
    /**
     * Lấy danh sách tất cả coupon (cho admin)
     * @return List tất cả Coupon
     */
    List<Coupon> getAllCoupons();
    
    /**
     * Tạo coupon mới (cho admin)
     * @param coupon Thông tin coupon
     * @return CouponResult chứa kết quả
     */
    CouponResult createCoupon(Coupon coupon);
    
    /**
     * Cập nhật thông tin coupon
     * @param coupon Thông tin coupon cần cập nhật
     * @return CouponResult chứa kết quả
     */
    CouponResult updateCoupon(Coupon coupon);
    
    /**
     * Xóa/vô hiệu hóa coupon
     * @param couponId ID coupon
     * @return boolean thành công hay không
     */
    boolean deactivateCoupon(int couponId);
    
    /**
     * Lấy lịch sử sử dụng coupon của user
     * @param userId ID người dùng
     * @return List CouponUsage
     */
    List<CouponUsage> getUserCouponUsageHistory(int userId);
    
    /**
     * Lấy lịch sử sử dụng của một coupon cụ thể
     * @param couponId ID coupon
     * @return List CouponUsage
     */
    List<CouponUsage> getCouponUsageHistory(int couponId);
    
    /**
     * Kiểm tra user đã sử dụng coupon này chưa (cho coupon giới hạn 1 lần/user)
     * @param couponId ID coupon
     * @param userId ID user
     * @return true nếu đã sử dụng
     */
    boolean hasUserUsedCoupon(int couponId, int userId);
    
    /**
     * Kết quả validation coupon
     */
    public static class CouponValidationResult {
        private boolean valid;
        private int couponId;
        private double discountAmount;
        private String message;
        
        public CouponValidationResult(boolean valid, int couponId, double discountAmount, String message) {
            this.valid = valid;
            this.couponId = couponId;
            this.discountAmount = discountAmount;
            this.message = message;
        }
        
        public boolean isValid() { return valid; }
        public int getCouponId() { return couponId; }
        public double getDiscountAmount() { return discountAmount; }
        public String getMessage() { return message; }
    }
    
    /**
     * Kết quả các operations khác
     */
    public static class CouponResult {
        private boolean success;
        private String message;
        private int couponId;
        
        public CouponResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public CouponResult(boolean success, String message, int couponId) {
            this.success = success;
            this.message = message;
            this.couponId = couponId;
        }
        
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public int getCouponId() { return couponId; }
    }
}