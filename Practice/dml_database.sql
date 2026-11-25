IF NOT EXISTS (SELECT 1 FROM crm.customers)
BEGIN
    SET IDENTITY_INSERT crm.customers ON;

    INSERT INTO crm.customers
        (customer_id, first_name, last_name, email,
         phone, city, state_province)
    VALUES
        (1, 'Priya', 'Sharma', 'priya@example.com',
         '9876543210', 'Mumbai', 'Maharashtra'),

        (2, 'Aarav', 'Mehta', 'aarav@example.com',
         '9876543211', 'Pune', 'Maharashtra'),

        (3, 'Neha', 'Patel', 'neha@example.com',
         '9876543212', 'Ahmedabad', 'Gujarat'),

        (4, 'Kabir', 'Khan', 'kabir@example.com',
         '9876543213', 'Delhi', 'Delhi'),

        (5, 'Ananya', 'Rao', 'ananya@example.com',
         '9876543214', 'Bengaluru', 'Karnataka'),

        (6, 'Rohan', 'Desai', 'rohan@example.com',
         NULL, 'Mumbai', 'Maharashtra'),

        (7, 'Isha', 'Nair', 'isha@example.com',
         '9876543216', 'Kochi', 'Kerala'),

        (8, 'Vikram', 'Singh', 'vikram@example.com',
         '9876543217', 'Lucknow', 'Uttar Pradesh');

    SET IDENTITY_INSERT crm.customers OFF;
END;
GO

IF NOT EXISTS (SELECT 1 FROM sales.products)
BEGIN
    SET IDENTITY_INSERT sales.products ON;

    INSERT INTO sales.products
        (product_id, sku, product_name, category,
         unit_price, stock_quntity)
    VALUES
        (101, 'ELEC-LAP-001', 'Business Laptop',
         'Electronics', 74999.00, 12),

        (102, 'ACC-MOU-001', 'Wireless Mouse',
         'Accessories', 799.00, 150),

        (103, 'ACC-KEY-001', 'Mechanical Keyboard',
         'Accessories', 1499.00, 75),

        (104, 'ELEC-MON-001', '27-inch Monitor',
         'Electronics', 12999.00, 25),

        (105, 'ACC-HUB-001', 'USB-C Hub',
         'Accessories', 2499.00, 60),

        (106, 'ELEC-AUD-001', 'Bluetooth Headphones',
         'Electronics', 3999.00, 45),

        (107, 'FUR-CHR-001', 'Ergonomic Chair',
         'Furniture', 8999.00, 18),

        (108, 'ELEC-CAM-001', '1080p Webcam',
         'Electronics', 2799.00, 35),

        (109, 'ELEC-SSD-001', '1TB SSD',
         'Electronics', 5999.00, 40),

        (110, 'ACC-SLV-001', 'Laptop Sleeve',
         'Accessories', 999.00, 90);

    SET IDENTITY_INSERT sales.products OFF;
END;
GO

IF NOT EXISTS (SELECT 1 FROM sales.orders)
BEGIN
    SET IDENTITY_INSERT sales.orders ON;

    INSERT INTO sales.orders
        (order_id, customer_id, order_date,
         order_status, payment_method, shipping_city, shipped_at)
    VALUES
        (1001, 1, '2026-01-05T10:15:00',
         'Delivered', 'UPI', 'Mumbai', '2026-01-06T10:00:00'),

        (1002, 2, '2026-01-15T12:30:00',
         'Delivered', 'Card', 'Pune', '2026-01-16T11:00:00'),

        (1003, 1, '2026-02-02T09:45:00',
         'Cancelled', 'UPI', 'Mumbai', NULL),

        (1004, 3, '2026-03-10T16:20:00',
         'Delivered', 'NetBanking', 'Ahmedabad', '2026-03-11T12:00:00'),

        (1005, 4, '2026-04-18T11:10:00',
         'Processing', 'COD', 'Delhi', NULL),

        (1006, 5, '2026-05-09T14:05:00',
         'Shipped', 'Card', 'Bengaluru', '2026-05-10T09:00:00'),

        (1007, 6, '2026-06-22T18:40:00',
         'Pending', 'UPI', 'Mumbai', NULL),

        (1008, 7, '2026-07-05T10:00:00',
         'Delivered', 'Walet', 'Kochi', '2026-07-06T10:00:00'),

        (1009, 8, '2026-08-16T17:25:00',
         'Cancelled', 'Card', 'Lucknow', NULL),

        (1010, 2, '2026-09-02T13:50:00',
         'Delivered', 'UPI', 'Pune', '2026-09-03T10:00:00'),

        (1011, 3, '2026-10-12T10:30:00',
         'Shipped', 'NetBanking', 'Ahmedabad', '2026-10-13T11:00:00'),

        (1012, 8, '2026-11-10T19:15:00',
         'Processing', 'COD', 'Lucknow', NULL);

    SET IDENTITY_INSERT sales.orders OFF;
END;
GO


IF NOT EXISTS (SELECT 1 FROM sales.order_items)
BEGIN
    SET IDENTITY_INSERT sales.order_items ON;

    INSERT INTO sales.order_items
        (order_item_id, order_id, product_id,
         quantity, unit_price, discount_percent)
    VALUES
        (1, 1001, 101, 1, 74999.00, 5.00),
        (2, 1001, 102, 1, 799.00, 0.00),

        (3, 1002, 104, 1, 12999.00, 10.00),
        (4, 1002, 106, 1, 3999.00, 0.00),

        (5, 1003, 107, 1, 8999.00, 0.00),

        (6, 1004, 103, 2, 1499.00, 0.00),
        (7, 1004, 109, 1, 5999.00, 5.00),

        (8, 1005, 105, 1, 2499.00, 0.00),
        (9, 1005, 102, 2, 799.00, 0.00),

        (10, 1006, 101, 1, 74999.00, 8.00),
        (11, 1006, 110, 1, 999.00, 0.00),

        (12, 1007, 108, 1, 2799.00, 0.00),
        (13, 1007, 102, 1, 799.00, 0.00),

        (14, 1008, 106, 2, 3999.00, 10.00),
        (15, 1008, 105, 1, 2499.00, 0.00),

        (16, 1009, 104, 1, 12999.00, 0.00),

        (17, 1010, 107, 1, 8999.00, 5.00),
        (18, 1010, 103, 1, 1499.00, 0.00),

        (19, 1011, 109, 2, 5999.00, 0.00),
        (20, 1011, 108, 1, 2799.00, 0.00),

        (21, 1012, 101, 1, 74999.00, 0.00),
        (22, 1012, 110, 1, 999.00, 0.00);

    SET IDENTITY_INSERT sales.order_items OFF;
END;
GO

USE SQL_Industry_Lab;
GO

-- 1. Verify current database
SELECT DB_NAME() AS current_database;

-- 2. Verify table row counts
SELECT 'crm.customers' AS table_name,
       COUNT_BIG(*) AS total_rows
FROM crm.customers

UNION ALL

SELECT 'sales.products', COUNT_BIG(*)
FROM sales.products

UNION ALL

SELECT 'sales.orders', COUNT_BIG(*)
FROM sales.orders

UNION ALL

SELECT 'sales.order_items', COUNT_BIG(*)
FROM sales.order_items;


-- 3. Verify foreign-key relationships
SELECT
    fk.name AS foreign_key_name,
    OBJECT_SCHEMA_NAME(fk.parent_object_id)
        + '.' +
    OBJECT_NAME(fk.parent_object_id) AS child_table,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id)
        + '.' +
    OBJECT_NAME(fk.referenced_object_id) AS parent_table
FROM sys.foreign_keys AS fk
ORDER BY child_table;


-- 4. Verify business query relationship
SELECT COUNT_BIG(*) AS joined_order_count
FROM
(
    SELECT o.order_id
    FROM sales.orders AS o
    INNER JOIN crm.customers AS c
        ON o.customer_id = c.customer_id
    INNER JOIN sales.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) AS order_summary;


-- 5. Verify constraint integrity
DBCC CHECKCONSTRAINTS WITH ALL_CONSTRAINTS;
GO