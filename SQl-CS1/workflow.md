
-- Execution Workflow: Vendor / Supply Chain On-Time Delivery Scorecard


-- PHASE 1: EXTRACTION (Python)
-- 1. Authenticate with Kaggle API using local kaggle.json token
-- 2. Download "DataCo Smart Supply Chain for Big Data Analysis" dataset as CSV
-- 3. Read raw CSV into a DataFrame using Latin-1 encoding (source is not UTF-8)
-- 4. Select only columns needed for delivery-performance analysis:
--    Order Id, Order Date, Shipping Mode, Days for shipping (real),
--    Days for shipment (scheduled), Late_delivery_risk, Delivery Status,
--    Order Region, Order Country, Category Name, Order Item Quantity, Sales
-- 5. Rename columns to snake_case for consistency
-- 6. Parse order_date column to proper datetime type
-- 7. Drop rows with nulls in critical fields (order_date, shipping_mode)
-- 8. Export cleaned DataFrame to staged_shipments.csv

-- PHASE 2: LOAD (Python -> MySQL)
-- 1. Check pymysql driver is installed; raise clear error if missing
-- 2. Build MySQL connection URL using SQLAlchemy's URL.create()
--    (handles special characters like # and @ safely inside the password)
-- 3. Connect to MySQL server without specifying a database first
-- 4. Run: CREATE DATABASE IF NOT EXISTS supply_chain_db
-- 5. Reconnect, this time specifying supply_chain_db as the target database
-- 6. Read staged_shipments.csv into a DataFrame
-- 7. Write DataFrame into raw_shipments table (replace if exists, load in chunks)
-- 8. Print confirmation with total row count loaded

-- PHASE 3: TRANSFORM (SQL, run in MySQL Workbench)
-- 1. USE supply_chain_db
-- 2. Verify row count and structure of raw_shipments table
-- 3. CREATE OR REPLACE VIEW vw_shipment_delays:
--    - delay_days = actual_shipping_days - scheduled_shipping_days
--    - is_late = 1 IF actual_shipping_days > scheduled_shipping_days ELSE 0
--    - carry forward: order_id, order_date, shipping_mode, region, country,
--      category_name, order_sales

-- PHASE 4: ANALYZE (SQL)
-- 1. Shipping-mode-level performance:
--    GROUP BY shipping_mode
--    Compute: total_shipments, late_shipments, late_rate_pct,
--    on_time_rate_pct, avg_delay_days, STDDEV(delay_days) as delay_variability
--
-- 2. Region x shipping-mode risk concentration:
--    GROUP BY order_region, shipping_mode
--    HAVING COUNT(*) >= 50 (filter out statistically noisy small samples)
--    Compute: late_rate_pct, avg_delay_days
--    Sort descending by late_rate_pct, limit to top 15
--
-- 3. Category-level financial exposure:
--    GROUP BY category_name
--    Compute: late_shipments, late_rate_pct
--    revenue_at_risk = SUM(order_sales WHERE is_late = 1)
--    Sort descending by revenue_at_risk, limit to top 10
--
-- 4. Composite scorecard (final deliverable):
--    Build mode_stats CTE: on_time_pct, avg_delay_days, delay_stddev per shipping_mode
--    Apply RANK() OVER (
--      ORDER BY on_time_pct DESC, avg_delay_days ASC, delay_stddev ASC
--    ) AS performance_rank
--    Output final ranked table ordered by performance_rank

-- PHASE 5: OUTPUT & DOCUMENTATION
-- 1. Export the final ranked scorecard as the primary deliverable
-- 2. Cross-check any striking result (e.g., 0% on-time, 0 variance) against
--    a regional breakdown before treating it as a real finding

