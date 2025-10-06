# ✅ SỬA LỖI 404 CHECKOUT PAGE - HƯỚNG DẪN MANUAL

## 🚨 **VẤN ĐỀ HIỆN TẠI:**
- Lỗi 404 khi truy cập `/checkout`
- Jakarta Servlet API không được nhận diện trong IDE
- Cần refresh và rebuild project

## 🔧 **HƯỚNG DẪN SỬA LỖI TRONG NETBEANS:**

### Bước 1: Refresh Libraries
1. **Mở NetBeans IDE**
2. **Chuột phải vào project** → **Properties**
3. **Libraries** → **Compile** → **Add JAR/Folder**
4. **Navigate đến**: `web/WEB-INF/lib/`
5. **Chọn tất cả JAR files**:
   - ✅ `jakarta.servlet-api-6.0.0.jar` ← **QUAN TRỌNG**
   - ✅ `jakarta.mail-1.6.7.jar`
   - ✅ `javax.mail-1.6.2.jar`
   - ✅ `gson-2.10.1.jar`
   - ✅ `jakarta.servlet.jsp.jstl-2.0.0.jar`
   - ✅ `jakarta.servlet.jsp.jstl-api-2.0.0.jar`
   - ✅ `json-20250517.jar`
   - ✅ `sqljdbc4-3.0.jar`

### Bước 2: Clean & Build
1. **Chuột phải vào project** → **Clean and Build**
2. **Chờ build xong** (không có lỗi compile)
3. **Nếu vẫn lỗi**: **Chuột phải** → **Clean** → **Build**

### Bước 3: Deploy/Restart Server
1. **Stop Tomcat** server
2. **Undeploy project** (nếu đã deploy)
3. **Deploy lại project**
4. **Start Tomcat**

### Bước 4: Test Checkout
1. **Login vào hệ thống**
2. **Add products vào cart**
3. **Go to Cart** → Click **"Checkout"**
4. **Kết quả mong đợi**: Trang checkout.jsp hiển thị đẹp

## 📁 **FILES ĐÃ TẠO:**

✅ **checkout.jsp** - Trang checkout với Bootstrap
✅ **CheckoutServlet.java** - Servlet xử lý GET/POST
✅ **web.xml** - Đã có mapping `/checkout`
✅ **JAR Files** - Đã tải đầy đủ dependencies

## 🔗 **URL TESTING:**

- **Cart**: `localhost:8080/cart`
- **Checkout**: `localhost:8080/checkout` ← Sẽ hoạt động sau khi rebuild
- **Success**: `localhost:8080/cart/success.jsp`

## ⚠️ **NẾU VẪN LỖI 404:**

### Option 1: Check Servlet Mapping
```xml
<!-- Trong web.xml, đảm bảo có: -->
<servlet>
    <servlet-name>CheckoutServlet</servlet-name>
    <servlet-class>controller.CheckoutServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>CheckoutServlet</servlet-name>
    <url-pattern>/checkout</url-pattern>
</servlet-mapping>
```

### Option 2: Check Classes Directory
1. **Vào** `build/web/WEB-INF/classes/controller/`
2. **Kiểm tra** có `CheckoutServlet.class` không
3. **Nếu không có**: Build lại project

### Option 3: Direct JSP Access
- **Test**: `localhost:8080/checkout.jsp`
- **Nếu hiển thị được**: Problem ở servlet
- **Nếu không**: Problem ở JSP

## 🎯 **KẾT QUẢ MONG ĐỢI:**

Sau khi làm theo hướng dẫn, `/checkout` sẽ hiển thị:
- ✅ Form thông tin khách hàng
- ✅ Danh sách sản phẩm trong cart  
- ✅ Tổng tiền đơn hàng
- ✅ Button "Place Order" hoạt động

**🚀 Checkout system sẽ hoạt động hoàn hảo!**