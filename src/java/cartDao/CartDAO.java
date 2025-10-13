package cartDao;

import dao.DBConnection;
import model.CartItem;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO implements ICartDAO {
    
    @Override
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
   
    @Override
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
    
    @Override
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
                product.setStatus(rs.getString("status"));
                
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
    
    @Override
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
    
    @Override
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
    
    @Override
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
    
    @Override
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
    
    @Override
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
    
    @Override
    public double getCartTotal(int userId) {
        String sql = """
            SELECT SUM(c.quantity * p.price) as total
            FROM Cart c
            INNER JOIN Product p ON c.product_id = p.id
            WHERE c.user_id = ? AND p.status = 'available'
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble("total");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    @Override
    public CartItem getCartItem(int cartId) {
        String sql = """
            SELECT c.id, c.user_id, c.product_id, c.quantity, c.added_date, c.updated_date,
                   p.name, p.price, p.description, p.stock, p.import_date, p.status
            FROM Cart c
            INNER JOIN Product p ON c.product_id = p.id
            WHERE c.id = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, cartId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                // Tạo Product object
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getDouble("price"));
                product.setDescription(rs.getString("description"));
                product.setStock(rs.getInt("stock"));
                product.setImportDate(rs.getString("import_date"));
                product.setStatus(rs.getString("status"));
                
                // Tạo CartItem object
                CartItem cartItem = new CartItem();
                cartItem.setId(rs.getInt("id"));
                cartItem.setProduct(product);
                cartItem.setQuantity(rs.getInt("quantity"));
                cartItem.setAddedDate(rs.getTimestamp("added_date"));
                cartItem.setUpdatedDate(rs.getTimestamp("updated_date"));
                
                return cartItem;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public boolean hasProductInCart(int userId, int productId) {
        String sql = "SELECT COUNT(*) as count FROM Cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    @Override
    public int getProductQuantityInCart(int userId, int productId) {
        String sql = "SELECT quantity FROM Cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, productId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("quantity");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}