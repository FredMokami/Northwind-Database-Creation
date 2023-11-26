CREATE DATABASE jewelrystore_db;
USE jewelrystore_db;

-- item table
CREATE TABLE item(ItemID INT, Name VARCHAR(150), Cost INT, PRIMARY KEY(ItemID));
INSERT INTO item VALUES(1,'Engagement ring',2500),(2,'Silver brooch',400),(3,'Earrings',350),(4,'Luxury watch',1250),(5,'Golden bracelet',800), (6,'Gemstone',1500);

-- mg_orders table
CREATE TABLE mg_orders(OrderID INT, ItemID INT, Quantity INT, Cost INT, OrderDate DATE, DeliveryDate DATE, OrderStatus VARCHAR(50), PRIMARY KEY(OrderID));
INSERT INTO mg_orders VALUES(1,1,50,122000,'2022-04-05','2022-05-25', 'Delivered'),(2,2,75,28000,'2022-03-08',NULL, 'In progress'), (3,3,80,25000,'2022-05-19','2022-06-08', 'Delivered'), (4,4,45,100000,'2022-01-10',NULL, 'In progress'),(5,5,70,56000,'2022-05-19',NULL, 'In progress'),(6,6,60,90000,'2022-06-10','2022-06-18', 'Delivered');

/*Task 1: Item name–quantity–order status concatnation*/
-- My solution
SELECT CONCAT (LOWER(i.Name),'-', o.Quantity ,'-', UPPER(o.OrderStatus)) AS Result
FROM item i
JOIN mg_orders o ON i.ItemID = O.ItemID;

-- Exc solution
SELECT CONCAT(LCASE(Name),'-',Quantity,'-', UCASE(OrderStatus)) 
FROM item,mg_orders 
WHERE item.ItemID = mg_orders.ItemID;


/*AS Task 2: Write a SQL SELECT query using an appropriate date function and a format string to find the name of the weekday 
on which M&G’s orders are to be delivered.*/ 

SELECT DAYNAME(DeliveryDate)
FROM mg_orders;

-- Exc solution
SELECT DATE_FORMAT(DeliveryDate,'%W') 
FROM mg_orders; 

/*Task 3: Write a SQL SELECT query that calculates the cost of handling each order.
This should be 5% of the total order cost. Use an appropriate math function to round that value to 2 decimal places.*/

SELECT OrderID, ROUND((0.05*Cost),2) AS 'Handling_Cost'
FROM mg_orders;

--
SELECT OrderID, ROUND((Cost * 5 / 100),2) AS HandlingCost
FROM mg_orders; 

/*Task 4: Review the query that you wrote in the second task.
Use an appropriate comparison function to filter out the records that do not have a NULL value in the delivery date column*/

SELECT DAYNAME(DeliveryDate) AS 'Delivery_Day'
FROM mg_orders
WHERE DAYNAME(DeliveryDate) IS NOT NULL;

-- Exc solution
SELECT DATE_FORMAT(DeliveryDate,'%W') 																				
FROM mg_orders 
WHERE !ISNULL(DeliveryDate);