-- Update Product prices to VND format (remove decimals, use whole numbers)
USE SP25_Demo;

-- Backup existing product data
SELECT * INTO Product_Backup_$(FORMAT(GETDATE(), 'yyyyMMdd_HHmmss')) FROM Product;

-- Update product prices to VND format (multiply by appropriate factor)
-- Assuming current price ₫123.04 should become 123,040 VND
UPDATE Product 
SET price = ROUND(price * 1000, 0)  -- Convert to VND (multiply by 1000, no decimals)
WHERE price < 1000;  -- Only update if price is still in old format

-- Alternative: Set specific VND prices
UPDATE Product 
SET price = CASE 
    WHEN name LIKE '%Laptop%' OR name LIKE '%laptop%' THEN 15000000  -- 15M VND for laptops
    WHEN name LIKE '%Phone%' OR name LIKE '%phone%' OR name LIKE '%điện thoại%' THEN 8000000   -- 8M VND for phones
    WHEN name LIKE '%Mouse%' OR name LIKE '%mouse%' OR name LIKE '%chuột%' THEN 500000    -- 500K VND for mouse
    WHEN name LIKE '%Keyboard%' OR name LIKE '%keyboard%' OR name LIKE '%bàn phím%' THEN 800000  -- 800K VND for keyboards
    WHEN name LIKE '%Monitor%' OR name LIKE '%monitor%' OR name LIKE '%màn hình%' THEN 3000000   -- 3M VND for monitors
    WHEN name LIKE '%Headphone%' OR name LIKE '%headphone%' OR name LIKE '%tai nghe%' THEN 1200000 -- 1.2M VND for headphones
    ELSE ROUND(price * 1000, 0)  -- Default: multiply current price by 1000
END;

-- Specific update for the product showing in the cart (Chau Vuong Hoang)
UPDATE Product 
SET price = 123000  -- 123,000 VND instead of 123.04
WHERE name = 'Chau Vuong Hoang' OR price = 123.04;

-- Display updated prices
SELECT 
    id,
    name,
    FORMAT(price, 'N0') + ' VNĐ' as price_display,
    stock,
    status
FROM Product 
ORDER BY price;

PRINT 'Product prices updated to VND format (no decimals)!';
PRINT 'Example: 123.04 -> 123,000 VNĐ';