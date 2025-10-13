-- Tạo stored procedures cần thiết cho hệ thống coupon
USE SP25_Demo;
GO

-- 1. Simplified stored procedure để validate coupon (No min/max logic)
IF OBJECT_ID('sp_ValidateCoupon', 'P') IS NOT NULL
    DROP PROCEDURE sp_ValidateCoupon;
GO

CREATE PROCEDURE sp_ValidateCoupon
    @coupon_code NVARCHAR(20),
    @user_id INT,
    @order_amount DECIMAL(15,2)  -- VND format
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @coupon_id INT, @discount_type NVARCHAR(20), @discount_value DECIMAL(15,2);
    DECLARE @start_date DATETIME, @end_date DATETIME;
    DECLARE @usage_limit INT, @usage_count INT;
    DECLARE @discount_amount DECIMAL(15,2) = 0;
    DECLARE @is_valid BIT = 0;
    DECLARE @message NVARCHAR(255);
    
    -- Ensure order_amount is properly formatted (VND)
    SET @order_amount = ROUND(@order_amount, 0); -- VND doesn't use decimals
    
    -- Lấy thông tin coupon (chỉ cần discount_value)
    SELECT 
        @coupon_id = id,
        @discount_type = discount_type,
        @discount_value = ROUND(CAST(discount_value AS DECIMAL(15,2)), 0),
        @start_date = start_date,
        @end_date = end_date,
        @usage_limit = usage_limit,
        @usage_count = usage_count
    FROM Coupon
    WHERE code = @coupon_code AND is_active = 1;
    
    -- Kiểm tra coupon có tồn tại
    IF @coupon_id IS NULL
    BEGIN
        SET @message = N'Mã giảm giá không tồn tại hoặc đã bị vô hiệu hóa';
        GOTO RETURN_RESULT;
    END
    
    -- Kiểm tra thời hạn
    IF GETDATE() < @start_date
    BEGIN
        SET @message = N'Mã giảm giá chưa có hiệu lực';
        GOTO RETURN_RESULT;
    END
    
    IF GETDATE() > @end_date
    BEGIN
        SET @message = N'Mã giảm giá đã hết hạn';
        GOTO RETURN_RESULT;
    END
    
    -- Kiểm tra giới hạn sử dụng
    IF @usage_count >= @usage_limit
    BEGIN
        SET @message = N'Mã giảm giá đã hết lượt sử dụng';
        GOTO RETURN_RESULT;
    END
    
    -- Kiểm tra user đã sử dụng chưa
    IF EXISTS (SELECT 1 FROM CouponUsage WHERE coupon_id = @coupon_id AND user_id = @user_id)
    BEGIN
        SET @message = N'Bạn đã sử dụng mã giảm giá này rồi';
        GOTO RETURN_RESULT;
    END
    
    -- Tính discount đơn giản - chỉ áp dụng discount_value
    IF @discount_type = 'PERCENTAGE'
    BEGIN
        SET @discount_amount = ROUND(@order_amount * (@discount_value / 100.0), 0);
    END
    ELSE IF @discount_type = 'FIXED_AMOUNT'
    BEGIN
        SET @discount_amount = @discount_value;
    END
    
    -- Đảm bảo discount không vượt quá order amount
    IF @discount_amount > @order_amount
        SET @discount_amount = @order_amount;
    
    -- Round final discount amount (VND format)
    SET @discount_amount = ROUND(@discount_amount, 0);
    
    -- Nếu đến đây thì valid
    SET @is_valid = 1;
    SET @message = N'Áp dụng thành công! Giảm ' + FORMAT(@discount_amount, 'N0') + N' VNĐ';
    
    RETURN_RESULT:
    SELECT 
        @is_valid as valid,
        @coupon_id as coupon_id,
        @discount_amount as discount_amount,
        @message as message;
END;
GO

-- 2. Stored procedure để lấy active coupons
IF OBJECT_ID('sp_GetActiveCoupons', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetActiveCoupons;
GO

CREATE PROCEDURE sp_GetActiveCoupons
    @user_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        id, code, name, description, discount_type, discount_value,
        start_date, end_date, usage_limit, usage_count, is_active, created_date
    FROM Coupon
    WHERE is_active = 1
        AND GETDATE() BETWEEN start_date AND end_date
        AND usage_count < usage_limit
        AND (@user_id IS NULL OR id NOT IN (
            SELECT coupon_id FROM CouponUsage WHERE user_id = @user_id
        ))
    ORDER BY discount_value DESC; -- Order by discount value instead
END;
GO

-- 3. Stored procedure để apply coupon
IF OBJECT_ID('sp_ApplyCoupon', 'P') IS NOT NULL
    DROP PROCEDURE sp_ApplyCoupon;
GO

CREATE PROCEDURE sp_ApplyCoupon
    @coupon_id INT,
    @user_id INT,
    @order_id INT,
    @discount_amount DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insert vào CouponUsage
        INSERT INTO CouponUsage (coupon_id, user_id, order_id, discount_amount, used_date)
        VALUES (@coupon_id, @user_id, @order_id, @discount_amount, GETDATE());
        
        -- Update usage_count
        UPDATE Coupon 
        SET usage_count = usage_count + 1, updated_date = GETDATE()
        WHERE id = @coupon_id;
        
        COMMIT TRANSACTION;
        
        SELECT 1 as success, N'Áp dụng mã giảm giá thành công' as message;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 0 as success, ERROR_MESSAGE() as message;
    END CATCH
END;
GO

PRINT 'Stored procedures created successfully!';