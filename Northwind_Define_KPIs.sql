USE northwind;
SELECT
	MIN(order_date),
    MAX(order_date)
 FROM orders;

/* SALES AND ORDERS TRENDS*/
-- Orders count
SELECT COUNT(DISTINCT order_id) AS OrderCount
FROM orders;

-- How much SALES did we make?
SELECT ROUND(SUM(quantity * (unit_price * (1 - discount))), 0) AS TotalSales
FROM order_details;

-- 1. A) What is our year-to-date total sales, excluding May, which is still in progress?

SELECT
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Sales
FROM Orders o
JOIN Order_Details od 
	ON o.order_id = od.order_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'; -- May, 2015 is incomplete

-- How does our monthly trend for sales look like - general?
SELECT
	YEAR(o.order_date) AS yr, 
    MONTH(o.order_date) AS mo,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS MonthlySales
    -- COUNT(DISTINCT o.order_id) AS MonthlyOrderCount
FROM orders o
	JOIN order_details od 
		ON o.order_id = od.order_id
WHERE o.order_date BETWEEN '2013-01-01' AND '2015-04-30'
GROUP BY yr, mo;

-- B) What does our monthly sales trend look like?

CREATE TEMPORARY TABLE MonthlySales2015(
SELECT 
	YEAR(o.order_date) AS yr,
	MONTH(o.order_date) AS mo,
	ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS MonthlySales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE o.order_date BETWEEN '2015-01-01' AND '2015-04-30' -- 2015, May is incomplete
GROUP BY yr, mo
);

SELECT * FROM MonthlySales2015;
DROP TEMPORARY TABLE MonthlyRevenue2015;

-- C) In which months did we achieve our $100,000 revenue target in 2015?
WITH  MonthlySales2015 AS
(
 SELECT 
	YEAR(o.order_date) AS yr,
	MONTH(o.order_date) AS mo,
	ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS MonthlySales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
WHERE o.order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY yr, mo
)
SELECT
	mo,
    MonthlySales,
	CASE
        WHEN MonthlySales >= 100000 THEN 'Achieved_Target'
        ELSE 'Missed_Target'
    END AS Revenue_Target_Status
FROM MonthlySales2015;

-- D) Top/least performing PRODUCTS in terms of revenue in 2015
-- Top performing products
SELECT
    p.product_name AS Top_performing_prdcts,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Total_sales
FROM products p
	LEFT JOIN order_details od
		ON od.product_id = p.product_id
	LEFT JOIN orders o
		ON od.order_id = o.order_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- Least performing products
SELECT
    p.product_name AS Least_performing_prdcts,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Total_sales
FROM products p
	LEFT JOIN order_details od
		ON od.product_id = p.product_id
	LEFT JOIN orders o
		ON od.order_id = o.order_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY 1
ORDER BY Total_sales ASC
LIMIT 3;

-- E) Key CUSTOMERS by revenue
-- Top performing customers
SELECT
    c.company_name AS Top_cust_sales,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Sales
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Details od ON o.order_id = od.order_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY 1
ORDER BY Sales DESC
LIMIT 3;

-- Least performing customers
SELECT
    c.company_name AS Least_cust_sales,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Sales
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Details od ON o.order_id = od.order_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY 1
ORDER BY Sales ASC
LIMIT 3;



-- On-time delivery-- REVIEW THIS WHOLE THING

/*On-time delivery measures the percentage of orders delivered to customers on or before the promised delivery date. 
It helps evaluate the efficiency of the business/supply chain in meeting customer expectations.*/

-- on_time_delivery_rate in 2015
-- A) I assumed that transportion takes 2 days. How does our year-to-date On-time Delivery (OTD) rate compare to our benchmark of 95%?

WITH OTD_summary AS (
SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
    COUNT(DISTINCT order_id) AS Total_orders,
    COUNT(DISTINCT CASE WHEN DATEDIFF(required_date, shipped_date) < 2 THEN order_id END) AS Orders_shipped_late,
    COUNT(DISTINCT CASE WHEN DATEDIFF(required_date, shipped_date) >= 2 THEN order_id END) AS Orders_shipped_OnTime,
    ROUND(COUNT(DISTINCT CASE WHEN DATEDIFF(required_date, shipped_date) >= 2 THEN order_id END) / COUNT(DISTINCT order_id), 2) AS OTD_rate
FROM orders
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY 1, 2
)
SELECT 
	yr, 
    mo,
	OTD_rate,
	CASE WHEN OTD_rate < 0.95 THEN 'Below_Target' ELSE 'Met_target' END AS OTD_flag
FROM OTD_summary;

/*-- Segment customers into High_Value, Medium_Value or Low_Value - REVIEW
-- Is this analysis necessary?
SELECT
    c.customer_id,
    c.company_name,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Revenue,
    CASE
        WHEN SUM(od.quantity * (od.unit_price * (1 - od.discount))) >= 10000 THEN 'High_Value'
        WHEN SUM(od.quantity * (od.unit_price * (1 - od.discount))) >= 1000 THEN 'Medium_Value '
        ELSE 'Low_Value'
    END AS CustomerSegment
FROM orders o
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN customers c ON o.customer_id  = c.customer_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY customer_id
ORDER BY Revenue DESC;*/

-- Employee Performance and Impact
-- Who are our top and least-performing employees based on sales?


-- What is the total freight cost for all orders?
-- We aim for < 6% of net sales
SELECT
    ROUND(SUM(freight),0) AS total_freight_cost
FROM Orders
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30';

-- What is the overall average freight cost per order? REVIEWED
SELECT
	ROUND(SUM(freight) / COUNT(DISTINCT order_id),1) AS AvgFreight_cost_per_order
FROM Shippers s
LEFT JOIN Orders o 
	ON s.shipper_id = o.shipper_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30';

-- What is the freight cost per order for each shipper?
SELECT
    s.company_name AS shipper_name,
	ROUND(SUM(freight) / COUNT(DISTINCT order_id),1) AS AvgFreight_cost_per_order
FROM Shippers s
LEFT JOIN Orders o 
	ON s.shipper_id = o.shipper_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY shipper_name
ORDER BY AvgFreight_cost_per_order DESC;

-- What is the trend in the average shipping cost per order?
SELECT
    YEAR(order_date) AS yr,
    MONTH(order_date) AS mo,
	ROUND(SUM(freight) / COUNT(DISTINCT order_id),1) AS AvgFreight_cost_per_order
FROM Shippers s
LEFT JOIN Orders o 
	ON s.shipper_id = o.shipper_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY yr, mo;

-- -----------


/*Employee Performance and Impact*/

-- Who are our top and least-performing employees based on sales?
SELECT 
    employee_name,
    ROUND(SUM(quantity * (unit_price * (1 - discount))), 0) AS Revenue
FROM employees e
	JOIN orders o
		ON e.employee_id = o.employee_id
	JOIN order_details od
		ON od.order_id = o.order_id
GROUP BY employee_name
ORDER BY Revenue DESC
LIMIT 3; -- You can limit to get top/least performing employees



-- Customer orders
SELECT 
	c.customer_id, -- Is the ID necessary?
    company_name,
    COUNT(DISTINCT o.order_id) AS OrderCount
FROM customers c
	LEFT JOIN orders o
		ON c.customer_id = o.customer_id
GROUP BY customer_id
ORDER BY OrderCount DESC;

SELECT * FROM customers LIMIT 10;

-- Top products by revenue  -  OK GERRARD