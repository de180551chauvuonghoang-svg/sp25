package controller;

import com.google.gson.Gson;
import productDao.ProductDAO;
import model.Product;
import model.CartItem;

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
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        if ("count".equals(action)) {
            // Trả về số lượng item trong giỏ hàng
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            int cartSize = cart != null ? cart.size() : 0;
            
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("cartSize", cartSize);
            
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(result));
        } else {
            // Hiển thị trang giỏ hàng
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
            }
            
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Thêm sản phẩm vào giỏ hàng
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Product product = productDAO.selectProduct(productId);
            if (product != null && product.getStock() >= quantity) {
                addToCart(session, product, quantity);
                
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Đã thêm " + product.getName() + " vào giỏ hàng");
                
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(result));
            } else {
                Map<String, Object> result = new HashMap<>();
                result.put("success", false);
                result.put("message", "Sản phẩm không có đủ số lượng trong kho");
                if (product != null) {
                    result.put("availableStock", product.getStock());
                }
                
                response.setContentType("application/json");
                response.getWriter().write(gson.toJson(result));
            }
        } else if ("update".equals(action)) {
            // Cập nhật số lượng sản phẩm trong giỏ hàng
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            updateCartItem(session, productId, quantity);
            response.sendRedirect("cart");
            
        } else if ("remove".equals(action)) {
            // Xóa sản phẩm khỏi giỏ hàng
            int productId = Integer.parseInt(request.getParameter("productId"));
            
            removeFromCart(session, productId);
            response.sendRedirect("cart");
        }
    }

    private void addToCart(HttpSession session, Product product, int quantity) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        
        // Kiểm tra sản phẩm đã có trong giỏ hàng chưa
        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProduct().getId() == product.getId()) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }
        
        if (!found) {
            cart.add(new CartItem(product, quantity));
        }
    }
    
    private void updateCartItem(HttpSession session, int productId, int quantity) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null) {
            for (CartItem item : cart) {
                if (item.getProduct().getId() == productId) {
                    if (quantity <= 0) {
                        cart.remove(item);
                    } else {
                        item.setQuantity(quantity);
                    }
                    break;
                }
            }
        }
    }
    
    private void removeFromCart(HttpSession session, int productId) {
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cart.removeIf(item -> item.getProduct().getId() == productId);
        }
    }
}