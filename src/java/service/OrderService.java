package service;

import orderDao.OrderDAO;
import orderDao.IOrderDAO;
import model.Order;
import model.CartItem;
import java.util.List;

public class OrderService {
    private IOrderDAO orderDao;
    
    public OrderService() {
        this.orderDao = new OrderDAO();
    }
    
    public int createOrderFromCart(int userId, List<CartItem> cart) {
        // Tính tổng giá trị đơn hàng
        double totalPrice = 0;
        for (CartItem item : cart) {
            totalPrice += item.getProduct().getPrice() * item.getQuantity();
        }
        
        // Tạo đơn hàng
        Order order = new Order(0, userId, totalPrice, "PENDING");
        int orderId = orderDao.createOrder(order);
        
        // Thêm chi tiết đơn hàng
        if (orderId > 0) {
            for (CartItem item : cart) {
                orderDao.addOrderDetail(orderId, item.getProduct().getId(), 
                                      item.getQuantity(), item.getProduct().getPrice());
            }
        }
        
        return orderId;
    }
    
    public List<Order> getAllOrders() {
        return orderDao.selectAllOrders();
    }
    
    public Order getOrderById(int id) {
        return orderDao.getOrderById(id);
    }
}