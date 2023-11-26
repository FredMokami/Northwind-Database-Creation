USE northwind;

/*On-time delivery*/ -- REVIEW THIS WHOLE THING

/*On-time delivery measures the percentage of orders delivered to customers on or before the promised delivery date. 
It helps evaluate the efficiency of the business/supply chain in meeting customer expectations.*/

-- on_time_delivery_rate in 2015
-- I assumed that transportion takes 2 days. How does our year-to-date On-time Delivery (OTD) rate compare to our benchmark of 95%?

SELECT	
		SUM(CASE WHEN DATEDIFF(required_date, shipped_date) < 2 THEN 1 ELSE 0 END) AS orders_shipped_late,
		COUNT(*) AS total_orders,
		ROUND((SUM(CASE WHEN DATEDIFF(required_date, shipped_date) >= 2 THEN 1 ELSE 0 END) / COUNT(*)) * 100,1) AS OTD_rate
FROM Orders;

-- What is the year-to-date trend for our On-time Delivery rate?

CREATE TEMPORARY TABLE delivery_summary (
SELECT
    YEAR(required_date) AS yr,
    MONTH(required_date) AS mo,
    SUM(CASE WHEN DATEDIFF(required_date, shipped_date) < 2 THEN 1 ELSE 0 END) AS orders_shipped_late,
    COUNT(*) AS total_orders,
    ROUND((SUM(CASE WHEN DATEDIFF(required_date, shipped_date) >= 2 THEN 1 ELSE 0 END) / COUNT(*)) * 100,1) AS OTD_rate
FROM Orders
WHERE required_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY yr, mo
ORDER BY yr, mo
);

SELECT * FROM delivery_summary;

DROP TEMPORARY TABLE delivery_summary;

-- I assumed OTD rate should be > 95
-- Flag OTD as either 1 - on-target' or 0 - below target
SELECT
    yr,
    mo,
    OTD_rate,
    CASE WHEN OTD_rate >= 95 THEN '1' ELSE '0' END AS OTD_flag
FROM delivery_summary;








-- Customer sales
SELECT
    -- c.customer_id,
    c.company_name,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Revenue
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Details od ON o.order_id = od.order_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY 1
ORDER BY Revenue DESC;

-- Average order - REVIEW!
SELECT
    c.customer_id,
    c.company_name,
    AVG(total_order_value) AS average_order
FROM Customers c
JOIN (
    SELECT
        o.customer_id,
        o.order_id,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_order_value
    FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    GROUP BY o.customer_id, o.order_id
) customer_orders ON c.customer_id = customer_orders.customer_id
GROUP BY
    c.customer_id, c.company_name
ORDER BY
    average_order DESC;
    
   -- Average order - REVIEW! 
SELECT
    c.customer_id,
    c.company_name,
    COUNT(o.order_id) AS total_orders,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_revenue,
    SUM(od.quantity * (od.unit_price * (1 - od.discount)))/COUNT(DISTINCT o.order_id) AS average_order_value
FROM
    Customers c
JOIN
    Orders o ON c.customer_id = o.customer_id
JOIN
    Order_Details od ON o.order_id = od.order_id
GROUP BY
    c.customer_id, c.company_name
ORDER BY
    average_order_value DESC;
    
-- Average freight cost per order for each shipper? - REVIEW!
SELECT
    s.shipper_id,
    s.company_name AS shipper_name,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.freight) / COUNT(o.order_id), 2) AS average_freight_cost_per_order
FROM
    Shippers s
JOIN
    Orders o ON s.shipper_id = o.shipper_id
GROUP BY
    s.shipper_id, s.company_name
ORDER BY
    average_freight_cost_per_order DESC;
    
 -- -- -- ----------------------------------------------------   
SELECT
    c.company_name AS Top_cust_sales,
    ROUND(SUM(od.quantity * (od.unit_price * (1 - od.discount))), 0) AS Sales
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Details od ON o.order_id = od.order_id
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY 1
ORDER BY Sales ASC
;


SELECT
    -- YEAR(required_date) AS yr,
    -- MONTH(required_date) AS mo,
    SUM(CASE WHEN DATEDIFF(required_date, shipped_date) < 2 THEN 1 ELSE 0 END) AS Orders_shipped_late,
    COUNT(DISTINCT order_id) AS Total_orders,
    ROUND((SUM(CASE WHEN DATEDIFF(required_date, shipped_date) >= 2 THEN 1 ELSE 0 END) / COUNT(DISTINCT order_id)) * 100,1) AS OTD_rate
FROM Orders
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30';

SELECT
	order_id,
    required_date,
    shipped_date,
    DATEDIFF(required_date, shipped_date)
FROM orders
WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
GROUP BY order_id;
-----------

SELECT
	YEAR(orders.order_date) AS yr, 
    MONTH(orders.order_date) AS mo, 
    COUNT(DISTINCT CASE WHEN DATEDIFF(required_date, shipped_date) < 2 THEN orders.order_id ELSE NULL END) AS Orders_shipped_late, 
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN orders.order_id ELSE NULL END) AS desktop_orders,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions, 
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN orders.order_id ELSE NULL END) AS mobile_orders
FROM website_sessions
	LEFT JOIN orders 
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
	AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,2;

-- Monthly OTD worked - REVIEW!! - Check Marj Benchmark
-- Recommended OTD is above 95%
# Sum of Orders_shipped_late and Orders_shipped_late != Total_orders (INNER QUERY)
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

# OTD iteration for diffrent segments
-- SELECT
-- 	s.company_name AS Shippier, 
--     COUNT(DISTINCT order_id) AS Total_orders,
--     COUNT(DISTINCT CASE WHEN DATEDIFF(required_date, shipped_date) < 2 THEN order_id ELSE NULL END) AS Orders_shipped_late,
--     COUNT(DISTINCT CASE WHEN DATEDIFF(required_date, shipped_date) >= 2 THEN order_id ELSE NULL END) AS Orders_shipped_OnTime,
--     ROUND(COUNT(DISTINCT CASE WHEN DATEDIFF(required_date, shipped_date) >= 2 THEN order_id ELSE NULL END)/COUNT(DISTINCT order_id),2) AS OTD_rate
-- FROM orders o
-- 	LEFT JOIN shippers s
-- 		ON o.shipper_id = s.shipper_id
-- WHERE order_date BETWEEN '2015-01-01' AND '2015-04-30'
-- GROUP BY 1; 



