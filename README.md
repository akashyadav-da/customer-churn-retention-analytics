# Customer Churn & Retention Analytics

**A customer churn investigation for an e-commerce business — built to answer one question: who is leaving, why, and where should retention efforts go first?**

---

## Business Problem

The e-commerce company is experiencing customer churn and wants to understand which customer groups are most likely to leave, what behavioural and service-related factors are associated with churn, and where retention efforts should be prioritized to reduce customer loss and protect valuable customers.

## Key Business Questions

1. What is the overall customer churn rate?
2. Which customer demographic segments have the highest churn rate?
3. How does customer tenure relate to churn?
4. Does customer satisfaction affect churn — and why does the raw pattern look backwards?
5. Do customers who raise complaints churn more frequently?
6. Does purchase recency and app engagement relate to churn?
7. Which product category preference has the highest churn?
8. Does purchase frequency affect retention?
9. Which combination of risk factors identifies the highest-risk customers?
10. How many valuable customers are at risk, and what's the retention opportunity (₹)?



---

## Dataset

- **Source:** [E-Commerce Customer Churn Analysis and Prediction](https://www.kaggle.com/datasets/ankitverma2010/ecommerce-customer-churn-analysis-and-prediction) (Kaggle)
- **Size:** 5,630 rows, 20 original columns — one row per customer (snapshot, not a purchase-history log)
- **Target variable:** `Churn` (0 = retained, 1 = churned) — 16.8% churn rate


## Project Highlights

- **5,630 customers** analyzed
- **16.8% overall churn rate**
- **32.4% → 0% churn** from early-tenure to 2+ year customers
- **68.2% churn rate** among customers with all 3 identified risk factors
- **1,672 customers** identified as high-risk, representing **₹247,735** in cashback exposure


## Tools Used

| Tool | Purpose |
|---|---|
| Python | Data cleaning, feature engineering, and EDA |
| Pandas / NumPy | Data manipulation |
| Matplotlib / Seaborn | Exploratory visualization |
| MySQL | Business analysis and SQL queries |
| Power BI | Interactive dashboard and business reporting |
| Git & GitHub | Version control and project documentation |



---

## Repo Structure

```
├── data/
│   ├── raw/                                  # Original source dataset
│   └── processed/                            # Cleaned + feature-engineered dataset
│
├── notebooks/
│   └── churn_eda.ipynb                 # Data cleaning, EDA & feature engineering
│
├── sql/
│   ├── db_creation.sql                       # Database/table creation and data loading
│   └── retention_root_cause_analysis.sql     # SQL analysis for all 10 business questions
│
├── dashboard/
│   └── retention_dashboard.pbix              # Power BI report (2 pages)
│
├── images/
│   ├── dashboard_page_1.png                  # Overview & Churn Drivers
│   └── dashboard_page_2.png                  # Risk & Retention Analysis
│
├── README.md
└── .gitignore

```
---

## Methodology

```
Raw Data
   ↓
Data Cleaning & Validation
   ↓
Feature Engineering
   ↓
Exploratory Data Analysis
   ↓
SQL Business Analysis
   ↓
Power BI Dashboard
   ↓
Business Insights & Recommendations

```

**Data cleaning highlights:**
- Investigated and capped 2 extreme `WarehouseToHome` outliers (likely decimal entry errors) rather than dropping them
- Checked whether missingness in 7 null-containing columns correlated with churn *before* imputing — found 6 of 7 did, so created missingness-flag columns to preserve that signal ahead of median imputation
- Standardized 3 categorical columns where the source data used inconsistent labels for the same real-world category (e.g. `'CC'` → `'Credit Card'`)

**Feature engineering:**
- `Tenure_Bucket`, `Recency_Bucket`, `Order_Frequency_Bucket` — built at ranges matched to this dataset's actual distribution, not arbitrary round numbers
- `Risk_Score` (0–3) — combines three factors strongly associated with churn in this dataset: short tenure, complaint status, and Mobile Phone category preference.

---

## SQL Analysis

---

## Key Findings

1. **Tenure is the dominant churn driver.** Churn drops from **32.4%** (0–6 months) to **0%** (2+ years) in a near-perfect staircase.
2. **Complaints matter far more than reported satisfaction.** Raw satisfaction scores show a counterintuitive pattern (churn *rises* with satisfaction) — fully explained by complaint status. At every satisfaction level, complaining customers churn roughly **3x more** than non-complainers.
3. **Recency is confounded by tenure.** Customers with the most recent orders show the *highest* churn — likely because a customer's final order naturally looks "recent" in a snapshot dataset, not because recent activity is protective.
4. **Category matters:** Mobile Phone buyers churn at **27.4%**, over 5x the rate of Grocery buyers (**4.9%**).
5. **Combining the three strongest drivers (Tenure, Complain, Category) into a Risk Score produces a dramatic gradient** — 3.8% churn at 0 flags, climbing to **68.2%** at 3 flags.
6. **1,672 customers (29.7% of the base)** carry 2+ risk flags, representing **₹247,735** in cashback exposure, used as a proxy for customer value

## Recommendations

1. **Prioritize the 362 "critical risk" customers first** (all 3 flags, 68.2% churn rate, ₹51,222 exposure) — highest urgency, smallest, most targeted group.
2. **Build an early-lifecycle retention program for the first 6 months** — this is where churn risk is structurally highest regardless of any other factor.
3. **Prioritize complaint resolution alongside satisfaction monitoring** — complaint status was a stronger churn signal in this dataset, suggesting that response speed and resolution quality may deserve greater operational attention.

---

## Dashboard Preview

*(screenshot goes here — [add your exported PNG to `/images/dashboard_preview.png`])*

Two-page Power BI report:
- **Page 1 — Overview:** churn rate by tenure, complaint, product category, and recency
- **Page 2 — Risk Analysis:** the combined risk score, a tenure × recency risk matrix, and the sized retention opportunity

---

## Assumptions & Limitations

- This dataset is a **single snapshot per customer**, not a purchase-history log — true cohort analysis and repeat-purchase-over-time tracking are not possible with this data.
- Findings describe **association, not proven causation** — particularly for `Complain`, `Recency`, and `CashbackAmount`, where a plausible reverse or third-factor explanation exists and is discussed in the analysis notebook.
- `CashbackAmount` is used as a proxy for customer value in the absence of a direct revenue/lifetime-value column.
- Two `WarehouseToHome` values were treated as likely data entry errors and capped — this judgment call is documented in the cleaning notebook.
- The dataset does not contain timestamps or a defined observation period, so churn trends over time and seasonality cannot be analyzed.


---

## Author

**[Akash Yadav]** — Aspiring Data Analyst | Python | SQL | Power BI

