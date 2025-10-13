-- Simplify Coupon table structure - remove min/max, use VND format
USE SP25_Demo;
GO

-- Backup existing data first (if table exists)
IF OBJECT_ID('Coupon', 'U') IS NOT NULL
BEGIN
    DECLARE @BackupTableName NVARCHAR(100) = 'Coupon_Backup_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmmss');
    DECLARE @SQL NVARCHAR(MAX) = 'SELECT * INTO ' + @BackupTableName + ' FROM Coupon';
    EXEC sp_executesql @SQL;
    PRINT 'Backup created: ' + @BackupTableName;
END

-- Update existing table structure (keep existing data but simplify logic)
-- We'll keep the columns but ignore min/max in logic

-- Clear existing coupon data to start fresh
DELETE FROM CouponUsage;
DELETE FROM Coupon;

-- Insert simplified coupon data with VND format (NO MIN/MAX)
INSERT INTO Coupon (
    code, name, description, discount_type, discount_value, 
    min_order_amount, max_discount_amount, start_date, end_date, 
    usage_limit, usage_count, is_active, created_by, created_date, updated_date
) VALUES 
(
    'GIAM10K', 
    N'Giảm 10,000 VNĐ',
    N'Giảm ngay 10,000 VNĐ cho mọi đơn hàng',
    'FIXED_AMOUNT', 
    10000.00,    -- 10,000 VNĐ
    0.00,        -- Ignored in logic
    0.00,        -- Ignored in logic  
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
    'GIAM20K', 
    N'Giảm 20,000 VNĐ',
    N'Giảm ngay 20,000 VNĐ cho mọi đơn hàng',
    'FIXED_AMOUNT', 
    20000.00,    -- 20,000 VNĐ
    0.00,        
    0.00,        
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
    'GIAM50K', 
    N'Giảm 50,000 VNĐ',
    N'Giảm ngay 50,000 VNĐ cho mọi đơn hàng',
    'FIXED_AMOUNT', 
    50000.00,    -- 50,000 VNĐ
    0.00,        
    0.00,        
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
    'GIAM15PHAN', 
    N'Giảm 15%',
    N'Giảm 15% tổng giá trị đơn hàng',
    'PERCENTAGE', 
    15.00,       -- 15%
    0.00,        
    0.00,        -- Không giới hạn max discount
    '2025-01-01',
    '2025-12-31',
    75,
    0,
    1,
    1,
    GETDATE(),
    GETDATE()
),
(
    'GIAM25PHAN', 
    N'Giảm 25%',
    N'Giảm 25% tổng giá trị đơn hàng',
    'PERCENTAGE', 
    25.00,       -- 25%
    0.00,        
    0.00,        -- Không giới hạn max discount
    '2025-01-01',
    '2025-12-31',
    30,
    0,
    1,
    1,
    GETDATE(),
    GETDATE()
),
(
    'GIAM50PHAN', 
    N'Giảm 50%',
    N'Giảm 50% tổng giá trị đơn hàng - Siêu khuyến mãi!',
    'PERCENTAGE', 
    50.00,       -- 50%
    0.00,        
    0.00,        -- Không giới hạn max discount
    '2025-01-01',
    '2025-12-31',
    10,          -- Chỉ 10 lượt sử dụng
    0,
    1,
    1,
    GETDATE(),
    GETDATE()
);

-- Display created coupons with simple VND formatting (NO MIN/MAX)
SELECT 
    code,
    name,
    discount_type,
    CASE 
        WHEN discount_type = 'PERCENTAGE' 
        THEN CAST(discount_value AS VARCHAR) + '%'
        ELSE FORMAT(discount_value, 'N0') + ' VNĐ'
    END as discount_display,
    usage_count,
    usage_limit,
    'ACTIVE' as status
FROM Coupon
WHERE is_active = 1
ORDER BY 
    CASE WHEN discount_type = 'FIXED_AMOUNT' THEN discount_value ELSE 0 END DESC,
    CASE WHEN discount_type = 'PERCENTAGE' THEN discount_value ELSE 0 END DESC;

PRINT 'Ultra-simplified coupon data created with VND format!';
PRINT 'Available coupons: GIAM10K, GIAM20K, GIAM50K, GIAM15PHAN, GIAM25PHAN, GIAM50PHAN';
PRINT 'NO minimum order, NO maximum discount - pure discount value only!';