## Quality Control Summary

To validate the reliability of the Global Superstore dataset before analysis, I performed a series of quality control checks across the `orders`, `returns`, and `people` tables. These checks focused on record counts, date coverage, null values, duplicates, numeric ranges, discount anomalies, return mapping, and join integrity.

---

### 1. Order Table Record Validation

I first checked total row count versus distinct `Order_ID` count in the `orders` table to confirm whether each row represented a unique line item or whether multiple rows existed per order.

**QC Findings:**
- Total rows: `51290`
- Distinct orders: `25728`

**Interpretation:**  
This confirms that the dataset is structured at the line-item level rather than one row per order, which is expected for transaction-level sales analysis.

---

### 2. Date Range Validation

I reviewed the minimum and maximum `Order_Date` values to confirm the time span covered by the dataset.

**QC Findings:**
- Earliest order date: `2012-01-01`
- Latest order date: `2015-12-31`

**Interpretation:**  
This establishes the reporting window for the dataset and confirms the date field is populated within the expected historical range.

---

### 3. Returns Table Validation

I checked the total number of records and distinct returned orders in the `returns` table.

**QC Findings:**
- Total return records: `1079`
- Distinct returned orders: `1079`

**Interpretation:**  
This confirms how many orders were flagged as returned and helps validate the size of the return population before merging returns into the base table.
This also confirms that while the `orders` table is line-level, the `returns` table is order-level.

---

### 4. Duplicate Return Check

I tested whether any `Order_ID` appeared more than once in the `returns` table.

**QC Findings:**
- Duplicate return records: `0`

**Interpretation:**  
If duplicates exist, that would indicate a data quality issue in the returns table and could inflate return counts after joining. If none were found, the table can be treated as a clean order-level return flag source.

---

### 5. Null Check in Key Fields

I checked for missing values in important analytical fields in the `orders` table.

**Fields reviewed:**
- `Order_ID`
- `Order_Date`
- `Customer_ID`
- `Sales`
- `Profit`

**QC Findings:**
No nulls were found across these specific columns.

**Interpretation:**  
These checks confirm whether critical identifiers and financial fields are complete enough for reliable KPI, trend, and customer analysis.

---

### 6. Numeric Range Validation

I reviewed the minimum and maximum values for `Sales`, `Profit`, and `Discount` to identify unusual ranges or possible outliers.

**QC Findings:**
- Min sales: `[insert result]`
- Max sales: `[insert result]`
- Min profit: `[insert result]`
- Max profit: `[insert result]`
- Min discount: `[insert result]`
- Max discount: `[insert result]`

**Interpretation:**  
This helps confirm that the core financial columns fall within a believable business range and highlights whether losses, extreme profits, or unexpected discount values need special attention.

---

### 7. Zero-Value Check

I checked how many rows had zero sales or zero profit.

**QC Findings:**
- Zero sales rows: `[insert result]`
- Zero profit rows: `[insert result]`

**Interpretation:**  
Zero-value checks help identify transactions that may need further review. Zero profit may be valid, but zero sales should be assessed carefully depending on business logic.

---

### 8. Discount Value Review

I pulled all distinct discount values from the `orders` table to confirm whether discounts follow standard expected increments.

**QC Findings:**
- Distinct discount values: `[insert values]`

**Interpretation:**  
This step helps identify irregular discount values that may represent data entry issues, formatting inconsistencies, or edge-case transactions.

---

### 9. Low Discount Anomaly (`0.002`)

A specific QC check was run on discount value `0.002`, since this appears unusually small compared with standard retail discount tiers.

**QC Findings:**
- Number of rows with `discount = 0.002`: `[insert result]`
- Percentage of total rows: `[insert result]%`
- Revenue tied to `discount = 0.002`: `[insert result]`
- Percentage of total revenue: `[insert result]%`

**Interpretation:**  
This value likely represents an anomaly or precision inconsistency rather than a meaningful business discount category. Because it contributes only a small portion of total rows and revenue, it may not materially affect analysis, but it should be documented as a known data quality observation.

---

### 10. Return Flag Validation

I created an order-level return flag by joining `orders` to `returns` and checking whether each order was returned or not.

**QC Findings:**
- Returned orders: `[insert result]`
- Non-returned orders: `[insert result]`
- Total distinct orders reviewed: `[insert result]`

**Interpretation:**  
This confirms that return status can be reliably assigned at the order level and used later in return-rate, profitability, and category performance analysis.

---

### 11. People Table Join Check

I tested the join between `orders` and `people` using `Region` to confirm whether all order records successfully matched to a region owner/manager.

**QC Findings:**
- Total rows checked: `[insert result]`
- Matched people rows: `[insert result]`
- Unmatched people rows: `[insert result]`

**Interpretation:**  
This validates whether the `people` table can be safely joined for region-level attribution. Any unmatched rows should be noted because they may affect regional performance reporting.

---

## Overall QC Conclusion

Overall, the dataset appears **[clean / mostly clean / clean with minor anomalies]** and suitable for analysis. The main QC observations included:

- `[example: no critical nulls in key fields]`
- `[example: returns table behaved as expected]`
- `[example: order-level return flag could be created successfully]`
- `[example: region join was fully matched]`
- `[example: a small discount anomaly of 0.002 was identified and documented]`

Based on these checks, the dataset was considered ready for transformation and dashboard analysis, with minor anomalies noted for transparency.

---


## Discount Field Validation & Structured Micro-Tier Review

### Observation
During distribution analysis of the `discount` field, a recurring value of **0.002 (0.2%)** was identified across **461 rows (~0.9% of total records)**. This value appeared consistently and was the only fractional value below 1% aside from 0.

### Frequency & Materiality Assessment
- **Rows affected:** 461  
- **Share of total records:** ~0.9%  
- **Revenue impact:** Aprroximately ~2% of total revenue  
- **Distinct sub-1% values observed:** 0 and 0.002 only  

Because the value is present in the original source and contributes materially to revenue, it was treated as valid transactional data.

### Business Interpretation
Retail discount tiers typically occur in structured percentage increments (e.g., 5%, 10%, 20%). Although 0.2% discounting is atypical in standard retail tier structures, its consistent presence in the source dataset indicates it represents a defined promotional or system-level discount rule.

### Decision
- Raw discount values were preserved to maintain source data integrity.
- Discount banding was implemented using logical percentage ranges (0%, <1%, 1%–15%, 16–30%, 31–50%, >50%) to ensure consistent analytical segmentation without altering original values.

### Conclusion
No corrective transformation was required. Analytical banding sufficiently addresses segmentation consistency while preserving the fidelity of the original dataset.
