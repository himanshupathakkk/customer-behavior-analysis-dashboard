-- Q1. Segment customers based on their spending behavior to identify high-value customers.

-- USE myproject;

SELECT 
    customer_id,
    purchase_amount,
    CASE 
        WHEN purchase_amount >= 80 THEN 'High Value'
        WHEN purchase_amount BETWEEN 40 AND 79 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_shopping;

-- After Aggregation
SELECT 
    customer_segment,
    COUNT(*) AS number_of_customers,
    ROUND(AVG(purchase_amount),2) AS avg_spend
FROM (
    SELECT 
        purchase_amount,
        CASE 
            WHEN purchase_amount >= 80 THEN 'High Value'
            WHEN purchase_amount BETWEEN 40 AND 79 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_shopping
) t
GROUP BY customer_segment;


-- Q2: The company wants to understand whether discounts actually increase customer spending or just reduce margins.

SELECT 
    discount_applied,
    COUNT(*) AS total_orders,
    ROUND(AVG(purchase_amount),2) AS avg_order_value,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping
GROUP BY discount_applied;

-- One Level Deeper
SELECT 
    discount_applied,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS order_percentage
FROM customer_shopping
GROUP BY discount_applied;
-- % of orders with discount vs without


-- Q3: The company wants to know whether a small group of customers contributes most of the revenue.

-- 💻 Step 1 — Total Spend Per Customer
SELECT 
    customer_id,
    SUM(purchase_amount) AS total_spent
FROM customer_shopping
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 💻 Step 2 — Top 10 Customers Contribution

SELECT 
    SUM(total_spent) AS top_10_revenue
FROM (
    SELECT 
        customer_id,
        SUM(purchase_amount) AS total_spent
    FROM customer_shopping
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 10
) t;

-- 💻 Step 3 — Total Revenue
SELECT SUM(purchase_amount) AS total_revenue
FROM customer_shopping;


-- Q4: The company wants to identify seasonal trends in revenue to optimize inventory and marketing campaigns.

SELECT 
    season,
    COUNT(*) AS total_orders,
    ROUND(AVG(purchase_amount),2) AS avg_order_value,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping
GROUP BY season
ORDER BY total_revenue DESC;


-- Q5. The company wants to understand whether shipping preferences influence customer spending behavior.

SELECT 
    shipping_type,
    COUNT(*) AS total_orders,
    ROUND(AVG(purchase_amount),2) AS avg_order_value,
    SUM(purchase_amount) AS total_revenue
FROM customer_shopping
GROUP BY shipping_type
ORDER BY avg_order_value DESC;
