CREATE DATABASE little_lemon; 
USE little_lemon;

-- Customers table
CREATE TABLE Customers (
	CustomerID INT NOT NULL PRIMARY KEY,
	FullName VARCHAR(100) NOT NULL,
	PhoneNumber INT NOT NULL UNIQUE
	);
    
INSERT INTO Customers(CustomerID, FullName, PhoneNumber) VALUES (1, "Vanessa McCarthy", 0757536378), (2, "Marcos Romero", 0757536379), (3, "Hiroki Yamane", 0757536376), (4, "Anna Iversen", 0757536375), (5, "Diana Pinto", 0757536374);

-- Bookings table
CREATE TABLE Bookings (
	BookingID INT NOT NULL PRIMARY KEY,
	BookingDate DATE NOT NULL,
	TableNumber INT NOT NULL,
	NumberOfGuests INT NOT NULL CHECK (NumberOfGuests <= 8),
	CustomerID INT NOT NULL,
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
	ON DELETE CASCADE
	ON UPDATE CASCADE
	);
    
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, NumberOfGuests, CustomerID) VALUES (10, '2021-11-11', 7, 5, 1), (11, '2021-11-10', 5, 2, 2), (12, '2021-11-10', 3, 2, 4);

--  Customers who have made bookings
SELECT c.FullName AS "Full Name", 
	c.PhoneNumber AS "Phone Number",
	b.BookingDate AS "Booking Date",
	b.NumberOfGuests AS "Number Of Guests"
FROM Customers c
INNER JOIN Bookings b
	ON c.CustomerID = b.CustomerID;
    
-- Existing customers with bookings that have been made so far. This data must include customers who haven’t made any booking yet
SELECT c.CustomerID,
	c.FullName AS "Full Name", 
	b.BookingID AS "Booking ID"
FROM Customers c
LEFT JOIN Bookings b
	ON c.CustomerID = b.CustomerID
ORDER BY c.CustomerID DESC;

-- LUCKY SHRUBS
CREATE DATABASE luckyshrub_db;
USE luckyshrub_db;

-- Orders table
CREATE TABLE Orders(OrderID INT, Department VARCHAR(100), OrderDate DATE, OrderQty INT, OrderTotal INT, PRIMARY KEY(OrderID));

INSERT INTO Orders VALUES(1,'Lawn Care','2022-05-05',12,500),(2,'Decking','2022-05-22',150,1450),(3,'Compost and Stones','2022-05-27',20,780),(4,'Trees and Shrubs','2022-06-01',15,400),(5,'Garden Decor','2022-06-10',2,1250),(6,'Lawn Care','2022-06-10',12,500),(7,'Decking','2022-06-25',150,1450),(8,'Compost and Stones','2022-05-29',20,780),(9,'Trees and Shrubs','2022-06-10',15,400),(10,'Garden Decor','2022-06-10',2,1250),(11,'Lawn Care','2022-06-25',10,400), 
(12,'Decking','2022-06-25',100,1400),(13,'Compost and Stones','2022-05-30',15,700),(14,'Trees and Shrubs','2022-06-15',10,300),(15,'Garden Decor','2022-06-11',2,1250),(16,'Lawn Care','2022-06-10',12,500),(17,'Decking','2022-06-25',150,1450),(18,'Trees and Shrubs','2022-06-10',15,400),(19,'Lawn Care','2022-06-10',12,500),(20,'Decking','2022-06-25',150,1450),(21,'Decking','2022-06-25',150,1450);

-- all records that have the same order date
SELECT OrderDate
FROM Orders
GROUP BY OrderDate;

-- The number of orders placed on the same day
SELECT OrderDate, COUNT(OrderQty) 
FROM Orders
GROUP BY OrderDate;

-- Total order quantities placed by each department
SELECT Department, SUM(OrderQty)
FROM Orders
GROUP BY Department;

-- Number of orders placed on the same day between 1st June 2022 and 30th June 2022
SELECT OrderDate,
	COUNT(OrderQty) AS "Order Qty"
FROM Orders
GROUP BY OrderDate
HAVING OrderDate BETWEEN '2022-06-01'
		AND '2022-06-30';
        
-- GRAYHAT - weight_loss  (1,'Lawn Care','2022-05-05',12,500)
CREATE TABLE  weight_loss(member_id INT, date DATE, weight INT);
INSERT INTO weight_loss VALUES(1, '2022-10-01', 80),
	(2, '2023-01-01', 74),
    (3, '2023-01-01', 66),
    (1, '2023-01-01', 78),
    (3, '2023-01-15', 65),
    (3, '2023-01-05', 78);
    
SELECT * FROM weight_loss;
DESCRIBE weight_loss;

-- What is the first and the last weight for each member_id?
SELECT
    member_id,
    MIN(weight) AS first_weight,
    MAX(weight) AS last_weight
FROM weight_loss
GROUP BY member_id;

-- member_id with the lowest weight in the period btn 2022-01-01 and 2023-01-01
SELECT member_id, 
	MIN(weight) AS lowest_weight
FROM  weight_loss
WHERE date BETWEEN '2022-01-01' AND '2023-01-01'
GROUP BY member_id
ORDER BY lowest_weight DESC
LIMIT 1;
-- member_id with the lowest weight in the period btn 2022-01-01 and 2023-01-01
SELECT member_id
FROM weight_loss
WHERE DATE BETWEEN '2022-01-01'
		AND '2023-01-01'
ORDER BY weight LIMIT 1;

-- Members with the same weight
SELECT DISTINCT wL1.member_id,
	wL1.weight
FROM weight_loss wL1
INNER JOIN weight_loss wL2
	ON wl1.weight = wL2.weight
		AND wL1.member_id <> wL2.member_id
ORDER BY wL1.weight,
	wL1.member_id;
    


