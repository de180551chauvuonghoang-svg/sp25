-- Demo script để test hệ thống coupon
USE SP25_Demo;

-- Tạo một số coupon mẫu để test
PRINT 'Creating sample coupons for testing...';

-- Coupon giảm giá phần trăm
EXEC sp_CreateCoupon 
    @code = 'SAVE20',
    @name = N'Giảm 20%',
    @description = N'Giảm giá 20% cho đơn hàng từ 500,000đ',
    @discount_type = 'PERCENTAGE',
    @discount_value = 20,
    @min_order_amount = 500000,
    @max_discount_amount = 200000,
    @start_date = '2025-01-01',
    @end_date = '2025-12-31',
    @usage_limit = 100,
    @created_by = 1;

-- Coupon giảm giá cố định
EXEC sp_CreateCoupon 
    @code = 'FIXED50K',
    @name = N'Giảm 50K',
    @description = N'Giảm ngay 50,000đ cho đơn hàng từ 200,000đ',
    @discount_type = 'FIXED_AMOUNT',
    @discount_value = 50000,
    @min_order_amount = 200000,
    @max_discount_amount = 50000,
    @start_date = '2025-01-01',
    @end_date = '2025-06-30',
    @usage_limit = 50,
    @created_by = 1;

-- Coupon VIP cho đơn hàng lớn
EXEC sp_CreateCoupon 
    @code = 'VIP100K',
    @name = N'VIP - Giảm 100K',
    @description = N'Giảm 100,000đ cho đơn hàng từ 1,000,000đ',
    @discount_type = 'FIXED_AMOUNT',
    @discount_value = 100000,
    @min_order_amount = 1000000,
    @max_discount_amount = 100000,
    @start_date = '2025-01-01',
    @end_date = '2025-12-31',
    @usage_limit = 20,
    @created_by = 1;

-- Coupon hết hạn để test validation
EXEC sp_CreateCoupon 
    @code = 'EXPIRED',
    @name = N'Mã hết hạn',
    @description = N'Mã giảm giá đã hết hạn - để test',
    @discount_type = 'PERCENTAGE',
    @discount_value = 15,
    @min_order_amount = 100000,
    @max_discount_amount = 100000,
    @start_date = '2024-01-01',
    @end_date = '2024-12-31',
    @usage_limit = 10,
    @created_by = 1;

PRINT 'Sample coupons created!';

-- Hiển thị danh sách coupon đã tạo
PRINT 'Current active coupons:';
SELECT 
    code,
    name,
    discount_type,
    discount_value,
    min_order_amount,
    usage_count,
    usage_limit,
    CASE 
        WHEN GETDATE() BETWEEN start_date AND end_date THEN 'VALID'
        WHEN GETDATE() < start_date THEN 'NOT_STARTED'
        ELSE 'EXPIRED'
    END as status
FROM Coupon 
WHERE is_active = 1
ORDER BY created_date DESC;

-- Test validation với một số scenarios
PRINT 'Testing coupon validation scenarios...';

-- Test 1: Coupon hợp lệ với đơn hàng đủ điều kiện
PRINT 'Test 1: Valid coupon with sufficient order amount';
EXEC sp_ValidateCoupon @coupon_code = 'SAVE20', @user_id = 1, @order_amount = 600000;

-- Test 2: Coupon hợp lệ nhưng đơn hàng không đủ điều kiện
PRINT 'Test 2: Valid coupon but insufficient order amount';
EXEC sp_ValidateCoupon @coupon_code = 'SAVE20', @user_id = 1, @order_amount = 300000;

-- Test 3: Coupon không tồn tại
PRINT 'Test 3: Non-existent coupon';
EXEC sp_ValidateCoupon @coupon_code = 'NOTEXIST', @user_id = 1, @order_amount = 500000;

-- Test 4: Coupon hết hạn
PRINT 'Test 4: Expired coupon';
EXEC sp_ValidateCoupon @coupon_code = 'EXPIRED', @user_id = 1, @order_amount = 500000;

PRINT 'Demo completed! You can now test the web interface with these coupon codes:';
PRINT '- SAVE20 (20% off, min 500K)';
PRINT '- FIXED50K (50K off, min 200K)';
PRINT '- VIP100K (100K off, min 1M)';
PRINT '- EXPIRED (should fail - expired)';