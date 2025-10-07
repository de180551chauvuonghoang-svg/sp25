USE [SP25_DemoPRJ_1]
GO
/****** Object:  Table [dbo].[Cart]    Script Date: 10/8/2025 1:10:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cart](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[added_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Discount]    Script Date: 10/8/2025 1:10:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](50) NOT NULL,
	[description] [nvarchar](255) NULL,
	[discount_type] [nvarchar](20) NULL,
	[value] [decimal](10, 2) NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[usage_limit] [int] NULL,
	[used_count] [int] NULL,
	[is_active] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 10/8/2025 1:10:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[subtotal]  AS ([quantity]*[price]),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 10/8/2025 1:10:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[order_date] [datetime] NULL,
	[total_price] [decimal](10, 2) NOT NULL,
	[status] [nvarchar](50) NOT NULL,
	[discount_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 10/8/2025 1:10:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[description] [nvarchar](500) NULL,
	[stock] [int] NOT NULL,
	[import_date] [datetime] NULL,
	[status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 10/8/2025 1:10:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](120) NOT NULL,
	[email] [nvarchar](220) NOT NULL,
	[country] [nvarchar](120) NULL,
	[role] [nvarchar](50) NOT NULL,
	[status] [bit] NOT NULL,
	[password] [nvarchar](255) NOT NULL,
	[dateofbirth] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Discount] ON 

INSERT [dbo].[Discount] ([id], [code], [description], [discount_type], [value], [start_date], [end_date], [usage_limit], [used_count], [is_active]) VALUES (1, N'SALE10', N'Giảm 10% cho đơn hàng bất kỳ', N'percent', CAST(10.00 AS Decimal(10, 2)), CAST(N'2025-10-06' AS Date), CAST(N'2025-10-31' AS Date), 100, 0, 1)
INSERT [dbo].[Discount] ([id], [code], [description], [discount_type], [value], [start_date], [end_date], [usage_limit], [used_count], [is_active]) VALUES (2, N'FREESHIP', N'Giảm 30.000 VNĐ phí vận chuyển', N'amount', CAST(30000.00 AS Decimal(10, 2)), CAST(N'2025-10-06' AS Date), CAST(N'2025-10-31' AS Date), 50, 0, 1)
SET IDENTITY_INSERT [dbo].[Discount] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (1, 1, CAST(N'2025-10-05T16:37:29.240' AS DateTime), CAST(1500.00 AS Decimal(10, 2)), N'Pending', NULL)
INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (2, 20, CAST(N'2025-10-06T11:11:18.517' AS DateTime), CAST(1500.00 AS Decimal(10, 2)), N'PENDING', NULL)
INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (3, 20, CAST(N'2025-10-06T11:12:13.610' AS DateTime), CAST(1500.00 AS Decimal(10, 2)), N'PENDING', NULL)
INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (4, 20, CAST(N'2025-10-06T11:12:26.580' AS DateTime), CAST(4500.00 AS Decimal(10, 2)), N'PENDING', NULL)
INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (6, 14, CAST(N'2025-10-06T11:37:00.927' AS DateTime), CAST(1500.00 AS Decimal(10, 2)), N'PENDING', NULL)
INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (7, 14, CAST(N'2025-10-06T12:26:59.417' AS DateTime), CAST(1500.00 AS Decimal(10, 2)), N'PENDING', NULL)
INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (8, 21, CAST(N'2025-10-06T14:11:52.963' AS DateTime), CAST(1500.00 AS Decimal(10, 2)), N'PENDING', NULL)
INSERT [dbo].[Orders] ([id], [user_id], [order_date], [total_price], [status], [discount_id]) VALUES (9, 21, CAST(N'2025-10-07T22:40:27.400' AS DateTime), CAST(1500.00 AS Decimal(10, 2)), N'PENDING', NULL)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (1, N'Laptop Dell XPS 13', CAST(1500.00 AS Decimal(10, 2)), N'Máy tính xách tay Dell hiệu suất
	cao', 21, CAST(N'2025-10-15T00:00:00.000' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (2, N'Laptop MacBook Pro 14', CAST(2200.00 AS Decimal(10, 2)), N'Máy tính xách tay Apple với chip
	M2', 15, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (3, N'Smartphone iPhone 14', CAST(999.99 AS Decimal(10, 2)), N'Điện thoại Apple iPhone 14 mới
	nhất', 20, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (4, N'Smartphone Samsung Galaxy S23', CAST(899.99 AS Decimal(10, 2)), N'Điện thoại Samsung
	flagship', 25, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (5, N'Tai nghe Sony WH-1000XM5', CAST(349.99 AS Decimal(10, 2)), N'Tai nghe chống ồn cao cấp', 30, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (6, N'Tai nghe AirPods Pro 2', CAST(249.99 AS Decimal(10, 2)), N'Tai nghe không dây của Apple', 18, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (7, N'Màn hình LG UltraFine 5K', CAST(1299.99 AS Decimal(10, 2)), N'Màn hình 5K dành cho thiết
	kế', 18, CAST(N'2025-10-02T00:00:00.000' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (8, N'Màn hình Dell UltraSharp 32"', CAST(999.99 AS Decimal(10, 2)), N'Màn hình 4K với màu sắc
	chính xác', 12, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (9, N'Bàn phím cơ Keychron K6', CAST(99.99 AS Decimal(10, 2)), N'Bàn phím cơ không dây có đèn nền', 50, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (10, N'Chuột Logitech MX Master 3', CAST(119.99 AS Decimal(10, 2)), N'Chuột không dây dành cho
	dân văn phòng', 40, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (11, N'Ổ cứng SSD Samsung 1TB', CAST(150.00 AS Decimal(10, 2)), N'Ổ SSD NVMe tốc độ cao', 35, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (12, N'Ổ cứng HDD Seagate 4TB', CAST(100.00 AS Decimal(10, 2)), N'Ổ cứng lưu trữ dung lượng lớn', 28, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (13, N'Camera GoPro Hero 11', CAST(499.99 AS Decimal(10, 2)), N'Camera hành trình 4K chống nước', 22, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (14, N'Máy ảnh Sony A7 IV', CAST(2500.00 AS Decimal(10, 2)), N'Máy ảnh mirrorless chuyên nghiệp', 5, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (15, N'Micro Rode NT1-A', CAST(229.99 AS Decimal(10, 2)), N'Micro
	thu âm chất lượng cao', 17, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (16, N'Bộ phát WiFi TP-Link AX3000', CAST(129.99 AS Decimal(10, 2)), N'Router WiFi 6 tốc độ cao', 20, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (17, N'Pin sạc dự phòng Anker 20000mAh', CAST(49.99 AS Decimal(10, 2)), N'Pin sạc nhanh dung lượng
	lớn', 60, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (18, N'Loa Bluetooth JBL Charge 5', CAST(149.99 AS Decimal(10, 2)), N'Loa không dây chống nước', 32, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (19, N'Máy chơi game PlayStation 5', CAST(499.99 AS Decimal(10, 2)), N'Console PS5 phiên bản tiêu
	chuẩn', 10, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (20, N'Bộ điều khiển Xbox Series X', CAST(59.99 AS Decimal(10, 2)), N'Tay cầm chơi game không
	dây', 45, CAST(N'2025-09-25T23:21:31.897' AS DateTime), N'AVAILABLE')
INSERT [dbo].[Product] ([id], [name], [price], [description], [stock], [import_date], [status]) VALUES (21, N'Chau Vuong Hoang', CAST(123.04 AS Decimal(10, 2)), N'1234', 1234, CAST(N'2025-09-03T00:00:00.000' AS DateTime), N'AVAILABLE')
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (1, N'Chi Pheo', N'chi@gmail.com', N'Viet Nam', N'user', 1, N'abc@123', NULL)
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (2, N'Tu Hai', N'hai@fpt.edu.vn', N'Canada', N'user', 1, N'abc@123', NULL)
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (3, N'John Doe', N'john.doe@example.com', N'USA', N'Admin', 1, N'abc@123', NULL)
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (4, N'Jane Smith', N'jane.smith@example.com', N'UK', N'User', 1, N'abc@123', NULL)
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (5, N'Mike Brown', N'mike.brown@example.com', NULL, N'Moderator', 0, N'abc@123', NULL)
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (6, N'Sarah Johnson', N'sarah.johnson@example.com', N'Canada', N'User', 1, N'abc@123', NULL)
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (7, N'Emily Davis', N'emily.davis@example.com', N'Australia', N'Admin', 0, N'abc@123', NULL)
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (14, N'Dell Presscion 5533', N'de180551chauvuonghoang@gmail.com', N'd', N'user', 1, N'123123123', N'2025-09-18')
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (15, N'admin', N'a@gmail.com', N'd', N'admin', 0, N'ádasdasd', N'2025-09-11')
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (16, N'heone', N'123@gmail.com', N'123', N'admin', 1, N'123213', N'2025-09-02')
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (18, N'chauvuonghoang123', N'a1234@gmail.com', N'Japan', N'admin', 1, N'e06b1afd38ddb78b3f87842adc69bd243286f24c7b4ba9c94aaedf366fa064e6', N'2025-10-29')
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (19, N'chauvuonghoang123456', N'hpp08684@fosiq.com', N'', N'user', 1, N'e06b1afd38ddb78b3f87842adc69bd243286f24c7b4ba9c94aaedf366fa064e6', N'')
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (20, N'nguyenthibe', N'mit54480@gmail.com', N'China', N'admin', 1, N'aa1c78d5cb30fe18dccaa98dcf940327ce4e6536ee71500fcf7a004776c4f0de', N'2025-10-21')
INSERT [dbo].[Users] ([id], [name], [email], [country], [role], [status], [password], [dateofbirth]) VALUES (21, N'hieu33', N'hieu33tran@gmail.com', N'Thailand', N'user', 1, N'123456789', N'2025-10-23')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO

-- ========================================================================================
-- TRIGGERS FOR CART AND INVENTORY MANAGEMENT
-- ========================================================================================

-- Trigger: Kiểm tra số lượng tồn kho khi thêm vào giỏ hàng
IF OBJECT_ID('tr_Cart_CheckStock', 'TR') IS NOT NULL
    DROP TRIGGER tr_Cart_CheckStock
GO

CREATE TRIGGER tr_Cart_CheckStock
ON [dbo].[Cart]
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @product_id INT, @quantity INT, @user_id INT, @available_stock INT;
    
    SELECT @product_id = product_id, @quantity = quantity, @user_id = user_id
    FROM inserted;
    
    -- Lấy số lượng tồn kho hiện tại
    SELECT @available_stock = stock 
    FROM Product 
    WHERE id = @product_id AND status = 'AVAILABLE';
    
    -- Kiểm tra sản phẩm có tồn tại và có sẵn không
    IF @available_stock IS NULL
    BEGIN
        RAISERROR(N'Sản phẩm không tồn tại hoặc không khả dụng', 16, 1);
        RETURN;
    END
    
    -- Kiểm tra số lượng yêu cầu có vượt quá tồn kho không
    IF @quantity > @available_stock
    BEGIN
        RAISERROR(N'Số lượng yêu cầu vượt quá tồn kho', 16, 1);
        RETURN;
    END
    
    -- Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    IF EXISTS (SELECT 1 FROM Cart WHERE user_id = @user_id AND product_id = @product_id)
    BEGIN
        -- Cập nhật số lượng nếu đã có
        DECLARE @current_quantity INT;
        SELECT @current_quantity = quantity FROM Cart WHERE user_id = @user_id AND product_id = @product_id;
        
        -- Kiểm tra tổng số lượng sau khi cộng
        IF (@current_quantity + @quantity) > @available_stock
        BEGIN
            RAISERROR(N'Tổng số lượng trong giỏ hàng sẽ vượt quá tồn kho', 16, 1);
            RETURN;
        END
        
        UPDATE Cart 
        SET quantity = quantity + @quantity, updated_date = GETDATE()
        WHERE user_id = @user_id AND product_id = @product_id;
    END
    ELSE
    BEGIN
        -- Thêm mới vào giỏ hàng
        INSERT INTO Cart (user_id, product_id, quantity, added_date, updated_date)
        VALUES (@user_id, @product_id, @quantity, GETDATE(), GETDATE());
    END
END
GO

-- Trigger: Kiểm tra và cập nhật khi sửa số lượng trong giỏ hàng
IF OBJECT_ID('tr_Cart_UpdateStock', 'TR') IS NOT NULL
    DROP TRIGGER tr_Cart_UpdateStock
GO

CREATE TRIGGER tr_Cart_UpdateStock
ON [dbo].[Cart]
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @cart_id INT, @product_id INT, @new_quantity INT, @available_stock INT;
    
    SELECT @cart_id = id, @product_id = product_id, @new_quantity = quantity
    FROM inserted;
    
    -- Lấy số lượng tồn kho hiện tại
    SELECT @available_stock = stock 
    FROM Product 
    WHERE id = @product_id AND status = 'AVAILABLE';
    
    -- Kiểm tra số lượng mới có hợp lệ không
    IF @new_quantity <= 0
    BEGIN
        DELETE FROM Cart WHERE id = @cart_id;
        RETURN;
    END
    
    IF @new_quantity > @available_stock
    BEGIN
        RAISERROR(N'Số lượng yêu cầu vượt quá tồn kho', 16, 1);
        RETURN;
    END
    
    -- Cập nhật số lượng
    UPDATE Cart 
    SET quantity = @new_quantity, updated_date = GETDATE()
    WHERE id = @cart_id;
END
GO

-- Trigger: Cập nhật tồn kho khi checkout thành công (khi insert vào OrderDetails)
IF OBJECT_ID('tr_OrderDetails_UpdateStock', 'TR') IS NOT NULL
    DROP TRIGGER tr_OrderDetails_UpdateStock
GO

CREATE TRIGGER tr_OrderDetails_UpdateStock
ON [dbo].[OrderDetails]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @product_id INT, @quantity INT, @current_stock INT;
    
    SELECT @product_id = product_id, @quantity = quantity
    FROM inserted;
    
    -- Lấy số lượng tồn kho hiện tại
    SELECT @current_stock = stock FROM Product WHERE id = @product_id;
    
    -- Kiểm tra đủ hàng không
    IF @current_stock < @quantity
    BEGIN
        RAISERROR(N'Không đủ hàng trong kho', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
    
    -- Trừ số lượng tồn kho
    UPDATE Product 
    SET stock = stock - @quantity
    WHERE id = @product_id;
    
    -- Cập nhật trạng thái sản phẩm nếu hết hàng
    UPDATE Product 
    SET status = 'OUT_OF_STOCK'
    WHERE id = @product_id AND stock = 0;
END
GO

-- Trigger: Cập nhật trạng thái sản phẩm khi stock thay đổi
IF OBJECT_ID('tr_Product_StatusUpdate', 'TR') IS NOT NULL
    DROP TRIGGER tr_Product_StatusUpdate
GO

CREATE TRIGGER tr_Product_StatusUpdate
ON [dbo].[Product]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật trạng thái dựa trên stock
    UPDATE Product 
    SET status = CASE 
                    WHEN stock > 0 THEN 'AVAILABLE'
                    ELSE 'OUT_OF_STOCK'
                 END
    WHERE id IN (SELECT id FROM inserted WHERE stock != (SELECT stock FROM deleted WHERE deleted.id = inserted.id));
END
GO

-- Trigger: Xóa giỏ hàng khi checkout thành công  
IF OBJECT_ID('tr_Orders_ClearCart', 'TR') IS NOT NULL
    DROP TRIGGER tr_Orders_ClearCart
GO

CREATE TRIGGER tr_Orders_ClearCart
ON [dbo].[Orders]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @user_id INT;
    SELECT @user_id = user_id FROM inserted;
    
    -- Chỉ xóa giỏ hàng khi đơn hàng được tạo thành công
    -- (Logic này sẽ được gọi từ application sau khi tạo OrderDetails)
END
GO

-- Stored Procedure: Thêm sản phẩm vào giỏ hàng với kiểm tra
IF OBJECT_ID('sp_AddToCart', 'P') IS NOT NULL
    DROP PROCEDURE sp_AddToCart
GO

CREATE PROCEDURE sp_AddToCart
    @user_id INT,
    @product_id INT,
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Thêm vào giỏ hàng (trigger sẽ xử lý validation)
        INSERT INTO Cart (user_id, product_id, quantity, added_date, updated_date)
        VALUES (@user_id, @product_id, @quantity, GETDATE(), GETDATE());
        
        COMMIT TRANSACTION;
        
        -- Trả về kết quả thành công
        SELECT 1 as success, 'Thêm vào giỏ hàng thành công' as message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        -- Trả về lỗi
        SELECT 0 as success, ERROR_MESSAGE() as message;
    END CATCH
END
GO

-- Stored Procedure: Cập nhật số lượng trong giỏ hàng
IF OBJECT_ID('sp_UpdateCart', 'P') IS NOT NULL
    DROP PROCEDURE sp_UpdateCart
GO

CREATE PROCEDURE sp_UpdateCart
    @cart_id INT,
    @quantity INT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Cập nhật giỏ hàng (trigger sẽ xử lý validation)
        UPDATE Cart 
        SET quantity = @quantity
        WHERE id = @cart_id;
        
        COMMIT TRANSACTION;
        
        SELECT 1 as success, 'Cập nhật giỏ hàng thành công' as message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        SELECT 0 as success, ERROR_MESSAGE() as message;
    END CATCH
END
GO

-- Stored Procedure: Checkout với kiểm tra đầy đủ
IF OBJECT_ID('sp_Checkout', 'P') IS NOT NULL
    DROP PROCEDURE sp_Checkout
GO

CREATE PROCEDURE sp_Checkout
    @user_id INT,
    @total_price DECIMAL(10,2),
    @discount_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @order_id INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Kiểm tra giỏ hàng có sản phẩm không
        IF NOT EXISTS (SELECT 1 FROM Cart WHERE user_id = @user_id)
        BEGIN
            RAISERROR('Giỏ hàng trống', 16, 1);
            RETURN;
        END
        
        -- Tạo đơn hàng
        INSERT INTO Orders (user_id, order_date, total_price, status, discount_id)
        VALUES (@user_id, GETDATE(), @total_price, 'PENDING', @discount_id);
        
        SET @order_id = SCOPE_IDENTITY();
        
        -- Tạo OrderDetails từ Cart (trigger sẽ cập nhật stock)
        INSERT INTO OrderDetails (order_id, product_id, quantity, price)
        SELECT @order_id, c.product_id, c.quantity, p.price
        FROM Cart c
        INNER JOIN Product p ON c.product_id = p.id
        WHERE c.user_id = @user_id;
        
        -- Xóa giỏ hàng sau khi checkout thành công
        DELETE FROM Cart WHERE user_id = @user_id;
        
        COMMIT TRANSACTION;
        
        -- Trả về order_id
        SELECT @order_id as order_id, 'Checkout thành công' as message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        SELECT 0 as order_id, ERROR_MESSAGE() as message;
    END CATCH
END
GO

-- Function: Kiểm tra sản phẩm có sẵn để mua không
IF OBJECT_ID('fn_IsProductAvailable', 'FN') IS NOT NULL
    DROP FUNCTION fn_IsProductAvailable
GO

CREATE FUNCTION fn_IsProductAvailable(@product_id INT, @quantity INT)
RETURNS BIT
AS
BEGIN
    DECLARE @available BIT = 0;
    
    IF EXISTS (
        SELECT 1 FROM Product 
        WHERE id = @product_id 
        AND status = 'AVAILABLE' 
        AND stock >= @quantity
    )
    BEGIN
        SET @available = 1;
    END
    
    RETURN @available;
END
GO