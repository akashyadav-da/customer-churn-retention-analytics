-- =====================================================
-- RETENTION ROOT-CAUSE ANALYSIS
-- Business Problem: The e-commerce company is experiencing customer churn
-- and wants to understand which customer groups are most likely to leave,
-- what behavioural and service-related factors are associated with churn,
-- and where retention efforts should be prioritized to reduce customer
-- loss and protect valuable customers.
--
-- Database: retention_analysis
-- Table: customers (5,630 rows, one row per customer)
-- =====================================================
 
 use churn_analysis;
 
 -- Q1. What is the overall customer churn rate?
 
-- Churn = 1 → churned
-- Churn = 0 → retained
   
SELECT
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    SUM(CASE WHEN Churn = 0 THEN 1 ELSE 0 END) AS retained_customers,
    ROUND(100.0 * SUM(Churn) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN Churn = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_rate_pct
FROM customers;

-- Q2. Which customer demographic segments have the highest churn rate?

SELECT 'Gender' AS segment_type, Gender AS segment_value,
       COUNT(*) AS customers, SUM(Churn) AS churned,
       ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers GROUP BY Gender
 
UNION ALL
 
SELECT 'MaritalStatus', MaritalStatus,
       COUNT(*), SUM(Churn),
       ROUND(100.0 * AVG(Churn), 2)
FROM customers GROUP BY MaritalStatus
 
UNION ALL
 
SELECT 'CityTier', CAST(CityTier AS CHAR),
       COUNT(*), SUM(Churn),
       ROUND(100.0 * AVG(Churn), 2)
FROM customers GROUP BY CityTier
 
ORDER BY segment_type, churn_rate_pct DESC;

-- Q3. How does customer tenure relate to churn?

SELECT Tenure_Bucket, 
       COUNT(*) AS customers, 
       SUM(Churn) AS churned,
       ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers 
GROUP BY Tenure_Bucket
ORDER BY   churn_rate_pct DESC;

-- Q4. Does customer satisfaction affect churn?

-- Q4a. Raw view — satisfaction alone
SELECT
    SatisfactionScore,
    COUNT(*) AS customers,
    SUM(Churn) AS churned,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
GROUP BY SatisfactionScore
ORDER BY SatisfactionScore DESC;

-- Q4b. Controlled view — satisfaction split by complaint status

SELECT
    SatisfactionScore,
    Complain,
    COUNT(*) AS customers,
    SUM(Churn) AS churned,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
GROUP BY SatisfactionScore, Complain
ORDER BY SatisfactionScore, Complain DESC;

-- Q5. Do customers who raise complaints churn more frequently?

SELECT
    CASE
        WHEN Complain = 1 THEN 'Complaint Raised'
        ELSE 'No Complaint'
    END AS complaint_status,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    ROUND(AVG(Churn) * 100, 2) AS churn_rate_pct
FROM customers
GROUP BY Complain
ORDER BY churn_rate_pct DESC;

-- Q6. Does purchase recency and app engagement relate to churn?

-- Q6a. Churn by recency bucket
SELECT
    Recency_Bucket,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
GROUP BY Recency_Bucket
ORDER BY FIELD(Recency_Bucket, '0-2 days', '3-7 days', '8-15 days', '16+ days');

-- Q6b. Churn by app engagement (hours spent)
SELECT
    HourSpendOnApp,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
GROUP BY HourSpendOnApp
ORDER BY churn_rate_pct DESC;

-- Q6c. Recency confounded by tenure — is "recent order" really a red flag,
-- or just a symptom of being a new customer about to churn?
SELECT
    Tenure_Bucket,
    Recency_Bucket,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
GROUP BY Tenure_Bucket, Recency_Bucket
ORDER BY FIELD(Tenure_Bucket, '0-6mo', '6-12mo', '1-2yr', '2yr+'),
         FIELD(Recency_Bucket, '0-2 days', '3-7 days', '8-15 days', '16+ days');
         
-- Q7. Which product category preference has the highest churn?

 SELECT
    PreferedOrderCat,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
GROUP BY PreferedOrderCat
ORDER BY churn_rate_pct DESC;

-- Q8. Does purchase frequency affect retention?

SELECT
    Order_Frequency_Bucket,
    COUNT(*) AS customers,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
GROUP BY Order_Frequency_Bucket
ORDER BY FIELD(Order_Frequency_Bucket, 'Low (1-2)', 'Medium (3-5)', 'High (6+)');


-- Q9. Which combination of factors identifies the highest-risk customers?
WITH risk_analysis AS (
    SELECT
        CustomerID,
        Churn,

        CASE
            WHEN Tenure <= 6 THEN 1
            ELSE 0
        END +

        CASE
            WHEN Complain = 1 THEN 1
            ELSE 0
        END +

        CASE
            WHEN PreferedOrderCat = 'Mobile Phone' THEN 1
            ELSE 0
        END AS risk_score

    FROM customerS
)

SELECT
    risk_score,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned,
    ROUND(AVG(Churn) * 100, 2) AS churn_rate_pct
FROM risk_analysis
GROUP BY risk_score
ORDER BY risk_score;

-- Q10. What is the retention opportunity among high-value customers at risk?
-- (CashbackAmount used as the value proxy, since no direct revenue column exists).

SELECT
    COUNT(*) AS high_risk_customers,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) AS pct_of_total_customers,
    ROUND(AVG(CashbackAmount), 2) AS avg_cashback_per_customer,
    ROUND(SUM(CashbackAmount), 2) AS total_cashback_exposure,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct_within_segment
FROM customers
WHERE Risk_Score >= 2;
 
-- Q10b. Breakdown of the highest-urgency sub-segment (all 3 flags)
SELECT
    COUNT(*) AS critical_risk_customers,
    ROUND(SUM(CashbackAmount), 2) AS critical_cashback_exposure,
    ROUND(100.0 * AVG(Churn), 2) AS churn_rate_pct
FROM customers
WHERE Risk_Score = 3;