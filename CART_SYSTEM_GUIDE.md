# 🛒 HƯỚNG DẪN SỬ DỤNG HỆ THỐNG GIỎ HÀNG

## 📋 TỔNG QUAN TÍNH NĂNG

Hệ thống giỏ hàng đã được tích hợp đầy đủ với các tính năng:

### ✅ **TÍNH NĂNG CHÍNH**
1. **Thêm sản phẩm vào giỏ hàng** - Kiểm tra stock tự động
2. **Quản lý giỏ hàng** - Cập nhật số lượng, xóa sản phẩm
3. **Kiểm tra stock real-time** - Cập nhật số lượng khi stock thay đổi
4. **Thanh toán (Checkout)** - Đặt hàng và trừ stock tự động
5. **Quản lý đơn hàng** - Lưu trữ chi tiết đơn hàng

---

## 🚀 HƯỚNG DẪN SỬ DỤNG

### **1. CHO CUSTOMER:**

#### 🛍️ **Thêm sản phẩm vào giỏ**
- Truy cập: `Dashboard` hoặc `Danh sách sản phẩm`
- Chọn số lượng (không vượt quá stock)
- Click "Thêm vào giỏ"
- Hệ thống sẽ kiểm tra stock và thông báo

#### 🛒 **Quản lý giỏ hàng**
- Click biểu tượng giỏ hàng hoặc truy cập `/cart`
- **Cập nhật số lượng**: Thay đổi số lượng → Click "Cập nhật"
- **Xóa sản phẩm**: Click "Xóa" → Xác nhận
- **Xóa toàn bộ**: Click "Xóa toàn bộ" → Xác nhận

#### 💳 **Thanh toán**
- Trong giỏ hàng, click "Thanh toán ngay"
- Điền thông tin giao hàng (họ tên, email, phone, địa chỉ)
- Kiểm tra lại đơn hàng
- Click "Đặt hàng ngay"
- Hệ thống sẽ:
  - Trừ stock sản phẩm
  - Tạo đơn hàng
  - Xóa giỏ hàng
  - Hiển thị trang thành công

### **2. CHO ADMIN:**

#### 📦 **Quản lý stock sản phẩm**
- Truy cập: `Quản lý sản phẩm`
- Cập nhật số lượng sản phẩm
- Customer sẽ thấy số lượng mới ngay lập tức
- Nếu customer có sản phẩm trong giỏ vượt quá stock mới → tự động điều chỉnh

#### 📊 **Theo dõi đơn hàng**
- Các đơn hàng được lưu trong bảng `Orders` và `OrderDetails`
- Admin có thể xem chi tiết đơn hàng và trạng thái

---

## 🏗️ CẤU TRÚC HỆ THỐNG

### **📁 Files đã tạo/cập nhật:**

```
src/java/
├── model/
│   └── CartItem.java              ✅ NEW - Model cho item trong giỏ
├── controller/
│   ├── CartServlet.java           ✅ NEW - Xử lý giỏ hàng
│   └── CheckoutServlet.java       ✅ NEW - Xử lý thanh toán
├── productDao/
│   ├── IProductDAO.java           ✅ UPDATED - Thêm method cập nhật stock
│   └── ProductDAO.java            ✅ UPDATED - Implement stock methods

web/
├── cart.jsp                       ✅ NEW - Trang giỏ hàng
├── checkout.jsp                   ✅ NEW - Trang thanh toán
├── checkout-success.jsp           ✅ NEW - Trang thành công
├── dashboard.jsp                  ✅ UPDATED - Thêm add to cart
└── productListCart.jsp            ✅ UPDATED - Hiển thị stock
```

### **🗄️ Database Tables:**

```sql
Orders:
- id (PK, Auto)
- userId (FK)
- totalPrice
- status (PENDING/COMPLETED/CANCELLED)
- orderDate
- customerName
- customerEmail

OrderDetails:
- id (PK, Auto)
- orderId (FK)
- productId (FK)
- quantity
- price
```

---

## 🔄 FLOW HOẠT ĐỘNG

### **📱 Customer Flow:**
```
1. Login → Dashboard
2. Xem sản phẩm → Thêm vào giỏ (kiểm tra stock)
3. Quản lý giỏ hàng (cập nhật/xóa)
4. Checkout → Điền thông tin
5. Đặt hàng → Trừ stock → Tạo order → Success
```

### **👨‍💼 Admin Flow:**
```
1. Login → Dashboard Admin
2. Quản lý sản phẩm → Cập nhật stock
3. Customer thấy stock mới ngay lập tức
4. Theo dõi đơn hàng từ database
```

---

## ⚡ TÍNH NĂNG NỔI BẬT

### **🔒 Bảo mật & Validation:**
- ✅ Kiểm tra đăng nhập trước khi thao tác
- ✅ Validation số lượng không vượt quá stock
- ✅ Kiểm tra stock real-time trước khi checkout
- ✅ Transaction safety khi trừ stock

### **🎯 User Experience:**
- ✅ Hiển thị số lượng trong giỏ hàng real-time
- ✅ Cập nhật stock tự động khi admin thay đổi
- ✅ Thông báo rõ ràng khi hết hàng/vượt quá stock
- ✅ Auto-refresh stock info (30s)
- ✅ Responsive design cho mobile

### **📈 Performance:**
- ✅ Session-based cart (không cần database cho cart)
- ✅ Efficient stock checking
- ✅ Pagination cho danh sách sản phẩm
- ✅ Minimal database queries

---

## 🧪 TESTING

### **Test Cases:**
1. **Add to Cart**: Thêm sản phẩm với số lượng khác nhau
2. **Stock Validation**: Thử thêm vượt quá stock
3. **Cart Management**: Cập nhật/xóa sản phẩm trong giỏ
4. **Stock Update**: Admin thay đổi stock → Customer thấy ngay
5. **Checkout**: Đặt hàng thành công → Kiểm tra stock bị trừ
6. **Edge Cases**: Hết hàng, đăng xuất giữa chừng, multiple users

### **URLs để test:**
- Cart: `http://localhost:8080/SP25_Demo_MainController/cart`
- Checkout: `http://localhost:8080/SP25_Demo_MainController/checkout`
- Product List: `http://localhost:8080/SP25_Demo_MainController/productListCart.jsp`

---

## 🔧 TROUBLESHOOTING

### **Lỗi thường gặp:**

1. **Cart không hiển thị**
   - Check session có tồn tại không
   - Kiểm tra user đã login chưa

2. **Không thêm được vào giỏ**
   - Kiểm tra stock sản phẩm
   - Check CartServlet mapping trong web.xml

3. **Checkout lỗi 404**
   - Kiểm tra CheckoutServlet đã compile chưa
   - Check Jakarta dependencies

4. **Stock không cập nhật**
   - Kiểm tra ProductDAO.decreaseStock() method
   - Check database connection

---

## 🎯 KẾT QUẢ MONG ĐỢI

Sau khi implement xong, hệ thống sẽ có:

✅ **Giỏ hàng hoàn chỉnh** với đầy đủ tính năng CRUD  
✅ **Stock management** real-time giữa admin và customer  
✅ **Checkout process** hoàn chỉnh với validation  
✅ **Order tracking** với database lưu trữ  
✅ **User-friendly interface** với thông báo rõ ràng  
✅ **Mobile responsive** cho mọi thiết bị  

---

**🎉 Chúc bạn sử dụng hệ thống thành công!**