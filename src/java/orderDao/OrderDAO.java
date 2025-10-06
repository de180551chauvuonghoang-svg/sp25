package orderDao;

import dao.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Order;

public class OrderDAO implements IOrderDAO {
    
    private static final String INSERT_ORDER = "INSERT INTO Orders (user_id, total_price, status) VALUES (?, ?, ?)";
    private static final String SELECT_ORDER_BY_ID = "SELECT * FROM Orders WHERE id = ?";
    private static final String SELECT_ALL_ORDERS = "SELECT * FROM Orders";
    private static final String DELETE_ORDER = "DELETE FROM Orders WHERE id = ?";
    private static final String UPDATE_ORDER = "UPDATE Orders SET user_id = ?, total_price = ?, status = ? WHERE id = ?";
    private static final String INSERT_ORDER_DETAIL = "INSERT INTO OrderDetails (order_id, product_id, quantity, price, subtotal) VALUES (?, ?, ?, ?, ?)";

    @Override
    public void insertOrder(Order orderObj) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_ORDER)) {
            
            stmt.setInt(1, orderObj.getUserId());
            stmt.setDouble(2, orderObj.getTotalPrice());
            stmt.setString(3, orderObj.getStatus());
            stmt.executeUpdate();
        }
    }

    @Override
    public Order getOrderById(int id) {
        Order order = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ORDER_BY_ID)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                order = Order.fromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    @Override
    public List<Order> selectAllOrders() {
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery(SELECT_ALL_ORDERS);
            while (rs.next()) {
                orders.add(Order.fromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    @Override
    public boolean deleteOrder(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_ORDER)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateOrder(Order orderObj) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_ORDER)) {
            
            stmt.setInt(1, orderObj.getUserId());
            stmt.setDouble(2, orderObj.getTotalPrice());
            stmt.setString(3, orderObj.getStatus());
            stmt.setInt(4, orderObj.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }

    @Override
    public int createOrder(Order order) {
        int orderId = -1;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, order.getUserId());
            stmt.setDouble(2, order.getTotalPrice());
            stmt.setString(3, order.getStatus());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    orderId = generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderId;
    }

    @Override
    public void addOrderDetail(int orderId, int productId, int quantity, double price) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_ORDER_DETAIL)) {
            
            double subtotal = quantity * price;
            stmt.setInt(1, orderId);
            stmt.setInt(2, productId);
            stmt.setInt(3, quantity);
            stmt.setDouble(4, price);
            stmt.setDouble(5, subtotal);
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}