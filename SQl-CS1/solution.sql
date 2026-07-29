-- ============================================================
-- SOLUTION: VENDOR / SUPPLY CHAIN ON-TIME DELIVERY SCORECARD
-- Database: MySQL 8.x | Client: MySQL Workbench
-- ============================================================

-- Switch to working database
USE supply_chain_db;

-- Sanity check: confirm data loaded correctly
SELECT COUNT(*) AS total_rows FROM raw_shipments;
DESCRIBE raw_shipments;
SELECT * FROM raw_shipments LIMIT 10;


-- ============================================================
-- 1. TRANSFORMATION LAYER
-- Create a reusable view with derived delay metrics
-- ============================================================
CREATE OR REPLACE VIEW vw_shipment_delays AS
SELECT
    order_id,
    order_date,
    shipping_mode,
    order_region,
    order_country,
    category_name,
    actual_shipping_days,
    scheduled_shipping_days,
    (actual_shipping_days - scheduled_shipping_days) AS delay_days,
    CASE
        WHEN actual_shipping_days > scheduled_shipping_days THEN 1
        ELSE 0
    END AS is_late,
    order_sales
FROM raw_shipments;

-- Verify the view
SELECT * FROM vw_shipment_delays LIMIT 20;


-- ============================================================
-- 2. ON-TIME PERCENTAGE AND DELAY VARIABILITY BY SHIPPING MODE
-- ============================================================
SELECT
    shipping_mode,
    COUNT(*) AS total_shipments,
    SUM(is_late) AS late_shipments,
    ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct,
    ROUND(100.0 * (COUNT(*) - SUM(is_late)) / COUNT(*), 2) AS on_time_rate_pct,
    ROUND(AVG(delay_days), 2) AS avg_delay_days,
    ROUND(STDDEV(delay_days), 2) AS delay_variability
FROM vw_shipment_delays
GROUP BY shipping_mode
ORDER BY late_rate_pct DESC;


-- ============================================================
-- 3. REGIONAL BREAKDOWN
-- Highest-risk region and shipping-mode combinations
-- ============================================================
SELECT
    order_region,
    shipping_mode,
    COUNT(*) AS total_shipments,
    ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct,
    ROUND(AVG(delay_days), 2) AS avg_delay_days
FROM vw_shipment_delays
GROUP BY order_region, shipping_mode
HAVING COUNT(*) >= 50
ORDER BY late_rate_pct DESC
LIMIT 15;


-- ============================================================
-- 4. PRODUCT CATEGORY RISK CONTRIBUTION
-- Revenue exposure tied to late shipments
-- ============================================================
SELECT
    category_name,
    COUNT(*) AS total_shipments,
    SUM(is_late) AS late_shipments,
    ROUND(100.0 * SUM(is_late) / COUNT(*), 2) AS late_rate_pct,
    ROUND(SUM(CASE WHEN is_late = 1 THEN order_sales ELSE 0 END), 2) AS revenue_at_risk
FROM vw_shipment_delays
GROUP BY category_name
ORDER BY revenue_at_risk DESC
LIMIT 10;


-- ============================================================
-- 5. FINAL DELIVERABLE
-- Composite shipping-mode scorecard, ranked
-- ============================================================
WITH mode_stats AS (
    SELECT
        shipping_mode,
        COUNT(*) AS total_shipments,
        ROUND(100.0 * (COUNT(*) - SUM(is_late)) / COUNT(*), 2) AS on_time_pct,
        ROUND(AVG(delay_days), 2) AS avg_delay_days,
        ROUND(STDDEV(delay_days), 2) AS delay_stddev
    FROM vw_shipment_delays
    GROUP BY shipping_mode
)
SELECT
    shipping_mode,
    total_shipments,
    on_time_pct,
    avg_delay_days,
    delay_stddev,
    RANK() OVER (
        ORDER BY on_time_pct DESC, avg_delay_days ASC, delay_stddev ASC
    ) AS performance_rank
FROM mode_stats
ORDER BY performance_rank;
