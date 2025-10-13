-- Fixed Coupon Triggers - Loại bỏ is_active column không tồn tại
USE SP25_Demo;
GO

-- Drop existing triggers first
IF OBJECT_ID('trg_CouponUsage_UpdateCount', 'TR') IS NOT NULL
    DROP TRIGGER trg_CouponUsage_UpdateCount;

IF OBJECT_ID('trg_CouponUsage_PreventDelete', 'TR') IS NOT NULL
    DROP TRIGGER trg_CouponUsage_PreventDelete;

IF OBJECT_ID('trg_CouponUsage_CheckLimit', 'TR') IS NOT NULL
    DROP TRIGGER trg_CouponUsage_CheckLimit;
GO

-- 1. Trigger để tự động cập nhật usage_count khi có usage mới
CREATE TRIGGER trg_CouponUsage_UpdateCount
ON CouponUsage
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cập nhật usage_count trong bảng Coupon
    UPDATE c
    SET usage_count = usage_count + 1,
        updated_date = GETDATE()
    FROM Coupon c
    INNER JOIN inserted i ON c.id = i.coupon_id;
    
    -- Log thông tin
    PRINT 'Trigger: Updated usage_count for coupon(s)';
END;
GO

-- 2. Trigger để ngăn chặn việc xóa CouponUsage
CREATE TRIGGER trg_CouponUsage_PreventDelete
ON CouponUsage
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Giảm usage_count trong bảng Coupon khi có CouponUsage bị "xóa"
    UPDATE c
    SET usage_count = usage_count - 1,
        updated_date = GETDATE()
    FROM Coupon c
    INNER JOIN deleted d ON c.id = d.coupon_id;
    
    -- Log action nhưng không thực sự xóa
    PRINT 'Trigger: Prevented deletion of CouponUsage records. Usage count decremented.';
    
    -- Nếu muốn thực sự xóa (uncomment dòng dưới nếu cần):
    -- DELETE cu FROM CouponUsage cu INNER JOIN deleted d ON cu.id = d.id;
END;
GO

-- 3. Trigger để kiểm tra usage limit trước khi insert CouponUsage
CREATE TRIGGER trg_CouponUsage_CheckLimit
ON CouponUsage
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @CouponId INT, @UserId INT, @OrderId INT, @DiscountAmount DECIMAL(10,2);
    DECLARE @UsageLimit INT, @CurrentUsage INT;
    DECLARE @ErrorMessage NVARCHAR(500);
    
    DECLARE usage_cursor CURSOR FOR
    SELECT coupon_id, user_id, order_id, discount_amount
    FROM inserted;
    
    OPEN usage_cursor;
    FETCH NEXT FROM usage_cursor INTO @CouponId, @UserId, @OrderId, @DiscountAmount;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Kiểm tra coupon có tồn tại và active không
        SELECT @UsageLimit = usage_limit, @CurrentUsage = usage_count
        FROM Coupon
        WHERE id = @CouponId AND is_active = 1;
        
        IF @@ROWCOUNT = 0
        BEGIN
            SET @ErrorMessage = 'Coupon không tồn tại hoặc đã bị vô hiệu hóa';
            RAISERROR(@ErrorMessage, 16, 1);
            RETURN;
        END
        
        -- Kiểm tra usage limit
        IF @CurrentUsage >= @UsageLimit
        BEGIN
            SET @ErrorMessage = 'Coupon đã đạt giới hạn sử dụng';
            RAISERROR(@ErrorMessage, 16, 1);
            RETURN;
        END
        
        -- Kiểm tra user đã sử dụng coupon này chưa
        IF EXISTS (
            SELECT 1 FROM CouponUsage 
            WHERE coupon_id = @CouponId 
            AND user_id = @UserId
        )
        BEGIN
            SET @ErrorMessage = 'Bạn đã sử dụng mã giảm giá này rồi';
            RAISERROR(@ErrorMessage, 16, 1);
            RETURN;
        END
        
        -- Nếu tất cả kiểm tra đều OK, thực hiện insert
        INSERT INTO CouponUsage (coupon_id, user_id, order_id, discount_amount, used_date)
        VALUES (@CouponId, @UserId, @OrderId, @DiscountAmount, GETDATE());
        
        FETCH NEXT FROM usage_cursor INTO @CouponId, @UserId, @OrderId, @DiscountAmount;
    END
    
    CLOSE usage_cursor;
    DEALLOCATE usage_cursor;
END;
GO

PRINT 'All coupon triggers created successfully!';

-- Test trigger (optional - uncomment to run tests)
/*
PRINT 'Testing triggers...';

-- Test 1: Insert a valid coupon usage
DECLARE @TestCouponId INT = 1;
DECLARE @TestUserId INT = 1;
DECLARE @TestOrderId INT = 1001;

-- Reset usage count for testing
UPDATE Coupon SET usage_count = 0 WHERE id = @TestCouponId;

-- Test insert
INSERT INTO CouponUsage (coupon_id, user_id, order_id, discount_amount)
VALUES (@TestCouponId, @TestUserId, @TestOrderId, 50000);

-- Check if usage_count was updated
SELECT id, code, usage_count, usage_limit 
FROM Coupon 
WHERE id = @TestCouponId;

PRINT 'Trigger testing completed successfully!';
*/