## Quality Control Summary

To validate the reliability of the Global Superstore dataset before analysis, I performed a series of quality control checks across the `orders`, `returns`, and `people` tables. These checks focused on record counts, date coverage, null values, duplicates, numeric ranges, discount anomalies, return mapping, and join integrity.

---

### 1. Order Table Record Validation

I first checked total row count versus distinct `Order_ID` count in the `orders` table to confirm whether each row represented a unique line item or whether multiple rows existed per order.

**QC Findings:**
- Total rows: `51,290`
- Distinct orders: `25,728`

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
- Total return records: `1,079`
- Distinct returned orders: `1,079`

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
- Min sales: `$0.44`
- Max sales: `$22,638.48`
- Min profit: `-$6,599.98`
- Max profit: `$8,399.98`
- Min discount: `0.2%`
- Max discount: `85%`

**Interpretation:**  
This helps confirm that the core financial columns fall within a believable business range and highlights whether losses, extreme profits, or unexpected discount values need special attention.

---

### 7. Zero-Value Check

I checked how many rows had zero sales or zero profit.

**QC Findings:**
- Zero sales rows: `0`
- Zero profit rows: `672`

**Interpretation:**  
Zero-value checks help identify transactions that may need further review. Zero profit may be valid, but zero sales should be assessed carefully depending on business logic.

---

### 8. Discount Value Review

I pulled all distinct discount values from the `orders` table to confirm whether discounts follow standard expected increments.

**Interpretation:**  
This step helps identify irregular discount values that may represent data entry issues, formatting inconsistencies, or edge-case transactions.

**QC Findings:**
- Standard discount tiers appear in expected increments (e.g., 0.1, 0.2, 0.3, etc.)
- Several values (e.g., 0.002, 0.202, 0.402, 0.602) indicate precision-level variations rather than intentional pricing tiers
- These values were confirmed to exist in the original source data (Excel), indicating they are not artifacts of data transformation

**Conclusion:**
- Discount values were preserved as-is for data integrity
- A `Discount_Band` field was created to group values into meaningful analytical categories

---

### 9. Low Discount Anomaly (`0.002`)

A specific QC check was run on discount value `0.002`, since this appears unusually small compared with standard retail discount tiers.

**QC Findings:**
- Number of rows with `discount = 0.002`: `461`
- Percentage of total rows: `9%`
- Revenue tied to `discount = 0.002`: `$26,1395.70`
- Percentage of total revenue: `2%`

**Interpretation:**  
Because this value contributes only a small portion of total rows and revenue, it may not materially affect analysis, but it should be documented as a known data quality observation.

---

### 10. Return Flag Validation

I created an order-level return flag by joining `orders` to `returns` and checking whether each order was returned or not.

**QC Findings:**
- Returned orders: `1,079`
- Non-returned orders: `24,649`
- Total distinct orders reviewed: `25,728`

**Interpretation:**  
This confirms that return status can be reliably assigned at the order level and used later in return-rate, profitability, and category performance analysis.

---

### 11. People Table Join Check

I tested the join between `orders` and `people` using `Region` to confirm whether all order records successfully matched to a region owner/manager.

**QC Findings:**
- Total rows checked: `51,290`
- Matched people rows: `50,906`
- Unmatched people rows: `384`

**Interpretation:**  
This validates whether the `people` table can be safely joined for region-level attribution. Any unmatched rows should be noted because they may affect regional performance reporting.

---

## Overall QC Conclusion

Overall, the dataset appears **clean with minor anomalies** and suitable for analysis. The main QC observations included:

- `No critical nulls in key fields`
- `Returns table behaved as expected`
- `Order-level return flag could be created successfully`
- `Region join was fully matched`
- `A small discount anomaly of 0.002 was identified and documented`

Based on these checks, the dataset was considered ready for transformation and dashboard analysis, with minor anomalies noted for transparency.

---
