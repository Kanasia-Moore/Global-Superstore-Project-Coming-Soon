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
- Discount banding was implemented using logical percentage ranges (>0%–10%, 11–20%, 21–40%, >40%) to ensure consistent analytical segmentation without altering original values.

### Conclusion
No corrective transformation was required. Analytical banding sufficiently addresses segmentation consistency while preserving the fidelity of the original dataset.
