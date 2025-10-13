-- Test if Coupon table exists and check structure
USE SP25_Demo;
GO

-- Check if Coupon table exists
IF OBJECT_ID('Coupon', 'U') IS NOT NULL
BEGIN
    PRINT 'Coupon table exists.';
    
    -- Check table structure
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Coupon'
    ORDER BY ORDINAL_POSITION;
    
    -- Check current data
    SELECT COUNT(*) as current_coupon_count FROM Coupon;
END
ELSE
BEGIN
    PRINT 'ERROR: Coupon table does not exist!';
    PRINT 'Please run the table creation script first.';
END

-- Check if CouponUsage table exists
IF OBJECT_ID('CouponUsage', 'U') IS NOT NULL
BEGIN
    PRINT 'CouponUsage table exists.';
    SELECT COUNT(*) as current_usage_count FROM CouponUsage;
END
ELSE
BEGIN
    PRINT 'ERROR: CouponUsage table does not exist!';
END