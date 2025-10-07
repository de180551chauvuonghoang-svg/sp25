package dao;

import model.CartItem;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
   
    public CartResult addToCart(int userId, int productId, int quantity) {
        String sql = "{CALL sp_AddToCart(?, ?, ?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setInt(1, userId);
            cstmt.setInt(2, productId);
            cstmt.setInt(3, quantity);
            
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                boolean success = rs.getBoolean("success");
                String message = rs.getString("message");
                return new CartResult(success, message);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new CartResult(false, "Lỗi hệ thống: " + e.getMessage());
        }
        
        return new CartResult(false, "Không thể thêm vào giỏ hàng");
    }
    
    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    public CartResult updateCart(int cartId, int quantity) {
        String sql = "{CALL sp_UpdateCart(?, ?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setInt(1, cartId);
            cstmt.setInt(2, quantity);
            
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                boolean success = rs.getBoolean("success");
                String message = rs.getString("message");
                return new CartResult(success, message);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new CartResult(false, "Lỗi hệ thống: " + e.getMessage());
        }
        
        return new CartResult(false, "Không thể cập nhật giỏ hàng");
    }
    
    /**
     * Lấy danh sách sản phẩm trong giỏ hàng của user
     */
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = """
            SELECT c.id, c.product_id, c.quantity, c.added_date, c.updated_date,
                   p.name, p.price, p.description, p.stock, p.import_date, p.status
            FROM Cart c
            INNER JOIN Product p ON c.product_id = p.id
            WHERE c.user_id = ?
            ORDER BY c.updated_date DESC
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                // Tạo Product object
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getDouble("price"));
                product.setDescription(rs.getString("description"));
                product.setStock(rs.getInt("stock"));
                product.setImportDate(rs.getString("import_date"));
                
                // Tạo CartItem object
                CartItem cartItem = new CartItem();
                cartItem.setId(rs.getInt("id"));
                cartItem.setProduct(product);
                cartItem.setQuantity(rs.getInt("quantity"));
                cartItem.setAddedDate(rs.getTimestamp("added_date"));
                cartItem.setUpdatedDate(rs.getTimestamp("updated_date"));
                
                cartItems.add(cartItem);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return cartItems;
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM Cart WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa toàn bộ giỏ hàng của user
     */
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM Cart WHERE user_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Checkout sử dụng stored procedure
     */
    public CheckoutResult checkout(int userId, double totalPrice, Integer discountId) {
        String sql = "{CALL sp_Checkout(?, ?, ?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setInt(1, userId);
            cstmt.setDouble(2, totalPrice);
            if (discountId != null) {
                cstmt.setInt(3, discountId);
            } else {
                cstmt.setNull(3, Types.INTEGER);
            }
            
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                int orderId = rs.getInt("order_id");
                String message = rs.getString("message");
                return new CheckoutResult(orderId > 0, orderId, message);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new CheckoutResult(false, 0, "Lỗi hệ thống: " + e.getMessage());
        }
        
        return new CheckoutResult(false, 0, "Không thể thực hiện checkout");
    }
    
    /**
     * Kiểm tra sản phẩm có sẵn để mua không
     */
    public boolean isProductAvailable(int productId, int quantity) {
        String sql = "SELECT dbo.fn_IsProductAvailable(?, ?) as available";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, productId);
            pstmt.setInt(2, quantity);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getBoolean("available");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Lấy số lượng item trong giỏ hàng
     */
    public int getCartItemCount(int userId) {
        String sql = "SELECT COUNT(*) as count FROM Cart WHERE user_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Inner classes cho kết quả trả về
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