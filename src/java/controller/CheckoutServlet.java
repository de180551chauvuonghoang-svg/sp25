package controller;

import service.EmailService;
import dao.CartDAO;
import dao.CartDAO.CheckoutResult;
import model.User;
import model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {
    private CartDAO cartDAO = new CartDAO();
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
        
        request.setAttribute("cart", cart);
        request.setAttribute("totalPrice", totalPrice);
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
        
        try {
            // Tính tổng tiền
            double totalPrice = 0;
            for (CartItem item : cart) {
                totalPrice += item.getProduct().getPrice() * item.getQuantity();
            }
            
            // Thực hiện checkout bằng stored procedure (triggers sẽ xử lý validation và cập nhật stock)
            CheckoutResult checkoutResult = cartDAO.checkout(loggedInUser.getId(), totalPrice, null);
            
            if (checkoutResult.isSuccess()) {
                int orderId = checkoutResult.getOrderId();
                
                // Gửi email xác nhận đơn hàng
                try {
                    // Tạo order object để gửi email
                    model.Order orderForEmail = new model.Order(orderId, loggedInUser.getId(), 
                                                               totalPrice, "PENDING");
                    
                    boolean emailSent = emailService.sendOrderConfirmationEmail(loggedInUser, orderForEmail, cart);
                    if (emailSent) {
                        logger.info("Email xác nhận đã được gửi thành công cho đơn hàng #" + orderId);
                    } else {
                        logger.warning("Không thể gửi email xác nhận cho đơn hàng #" + orderId);
                    }
                } catch (Exception e) {
                    logger.log(Level.SEVERE, "Lỗi khi gửi email xác nhận đơn hàng #" + orderId, e);
                }
                
                // Chuyển hướng đến trang thành công
                response.sendRedirect("cart/success.jsp?orderId=" + orderId);
            } else {
                // Checkout thất bại - hiển thị lỗi
                request.setAttribute("error", checkoutResult.getMessage());
                request.setAttribute("cart", cart);
                request.setAttribute("totalPrice", totalPrice);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during checkout", e);
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.");
            
            // Lấy lại giỏ hàng và totalPrice cho error page
            List<CartItem> errorCart = cartDAO.getCartItems(loggedInUser.getId());
            double totalPrice = 0;
            for (CartItem item : errorCart) {
                totalPrice += item.getProduct().getPrice() * item.getQuantity();
            }
            
            request.setAttribute("cart", errorCart);
            request.setAttribute("totalPrice", totalPrice);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}