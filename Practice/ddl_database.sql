USE SQL_Industry_Lab
GO

IF OBJECT_ID(N'crm.customers', N'U') IS NULL
BEGIN
	CREATE TABLE crm.customers
	(
	 customer_id INT IDENTITY(1,1) NOT NULL,
	 first_name NVARCHAR(50) NOT NULL,
	 last_name NVARCHAR(50) NOT NULL,
	 email NVARCHAR(254) NOT NULL,
	 phone NVARCHAR(25) NULL,
	 city NVARCHAR(80) NOT NULL,
	 state_province NVARCHAR(80) NOT NULL,
	 country_code CHAR(2) NOT NULL
		CONSTRAINT DF_crm_customers_country DEFAULT('IN'),
	 created_at DATETIME2(0) NOT NULL 
		CONSTRAINT DF_crm_customers_created DEFAULT(SYSUTCDATETIME()),
	 is_active BIT NOT NULL
		CONSTRAINT DF_crm_customers_active DEFAULT(1),
	 
	 CONSTRAINT PK_crm_customers
		PRIMARY KEY (customer_id),

	CONSTRAINT UQ_crm_customers_email
		UNIQUE(email)
	)
END;
GO

IF OBJECT_ID(N'sales.products', N'U') IS NULL
BEGIN
	CREATE TABLE sales.products
	(
	 product_id INT IDENTITY(1,1) NOT NULL,
	 sku NVARCHAR(30) NOT NULL,
	 product_name NVARCHAR(120) NOT NULL,
	 category NVARCHAR(60) NOT NULL,
	 unit_price DECIMAL(10, 2) NOT NULL,
	 stock_quntity INT NOT NULL
		CONSTRAINT DF_sales_products_stock DEFAULT(0),
	 is_active BIT NOT NULL
		CONSTRAINT DF_sales_product_active DEFAULT(1),
	 create_at DATETIME2(0) NOT NULL
		CONSTRAINT DF_sales_products_created DEFAULT(SYSUTCDATETIME()),
	 
	 CONSTRAINT PK_sales_products
		PRIMARY KEY (product_id),

	 CONSTRAINT UQ_sales_products_sku
		UNIQUE(sku),

	 CONSTRAINT CK_sales_product_price
		CHECK(unit_price >= 0),
	
	 CONSTRAINT CK_sales_product_stock
		CHECK(stock_quntity >= 0)
	)
END
GO

IF OBJECT_ID(N'sales.orders', N'U') IS NULL
BEGIN
	CREATE TABLE sales.orders 
	(
	 order_id INT IDENTITY(1,1) NOT NULL,
	 customer_id INT NOT NULL,
	 order_date DATETIME2(0) NOT NULL
		CONSTRAINT DF_sales_orders_date DEFAULT(SYSUTCDATETIME()),
	 order_status VARCHAR(20) NOT NULL
		CONSTRAINT DF_sales_orders_status DEFAULT('Pending'),
	 payment_method VARCHAR(20) NOT NULL
		CONSTRAINT DF_sales_orders_payment DEFAULT('UPI'),
	 shipping_city NVARCHAR(80) NOT NULL,
	 shipped_at DATETIME2(2) NULL,

	 CONSTRAINT PK_sales_orders
		PRIMARY KEY (order_id),

	 CONSTRAINT FK_sales_orders_customers
		FOREIGN KEY (customer_id) REFERENCES crm.customers(customer_id),
	 
	 CONSTRAINT CK_sales_orders_payment
		CHECK(payment_method IN ('UPI','Card','NetBanking','COD','Walet')),

	 CONSTRAINT CK_sales_orders_status
		CHECK(order_status IN ('Pending','Processing','Shipped','Delivered','Cancelled','Returned')),

	 CONSTRAINT CK_salse_orders_shipping_date
		CHECK(shipped_at IS NULL OR shipped_at >= order_date)
	)
END
GO

IF OBJECT_ID(N'sales.order_items', N'U') IS NULL
BEGIN
	CREATE TABLE sales.order_items
	(
	 order_item_id INT IDENTITY(1,1) NOT NULL,
	 order_id INT NOT NULL,
	 product_id INT NOT NULL,
	 quantity INT NOT NULL,
	 unit_price DECIMAL(10,2) NOT NULL,
	 discount_percent DECIMAL(5,2) NOT NULL
		CONSTRAINT DF_sales_order_items_discount DEFAULT(0),
	 
	 line_total AS CONVERT(
	 DECIMAL(10,2),
	 unit_price * quantity * (1.00 - discount_percent/100.00)
	 ) PERSISTED,

	 CONSTRAINT PK_sales_order_items
		PRIMARY KEY (order_item_id),

	 CONSTRAINT FK_sales_order_items_orders
		FOREIGN KEY (order_id) REFERENCES sales.orders(order_id),

	 CONSTRAINT FK_sales_order_items_products
		FOREIGN KEY (product_id) REFERENCES sales.products(product_id),

	 CONSTRAINT UQ_order_items_order_product
		UNIQUE(order_id,product_id),
	 
	 CONSTRAINT CK_sales_order_items_quantity
		CHECK(quantity > 0),

	 CONSTRAINT CK_order_item_price
		CHECK(unit_price >= 0),
	 
	 CONSTRAINT CK_order_discount
		CHECK(discount_percent BETWEEN 0 AND 100)
	);
END;
GO

DROP TABLE sales_order_items;