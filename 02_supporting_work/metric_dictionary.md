# Metric Dictionary

This document defines all calculated fields and key metrics used in the Global Superstore analysis. Metrics are organized by transformation layer to reflect how the data model was built.

---

## 1. Base-Level Derived Metrics (`superstore_base`)

These metrics are calculated at the transaction (row) level.

### Order_Month
- **Definition:** Month extracted from `Order_Date`
- **Formula:** `EXTRACT(MONTH FROM Order_Date)`
- **Purpose:** Enables monthly trend analysis

---

### Order_Year
- **Definition:** Year extracted from `Order_Date`
- **Formula:** `EXTRACT(YEAR FROM Order_Date)`
- **Purpose:** Enables year-over-year comparisons

---

### Return_Flag
- **Definition:** Indicates whether an order was returned
- **Formula:** `IF(Returned IS NOT NULL, 1, 0)`
- **Values:** 1 = Returned, 0 = Not Returned
- **Purpose:** Used to calculate return rate and analyze return behavior

---

### Discount_Band
- **Definition:** Categorizes discount values into grouped ranges
- **Logic:**
  - 0 → '0%'
  - ≤ 0.01 → '<1%'
  - ≤ 0.15 → '1-15%'
  - ≤ 0.30 → '16-30%'
  - ≤ 0.50 → '31-50%'
  - 0.50+ → '>50%'
- **Purpose:** Simplifies discount analysis and supports segmentation

---

### Profit_Margin_Line
- **Definition:** Profit margin calculated at the line-item level
- **Formula:**  
  `ROUND(SAFE_DIVIDE(Profit, Sales) * 100, 2)`
- **Purpose:** Measures profitability per transaction

---

## 2. Order-Level Metrics (`superstore_order_summary`)

These metrics are aggregated to the order level.

### Sales (Order-Level)
- **Definition:** Total sales per order
- **Formula:** `SUM(Sales)`
- **Purpose:** Measures revenue generated per order

---

### Profit (Order-Level)
- **Definition:** Total profit per order
- **Formula:** `SUM(Profit)`
- **Purpose:** Measures profitability per order

---

### Profit_Margin
- **Definition:** Profit margin per order
- **Formula:**  
  `ROUND(SAFE_DIVIDE(SUM(Profit), SUM(Sales)) * 100, 2)`
- **Purpose:** Evaluates order-level profitability

---

### Avg_Discount
- **Definition:** Average discount applied across items in an order
- **Formula:** `ROUND(AVG(Discount), 2)`
- **Purpose:** Helps analyze discounting strategy impact

---

### Return_Flag (Order-Level)
- **Definition:** Indicates whether any item in the order was returned
- **Formula:** `MAX(Return_Flag)`
- **Values:** 1 = Returned, 0 = Not Returned
- **Purpose:** Enables accurate return tracking at the order level

---

## 3. Key Performance Indicators (KPIs)

These are high-level metrics used to evaluate overall business performance.

---

### Total Orders
- **Definition:** Total number of orders
- **Formula:** `COUNT(*)`
- **Source:** `superstore_order_summary`
- **Purpose:** Measures overall transaction volume

---

### Total Returns
- **Definition:** Total number of returned orders
- **Formula:** `COUNTIF(Return_Flag = 1)`
- **Purpose:** Measures return volume

---

### Total Sales
- **Definition:** Total revenue across all orders
- **Formula:** `SUM(Sales)`
- **Purpose:** Measures overall business revenue

---

### Total Profit
- **Definition:** Total profit across all orders
- **Formula:** `SUM(Profit)`
- **Purpose:** Measures overall profitability

---

### Profit Margin
- **Definition:** Overall profit margin percentage
- **Formula:**  
  `ROUND(SAFE_DIVIDE(SUM(Profit), SUM(Sales)) * 100, 2)`
- **Purpose:** Indicates overall business efficiency

---

### Return Rate
- **Definition:** Percentage of orders that were returned
- **Formula:**  
  `ROUND(COUNTIF(Return_Flag = 1) / COUNT(*) * 100, 2)`
- **Purpose:** Evaluates product/customer satisfaction and operational issues

---

## Summary

This metric framework follows a layered approach:

- **Base Layer:** Row-level transformations for enrichment
- **Aggregation Layer:** Order-level consolidation
- **KPI Layer:** High-level performance indicators

This structure ensures consistency, scalability, and clarity across all analyses and dashboards.
