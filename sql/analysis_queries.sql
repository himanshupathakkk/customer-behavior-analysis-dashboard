-- =========================================
-- PROJECT: Customer Behavior Analysis
-- Description: SQL queries for customer segmentation,
-- revenue trends, discount impact, and business insights
-- =========================================


-- =========================================
-- 1. CUSTOMER SEGMENTATION (ROW LEVEL)
-- =========================================

SELECT 
    customer_id,
    purchase_amount,
    CASE 
        WHEN purchase_amount >= 80 THEN 'High'
        WHEN purchase_amount BETWEEN 40 AND 79 THEN 'Medium'
        ELSE 'Low'
    END AS customer_segment
FROM customer_shopping;


-- =========================================
-- 2. SEGMENT DISTRIBUTION (AGGREGATED)
-- =========================================

WITH customer_segments AS (
    SELECT 
        purchase_amount,
        CASE 
            WHEN purchase_amount >= 80 THEN 'High'
            WHEN purchase_amount BETWEEN 40 AND 79 THEN 'Medium'
            ELSE 'Low'
        END AS customer_segment
    FROM customer_shopping
)

SELECT 
    customer_segment,
    COUNT(*) AS number_of_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer_segments
GROUP BY customer_segment
ORDER BY number_of_customers DESC;


-- =========================================
-- 3. DISCOUNT IMPACT ANALYSIS
-- =========================================

SELECT 
    discount_applied,
    COUNT(*) AS total_orders,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping
GROUP BY discount_applied;


-- % Distribution of Orders
SELECT 
    discount_applied,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS order_percentage
FROM customer_shopping
GROUP BY discount_applied;


-- =========================================
-- 4. REVENUE CONCENTRATION (TOP CUSTOMERS)
-- =========================================

-- Total Spend Per Customer
WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(purchase_amount) AS total_spent
    FROM customer_shopping
    GROUP BY customer_id
)

SELECT * 
FROM customer_spend
ORDER BY total_spent DESC;


-- Top 10 Customers Revenue
SELECT 
    SUM(total_spent) AS top_10_revenue
FROM (
    SELECT total_spent
    FROM customer_spend
    ORDER BY total_spent DESC
    LIMIT 10
) t;


-- Total Revenue
SELECT 
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping;


-- =========================================
-- 5. SEASONAL ANALYSIS
-- =========================================

SELECT 
    season,
    COUNT(*) AS total_orders,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping
GROUP BY season
ORDER BY total_revenue DESC;


-- =========================================
-- 6. SHIPPING TYPE ANALYSIS
-- =========================================

SELECT 
    shipping_type,
    COUNT(*) AS total_orders,
    ROUND(AVG(purchase_amount), 2) AS avg_order_value,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping
GROUP BY shipping_type
ORDER BY avg_order_value DESC;


-- =========================================
-- 7. HIGH VALUE CUSTOMER PERCENTAGE
-- =========================================

WITH customer_segments AS (
    SELECT 
        CASE 
            WHEN purchase_amount >= 80 THEN 'High'
            WHEN purchase_amount BETWEEN 40 AND 79 THEN 'Medium'
            ELSE 'Low'
        END AS customer_segment
    FROM customer_shopping
)

SELECT 
    ROUND(
        SUM(CASE WHEN customer_segment = 'High' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS high_value_percentage
FROM customer_segments;