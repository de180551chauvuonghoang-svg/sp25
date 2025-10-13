-- Trigger để tự động cập nhật usage_count của coupon khi có usage mới
USE SP25_Demo;

-- Tạo trigger cho việc tự động cập nhật usage_count
IF OBJECT_ID('trg_CouponUsage_UpdateCount', 'TR') IS NOT NULL
    DROP TRIGGER trg_CouponUsage_UpdateCount;
GO

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

-- Trigger để ngăn chặn việc xóa CouponUsage (chỉ cho phép soft delete)
IF OBJECT_ID('trg_CouponUsage_PreventDelete', 'TR') IS NOT NULL
    DROP TRIGGER trg_CouponUsage_PreventDelete;
GO

CREATE TRIGGER trg_CouponUsage_PreventDelete
ON CouponUsage
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Thay vì xóa hoàn toàn, chúng ta có thể thêm cột deleted_date
    -- Hoặc đơn giản là không cho phép xóa
    
    -- Giảm usage_count trong bảng Coupon khi có CouponUsage bị "xóa"
    UPDATE c
    SET usage_count = usage_count - 1,
        updated_date = GETDATE()
    FROM Coupon c
    INNER JOIN deleted d ON c.id = d.coupon_id;
    
    -- Không thực hiện delete thực sự, chỉ log
    PRINT 'Trigger: Prevented deletion of CouponUsage records. Usage count decremented.';
    
    -- Nếu muốn thực sự xóa, bỏ comment dòng dưới:
    -- DELETE cu FROM CouponUsage cu INNER JOIN deleted d ON cu.id = d.id;
END;
GO

-- Trigger để kiểm tra usage limit trước khi insert CouponUsage
IF OBJECT_ID('trg_CouponUsage_CheckLimit', 'TR') IS NOT NULL
    DROP TRIGGER trg_CouponUsage_CheckLimit;
GO

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
        -- Kiểm tra usage limit
        SELECT @UsageLimit = usage_limit, @CurrentUsage = usage_count
        FROM Coupon
        WHERE id = @CouponId AND is_active = 1;
        
        IF @UsageLimit IS NULL
        BEGIN
            SET @ErrorMessage = 'Coupon không tồn tại hoặc đã bị vô hiệu hóa';
            RAISERROR(@ErrorMessage, 16, 1);
            RETURN;
        END
        
        IF @CurrentUsage >= @UsageLimit
        BEGIN
            SET @ErrorMessage = 'Coupon đã đạt giới hạn sử dụng';
            RAISERROR(@ErrorMessage, 16, 1);
            RETURN;
        END
        
        -- Kiểm tra user đã sử dụng coupon này chưa (nếu có limit per user)
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

-- Test trigger bằng cách tạo sample data (chỉ chạy nếu cần test)
/*
-- Test trigger functionality
PRINT 'Testing triggers...';

-- Giả sử có coupon với id = 1 và usage_limit = 3
UPDATE Coupon SET usage_count = 0 WHERE id = 1;

-- Test insert CouponUsage
INSERT INTO CouponUsage (coupon_id, user_id, order_id, discount_amount)
VALUES (1, 1, 1, 50000);

-- Kiểm tra usage_count đã tăng
SELECT id, code, usage_count, usage_limit FROM Coupon WHERE id = 1;

-- Test limit exceeded
INSERT INTO CouponUsage (coupon_id, user_id, order_id, discount_amount)
VALUES (1, 1, 2, 50000); -- Sẽ fail vì user đã dùng rồi

PRINT 'Trigger testing completed.';
*/

PRINT 'Coupon triggers created successfully!';