create database churn_analysis;

use churn_analysis;

CREATE TABLE customers (
    CustomerID INT PRIMARY KEY,
    Churn INT,
    Tenure FLOAT,
    PreferredLoginDevice VARCHAR(50),
    CityTier INT,
    WarehouseToHome FLOAT,
    PreferredPaymentMode VARCHAR(50),
    Gender VARCHAR(10),
    HourSpendOnApp FLOAT,
    NumberOfDeviceRegistered INT,
    PreferedOrderCat VARCHAR(50),
    SatisfactionScore INT,
    MaritalStatus VARCHAR(20),
    NumberOfAddress INT,
    Complain INT,
    OrderAmountHikeFromlastYear FLOAT,
    CouponUsed FLOAT,
    OrderCount FLOAT,
    DaySinceLastOrder FLOAT,
    CashbackAmount FLOAT,
    Tenure_Missing INT,
    WarehouseToHome_Missing INT,
    HourSpendOnApp_Missing INT,
    OrderCount_Missing INT,
    CouponUsed_Missing INT,
    OrderAmountHike_Missing INT,
    Tenure_Bucket VARCHAR(20),
    Recency_Bucket VARCHAR(20),
    Order_Frequency_Bucket VARCHAR(20),
    Risk_Score INT
);

INSERT INTO customers
SELECT * FROM ecommerce_churn_cleaned;



