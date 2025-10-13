-- Tạo sample coupon data để test
USE SP25_Demo;
GO

-- Xóa dữ liệu cũ nếu có
DELETE FROM CouponUsage;
DELETE FROM Coupon;
GO

-- Tạo sample coupon data với format đồng nhất
INSERT INTO Coupon (
    code, name, description, discount_type, discount_value, 
    min_order_amount, max_discount_amount, start_date, end_date, 
    usage_limit, usage_count, is_active, created_by, created_date, updated_date
) VALUES 
(
    'TECH20', 
    N'Giảm 20% cho đơn hàng công nghệ',
    N'Giảm 20% cho đơn hàng từ 100đ',
    'PERCENTAGE', 
    20.00,
    100.00,   -- Đổi thành format nhỏ phù hợp với giá sản phẩm hiện tại
    50.00,    -- Max discount 50đ
    '2025-01-01',
    '2025-12-31',
    100,
    0,
    1,
    1,
    GETDATE(),
    GETDATE()
),
(
    'SAVE50', 
    N'Giảm 50đ cho đơn hàng',
    N'Giảm ngay 50đ cho đơn hàng từ 200đ',
    'FIXED_AMOUNT', 
    50.00,    -- 50đ discount
    200.00,   -- Min order 200đ
    50.00,
    '2025-01-01',
    '2025-12-31',
    50,
    0,
    1,
    1,
    GETDATE(),
    GETDATE()
),
(
    'VIP100', 
    N'VIP - Giảm 100đ',
    N'Giảm 100đ cho đơn hàng từ 500đ',
    'FIXED_AMOUNT', 
    100.00,   -- 100đ discount  
    500.00,   -- Min order 500đ
    100.00,
    '2025-01-01',
    '2025-12-31',
    20,
    0,
    1,
    1,
    GETDATE(),
    GETDATE()
),
(
    'NEWBIE10',
    N'Giảm 10% cho người mới',
    N'Giảm 10% cho đơn hàng đầu tiên, tối thiểu 50đ',
    'PERCENTAGE',
    10.00,
    50.00,    -- Min order 50đ
    20.00,    -- Max discount 20đ
    '2025-01-01',
    '2025-12-31',
    200,
    0,
    1,
    1,
    GETDATE(),
    GETDATE()
);

-- Kiểm tra dữ liệu đã tạo
SELECT 
    id, code, name, discount_type, discount_value, 
    min_order_amount, usage_count, usage_limit,
    CASE 
        WHEN GETDATE() BETWEEN start_date AND end_date THEN 'VALID'
        ELSE 'EXPIRED'
    END as status
FROM Coupon
WHERE is_active = 1;

PRINT 'Sample coupon data created successfully!';
PRINT 'Test codes: TECH20, SAVE50K, VIP100K';