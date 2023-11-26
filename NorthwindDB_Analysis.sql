USE northwinddb;
-- SALES
-- TOTAL SALES
SELECT ROUND(SUM(quantity * (unitPrice * (1 - discount))), 2) AS TotalSalesForCurrentYear
FROM Order_details;

-- 2015
SELECT ROUND(SUM(quantity * (unitPrice * (1 - discount))), 2) AS TotalSalesForCurrentYear
FROM Order_details;

-- Sales with discount trend Exc '2015-05'
SELECT 
    DATE_FORMAT(orderDate, '%Y-%m') AS Month,
    ROUND(SUM(quantity * (unitPrice * (1 - discount))), 2) AS TotalRevenue
FROM Orders
JOIN Order_details ON Orders.orderID = Order_details.orderID
WHERE DATE_FORMAT(orderDate, '%Y-%m') != '2015-05'
GROUP BY Month
ORDER BY Month;

-- Sales without discount trend Exc '2015-05'
SELECT 
        DATE_FORMAT(orderDate, '%Y-%m') AS Month,
        ROUND(SUM(quantity * unitPrice)) AS TotalSales
    FROM Orders
    JOIN Order_details ON Orders.orderID = Order_details.orderID
    WHERE DATE_FORMAT(orderDate, '%Y-%m') != '2015-05'
    GROUP BY Month;

-- Highest AND least revenue with CTE
WITH MonthlyRevenues AS (
    SELECT 
        DATE_FORMAT(orderDate, '%Y-%m') AS Month,
        ROUND(SUM(quantity * (unitPrice * (1 - discount))), 2) AS TotalRevenue
    FROM Orders
    JOIN Order_details ON Orders.orderID = Order_details.orderID
    WHERE DATE_FORMAT(orderDate, '%Y-%m') != '2015-05'
    GROUP BY Month
)
SELECT Month
FROM MonthlyRevenues
WHERE TotalRevenue = (SELECT MAX(TotalRevenue) FROM MonthlyRevenues);

-- least revenue with CTE without subquery
WITH MonthlyRevenues AS (
    SELECT 
        DATE_FORMAT(orderDate, '%Y-%m') AS Month,
        ROUND(SUM(quantity * (unitPrice * (1 - discount))), 2) AS TotalRevenue
    FROM Orders
    JOIN Order_details ON Orders.orderID = Order_details.orderID
    WHERE DATE_FORMAT(orderDate, '%Y-%m') != '2015-05'
    GROUP BY Month
)
SELECT Month
FROM MonthlyRevenues
ORDER BY TotalRevenue
LIMIT 1;


-- Monthly sales range
SELECT
    DATE_FORMAT(orderDate, '%Y-%m') AS Month,
    SUM(quantity * unitPrice) AS TotalSales
FROM Orders
JOIN Order_details ON Orders.orderID = Order_details.orderID
GROUP BY Month
ORDER BY TotalSales DESC
LIMIT 1;

SELECT
    DATE_FORMAT(orderDate, '%Y-%m') AS Month,
    ROUND(SUM(quantity * (unitPrice * (1 - discount))), 2) AS TotalRevenue
FROM Orders
JOIN Order_details ON Orders.orderID = Order_details.orderID
GROUP BY Month
ORDER BY TotalRevenue ASC
LIMIT 1;


/*
-- Sales by quater
SELECT CONCAT(YEAR(o.orderDate), ' Q', QUARTER(o.orderDate)) AS Quarter,
    ROUND(SUM(d.quantity * d.unitPrice)) AS TotalSales
FROM Orders o
JOIN Order_details d
    ON o.orderID = d.orderID
GROUP BY Quarter
ORDER BY Quarter;
*/

SELECT * FROM Order_details;
SELECT AVG (unitPrice) FROM Order_details;

-- AVG monthly sales
SELECT 
    DATE_FORMAT(orderDate, '%Y-%m') AS Month,
    ROUND(AVG(quantity * (unitPrice * (1 - discount))), 2) AS TotalRevenue
FROM Orders
JOIN Order_details ON Orders.orderID = Order_details.orderID
WHERE DATE_FORMAT(orderDate, '%Y-%m') != '2015-05'
GROUP BY Month
ORDER BY Month;

SELECT ROUND(SUM(quantity * (unitPrice * (1 - discount)), 2) / COUNT(DISTINCT o.orderID), 2) AS AverageSales
FROM Orders o
JOIN Order_details od ON o.orderID = od.orderID;

-- ORDERS
SELECT COUNT(orderID) AS TotalOrders
FROM Orders
WHERE DATE_FORMAT(orderDate, '%Y-%m') != '2015-05';

-- Customers
SELECT
    DATE_FORMAT(o.orderDate, '%Y-%m') AS Month,
    COUNT(DISTINCT c.customerID) AS CustomerCount
FROM Orders o
JOIN Customers c ON o.customerID = c.customerID
GROUP BY Month
ORDER BY Month;
