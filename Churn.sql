-- Create a new database called 'customer_data'
CREATE DATABASE customer_data;

-- Switch to the newly created database
USE customer_data;

-- Create a table called 'customer_info' to store the customer data

CREATE TABLE customer_churn (
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



DROP TABLE customer_churn;

DESCRIBE customer_churn;
SELECT * FROM customer_churn;

INSERT INTO customer_churn
  (CustomerID, Churn, Tenure, PreferredLoginDevice, CityTier, WarehouseToHome, PreferredPaymentMode, Gender, HourSpendOnApp, NumberOfDeviceRegistered, PreferedOrderCat, SatisfactionScore, MaritalStatus, NumberOfAddress, Complain, OrderAmountHikeFromlastYear, CouponUsed, OrderCount, DaySinceLastOrder, CashbackAmount)
VALUES
  (50001, 1, 4, 'Mobile Phone', 3, 6, 'Debit Card', 'Female', 3, 3, 'Laptop & Accessory', 2, 'Single', 9, 1, 11, 1, 1, 5, 160),
  (50002, 1, NULL, 'Phone', 1, 8, 'UPI', 'Male', 3, 4, 'Mobile', 3, 'Single', 7, 1, 15, 0, 1, 0, 121),
  (50003, 1, NULL, 'Phone', 1, 30, 'Debit Card', 'Male', 2, 4, 'Mobile', 3, 'Single', 6, 1, 14, 0, 1, 3, 120),
  (50004, 1, 0, 'Phone', 3, 15, 'Debit Card', 'Male', 2, 4, 'Laptop & Accessory', 5, 'Single', 8, 0, 23, 0, 1, 3, 134),
  (50005, 1, 0, 'Phone', 1, 12, 'CC', 'Male', NULL, 3, 'Mobile', 5, 'Single', 3, 0, 11, 1, 1, 3, 130),
  (50006, 1, 0, 'Computer', 1, 22, 'Debit Card', 'Female', 3, 5, 'Mobile Phone', 5, 'Single', 2, 1, 22, 4, 6, 7, 139),
  (50007, 1, NULL, 'Phone', 3, 11, 'Cash on Delivery', 'Male', 2, 3, 'Laptop & Accessory', 2, 'Divorced', 4, 0, 14, 0, 1, 0, 121),
  (50008, 1, NULL, 'Phone', 1, 6, 'CC', 'Male', 3, 3, 'Mobile', 2, 'Divorced', 3, 1, 16, 2, 2, 0, 123),
  (50009, 1, 13, 'Phone', 3, 9, 'E wallet', 'Male', NULL, 4, 'Mobile', 3, 'Divorced', 2, 1, 14, 0, 1, 2, 127),
  (50010, 1, NULL, 'Phone', 1, 31, 'Debit Card', 'Male', 2, 5, 'Mobile', 3, 'Single', 2, 0, 12, 1, 1, 1, 123),
(50011, 1, 4, 'Mobile Phone', 1, 18, 'Cash on Delivery', 'Female', 2, 3, 'Others', 3, 'Divorced', 2, 0, NULL, 9, 15, 8, 295),
(50012, 1, 11, 'Mobile Phone', 1, 6, 'Debit Card', 'Male', 3, 4, 'Fashion', 3, 'Single', 10, 1, 13, 0, 1, 0, 154),
(50013, 1, 0, 'Phone', 1, 11, 'COD', 'Male', 2, 3, 'Mobile', 3, 'Single', 2, 1, 13, 2, 2, 2, 134),
(50014, 1, 0, 'Phone', 1, 15, 'CC', 'Male', 3, 4, 'Mobile', 3, 'Divorced', 1, 1, 17, 0, 1, 0, 134),
(50015, 1, 9, 'Mobile Phone', 3, 15, 'Credit Card', 'Male', 3, 4, 'Fashion', 2, 'Single', 2, 0, 16, 0, 4, 7, 196),
(50016, 1, NULL, 'Phone', 2, 12, 'UPI', 'Male', 3, 3, 'Mobile', 5, 'Married', 5, 1, 22, 1, 1, 2, 121),
(50017, 1, 0, 'Phone', 3, 11, 'Cash on Delivery', 'Male', 2, 3, 'Laptop & Accessory', 2, 'Divorced', 4, 0, 14, 0, 1, 0, 121),
(50018, 1, 0, 'Mobile Phone', 3, 11, 'E wallet', 'Male', 2, 4, 'Laptop & Accessory', 3, 'Single', 2, 1, 11, 1, 1, 3, 157),
(50019, 1, 0, 'Computer', 1, 13, 'Debit Card', 'Male', 3, 5, 'Laptop & Accessory', 3, 'Single', 2, 1, 24, 1, 1, 6, 161),
(50020, 1, 19, 'Mobile Phone', 1, 20, 'Debit Card', 'Female', 3, 3, 'Mobile Phone', 4, 'Divorced', 10, 1, 18, 1, 4, 3, 150),
(50021, 1, 0, 'Mobile Phone', 3, 12, 'Debit Card', 'Male', 3, 5, 'Laptop & Accessory', 3, 'Divorced', 5, 1, 18, 6, 7, 7, 162),
(50022, 1, 20, 'Mobile Phone', 1, 29, 'Credit Card', 'Female', 3, 3, 'Fashion', 2, 'Divorced', 2, 0, 12, 11, 15, 6, 203),
(50023, 1, NULL, 'Mobile Phone', 3, 28, 'E wallet', 'Male', 2, 3, 'Mobile Phone', 3, 'Single', 2, 1, 19, 0, 1, 0, 117),
(50024, 1, 0, 'Phone', 3, 26, 'Debit Card', 'Female', 3, 5, 'Laptop & Accessory', 3, 'Divorced', 4, 1, 11, 1, 2, 2, 146),
(50025, 1, 14, 'Computer', 1, 14, 'Debit Card', 'Male', 

