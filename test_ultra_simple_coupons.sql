-- Ultra Simple Coupon Test - NO MIN/MAX constraints
USE SP25_Demo;

-- Test với giỏ hàng có giá trị 123,000 VNĐ
DECLARE @order_amount DECIMAL(15,2) = 123000;
DECLARE @user_id INT = 1;

PRINT 'Testing ultra-simple coupon system with order: ' + FORMAT(@order_amount, 'N0') + ' VNĐ';
PRINT '=====================================';

-- Test GIAM10K (Fixed 10,000 VNĐ)
PRINT 'Test 1: GIAM10K (10,000 VNĐ discount)';
EXEC sp_ValidateCoupon @coupon_code = 'GIAM10K', @user_id = @user_id, @order_amount = @order_amount;
PRINT '';

-- Test GIAM20K (Fixed 20,000 VNĐ) 
PRINT 'Test 2: GIAM20K (20,000 VNĐ discount)';
EXEC sp_ValidateCoupon @coupon_code = 'GIAM20K', @user_id = @user_id, @order_amount = @order_amount;
PRINT '';

-- Test GIAM15PHAN (15% discount)
PRINT 'Test 3: GIAM15PHAN (15% discount = ' + FORMAT(@order_amount * 0.15, 'N0') + ' VNĐ)';
EXEC sp_ValidateCoupon @coupon_code = 'GIAM15PHAN', @user_id = @user_id, @order_amount = @order_amount;
PRINT '';

-- Test GIAM25PHAN (25% discount)
PRINT 'Test 4: GIAM25PHAN (25% discount = ' + FORMAT(@order_amount * 0.25, 'N0') + ' VNĐ)';
EXEC sp_ValidateCoupon @coupon_code = 'GIAM25PHAN', @user_id = @user_id, @order_amount = @order_amount;
PRINT '';

-- Test GIAM50PHAN (50% discount)
PRINT 'Test 5: GIAM50PHAN (50% discount = ' + FORMAT(@order_amount * 0.50, 'N0') + ' VNĐ)';
EXEC sp_ValidateCoupon @coupon_code = 'GIAM50PHAN', @user_id = @user_id, @order_amount = @order_amount;
PRINT '';

-- Test với đơn hàng nhỏ hơn discount value
DECLARE @small_order DECIMAL(15,2) = 5000;
PRINT 'Test 6: Small order (' + FORMAT(@small_order, 'N0') + ' VNĐ) vs GIAM10K';
EXEC sp_ValidateCoupon @coupon_code = 'GIAM10K', @user_id = @user_id, @order_amount = @small_order;
PRINT 'Expected: Discount should be limited to order amount (5,000 VNĐ)';
PRINT '';

-- Show all available coupons
PRINT 'All available coupons:';
EXEC sp_GetActiveCoupons @user_id = @user_id;

PRINT '';
PRINT '✅ Ultra-simple coupon system:';
PRINT '   - NO minimum order requirements';
PRINT '   - NO maximum discount limits';
PRINT '   - Pure discount value application';
PRINT '   - Only limited by order total amount';