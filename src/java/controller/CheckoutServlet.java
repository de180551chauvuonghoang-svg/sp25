package controller;

import service.EmailService;
import service.VietQRService;
import cartDao.CartDAO;
import cartDao.ICartDAO.CheckoutResult;
import couponDao.CouponDAO;
import model.User;
import model.CartItem;
import model.Coupon;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();
    private CouponDAO couponDAO = new CouponDAO();
    private EmailService emailService = new EmailService();
    private static final Logger logger = Logger.getLogger(CheckoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Lấy giỏ hàng từ database
        List<CartItem> cart = cartDAO.getCartItems(loggedInUser.getId());
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // Tính tổng tiền
        double totalPrice = 0;
        for (CartItem item : cart) {
            totalPrice += item.getProduct().getPrice() * item.getQuantity();
        }
        
        // Lấy danh sách coupon có hiệu lực
        List<Coupon> availableCoupons = couponDAO.getActiveCoupons();
        
        request.setAttribute("cart", cart);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("availableCoupons", availableCoupons);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Lấy giỏ hàng từ database
        List<CartItem> cart = cartDAO.getCartItems(loggedInUser.getId());
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        // Kiểm tra loại thanh toán được chọn
        String paymentMethod = request.getParameter("paymentMethod");
        
        try {
            // Tính tổng tiền từ giỏ hàng (luôn tính lại để đảm bảo chính xác)
            double totalPrice = 0;
            for (CartItem item : cart) {
                totalPrice += item.getProduct().getPrice() * item.getQuantity();
            }
            
            // Sử dụng totalPrice tính từ giỏ hàng thay vì finalAmount từ form
            double finalPrice = totalPrice;
            
            logger.info(String.format("🛒 Cart total calculated: %.2f VND for user %s", 
                totalPrice, loggedInUser.getName()));
            
            // Xử lý thanh toán VietQR
            if ("vietqr".equals(paymentMethod)) {
                // Tạo temporary order ID
                String tempOrderId = "ORD" + System.currentTimeMillis();
                
                // Tạo thông tin QR code
                Map<String, Object> qrInfo = VietQRService.generateQRPaymentInfo(
                    finalPrice, 
                    tempOrderId, 
                    loggedInUser.getName()
                );
                
                if (qrInfo != null && !qrInfo.isEmpty()) {
                    // Lưu thông tin thanh toán vào session
                    session.setAttribute("pendingPayment", true);
                    session.setAttribute("paymentCart", cart);
                    session.setAttribute("paymentTotalPrice", totalPrice);
                    session.setAttribute("paymentFinalPrice", finalPrice);
                    session.setAttribute("paymentDiscountAmount", 0.0); // Không có discount từ cart
                    session.setAttribute("paymentCouponId", null);
                    session.setAttribute("qrPaymentInfo", qrInfo);
                    
                    // Chuyển hướng đến trang hiển thị QR
                    response.sendRedirect("qr-payment.jsp");
                    return;
                } else {
                    request.setAttribute("error", "Không thể tạo mã QR thanh toán. Vui lòng thử lại.");
                    response.sendRedirect("cart");
                    return;
                }
            }
            
            // Xử lý thanh toán COD (và các phương thức khác)
            CheckoutResult checkoutResult = cartDAO.checkout(loggedInUser.getId(), finalPrice, null);
            
            if (checkoutResult.isSuccess()) {
                int orderId = checkoutResult.getOrderId();
                
                // Gửi email xác nhận đơn hàng
                try {
                    model.Order orderForEmail = new model.Order(orderId, loggedInUser.getId(), 
                                                               finalPrice, "PENDING");
                    
                    boolean emailSent = emailService.sendOrderConfirmationEmail(loggedInUser, orderForEmail, cart);
                    if (emailSent) {
                        logger.info("Email xác nhận đã được gửi thành công cho đơn hàng #" + orderId);
                    } else {
                        logger.warning("Không thể gửi email xác nhận cho đơn hàng #" + orderId);
                    }
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Lỗi khi gửi email xác nhận đơn hàng #" + orderId, e);
                }
                
                // Lưu thông tin checkout vào session để hiển thị trang success
                session.setAttribute("checkoutOrderId", orderId);
                session.setAttribute("checkoutTotalPrice", totalPrice);
                session.setAttribute("checkoutFinalPrice", finalPrice);
                session.setAttribute("checkoutDiscountAmount", 0.0);
                
                // Lưu phương thức thanh toán
                if (paymentMethod == null || paymentMethod.isEmpty()) {
                    session.setAttribute("paymentMethod", "cod"); // Mặc định COD
                } else {
                    session.setAttribute("paymentMethod", paymentMethod);
                }
                
                // Chuyển hướng đến trang thành công
                response.sendRedirect("cart/success.jsp?orderId=" + orderId);
            } else {
                // Checkout thất bại - hiển thị lỗi
                request.setAttribute("error", checkoutResult.getMessage());
                response.sendRedirect("cart");
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during checkout", e);
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.");
            response.sendRedirect("cart");
        }
    }
}