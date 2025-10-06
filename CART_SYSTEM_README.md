# Hệ thống Giỏ hàng - Shopping Cart System

## Tổng quan
Hệ thống giỏ hàng được xây dựng theo mô hình MVC với các tính năng:
- ✅ Thêm sản phẩm vào giỏ hàng với kiểm tra tồn kho
- ✅ Cập nhật số lượng sản phẩm trong giỏ hàng
- ✅ Xóa sản phẩm khỏi giỏ hàng
- ✅ Checkout và tạo đơn hàng
- ✅ Tự động trừ số lượng tồn kho khi đặt hàng
- ✅ Cập nhật real-time số lượng tồn kho
- ✅ Xem lịch sử đơn hàng
- ✅ Quản lý trạng thái đơn hàng

## Cấu trúc Database

### Bảng Orders
```sql
Orders (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'PENDING'
)
```

### Bảng OrderDetails
```sql
OrderDetails (
    id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
)
```

## Cấu trúc MVC

### 1. Models
- **Order.java**: Model cho đơn hàng
- **OrderDetail.java**: Model cho chi tiết đơn hàng
- **CartItem.java**: Model cho item trong giỏ hàng

### 2. DAO Layer
- **IOrderDAO.java**: Interface cho Order DAO
- **OrderDAO.java**: Implementation của Order DAO với transaction support

### 3. Service Layer
- **CartService.java**: Business logic cho giỏ hàng
- **OrderService.java**: Business logic cho đơn hàng

### 4. Controllers
- **CartServlet.java**: Xử lý các thao tác với giỏ hàng
- **CheckoutServlet.java**: Xử lý thanh toán
- **OrderServlet.java**: Xử lý đơn hàng và lịch sử

### 5. Views
- **productList.jsp**: Danh sách sản phẩm với chức năng thêm vào giỏ
- **cart.jsp**: Trang giỏ hàng
- **checkout.jsp**: Trang thanh toán
- **order-history.jsp**: Lịch sử đơn hàng

## Tính năng chính

### 1. Thêm vào giỏ hàng
```javascript
// JavaScript function để thêm sản phẩm
function addToCart(productId) {
    const quantity = document.getElementById('qty-' + productId).value;
    fetch('/cart', {
        method: 'POST',
        body: 'action=add&productId=' + productId + '&quantity=' + quantity
    });
}
```

### 2. Kiểm tra tồn kho
- Kiểm tra số lượng tồn kho trước khi thêm vào giỏ
- Cập nhật real-time khi admin thay đổi tồn kho
- Hiển thị cảnh báo khi hết hàng

### 3. Checkout với Transaction
```java
@Override
public int processCheckout(Order order) {
    Connection conn = null;
    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); // Bắt đầu transaction
        
        // 1. Kiểm tra tồn kho
        // 2. Tạo order
        // 3. Thêm order details
        // 4. Cập nhật tồn kho
        
        conn.commit(); // Commit nếu thành công
        return orderId;
    } catch (Exception e) {
        conn.rollback(); // Rollback nếu có lỗi
        return -1;
    }
}
```

### 4. Quản lý trạng thái đơn hàng
- **PENDING**: Chờ xử lý
- **PROCESSING**: Đang xử lý
- **SHIPPED**: Đang giao hàng
- **COMPLETED**: Hoàn thành
- **CANCELLED**: Đã hủy

## API Endpoints

### Cart API
- `GET /cart` - Xem giỏ hàng
- `POST /cart?action=add` - Thêm sản phẩm
- `POST /cart?action=update` - Cập nhật số lượng
- `POST /cart?action=remove` - Xóa sản phẩm
- `POST /cart?action=clear` - Xóa toàn bộ giỏ hàng

### Checkout API
- `GET /checkout` - Trang thanh toán
- `POST /checkout?action=process` - Xử lý đặt hàng
- `POST /checkout?action=validate` - Kiểm tra giỏ hàng

### Orders API
- `GET /orders` - Lịch sử đơn hàng
- `GET /orders?action=view&orderId=X` - Chi tiết đơn hàng
- `POST /orders?action=cancel` - Hủy đơn hàng
- `POST /orders?action=updateStatus` - Cập nhật trạng thái (Admin)

## Cài đặt và chạy

### 1. Database Setup
```sql
-- Chạy script database_setup.sql để tạo bảng
sqlcmd -S localhost -d YourDatabase -i database_setup.sql
```

### 2. Configuration
- Cập nhật `DBConnection.java` với thông tin database
- Đảm bảo các JAR files cần thiết trong `/WEB-INF/lib/`

### 3. Deploy
- Deploy vào Tomcat server
- Truy cập: `http://localhost:8080/your-app/products`

## Bảo mật và Validation

### 1. Session Management
- Kiểm tra đăng nhập cho tất cả các thao tác
- Phân quyền Admin/User

### 2. Input Validation
- Validate số lượng sản phẩm
- Kiểm tra tồn kho trước khi thêm vào giỏ
- SQL injection prevention với PreparedStatement

### 3. Transaction Integrity
- Sử dụng database transaction cho checkout
- Rollback tự động khi có lỗi
- Kiểm tra concurrent access

## Tối ưu hóa

### 1. Database
- Index trên các cột thường truy vấn
- Foreign key constraints
- Check constraints cho data validation

### 2. Performance
- Connection pooling
- Caching session cart
- Lazy loading cho order details

### 3. User Experience
- AJAX cho thao tác không reload page
- Real-time cập nhật số lượng giỏ hàng
- Auto-refresh stock information

## Troubleshooting

### Lỗi thường gặp:
1. **Không thêm được vào giỏ hàng**: Kiểm tra session và tồn kho
2. **Checkout thất bại**: Xem log transaction và database connection
3. **Số lượng không cập nhật**: Kiểm tra ProductDAO.updateStock()

### Debug Tips:
- Bật logging trong OrderDAO và CartService
- Kiểm tra browser console cho AJAX errors
- Verify database foreign key relationships

## Phát triển thêm

### Tính năng có thể thêm:
- [ ] Voucher/Discount system
- [ ] Email notification sau khi đặt hàng
- [ ] Product reviews và ratings
- [ ] Wishlist functionality
- [ ] Advanced search và filter
- [ ] Payment gateway integration
- [ ] Inventory alerts cho Admin
- [ ] Order tracking system