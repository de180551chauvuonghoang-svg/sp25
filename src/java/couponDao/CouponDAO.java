package couponDao;

import dao.DBConnection;
import model.Coupon;
import model.CouponUsage;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CouponDAO implements ICouponDAO {
    
    @Override
    public CouponValidationResult validateCoupon(String couponCode, int userId, double orderAmount) {
        String sql = "{CALL sp_ValidateCoupon(?, ?, ?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setString(1, couponCode);
            cstmt.setInt(2, userId);
            cstmt.setDouble(3, orderAmount);
            
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                boolean valid = rs.getBoolean("valid");
                int couponId = rs.getInt("coupon_id");
                double discountAmount = rs.getDouble("discount_amount");
                String message = rs.getString("message");
                
                return new CouponValidationResult(valid, couponId, discountAmount, message);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new CouponValidationResult(false, 0, 0.0, "Lỗi hệ thống: " + e.getMessage());
        }
        
        return new CouponValidationResult(false, 0, 0.0, "Không thể kiểm tra mã giảm giá");
    }
    
    @Override
    public CouponResult applyCoupon(int couponId, int userId, int orderId, double discountAmount) {
        String sql = "{CALL sp_ApplyCoupon(?, ?, ?, ?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setInt(1, couponId);
            cstmt.setInt(2, userId);
            cstmt.setInt(3, orderId);
            cstmt.setDouble(4, discountAmount);
            
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                boolean success = rs.getBoolean("success");
                String message = rs.getString("message");
                return new CouponResult(success, message);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new CouponResult(false, "Lỗi hệ thống: " + e.getMessage());
        }
        
        return new CouponResult(false, "Không thể áp dụng mã giảm giá");
    }
    
    @Override
    public List<Coupon> getActiveCoupons() {
        List<Coupon> coupons = new ArrayList<>();
        String sql = "{CALL sp_GetActiveCoupons(?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setNull(1, Types.INTEGER); // user_id = null để lấy tất cả
            
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                Coupon coupon = mapResultSetToCoupon(rs);
                coupons.add(coupon);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return coupons;
    }
    
    /**
     * Lấy danh sách coupon khả dụng cho user cụ thể
     */
    public List<Coupon> getAvailableCouponsForUser(int userId) {
        List<Coupon> coupons = new ArrayList<>();
        String sql = "{CALL sp_GetActiveCoupons(?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setInt(1, userId); // Truyền user_id để kiểm tra usage limit
            
            ResultSet rs = cstmt.executeQuery();
            while (rs.next()) {
                Coupon coupon = mapResultSetToCoupon(rs);
                coupons.add(coupon);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return coupons;
    }
    
    @Override
    public Coupon getCouponByCode(String code) {
        String sql = """
            SELECT id, code, name, description, discount_type, discount_value,
                   min_order_amount, max_discount_amount, start_date, end_date,
                   usage_limit, usage_count, is_active, created_by, created_date, updated_date
            FROM Coupon 
            WHERE code = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setString(1, code);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCoupon(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public Coupon getCouponById(int id) {
        String sql = """
            SELECT id, code, name, description, discount_type, discount_value,
                   min_order_amount, max_discount_amount, start_date, end_date,
                   usage_limit, usage_count, is_active, created_by, created_date, updated_date
            FROM Coupon 
            WHERE id = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCoupon(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    @Override
    public List<Coupon> getAllCoupons() {
        List<Coupon> coupons = new ArrayList<>();
        String sql = """
            SELECT id, code, name, description, discount_type, discount_value,
                   min_order_amount, max_discount_amount, start_date, end_date,
                   usage_limit, usage_count, is_active, created_by, created_date, updated_date
            FROM Coupon 
            ORDER BY created_date DESC
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Coupon coupon = mapResultSetToCoupon(rs);
                coupons.add(coupon);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return coupons;
    }
    
    @Override
    public CouponResult createCoupon(Coupon coupon) {
        String sql = "{CALL sp_CreateCoupon(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        
        try (Connection con = DBConnection.getConnection();
             CallableStatement cstmt = con.prepareCall(sql)) {
            
            cstmt.setString(1, coupon.getCode());
            cstmt.setString(2, coupon.getName());
            cstmt.setString(3, coupon.getDescription());
            cstmt.setString(4, coupon.getDiscountType());
            cstmt.setDouble(5, coupon.getDiscountValue());
            
            if (coupon.getMinOrderAmount() != null) {
                cstmt.setDouble(6, coupon.getMinOrderAmount());
            } else {
                cstmt.setNull(6, Types.DECIMAL);
            }
            
            if (coupon.getMaxDiscountAmount() != null) {
                cstmt.setDouble(7, coupon.getMaxDiscountAmount());
            } else {
                cstmt.setNull(7, Types.DECIMAL);
            }
            
            cstmt.setTimestamp(8, coupon.getStartDate());
            cstmt.setTimestamp(9, coupon.getEndDate());
            
            if (coupon.getUsageLimit() != null) {
                cstmt.setInt(10, coupon.getUsageLimit());
            } else {
                cstmt.setNull(10, Types.INTEGER);
            }
            
            cstmt.setInt(11, coupon.getCreatedBy());
            
            ResultSet rs = cstmt.executeQuery();
            if (rs.next()) {
                boolean success = rs.getBoolean("success");
                String message = rs.getString("message");
                int couponId = rs.getInt("coupon_id");
                return new CouponResult(success, message, couponId);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new CouponResult(false, "Lỗi hệ thống: " + e.getMessage());
        }
        
        return new CouponResult(false, "Không thể tạo mã giảm giá");
    }
    
    @Override
    public CouponResult updateCoupon(Coupon coupon) {
        String sql = """
            UPDATE Coupon 
            SET name = ?, description = ?, discount_type = ?, discount_value = ?,
                min_order_amount = ?, max_discount_amount = ?, start_date = ?, end_date = ?,
                usage_limit = ?, is_active = ?, updated_date = GETDATE()
            WHERE id = ?
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setString(1, coupon.getName());
            pstmt.setString(2, coupon.getDescription());
            pstmt.setString(3, coupon.getDiscountType());
            pstmt.setDouble(4, coupon.getDiscountValue());
            
            if (coupon.getMinOrderAmount() != null) {
                pstmt.setDouble(5, coupon.getMinOrderAmount());
            } else {
                pstmt.setNull(5, Types.DECIMAL);
            }
            
            if (coupon.getMaxDiscountAmount() != null) {
                pstmt.setDouble(6, coupon.getMaxDiscountAmount());
            } else {
                pstmt.setNull(6, Types.DECIMAL);
            }
            
            pstmt.setTimestamp(7, coupon.getStartDate());
            pstmt.setTimestamp(8, coupon.getEndDate());
            
            if (coupon.getUsageLimit() != null) {
                pstmt.setInt(9, coupon.getUsageLimit());
            } else {
                pstmt.setNull(9, Types.INTEGER);
            }
            
            pstmt.setBoolean(10, coupon.isActive());
            pstmt.setInt(11, coupon.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                return new CouponResult(true, "Cập nhật mã giảm giá thành công");
            } else {
                return new CouponResult(false, "Không tìm thấy mã giảm giá để cập nhật");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return new CouponResult(false, "Lỗi hệ thống: " + e.getMessage());
        }
    }
    
    @Override
    public boolean deactivateCoupon(int couponId) {
        String sql = "UPDATE Coupon SET is_active = 0, updated_date = GETDATE() WHERE id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, couponId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<CouponUsage> getUserCouponUsageHistory(int userId) {
        List<CouponUsage> usageHistory = new ArrayList<>();
        String sql = """
            SELECT cu.id, cu.coupon_id, cu.user_id, cu.order_id, cu.discount_amount, cu.used_date,
                   c.code, c.name
            FROM CouponUsage cu
            INNER JOIN Coupon c ON cu.coupon_id = c.id
            WHERE cu.user_id = ?
            ORDER BY cu.used_date DESC
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                CouponUsage usage = new CouponUsage();
                usage.setId(rs.getInt("id"));
                usage.setCouponId(rs.getInt("coupon_id"));
                usage.setUserId(rs.getInt("user_id"));
                usage.setOrderId(rs.getInt("order_id"));
                usage.setDiscountAmount(rs.getDouble("discount_amount"));
                usage.setUsedDate(rs.getTimestamp("used_date"));
                
                // Tạo Coupon object với thông tin cơ bản
                Coupon coupon = new Coupon();
                coupon.setId(rs.getInt("coupon_id"));
                coupon.setCode(rs.getString("code"));
                coupon.setName(rs.getString("name"));
                usage.setCoupon(coupon);
                
                usageHistory.add(usage);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return usageHistory;
    }
    
    @Override
    public List<CouponUsage> getCouponUsageHistory(int couponId) {
        List<CouponUsage> usageHistory = new ArrayList<>();
        String sql = """
            SELECT cu.id, cu.coupon_id, cu.user_id, cu.order_id, cu.discount_amount, cu.used_date,
                   u.name as user_name, u.email as user_email
            FROM CouponUsage cu
            INNER JOIN Users u ON cu.user_id = u.id
            WHERE cu.coupon_id = ?
            ORDER BY cu.used_date DESC
        """;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, couponId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                CouponUsage usage = new CouponUsage();
                usage.setId(rs.getInt("id"));
                usage.setCouponId(rs.getInt("coupon_id"));
                usage.setUserId(rs.getInt("user_id"));
                usage.setOrderId(rs.getInt("order_id"));
                usage.setDiscountAmount(rs.getDouble("discount_amount"));
                usage.setUsedDate(rs.getTimestamp("used_date"));
                
                usageHistory.add(usage);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return usageHistory;
    }
    
    @Override
    public boolean hasUserUsedCoupon(int couponId, int userId) {
        String sql = "SELECT COUNT(*) as count FROM CouponUsage WHERE coupon_id = ? AND user_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            
            pstmt.setInt(1, couponId);
            pstmt.setInt(2, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Helper method để map ResultSet thành Coupon object
     */
    private Coupon mapResultSetToCoupon(ResultSet rs) throws SQLException {
        Coupon coupon = new Coupon();
        
        coupon.setId(rs.getInt("id"));
        coupon.setCode(rs.getString("code"));
        coupon.setName(rs.getString("name"));
        coupon.setDescription(rs.getString("description"));
        coupon.setDiscountType(rs.getString("discount_type"));
        coupon.setDiscountValue(rs.getDouble("discount_value"));
        
        // Handle nullable fields
        double minOrderAmount = rs.getDouble("min_order_amount");
        if (!rs.wasNull()) {
            coupon.setMinOrderAmount(minOrderAmount);
        }
        
        double maxDiscountAmount = rs.getDouble("max_discount_amount");
        if (!rs.wasNull()) {
            coupon.setMaxDiscountAmount(maxDiscountAmount);
        }
        
        coupon.setStartDate(rs.getTimestamp("start_date"));
        coupon.setEndDate(rs.getTimestamp("end_date"));
        
        int usageLimit = rs.getInt("usage_limit");
        if (!rs.wasNull()) {
            coupon.setUsageLimit(usageLimit);
        }
        
        coupon.setUsageCount(rs.getInt("usage_count"));
        coupon.setActive(rs.getBoolean("is_active"));
        coupon.setCreatedBy(rs.getInt("created_by"));
        coupon.setCreatedDate(rs.getTimestamp("created_date"));
        coupon.setUpdatedDate(rs.getTimestamp("updated_date"));
        
        return coupon;
    }
}