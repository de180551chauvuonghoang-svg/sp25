package cartDao;

import model.CartItem;
import java.util.List;

/**
 * Interface định nghĩa các operations cho Cart Data Access Object
 */
public interface ICartDAO {
    
    /**
     * Thêm sản phẩm vào giỏ hàng
     * @param userId ID của user
     * @param productId ID của sản phẩm
     * @param quantity Số lượng
     * @return CartResult chứa thông tin kết quả
     */
    CartResult addToCart(int userId, int productId, int quantity);
    
    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     * @param cartId ID của cart item
     * @param quantity Số lượng mới
     * @return CartResult chứa thông tin kết quả
     */
    CartResult updateCart(int cartId, int quantity);
    
    /**
     * Lấy danh sách sản phẩm trong giỏ hàng của user
     * @param userId ID của user
     * @return List các CartItem
     */
    List<CartItem> getCartItems(int userId);
    
    /**
     * Xóa sản phẩm khỏi giỏ hàng
     * @param cartId ID của cart item
     * @return true nếu xóa thành công
     */
    boolean removeFromCart(int cartId);
    
    /**
     * Xóa toàn bộ giỏ hàng của user
     * @param userId ID của user
     * @return true nếu xóa thành công
     */
    boolean clearCart(int userId);
    
    /**
     * Thực hiện checkout
     * @param userId ID của user
     * @param totalPrice Tổng tiền
     * @param discountId ID của discount (có thể null)
     * @return CheckoutResult chứa thông tin kết quả
     */
    CheckoutResult checkout(int userId, double totalPrice, Integer discountId);
    
    /**
     * Kiểm tra sản phẩm có sẵn để mua không
     * @param productId ID của sản phẩm
     * @param quantity Số lượng cần kiểm tra
     * @return true nếu có sẵn
     */
    boolean isProductAvailable(int productId, int quantity);
    
    /**
     * Lấy số lượng item trong giỏ hàng
     * @param userId ID của user
     * @return Số lượng items
     */
    int getCartItemCount(int userId);
    
    /**
     * Tính tổng giá trị giỏ hàng
     * @param userId ID của user
     * @return Tổng giá trị
     */
    double getCartTotal(int userId);
    
    /**
     * Lấy thông tin một cart item cụ thể
     * @param cartId ID của cart item
     * @return CartItem hoặc null nếu không tìm thấy
     */
    CartItem getCartItem(int cartId);
    
    /**
     * Kiểm tra user có sản phẩm này trong giỏ hàng không
     * @param userId ID của user
     * @param productId ID của sản phẩm
     * @return true nếu có sản phẩm trong giỏ
     */
    boolean hasProductInCart(int userId, int productId);
    
    /**
     * Lấy số lượng của sản phẩm cụ thể trong giỏ hàng
     * @param userId ID của user
     * @param productId ID của sản phẩm
     * @return Số lượng sản phẩm trong giỏ
     */
    int getProductQuantityInCart(int userId, int productId);
    
    /**
     * Inner class cho kết quả add/update cart
     */
    public static class CartResult {
        private boolean success;
        private String message;
        
        public CartResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
    }
    
    /**
     * Inner class cho kết quả checkout
     */
    public static class CheckoutResult {
        private boolean success;
        private int orderId;
        private String message;
        
        public CheckoutResult(boolean success, int orderId, String message) {
            this.success = success;
            this.orderId = orderId;
            this.message = message;
        }
        
        public boolean isSuccess() { return success; }
        public int getOrderId() { return orderId; }
        public String getMessage() { return message; }
    }
}