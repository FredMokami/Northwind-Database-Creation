USE customer_churn;

SET SQL_SAFE_UPDATES=0;
SET SQL_SAFE_UPDATES=1;
DESCRIBE ecommercechurn;
CREATE TABLE ecommercechurn (
    CustomerID INT,
    Churn INT,
    Tenure INT,
    PreferredLoginDevice VARCHAR(50),
    CityTier INT,
    WarehouseToHome INT,
    PreferredPaymentMode VARCHAR(50),
    Gender VARCHAR(10),
    HourSpendOnApp INT,
    NumberOfDeviceRegistered INT,
    PreferedOrderCat VARCHAR(50),
    SatisfactionScore INT,
    MaritalStatus VARCHAR(20),
    NumberOfAddress INT,
    Complain INT,
    OrderAmountHikeFromlastYear INT,
    CouponUsed INT,
    OrderCount INT,
    DaySinceLastOrder INT,
    CashbackAmount INT
);

SELECT * FROM ecommercechurn;
DELETE FROM ecommercechurn;

-- DATA CLEANING
-- Number of total customers
SELECT DISTINCT COUNT(CustomerID) AS NumberOfCustomers
FROM ecommercechurn;

-- Identify duplicate CustomerID values by counting occurrences
SELECT CustomerID, COUNT(CustomerID) AS Count
FROM ecommercechurn
GROUP BY CustomerID
HAVING COUNT(CustomerID) > 1;

-- Checking NULLs
SELECT 'Tenure' AS ColumnName, COUNT(*) AS NullCount FROM ecommercechurn WHERE Tenure IS NULL
UNION
SELECT 'WarehouseToHome' AS ColumnName, COUNT(*) AS NullCount FROM ecommercechurn WHERE WarehouseToHome IS NULL
UNION
SELECT 'HourSpendOnApp' AS ColumnName, COUNT(*) AS NullCount FROM ecommercechurn WHERE HourSpendOnApp IS NULL
UNION
SELECT 'OrderAmountHikeFromLastYear' AS ColumnName, COUNT(*) AS NullCount FROM ecommercechurn WHERE OrderAmountHikeFromLastYear IS NULL
UNION
SELECT 'CouponUsed' AS ColumnName, COUNT(*) AS NullCount FROM ecommercechurn WHERE CouponUsed IS NULL
UNION
SELECT 'OrderCount' AS ColumnName, COUNT(*) AS NullCount FROM ecommercechurn WHERE OrderCount IS NULL
UNION
SELECT 'DaySinceLastOrder' AS ColumnName, COUNT(*) AS NullCount FROM ecommercechurn WHERE DaySinceLastOrder IS NULL;

-- Dealing with NULLs
-- we will update NULLs with the mean value of the fields they belong to. 
UPDATE ecommercechurn AS e
JOIN (
    SELECT AVG(HourSpendOnApp) AS avg_hourspendonapp
    FROM ecommercechurn
) AS subq1 ON e.HourSpendOnApp IS NULL
SET e.HourSpendOnApp = subq1.avg_hourspendonapp;


UPDATE ecommercechurn AS e
JOIN (
    SELECT AVG(Tenure) AS avg_tenure
    FROM ecommercechurn
) AS subq2 ON e.Tenure IS NULL
SET e.Tenure = subq2.avg_tenure;


UPDATE ecommercechurn AS e
JOIN (
    SELECT AVG(OrderAmountHikeFromLastYear) AS avg_orderamounthikefromlastyear
    FROM ecommercechurn
) AS subq3 ON e.OrderAmountHikeFromLastYear IS NULL
SET e.OrderAmountHikeFromLastYear = subq3.avg_orderamounthikefromlastyear;


UPDATE ecommercechurn AS e
JOIN (
    SELECT AVG(WarehouseToHome) AS avg_warehousetohome
    FROM ecommercechurn
) AS subq4 ON e.WarehouseToHome IS NULL
SET e.WarehouseToHome = subq4.avg_warehousetohome;


UPDATE ecommercechurn AS e
JOIN (
    SELECT AVG(CouponUsed) AS avg_couponused
    FROM ecommercechurn
) AS subq5 ON e.CouponUsed IS NULL
SET e.CouponUsed = subq5.avg_couponused;


UPDATE ecommercechurn AS e
JOIN (
    SELECT AVG(OrderCount) AS avg_ordercount
    FROM ecommercechurn
) AS subq6 ON e.OrderCount IS NULL
SET e.OrderCount = subq6.avg_ordercount;


UPDATE ecommercechurn AS e
JOIN (
    SELECT AVG(DaySinceLastOrder) AS avg_daysincelastorder
    FROM ecommercechurn
) AS subq7 ON e.DaySinceLastOrder IS NULL
SET e.DaySinceLastOrder = subq7.avg_daysincelastorder;

-- Add a new column 'CustomerStatus' to the 'ecommercechurn' table
ALTER TABLE ecommercechurn
ADD ChurnStatus NVARCHAR(75);

-- Update the 'ChurnStatus' column based on the 'Churn' column
UPDATE ecommercechurn
SET ChurnStatus =
CASE
    WHEN Churn = 1 THEN 'Churned'
    WHEN Churn = 0 THEN 'Stayed'
END;

SELECT ChurnStatus FROM ecommercechurn;
DESCRIBE ecommercechurn;

-- Add a new column 'ComplainRecieved' with data type NVARCHAR(10) to the 'ecommercechurn' table
ALTER TABLE ecommercechurn
ADD FeedbackReceived NVARCHAR(10);


-- Update the 'ComplainRecieved' column based on the 'complain' column
UPDATE ecommercechurn
SET FeedbackReceived =
CASE
    WHEN complain = 1 THEN 'Yes'
    WHEN complain = 0 THEN 'No'
END;

-- Correcting redundancy in “preferredlogindevice” field
UPDATE ecommercechurn
SET preferredlogindevice = 'phone'
WHERE preferredlogindevice = 'mobile phone';

-- Correcting redundancy in Preferedordercat field
UPDATE ecommercechurn
SET Preferedordercat = 'Mobile'
WHERE Preferedordercat = 'Mobile Phone';

-- Update the 'PreferredPaymentMode' values
UPDATE ecommercechurn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

-- Correcting outliers in “WarehouseToHome” field
-- Update the 'warehousetohome' values
UPDATE ecommercechurn
SET warehousetohome = '27'
WHERE warehousetohome = '127';

-- Update the 'warehousetohome' values
UPDATE ecommercechurn
SET warehousetohome = '26'
WHERE warehousetohome = '126';



SELECT
    TotalNumberofCustomers,
    TotalNumberofChurnedCustomers,
    CAST((TotalNumberofChurnedCustomers * 1.0 / TotalNumberofCustomers * 1.0) * 100 AS DECIMAL(10, 2)) AS ChurnRate
FROM
    (SELECT COUNT(*) AS TotalNumberofCustomers FROM ecommercechurn) AS Total,
    (SELECT COUNT(*) AS TotalNumberofChurnedCustomers FROM ecommercechurn WHERE ChurnStatus = 'Churned') AS Churned;

-- What is the variation in churn rates depending on the preferred login device used by customers?
SELECT
    preferredlogindevice,
    COUNT(*) AS TotalCustomers,
    SUM(churn) AS ChurnedCustomers,
    CAST(SUM(churn) * 1.0 / COUNT(*) * 100 AS DECIMAL(10, 2)) AS ChurnRate
FROM ecommercechurn
GROUP BY preferredlogindevice;


SELECT
    citytier,
    COUNT(*) AS TotalCustomers,
    SUM(Churn) AS ChurnedCustomers,
    CAST(SUM(Churn) * 1.0 / COUNT(*) * 100 AS DECIMAL(10, 2)) AS ChurnRate
FROM ecommercechurn
GROUP BY citytier
ORDER BY ChurnRate DESC;






