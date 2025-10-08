# PRJ301 - Product Management System

## Mô tả dự án
Đây là một ứng dụng web quản lý sản phẩm được phát triển theo mô hình MVC (Model-View-Controller) cho môn học PRJ301.

## Yêu cầu hệ thống
- JDK 24
- Apache Tomcat 10.x
- SQL Server 2019/2022
- NetBeans IDE (hoặc IDE khác hỗ trợ Java Web)

## Cấu trúc dự án

### 1. Database Layer
- **dao/DBConnection.java**: Lớp quản lý kết nối database
- **s1.sql**: Script tạo database và dữ liệu mẫu

### 2. Model Layer
- **model/User.java**: Model cho bảng User_YourID
- **model/Product.java**: Model cho bảng Product_YourID

### 3. DAO Layer
- **userDao/IUserDAO.java**: Interface cho User DAO
- **userDao/UserDAO.java**: Implementation User DAO
- **productDao/IProductDAO.java**: Interface cho Product DAO  
- **productDao/ProductDAO.java**: Implementation Product DAO

### 4. Service Layer (Business Logic)
- **service/IUserService.java**: Interface User Service
- **service/UserService.java**: Implementation User Service
- **service/IProductService.java**: Interface Product Service
- **service/ProductService.java**: Implementation Product Service

### 5. Controller Layer
- **controller/LoginController.java**: Servlet xử lý đăng nhập
- **controller/ProductServlet.java**: Servlet xử lý sản phẩm

### 6. View Layer (JSP)
- **login.jsp**: Trang đăng nhập
- **viewAllProduct.jsp**: Trang hiển thị danh sách sản phẩm
- **invalid.jsp**: Trang thông báo đăng nhập thất bại
- **testDatabase.jsp**: Trang test kết nối database

## Cài đặt và chạy

### 1. Setup Database
1. Chạy SQL Server Management Studio
2. Thực thi file `s1.sql` để tạo database `PRJ301_DE180551`
3. Kiểm tra dữ liệu đã được tạo thành công

### 2. Config Database Connection
Mở file `src/java/dao/DBConnection.java` và kiểm tra thông tin kết nối:
```java
public static String dbURL = "jdbc:sqlserver://localhost:1433;databaseName=PRJ301_DE180551;encrypt=true;trustServerCertificate=true;";
public static String userDB = "sa";
public static String passDB = "1234";
```

### 3. Setup Project trong NetBeans
1. Mở NetBeans IDE
2. File -> Open Project -> Chọn thư mục WebApplication1
3. Right-click project -> Properties -> Libraries
4. Add Library: Jakarta EE Web API (hoặc Servlet API tương ứng với Tomcat 10)
5. Add SQL Server JDBC Driver (đã có trong WEB-INF/lib)

### 4. Deploy và chạy
1. Right-click project -> Run
2. Hoặc Deploy to Tomcat server manually

## Test ứng dụng

### 1. Test Database Connection
- Truy cập: `http://localhost:8080/WebApplication1/testDatabase.jsp`
- Kiểm tra kết nối database và dữ liệu

### 2. Test Login
- Truy cập: `http://localhost:8080/WebApplication1/`
- Sử dụng tài khoản demo:

#### Admin accounts:
- Username: `sa`, Password: `123456`
- Username: `admin`, Password: `abc@123`
- Username: `sa1`, Password: `123`

#### User accounts:
- Username: `An Binh`, Password: `111`
- Username: `An`, Password: `222`
- Username: `Binh An`, Password: `333`

## Tính năng

### Admin (sau khi đăng nhập):
- Xem tất cả sản phẩm sắp xếp theo category
- Thêm, sửa, xóa sản phẩm
- Tìm kiếm sản phẩm theo giá

### User thường (sau khi đăng nhập):
- Xem sản phẩm sắp xếp theo ngày nhập (ImportDate)
- Tìm kiếm sản phẩm theo giá
- Chỉ xem, không thể thêm/sửa/xóa

## Database Schema

### Bảng User_YourID
```sql
UserID INT PRIMARY KEY
UserName NVARCHAR(50) NOT NULL UNIQUE
Password NVARCHAR(50) NOT NULL
Role NVARCHAR(10) NOT NULL CHECK (Role IN ('admin', 'user'))
```

### Bảng Product_YourID
```sql
ProductID VARCHAR(10) PRIMARY KEY
ProductName NVARCHAR(100) NOT NULL
Price BIGINT NOT NULL
ImportDate DATE NOT NULL
Category NVARCHAR(50) NOT NULL
```

## Troubleshooting

### Lỗi kết nối database:
1. Kiểm tra SQL Server đang chạy
2. Kiểm tra username/password trong DBConnection.java
3. Kiểm tra SQL Server Authentication mode
4. Enable TCP/IP protocol cho SQL Server

### Lỗi Servlet API:
1. Đảm bảo đã add Jakarta EE Web API library
2. Với Tomcat 10, sử dụng Jakarta namespace thay vì javax

### Lỗi JDBC Driver:
1. Kiểm tra file `mssql-jdbc-13.2.0.jre8.jar` trong WEB-INF/lib
2. Add driver vào classpath nếu cần

## Tác giả
- Student ID: DE180551
- Course: PRJ301
- Semester: [Semester Info]

## Ghi chú
Project này được phát triển theo yêu cầu đề thi PRJ301 Practice Exam với thời gian 90 phút.