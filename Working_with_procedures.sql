CREATE DATABASE Lucky_ShrubProcedures;
USE Lucky_ShrubProcedures;

-- Orders table
CREATE TABLE Orders (OrderID INT, ClientID VARCHAR(10), ProductID VARCHAR(10), Quantity INT, Cost DECIMAL(6, 2));
INSERT INTO Orders (OrderID, ClientID, ProductID , Quantity, Cost) VALUES (1, "Cl1", "P1", 10, 500), (2, "Cl2", "P2", 5, 100), (3, "Cl3", "P3", 20, 800), (4, "Cl4", "P4", 15, 150), (5, "Cl3", "P3", 10, 450), (6, "Cl2", "P2", 5, 800), (7, "Cl1", "P4", 22, 1200), (8, "Cl1", "P1", 15, 150);

/*Task 1: Write a SQL statement that creates a stored procedure called 'GetOrdersData' which retrieves all data from the Orders table*/
CREATE PROCEDURE GetOrdersData()
SELECT *
FROM Orders;

CALL GetOrdersData();

/*Task 2: Write a SQL statement that creates a stored procedure called “GetListOfOrdersInRange”.
The procedure must contain two parameters that determine the range of retrieved data based on 
the user input of two cost values “MinimumValue” and “MaximumValue”*/
CREATE PROCEDURE GetListOfOrdersInRange (MinimumValue DECIMAL, MaximumValue DECIMAL)
SELECT *
FROM Orders
WHERE Cost >= MinimumValue AND Cost <= MaximumValue;

CALL GetListOfOrdersInRange (150, 600);

