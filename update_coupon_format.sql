-- Script để cập nhật format dữ liệu đồng nhất
USE SP25_Demo;

-- 1. Backup data hiện tại (optional)
-- SELECT * INTO Coupon_Backup FROM Coupon;

-- 2. Update existing coupons để có format phù hợp với giá sản phẩm hiện tại
UPDATE Coupon 
SET 
    min_order_amount = CASE 
        WHEN code = 'TECH20' THEN 100.00
        WHEN code = 'SAVE50K' THEN 200.00
        WHEN code = 'VIP100K' THEN 500.00
        ELSE min_order_amount
    END,
    discount_value = CASE 
        WHEN code = 'SAVE50K' THEN 50.00
        WHEN code = 'VIP100K' THEN 100.00
        ELSE discount_value
    END,
    max_discount_amount = CASE 
        WHEN code = 'TECH20' THEN 50.00
        WHEN code = 'SAVE50K' THEN 50.00
        WHEN code = 'VIP100K' THEN 100.00
        ELSE max_discount_amount
    END,
    name = CASE 
        WHEN code = 'SAVE50K' THEN N'Giảm 50đ cho đơn hàng'
        WHEN code = 'VIP100K' THEN N'VIP - Giảm 100đ'
        ELSE name
    END,
    description = CASE 
        WHEN code = 'TECH20' THEN N'Giảm 20% cho đơn hàng từ 100đ'
        WHEN code = 'SAVE50K' THEN N'Giảm ngay 50đ cho đơn hàng từ 200đ'
        WHEN code = 'VIP100K' THEN N'Giảm 100đ cho đơn hàng từ 500đ'
        ELSE description
    END,
    updated_date = GETDATE()
WHERE code IN ('TECH20', 'SAVE50K', 'VIP100K');

-- 3. Thêm coupon mới phù hợp với giá sản phẩm nhỏ
IF NOT EXISTS (SELECT 1 FROM Coupon WHERE code = 'NEWBIE10')
BEGIN
    INSERT INTO Coupon (
        code, name, description, discount_type, discount_value, 
        min_order_amount, max_discount_amount, start_date, end_date, 
        usage_limit, usage_count, is_active, created_by, created_date, updated_date
    ) VALUES (
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
END

-- 4. Hiển thị dữ liệu sau khi cập nhật
SELECT 
    code,
    name,
    discount_type,
    FORMAT(discount_value, 'N2') as discount_value,
    FORMAT(min_order_amount, 'N2') as min_order_amount,
    FORMAT(max_discount_amount, 'N2') as max_discount_amount,
    usage_count,
    usage_limit,
    CASE 
        WHEN GETDATE() BETWEEN start_date AND end_date THEN 'VALID'
        ELSE 'EXPIRED'
    END as status
FROM Coupon
WHERE is_active = 1
ORDER BY min_order_amount;

PRINT 'Database updated with consistent formatting!';
PRINT 'Updated coupon codes: TECH20, SAVE50K, VIP100K, NEWBIE10';
PRINT 'All amounts now use the same decimal format (XX.XX)';