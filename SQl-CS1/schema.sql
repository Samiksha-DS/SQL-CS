-- ============================================================
-- SCHEMA: VENDOR / SUPPLY CHAIN ON-TIME DELIVERY SCORECARD
-- Database: MySQL 8.x
-- ============================================================

-- Create the working database
CREATE DATABASE IF NOT EXISTS supply_chain_db;
USE supply_chain_db;

-- Drop table if it already exists (safe re-run for setup)
DROP TABLE IF EXISTS raw_shipments;

-- ============================================================
-- Table: raw_shipments
-- Source: DataCo Smart Supply Chain for Big Data Analysis (Kaggle)
-- Grain: one row = one order-item shipment record
-- ============================================================
CREATE TABLE raw_shipments (
    order_id                  INT,
    order_date                DATETIME,
    shipping_mode              VARCHAR(50),
    actual_shipping_days       INT,
    scheduled_shipping_days    INT,
    late_delivery_risk         TINYINT,
    delivery_status            VARCHAR(50),
    order_region                VARCHAR(100),
    order_country               VARCHAR(100),
    category_name               VARCHAR(100),
    order_qty                   INT,
    order_sales                 DECIMAL(12,2)
);

-- Recommended indexes for query performance
-- (this dataset has 180K+ rows; these speed up the GROUP BY /
--  aggregation queries in solution.sql)
CREATE INDEX idx_shipping_mode ON raw_shipments (shipping_mode);
CREATE INDEX idx_order_region  ON raw_shipments (order_region);
CREATE INDEX idx_category_name ON raw_shipments (category_name);

-- Verify structure
DESCRIBE raw_shipments;
