# 🚨 FIX LỖI JAKARTA SERVLET API - CHECKOUT 404

## ❌ **VẤN ĐỀ CHÍNH:**
- Jakarta Servlet API không được nhận diện trong project
- CheckoutServlet không compile được → 404 error
- Cần add dependencies đúng cách

## 🔧 **GIẢI PHÁP TRONG NETBEANS:**

### Bước 1: Add Jakarta Servlet API
1. **Chuột phải project** → **Properties**
2. **Categories** → **Libraries**
3. **Compile-time Libraries** → **Add JAR/Folder**
4. **Navigate to**: `web/WEB-INF/lib/jakarta.servlet-api-6.0.0.jar`
5. **Add file** → **OK**

### Bước 2: Clean and Build
1. **Chuột phải project** → **Clean and Build**
2. **Chờ build xong** (không có compile error)
3. **Check console** - không có lỗi Jakarta imports

### Bước 3: Deploy lại
1. **Stop Tomcat** server
2. **Undeploy** project nếu đã deploy
3. **Deploy** lại project
4. **Start Tomcat**

## 🧪 **TEST SERVLET:**

Tôi đã tạo **TestCheckoutServlet** để test:
- **URL**: `localhost:8080/SP25_Demo_MainController/test-checkout`
- **Không dùng Jakarta** → sẽ work ngay
- **Test cart clearing** và success page

## 📝 **FILES CẦN KIỂM TRA:**

1. **CheckoutServlet.java** - Có compile errors do Jakarta
2. **TestCheckoutServlet.java** - Simple test servlet  
3. **cart.jsp** - Đã sửa button trỏ đến test-checkout
4. **jakarta.servlet-api-6.0.0.jar** - Phải có trong lib

## ⚡ **QUICK FIX:**

Nếu vẫn lỗi, thử:
1. **Test button** → Click "Test Checkout" trong cart
2. **Nếu work** → Problem ở Jakarta dependencies  
3. **Nếu không work** → Problem ở servlet mapping/deployment

## 🎯 **KẾT QUẢ MONG ĐỢI:**

Sau khi fix dependencies:
- ✅ CheckoutServlet compile thành công
- ✅ Button "Checkout" hoạt động  
- ✅ Redirect đến success page
- ✅ Cart được clear
- ✅ Hiển thị thông báo thành công

## 🚀 **ALTERNATE SOLUTION:**

Nếu Jakarta vẫn không work, có thể:
1. **Dùng javax.servlet** thay vì jakarta.servlet
2. **Copy TestCheckoutServlet** logic vào CheckoutServlet
3. **Thay jakarta imports** thành javax imports

**Test ngay bằng "Test Checkout" button! 🎯**