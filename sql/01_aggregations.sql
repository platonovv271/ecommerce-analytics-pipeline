-- =================================================================
-- PHASE 1: FOUNDATIONAL AGGREGATIONS & INTERVAL ANALYSIS
-- File: sql/01_aggregations.sql
-- Engine: DuckDB
-- =================================================================

-- -----------------------------------------------------------------
-- Task 1: Payment Distribution by Installments
-- -----------------------------------------------------------------
-- Business Objective:
--   Analyze customer purchasing power and payment preferences by evaluating 
--   how order values distribute across different installment plans.
--
-- Logic & Methodology:
--   1. Filter out zero/invalid installments (payment_installments > 0).
--   2. Group transactions by installment count.
--   3. Aggregate total volume (COUNT) and calculate average order value (AVG).
--   4. Sort sequentially to observe trends from single-pay to long-term plans.
--
-- Input Source: olist_order_payments_dataset.csv
-- -----------------------------------------------------------------

SELECT 
    payment_installments,
    COUNT(*) AS total_transactions,
    ROUND(AVG(payment_value), 2) AS average_value
FROM 'D:/ANALYTICS_/ecommerce-analytics-pipeline/data/olist_order_payments_dataset.csv'
WHERE payment_installments > 0
GROUP BY payment_installments
ORDER BY payment_installments ASC;


-- -----------------------------------------------------------------
-- Task 2.1: High-Density Customer Regions
-- -----------------------------------------------------------------
-- Business Objective:
--   Identify core geographical markets with substantial customer concentration 
--   (>3,000 customers) to optimize regional logistics and warehouse distribution.
--
-- Logic & Methodology:
--   1. Aggregate total unique customer profiles per state using COUNT(*).
--   2. Apply post-aggregation filtering via HAVING total_state > 3000 to isolate key hubs.
--   3. Sort in descending order to highlight primary market leaders.
--
-- Input Source: olist_customers_dataset.csv
-- -----------------------------------------------------------------

SELECT 
    customer_state,
    COUNT(*) AS total_state
FROM 'D:/ANALYTICS_/ecommerce-analytics-pipeline/data/olist_customers_dataset.csv'
GROUP BY customer_state
HAVING total_state > 3000
ORDER BY total_state DESC;


-- -----------------------------------------------------------------
-- Task 2.2: High-Value Transactions (>100 BRL) by Payment Type
-- -----------------------------------------------------------------
-- Business Objective:
--   Evaluate payment method performance for major purchases to understand 
--   which payment channels process higher financial volume and peak basket sizes.
--
-- Logic & Methodology:
--   1. Filter raw transaction rows before aggregation (WHERE payment_value > 100).
--   2. Group filtered payments by payment channel (credit card, ticket, etc.).
--   3. Compute total large transactions, rounded average spend, and peak single check.
--   4. Rank payment methods by highest average large transaction size.
--
-- Input Source: olist_order_payments_dataset.csv
-- -----------------------------------------------------------------

SELECT 
    payment_type,
    COUNT(*) AS large_transactions,
    ROUND(AVG(payment_value), 2) AS avg_large_check,
    MAX(payment_value) AS max_check
FROM 'D:/ANALYTICS_/ecommerce-analytics-pipeline/data/olist_order_payments_dataset.csv'
WHERE payment_value > 100
GROUP BY payment_type
ORDER BY avg_large_check DESC;


-- -----------------------------------------------------------------
-- Task 3: Actual Delivery Timeframe Analysis by Order Status
-- -----------------------------------------------------------------
-- Business Objective:
--   Assess logistics operational efficiency by calculating actual lead times 
--   (in days) from purchase timestamp to final customer delivery.
--
-- Logic & Methodology:
--   1. Exclude incomplete or undelivered orders (WHERE order_delivered_customer_date IS NOT NULL).
--   2. Explicitly cast ISO string timestamps to TIMESTAMP types for date arithmetic.
--   3. Utilize date_diff('day', start, end) to compute exact fulfillment duration.
--   4. Aggregate overall order volume along with MIN, rounded AVG, and MAX delivery days.
--   5. Group results by order status and sort by volume to emphasize completed orders.
--
-- Input Source: olist_orders_dataset.csv
-- -----------------------------------------------------------------

SELECT 
    order_status,
    COUNT(*) AS total_orders,
    MIN(date_diff('day', order_purchase_timestamp::TIMESTAMP, order_delivered_customer_date::TIMESTAMP)) AS min_delivery,
    ROUND(AVG(date_diff('day', order_purchase_timestamp::TIMESTAMP, order_delivered_customer_date::TIMESTAMP)), 1) AS avg_delivery,
    MAX(date_diff('day', order_purchase_timestamp::TIMESTAMP, order_delivered_customer_date::TIMESTAMP)) AS max_delivery
FROM 'D:/ANALYTICS_/ecommerce-analytics-pipeline/data/olist_orders_dataset.csv'
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY order_status
ORDER BY total_orders DESC;