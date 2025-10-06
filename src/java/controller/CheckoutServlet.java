package controller;

import service.OrderService;
import service.EmailService;
import productDao.ProductDAO;
import model.User;
import model.CartItem;
import model.Product;

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
    private OrderService orderService = new OrderService();
    private ProductDAO productService = new ProductDAO();
    private EmailService emailService = new EmailService();
    private static final Logger logger = Logger.getLogger(CheckoutServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
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
        
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }
        
        try {
            // Kiểm tra tồn kho trước khi tạo đơn hàng
            boolean stockAvailable = true;
            StringBuilder stockMessage = new StringBuilder();
            
            for (CartItem item : cart) {
                Product currentProduct = productService.selectProduct(item.getProduct().getId());
                if (currentProduct.getStock() < item.getQuantity()) {
                    stockAvailable = false;
                    stockMessage.append("Sản phẩm ").append(currentProduct.getName())
                              .append(" chỉ còn ").append(currentProduct.getStock())
                              .append(" sản phẩm. ");
                }
            }
            
            if (!stockAvailable) {
                request.setAttribute("error", stockMessage.toString());
                request.setAttribute("cart", cart);
                double totalPrice = 0;
                for (CartItem item : cart) {
                    totalPrice += item.getProduct().getPrice() * item.getQuantity();
                }
                request.setAttribute("totalPrice", totalPrice);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
                return;
            }
            
            // Tạo đơn hàng
            int orderId = orderService.createOrderFromCart(loggedInUser.getId(), cart);
            
            if (orderId > 0) {
                // Cập nhật tồn kho
                for (CartItem item : cart) {
                    Product product = item.getProduct();
                    product.setStock(product.getStock() - item.getQuantity());
                    productService.updateProduct(product);
                }
                
                // Gửi email xác nhận đơn hàng
                try {
                    // Tính tổng tiền từ cart
                    double totalPrice = 0;
                    for (CartItem item : cart) {
                        totalPrice += item.getProduct().getPrice() * item.getQuantity();
                    }
                    
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
                
                // Xóa giỏ hàng
                session.removeAttribute("cart");
                
                // Chuyển hướng đến trang thành công
                response.sendRedirect("cart/success.jsp?orderId=" + orderId);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo đơn hàng. Vui lòng thử lại.");
                request.setAttribute("cart", cart);
                double totalPrice = 0;
                for (CartItem item : cart) {
                    totalPrice += item.getProduct().getPrice() * item.getQuantity();
                }
                request.setAttribute("totalPrice", totalPrice);
                request.getRequestDispatcher("checkout.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during checkout", e);
            request.setAttribute("error", "Có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại.");
            request.setAttribute("cart", cart);
            double totalPrice = 0;
            for (CartItem item : cart) {
                totalPrice += item.getProduct().getPrice() * item.getQuantity();
            }
            request.setAttribute("totalPrice", totalPrice);
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }
}