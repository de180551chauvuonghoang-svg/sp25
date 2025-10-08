-- 1. Tạo Database
-- Thay thế 'YourID' bằng mã số sinh viên hoặc một ID duy nhất của bạn.
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'PRJ301_YourID')
BEGIN
    CREATE DATABASE PRJ301_DE180551;
END
GO

-- Sử dụng Database vừa tạo
USE PRJ301_DE180551;
GO

-- 2. Tạo bảng User_YourID
IF OBJECT_ID('User_YourID', 'U') IS NOT NULL
    DROP TABLE User_YourID;
GO

CREATE TABLE User_YourID (
    UserID INT PRIMARY KEY,
    UserName NVARCHAR(50) NOT NULL UNIQUE,
    Password NVARCHAR(50) NOT NULL,
    Role NVARCHAR(10) NOT NULL CHECK (Role IN ('admin', 'user'))
);
GO

-- Chèn dữ liệu mẫu vào bảng User_YourID (tối thiểu 5 hàng)
INSERT INTO User_YourID (UserID, UserName, Password, Role) VALUES
(10, N'sa', N'123456', N'admin'),
(11, N'admin', N'abc@123', N'admin'),
(12, N'sa1', N'123', N'admin'),
(13, N'An Binh', N'111', N'user'),
(14, N'An', N'222', N'user'),
(15, N'Binh An', N'333', N'user');
GO

-- 3. Tạo bảng Product_YourID
IF OBJECT_ID('Product_YourID', 'U') IS NOT NULL
    DROP TABLE Product_YourID;
GO

CREATE TABLE Product_YourID (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    -- Dùng MONEY hoặc BIGINT để lưu trữ số tiền lớn như 35.000.000
    Price BIGINT NOT NULL, 
    ImportDate DATE NOT NULL,
    Category NVARCHAR(50) NOT NULL
);
GO

-- Chèn dữ liệu mẫu vào bảng Product_YourID (tối thiểu 5 hàng)
-- Lưu ý: Định dạng ngày tháng phải tuân thủ chuẩn SQL Server (thường là YYYY-MM-DD)
INSERT INTO Product_YourID (ProductID, ProductName, Price, ImportDate, Category) VALUES
(N'P001', N'Samsung Galaxy Z Fold5', 35000000, '2022-01-01', N'SamSung'),
(N'P002', N'IPhone 15 Pro', 33000000, '2023-12-06', N'Iphone'),
(N'P003', N'IPhone 13Pro', 29000000, '2024-11-09', N'Iphone'),
(N'P004', N'IPhone 14 Plus', 31000000, '2025-04-06', N'Iphone'),
(N'P005', N'Samsung Galaxy Z Fold5', 49000000, '2025-04-02', N'SamSung'),
(N'P006', N'Xiaomi 14 Ultra', 25000000, '2025-05-15', N'Xiaomi'); -- Thêm hàng thứ 6 để đảm bảo tối thiểu 5 hàng và đa dạng hơn
GO

-- Xem lại dữ liệu đã chèn
SELECT * FROM User_YourID;
SELECT * FROM Product_YourID;