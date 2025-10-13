-- Simple insert script without complex formatting
USE SP25_Demo;
GO

-- Simple clear and insert without backup
DELETE FROM CouponUsage WHERE coupon_id IN (SELECT id FROM Coupon);
DELETE FROM Coupon;

-- Simple insert with basic ASCII text
INSERT INTO Coupon (
    code, name, description, discount_type, discount_value, 
    min_order_amount, max_discount_amount, start_date, end_date, 
    usage_limit, usage_count, is_active, created_by, created_date, updated_date
) VALUES 
('GIAM10K', 'Giam 10K VND', 'Giam ngay 10,000 VND', 'FIXED_AMOUNT', 10000.00, 0.00, 0.00, '2025-01-01', '2025-12-31', 100, 0, 1, 1, GETDATE(), GETDATE()),
('GIAM20K', 'Giam 20K VND', 'Giam ngay 20,000 VND', 'FIXED_AMOUNT', 20000.00, 0.00, 0.00, '2025-01-01', '2025-12-31', 50, 0, 1, 1, GETDATE(), GETDATE()),
('GIAM50K', 'Giam 50K VND', 'Giam ngay 50,000 VND', 'FIXED_AMOUNT', 50000.00, 0.00, 0.00, '2025-01-01', '2025-12-31', 20, 0, 1, 1, GETDATE(), GETDATE()),
('GIAM15PHAN', 'Giam 15%', 'Giam 15% don hang', 'PERCENTAGE', 15.00, 0.00, 0.00, '2025-01-01', '2025-12-31', 75, 0, 1, 1, GETDATE(), GETDATE()),
('GIAM25PHAN', 'Giam 25%', 'Giam 25% don hang', 'PERCENTAGE', 25.00, 0.00, 0.00, '2025-01-01', '2025-12-31', 30, 0, 1, 1, GETDATE(), GETDATE()),
('GIAM50PHAN', 'Giam 50%', 'Giam 50% don hang', 'PERCENTAGE', 50.00, 0.00, 0.00, '2025-01-01', '2025-12-31', 10, 0, 1, 1, GETDATE(), GETDATE());

-- Simple select to verify
SELECT code, name, discount_type, discount_value FROM Coupon WHERE is_active = 1;

PRINT 'Simple coupon data inserted successfully!';