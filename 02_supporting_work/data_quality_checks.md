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

## Overall QC Conclusion

Overall, the dataset appears **clean with minor anomalies** and suitable for analysis.
