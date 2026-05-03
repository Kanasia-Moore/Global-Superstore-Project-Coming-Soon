# Global Superstore — Schema Notes

## Dataset Overview

This project uses the Global Superstore dataset consisting of three primary tables:

- **Orders**
- **Returns**
- **People**

These tables were validated before KPI development to confirm grain, key structure, and join integrity.

---

## 1. Orders Table

### Grain
Order-line level  
(Multiple rows per `Order ID`, one row per product line item.)

### Primary Identifiers
- `Order ID`
- `Customer ID`
- `Product Name`
- `Order Date`

### Key Metrics
- `Sales`
- `Profit`
- `Discount`
- `Quantity`

### Dimensions
- `Category`
- `Sub-Category`
- `Segment`
- `Region`
- `Market`
- `Ship Mode`

### Observations
- Order IDs repeat across multiple product rows, confirming line-level structure.
- Sales and Profit appear numeric and populated.
- Discount ranges from **0% to 85%**.

---

## 2. Returns Table

### Grain
One row per returned `Order ID`.

### Key Columns
- `Order ID`
- `Returned` (Flag: Yes)

### Observations
- Used as a return flag table.
- Does not contain monetary return values.
- Will be left joined to Orders to preserve full order population.

---

## 3. People Table

### Grain
One row per **Region** (or region-to-person mapping).

### Key Columns
- `Region`
- `Person`

### Observations
- Acts as a lookup/dimension table.
- Used for regional attribution.
- Joined to Orders via `Region`.

---

## Table Relationships

- `Orders` LEFT JOIN `Returns`
  - Join Key: `Order ID`
  - Purpose: Add binary return flag

- `Orders` LEFT JOIN `People`
  - Join Key: `Region`
  - Purpose: Add regional ownership context

---

## Data Integrity Notes

- Orders table is confirmed to be line-level.
- Returns table functions as a flag and should not change row counts when left joined.
- No critical nulls identified in primary metrics (`Sales`, `Profit`, `Order ID`).
- Dataset spans **2012 - 2015**.

---

## Assumptions

- Returns are treated as a risk flag rather than full refund accounting unless monetary values are provided.
- Profit and Sales are assumed to reflect finalized transaction values.


