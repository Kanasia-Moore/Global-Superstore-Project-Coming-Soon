# Global Superstore KPI & Performance Analysis

## Project Navigation

- [Business Questions](./docs/business_questions.md)
- [Data Quality Checks](./docs/qc_summary.md)
- [Metric Dictionary](./docs/metric_dictionary.md)
- [SQL / Data Transformation](./SQL/)
- [Dashboard](./Tableau/dashboard/)
- [Key Insights](./docs/insights_and_recommendations/)

## Project Overview

This project analyzes the Global Superstore dataset to evaluate business performance, profitability, and return behavior.  

The goal is to move beyond surface-level reporting and build a structured analysis that identifies key drivers of revenue, profit, and operational inefficiencies.

This project follows a full analytical workflow:
- Data validation and quality control
- Data modeling and transformation
- Metric definition and standardization
- KPI development
- Business-focused analysis

---

## Business Questions

The analysis is guided by the following key questions:

- How is the business performing in terms of sales and profit?
- What is the overall return rate, and how does it impact performance?
- How do discounts affect profitability?
- Which factors drive higher or lower profit margins?
- Are there patterns in returns across orders, regions, or segments?

---

## Dataset

The dataset consists of three primary tables:

- **Orders** → Transaction-level sales data  
- **Returns** → Flags for returned orders  
- **People** → Regional ownership/assignment  

These tables were joined and transformed to create a structured analysis-ready dataset.

---

## Data Preparation

Data preparation included:

- Joining `orders`, `returns`, and `people` tables
- Creating a return flag at the order level
- Extracting time-based fields (month, year)
- Creating discount groupings (`Discount_Band`)
- Calculating profit margin at the line level
- Aggregating data to the order level for accurate KPI analysis

A full quality control review was conducted to validate:
- Record consistency
- Null values
- Duplicate return records
- Numeric ranges
- Join integrity

---

## Data Model

The analysis follows a layered data model:

- **Base Layer (`superstore_base`)**  
  Enriched transaction-level dataset with derived fields

- **Aggregation Layer (`superstore_order_summary`)**  
  Order-level dataset for KPI calculations

This structure ensures consistency and prevents double counting when calculating metrics.

---

## Metric Framework

Metrics are defined across three layers:

- **Base Metrics** → Row-level calculations (e.g., profit margin per line)
- **Aggregated Metrics** → Order-level calculations (e.g., total order sales)
- **KPIs** → Business-level performance indicators

A full breakdown is available in [`metric_dictionary.md`](./metric_dictionary.md)

---

## Key Performance Indicators

The following KPIs were used to evaluate performance:

- **Total Orders** → Total number of transactions  
- **Total Sales** → Overall revenue  
- **Total Profit** → Overall profitability  
- **Profit Margin (%)** → Efficiency of revenue generation  
- **Total Returns** → Number of returned orders  
- **Return Rate (%)** → Percentage of orders returned  

These KPIs provide a high-level view of both financial performance and operational efficiency.

---

## Analysis Approach

The analysis was conducted using SQL in a structured, step-by-step approach:

1. Data validation and QC checks  
2. Creation of a base analytical dataset  
3. Development of order-level aggregations  
4. KPI calculations  
5. Exploratory analysis of returns, discounts, and profitability  

This approach ensures that insights are built on a reliable and well-defined data foundation.

---

## Key Insights

> *(Replace with your actual findings once finalized)*

- Return rates represent a meaningful portion of total orders and impact profitability  
- Higher discounts do not always translate to higher sales performance  
- Certain orders generate high revenue but low profit margins  
- Profitability varies significantly across transactions  

---

## Dashboard

> *(Add screenshots or link once completed)*

The final dashboard visualizes:
- KPI performance
- Return trends
- Profitability analysis
- Discount impact

---

## Tools & Technologies

- **SQL (BigQuery)** → Data transformation and analysis  
- **Tableau / Power BI (optional)** → Data visualization  
- **GitHub** → Version control and project presentation  

---
