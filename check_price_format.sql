-- Kiểm tra format dữ liệu hiện tại
USE SP25_Demo;

-- Kiểm tra format giá sản phẩm
SELECT TOP 5 
    id, 
    name,
    price,
    CAST(price AS DECIMAL(10,2)) as price_formatted
FROM Product;

-- Kiểm tra format discount value trong coupons
SELECT 
    code,
    discount_type,
    discount_value,
    CAST(discount_value AS DECIMAL(10,2)) as discount_formatted,
    min_order_amount,
    CAST(min_order_amount AS DECIMAL(10,2)) as min_order_formatted
FROM Coupon
WHERE is_active = 1;

-- Kiểm tra dữ liệu trong cart hiện tại
SELECT 
    c.id,
    p.name,
    p.price,
    c.quantity,
    (p.price * c.quantity) as total_item_price
FROM Cart c
INNER JOIN Product p ON c.product_id = p.id
WHERE c.user_id = 1; -- Thay đổi user_id nếu cần