-- PSEUDOCODE: VENDOR / SUPPLY CHAIN ON-TIME DELIVERY SCORECARD

-- PHASE 1: EXTRACTION (Python)
-- 1. Authenticate with Kaggle API using local kaggle.json token
-- 2. Download DataCo Smart Supply Chain dataset as CSV
-- 3. Read raw CSV using Latin-1 encoding (source file is not UTF-8)
-- 4. Select columns: Order Id, Order Date, Shipping Mode, Days for shipping (real), Days for shipment (scheduled), Late_delivery_risk, Delivery Status, Order Region, Order Country, Category Name, Order Item Quantity, Sales
-- 5. Rename columns to snake_case for consistency
-- 6. Parse order_date column to datetime type
-- 7. Drop rows with nulls in order_date or shipping_mode
-- 8. Export cleaned DataFrame to staged_shipments.csv

-- PHASE 2: LOAD (Python to MySQL)
-- 1. Check pymysql driver is installed
-- 2. Build MySQL connection URL using SQLAlchemy URL.create()
-- 3. Connect to MySQL server without specifying a database
-- 4. Run CREATE DATABASE IF NOT EXISTS supply_chain_db
-- 5. Reconnect targeting supply_chain_db
-- 6. Read staged_shipments.csv into a DataFrame
-- 7. Write DataFrame into raw_shipments table, replace if exists, load in chunks
-- 8. Print confirmation with total row count loaded

-- PHASE 3: TRANSFORM (SQL in MySQL Workbench)
-- 1. USE supply_chain_db
-- 2. Verify row count and structure of raw_shipments
-- 3. Create view vw_shipment_delays
-- 4. delay_days equals actual_shipping_days minus scheduled_shipping_days
-- 5. is_late equals 1 if actual_shipping_days greater than scheduled_shipping_days, else 0
-- 6. Carry forward order_id, order_date, shipping_mode, region, country, category_name, order_sales

-- PHASE 4: ANALYZE (SQL)
-- 1. Group by shipping_mode, compute total_shipments, late_shipments, late_rate_pct, on_time_rate_pct, avg_delay_days, delay_variability
-- 2. Group by order_region and shipping_mode, filter HAVING count >= 50, compute late_rate_pct and avg_delay_days, sort descending, limit 15
-- 3. Group by category_name, compute late_shipments, late_rate_pct, revenue_at_risk, sort descending, limit 10
-- 4. Build mode_stats CTE with on_time_pct, avg_delay_days, delay_stddev per shipping_mode
-- 5. Apply RANK() OVER ORDER BY on_time_pct DESC, avg_delay_days ASC, delay_stddev ASC as performance_rank
-- 6. Output final ranked table ordered by performance_rank

-- PHASE 5: OUTPUT AND DOCUMENTATION
-- 1. Export final ranked scorecard as primary deliverable
-- 2. Cross-check striking results against regional breakdown before trusting them
