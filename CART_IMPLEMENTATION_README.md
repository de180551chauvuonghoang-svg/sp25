# Shopping Cart with Database Triggers Implementation

## 📋 Tổng quan

Dự án đã được chuyển đổi từ việc xử lý giỏ hàng trong session sang sử dụng database với triggers để quản lý tự động các nghiệp vụ giỏ hàng.

## 🔄 Các thay đổi chính

### 1. Database Schema & Triggers

#### **Triggers đã thêm:**

- **`tr_Cart_CheckStock`**: Kiểm tra số lượng tồn kho khi thêm vào giỏ hàng
- **`tr_Cart_UpdateStock`**: Kiểm tra và cập nhật khi sửa số lượng trong giỏ hàng  
- **`tr_OrderDetails_UpdateStock`**: Cập nhật tồn kho khi checkout thành công
- **`tr_Product_StatusUpdate`**: Tự động cập nhật trạng thái sản phẩm khi stock thay đổi
- **`tr_Orders_ClearCart`**: Xóa giỏ hàng khi checkout thành công

#### **Stored Procedures:**

- **`sp_AddToCart`**: Thêm sản phẩm vào giỏ hàng với validation đầy đủ
- **`sp_UpdateCart`**: Cập nhật số lượng trong giỏ hàng
- **`sp_Checkout`**: Thực hiện checkout với kiểm tra tự động

#### **Functions:**

- **`fn_IsProductAvailable`**: Kiểm tra sản phẩm có sẵn để mua không

### 2. Model Classes

#### **CartItem.java**
- Thêm fields: `id`, `addedDate`, `updatedDate`
- Hỗ trợ mapping với database Cart table

#### **Product.java**  
- Thêm field `status` (AVAILABLE/OUT_OF_STOCK)
- Auto-update status dựa trên stock
- Helper methods: `isAvailable()`, `isOutOfStock()`

### 3. DAO Layer

#### **CartDAO.java** (Mới)
- **`addToCart()`**: Sử dụng stored procedure với trigger validation
- **`updateCart()`**: Cập nhật số lượng với kiểm tra tồn kho
- **`getCartItems()`**: Lấy giỏ hàng từ database với thông tin product đầy đủ
- **`checkout()`**: Thực hiện checkout với stored procedure
- **`isProductAvailable()`**: Kiểm tra tính khả dụng
- Inner classes: `CartResult`, `CheckoutResult` cho kết quả trả về

#### **ProductDAO.java**
- Cập nhật để lấy field `status` từ database
- Tất cả methods đều include status trong query

### 4. Controller Layer

#### **CartServlet.java**
- **Thay đổi từ session sang database:**
  - `addToCart()`: Sử dụng `CartDAO.addToCart()` với trigger validation
  - `updateCart()`: Sử dụng `cartId` thay vì `productId`
  - `getCart()`: Lấy từ database thay vì session
  - `cartCount()`: Đếm từ database

#### **CheckoutServlet.java**
- **Simplified checkout process:**
  - Sử dụng `CartDAO.checkout()` với stored procedure
  - Triggers tự động xử lý stock validation và update
  - Tự động xóa giỏ hàng sau checkout thành công

### 5. View Layer (JSP)

#### **cart.jsp**
- Hiển thị trạng thái sản phẩm (available/out-of-stock)
- Sử dụng `cartId` thay vì `productId` cho các actions
- Disable controls cho sản phẩm hết hàng
- CSS styling cho trạng thái out-of-stock

#### **productList.jsp**
- Real-time stock status display
- Disable "Add to Cart" button cho sản phẩm hết hàng
- Visual indicators cho stock levels
- Auto-refresh sau khi add to cart

## 🚀 Các tính năng mới

### 1. **Automatic Stock Management**
- Triggers tự động kiểm tra và cập nhật tồn kho
- Không cho phép mua vượt quá số lượng có sẵn
- Tự động cập nhật status sản phẩm

### 2. **Real-time UI Updates**
- Sản phẩm hết hàng được làm mờ và disable
- Stock warnings hiển thị trong giỏ hàng
- Auto-refresh product list sau khi thêm vào giỏ hàng

### 3. **Enhanced Error Handling**
- Trigger validation với error messages chi tiết
- Graceful handling cho các edge cases
- User-friendly error messages

### 4. **Database Integrity**
- Transaction-based operations
- Atomic checkout process
- Consistent data state

## 📊 Workflow mới

### **Add to Cart Flow:**
1. User clicks "Thêm vào giỏ hàng"
2. `CartServlet.addToCart()` calls `CartDAO.addToCart()`
3. `sp_AddToCart` stored procedure executes
4. `tr_Cart_CheckStock` trigger validates:
   - Product exists and available
   - Quantity not exceeds stock
   - Updates existing cart item or creates new
5. Return success/error to user interface
6. UI updates cart count and product display

### **Checkout Flow:**
1. User proceeds to checkout
2. `CheckoutServlet` calls `CartDAO.checkout()`
3. `sp_Checkout` stored procedure:
   - Validates cart is not empty
   - Creates order record
   - Inserts order details (triggers `tr_OrderDetails_UpdateStock`)
   - `tr_OrderDetails_UpdateStock` validates and updates stock
   - `tr_Product_StatusUpdate` updates product status if needed
   - Clears cart automatically
4. Email confirmation sent
5. Redirect to success page

### **Stock Update Flow (Admin):**
1. Admin updates product stock
2. `tr_Product_StatusUpdate` trigger automatically:
   - Sets status to 'AVAILABLE' if stock > 0
   - Sets status to 'OUT_OF_STOCK' if stock = 0
3. Customer UI immediately reflects changes

## 🔧 Cách chạy

1. **Database Setup:**
   ```sql
   -- Execute script1.sql để tạo triggers và stored procedures
   ```

2. **Application Deployment:**
   - Deploy updated Java classes
   - No additional configuration needed

3. **Testing:**
   - Test add to cart với quantities khác nhau
   - Test checkout process
   - Test admin stock updates
   - Verify UI updates real-time

## 💡 Lợi ích của approach mới

1. **Data Consistency**: Database triggers đảm bảo data integrity
2. **Performance**: Reduced Java processing, delegated to database
3. **Scalability**: Multiple users concurrent access được handle tốt hơn
4. **Maintainability**: Business logic tập trung trong database
5. **Real-time**: UI phản ánh ngay lập tức thay đổi từ database

## 🎯 Next Steps

1. Implement caching cho product data
2. Add WebSocket cho real-time stock updates
3. Implement inventory alerts cho admin
4. Add product reservation functionality
5. Implement wishlist với similar approach