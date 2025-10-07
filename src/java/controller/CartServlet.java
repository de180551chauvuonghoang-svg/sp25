package controller;

import com.google.gson.Gson;
import dao.CartDAO;
import dao.CartDAO.CartResult;
import productDao.ProductDAO;
import model.Product;
import model.CartItem;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private CartDAO cartDAO = new CartDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("count".equals(action)) {
            // Trả về số lượng item trong giỏ hàng từ database
            int cartSize = cartDAO.getCartItemCount(loggedInUser.getId());
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("cartSize", cartSize);
            
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(result));
        } else {
            // Hiển thị trang giỏ hàng - lấy từ database
            List<CartItem> cart = cartDAO.getCartItems(loggedInUser.getId());
            
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
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
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Thêm sản phẩm vào giỏ hàng
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            // Sử dụng CartDAO với trigger để thêm vào giỏ hàng
            CartResult result = cartDAO.addToCart(loggedInUser.getId(), productId, quantity);
            
            Map<String, Object> jsonResult = new HashMap<>();
            jsonResult.put("success", result.isSuccess());
            jsonResult.put("message", result.getMessage());
            
            // Nếu thất bại, lấy thông tin stock hiện tại
            if (!result.isSuccess()) {
                Product product = productDAO.selectProduct(productId);
                if (product != null) {
                    jsonResult.put("availableStock", product.getStock());
                }
            }
            
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(jsonResult));
            
        } else if ("update".equals(action)) {
            // Cập nhật số lượng sản phẩm trong giỏ hàng
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            CartResult result = cartDAO.updateCart(cartId, quantity);
            
            if (result.isSuccess()) {
                response.sendRedirect("cart");
            } else {
                request.setAttribute("error", result.getMessage());
                List<CartItem> cart = cartDAO.getCartItems(loggedInUser.getId());
                request.setAttribute("cart", cart);
                request.getRequestDispatcher("cart.jsp").forward(request, response);
            }
            
        } else if ("remove".equals(action)) {
            // Xóa sản phẩm khỏi giỏ hàng
            int cartId = Integer.parseInt(request.getParameter("cartId"));
            
            boolean success = cartDAO.removeFromCart(cartId);
            
            if (success) {
                response.sendRedirect("cart");
            } else {
                request.setAttribute("error", "Không thể xóa sản phẩm khỏi giỏ hàng");
                List<CartItem> cart = cartDAO.getCartItems(loggedInUser.getId());
                request.setAttribute("cart", cart);
                request.getRequestDispatcher("cart.jsp").forward(request, response);
            }
        }
    }
}