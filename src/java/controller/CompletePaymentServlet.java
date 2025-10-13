package controller;

import service.EmailService;
import cartDao.ICartDAO.CheckoutResult;
import couponDao.CouponDAO;
import model.User;
import model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet(name = "CompletePaymentServlet", urlPatterns = {"/complete-payment"})
public class CompletePaymentServlet extends HttpServlet {
    private CouponDAO couponDAO = new CouponDAO();
    private EmailService emailService = new EmailService();
    private static final Logger logger = Logger.getLogger(CompletePaymentServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Kiểm tra xem có thông tin thanh toán pending không
        Boolean pendingPayment = (Boolean) session.getAttribute("pendingPayment");
        if (pendingPayment == null || !pendingPayment) {
            response.sendRedirect("checkout");
            return;
        }
        
        try {
            // Lấy thông tin từ session
            @SuppressWarnings("unchecked")
            List<CartItem> cart = (List<CartItem>) session.getAttribute("paymentCart");
            Double totalPrice = (Double) session.getAttribute("paymentTotalPrice");
            Double finalPrice = (Double) session.getAttribute("paymentFinalPrice");
            Double discountAmount = (Double) session.getAttribute("paymentDiscountAmount");
            Integer couponId = (Integer) session.getAttribute("paymentCouponId");
            
            if (cart == null || finalPrice == null) {
                response.sendRedirect("checkout");
                return;
            }
            
            // Thực hiện checkout với cart từ session (cho VietQR)
            CheckoutResult checkoutResult = checkoutWithSessionCart(loggedInUser.getId(), finalPrice, couponId, cart);
            
            if (checkoutResult.isSuccess()) {
                int orderId = checkoutResult.getOrderId();
                
                // Áp dụng coupon nếu có
                if (couponId != null && discountAmount != null && discountAmount > 0) {
                    couponDAO.applyCoupon(couponId, loggedInUser.getId(), orderId, discountAmount);
                }
                
                // Gửi email xác nhận đơn hàng
                try {
                    model.Order orderForEmail = new model.Order(orderId, loggedInUser.getId(), 
                                                               finalPrice, "PAID"); // PAID vì đã thanh toán VietQR
                    
                    boolean emailSent = emailService.sendOrderConfirmationEmail(loggedInUser, orderForEmail, cart);
                    if (emailSent) {
                        logger.info("✅ Email xác nhận thanh toán VietQR đã được gửi thành công cho đơn hàng #" + orderId);
                    } else {
                        logger.warning("⚠️ Không thể gửi email xác nhận cho đơn hàng VietQR #" + orderId);
                    }
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "❌ Lỗi khi gửi email xác nhận đơn hàng VietQR #" + orderId, e);
                }
                
                // Lưu thông tin checkout vào session để hiển thị trang success
                session.setAttribute("checkoutOrderId", orderId);
                session.setAttribute("checkoutTotalPrice", totalPrice);
                session.setAttribute("checkoutFinalPrice", finalPrice);
                session.setAttribute("checkoutDiscountAmount", discountAmount);
                session.setAttribute("paymentMethod", "VietQR");
                
                // Xóa thông tin pending payment
                session.removeAttribute("pendingPayment");
                session.removeAttribute("paymentCart");
                session.removeAttribute("paymentTotalPrice");
                session.removeAttribute("paymentFinalPrice");
                session.removeAttribute("paymentDiscountAmount");
                session.removeAttribute("paymentCouponId");
                session.removeAttribute("qrPaymentInfo");
                
                // Chuyển hướng đến trang thành công
                response.sendRedirect("cart/success.jsp?orderId=" + orderId + "&payment=vietqr");
            } else {
                // Checkout thất bại
                request.setAttribute("error", checkoutResult.getMessage());
                request.getRequestDispatcher("qr-payment.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during payment completion", e);
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình xử lý thanh toán. Vui lòng thử lại.");
            request.getRequestDispatcher("qr-payment.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect GET requests to POST
        response.sendRedirect("qr-payment.jsp");
    }
    
    /**
     * Checkout đặc biệt cho VietQR sử dụng cart từ session
     * Vì cart trong database có thể đã bị xóa trong thời gian chờ thanh toán
     */
    private CheckoutResult checkoutWithSessionCart(int userId, double totalPrice, Integer discountId, List<CartItem> sessionCart) {
        String orderDetailsSql = "INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        
        try (Connection con = dao.DBConnection.getConnection()) {
            con.setAutoCommit(false);
            
            try {
                // 1. Tạo Order
                int orderId = 0;
                try (PreparedStatement pstmt = con.prepareStatement(
                    "INSERT INTO Orders (user_id, order_date, total_price, status, discount_id) VALUES (?, GETDATE(), ?, 'PAID', ?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                    
                    pstmt.setInt(1, userId);
                    pstmt.setDouble(2, totalPrice);
                    if (discountId != null) {
                        pstmt.setInt(3, discountId);
                    } else {
                        pstmt.setNull(3, java.sql.Types.INTEGER);
                    }
                    
                    pstmt.executeUpdate();
                    
                    try (ResultSet rs = pstmt.getGeneratedKeys()) {
                        if (rs.next()) {
                            orderId = rs.getInt(1);
                        }
                    }
                }
                
                if (orderId == 0) {
                    throw new SQLException("Không thể tạo đơn hàng");
                }
                
                // 2. Tạo OrderDetails từ session cart
                try (PreparedStatement pstmt = con.prepareStatement(orderDetailsSql)) {
                    for (CartItem item : sessionCart) {
                        pstmt.setInt(1, orderId);
                        pstmt.setInt(2, item.getProduct().getId());
                        pstmt.setInt(3, item.getQuantity());
                        pstmt.setDouble(4, item.getProduct().getPrice());
                        pstmt.addBatch();
                    }
                    pstmt.executeBatch();
                }
                
                // 3. Xóa cart trong database (nếu còn)
                try (PreparedStatement pstmt = con.prepareStatement("DELETE FROM Cart WHERE user_id = ?")) {
                    pstmt.setInt(1, userId);
                    pstmt.executeUpdate();
                }
                
                con.commit();
                logger.info("🎉 VietQR Checkout thành công - OrderID: " + orderId + " với " + sessionCart.size() + " items");
                
                return new CheckoutResult(true, orderId, "VietQR Checkout thành công");
                
            } catch (SQLException e) {
                con.rollback();
                throw e;
            }
            
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "❌ Lỗi VietQR checkout", e);
            return new CheckoutResult(false, 0, "Lỗi hệ thống: " + e.getMessage());
        }
    }
}