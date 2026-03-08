CREATE DATABASE superstore_db;
USE superstore_db;

CREATE TABLE superstore_raw (
    row_id INT,
    order_id VARCHAR(20),
    order_date VARCHAR(20),
    ship_date VARCHAR(20),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(20),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
) CHARACTER SET latin1;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sample - Superstore.csv'
INTO TABLE superstore_raw
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SELECT count(*) FROM superstore_raw;

CREATE TABLE superstore_clean AS
SELECT
    row_id,
    order_id,
    STR_TO_DATE(order_date, '%m/%d/%Y') AS order_date,
    STR_TO_DATE(ship_date, '%m/%d/%Y') AS ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw;

SELECT order_date, ship_date
FROM superstore_clean
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    SUM(order_date IS NULL) AS null_order_dates,
    SUM(ship_date IS NULL) AS null_ship_dates
FROM superstore_clean;

CREATE TABLE dim_customer AS
SELECT DISTINCT
    customer_id,
    customer_name,
    segment,
    region
FROM superstore_clean;

CREATE TABLE dim_product AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM superstore_clean;

CREATE TABLE dim_location AS
SELECT DISTINCT
    city,
    state,
    postal_code,
    region
FROM superstore_clean;

CREATE TABLE dim_ship_mode AS
SELECT DISTINCT
    ship_mode
FROM superstore_clean;

CREATE TABLE dim_date AS
SELECT DISTINCT
    order_date AS date,
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    QUARTER(order_date) AS quarter
FROM superstore_clean;

CREATE TABLE fact_sales AS
SELECT
    row_id,
    order_id,
    customer_id,
    product_id,
    city,
    ship_mode,
    order_date,
    sales,
    quantity,
    discount,
    profit
FROM superstore_clean;

SELECT COUNT(*) FROM dim_customer;

SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM fact_sales;

SELECT
    dc.region,
    SUM(fs.sales) AS total_sales,
    SUM(fs.profit) AS total_profit
FROM fact_sales fs
JOIN dim_customer dc
    ON fs.customer_id = dc.customer_id
GROUP BY dc.region
ORDER BY total_sales DESC;

SELECT
    dc.customer_name,
    SUM(fs.sales) AS total_sales
FROM fact_sales fs
JOIN dim_customer dc
    ON fs.customer_id = dc.customer_id
GROUP BY dc.customer_name
ORDER BY total_sales DESC
LIMIT 10;

SELECT
    dp.product_name,
    SUM(fs.profit) AS total_profit
FROM fact_sales fs
JOIN dim_product dp
    ON fs.product_id = dp.product_id
GROUP BY dp.product_name
HAVING total_profit < 0
ORDER BY total_profit;

SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(sales) AS total_sales
FROM fact_sales
GROUP BY year, month
ORDER BY year, month;

SELECT
    ship_mode,
    COUNT(*) AS orders,
    SUM(sales) AS sales,
    SUM(profit) AS profit
FROM fact_sales
GROUP BY ship_mode;

SELECT
    order_date,
    SUM(sales) AS daily_sales,
    SUM(SUM(sales)) OVER (ORDER BY order_date) AS running_sales
FROM fact_sales
GROUP BY order_date
ORDER BY order_date;

SELECT
    COUNT(*) AS loss_making_products_count
FROM (
    SELECT
        product_id,
        SUM(profit) AS total_profit
    FROM fact_sales
    GROUP BY product_id
    HAVING SUM(profit) < 0
) t;

CREATE TABLE dim_customer_clean AS
SELECT DISTINCT
    customer_id,
    customer_name,
    segment,
    region
FROM dim_customer;

CREATE TABLE dim_product_clean AS
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM dim_product;

SELECT 
    customer_id,
    COUNT(*) AS total_count
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT 
    product_id,
    COUNT(*) AS total_count
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM dim_customer;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS distinct_products
FROM dim_product;

CREATE TABLE dim_customer_final AS
SELECT
    customer_id,
    MAX(customer_name) AS customer_name,
    MAX(segment) AS segment,
    MAX(region) AS region
FROM dim_customer
GROUP BY customer_id;

CREATE TABLE dim_product_final AS
SELECT
    product_id,
    MAX(product_name) AS product_name,
    MAX(category) AS category,
    MAX(sub_category) AS sub_category
FROM dim_product
GROUP BY product_id;

SELECT 
    COUNT(*) total,
    COUNT(DISTINCT customer_id) distinct_ids
FROM dim_customer_final;

SELECT 
    COUNT(*) total,
    COUNT(DISTINCT product_id) distinct_ids
FROM dim_product_final;

SELECT 
    customer_id,
    COUNT(DISTINCT customer_name) AS name_variations
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_name) > 1;

SELECT 
    customer_id,
    COUNT(DISTINCT region) AS region_variations
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(DISTINCT region) > 1;

SELECT 
    customer_id,
    COUNT(DISTINCT segment) AS segment_variations
FROM dim_customer
GROUP BY customer_id
HAVING COUNT(DISTINCT segment) > 1;

SELECT 
    product_id,
    COUNT(DISTINCT product_name) AS name_variations
FROM dim_product
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1;

SELECT 
    product_id,
    COUNT(DISTINCT category) AS category_variations,
    COUNT(DISTINCT sub_category) AS subcategory_variations
FROM dim_product
GROUP BY product_id
HAVING 
    COUNT(DISTINCT category) > 1
    OR COUNT(DISTINCT sub_category) > 1;

drop TABLE dim_customer_final;

CREATE TABLE dim_customer_final AS
SELECT
    dc.customer_id,
    MAX(dc.customer_name) AS customer_name,
    MAX(dc.segment) AS segment,
    SUBSTRING_INDEX(
        GROUP_CONCAT(dc.region ORDER BY fs.order_date DESC),
        ',', 1
    ) AS current_region
FROM dim_customer dc
JOIN fact_sales fs
    ON dc.customer_id = fs.customer_id
GROUP BY dc.customer_id;

SELECT
    COUNT(*) total_rows,
    COUNT(DISTINCT customer_id) distinct_ids
FROM dim_customer_final;

drop TABLE dim_product_final;

CREATE TABLE dim_product_final AS
SELECT
    product_id,
    MAX(product_name) AS product_name,
    MAX(category) AS category,
    MAX(sub_category) AS sub_category
FROM dim_product
GROUP BY product_id;

SELECT
    COUNT(*) total_rows,
    COUNT(DISTINCT product_id) distinct_ids
FROM dim_product_final;

SELECT
    dc.customer_id,
    GROUP_CONCAT(dc.region ORDER BY fs.order_date DESC)
FROM dim_customer dc
JOIN fact_sales fs ON dc.customer_id = fs.customer_id
GROUP BY dc.customer_id
LIMIT 5;
