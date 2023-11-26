USE northwinddb;

-- Orders table
CREATE TABLE Orders (
    orderID INT PRIMARY KEY,
    customerID VARCHAR(255),
    employeeID INT,
    orderDate DATE,
    requiredDate DATE,
    shippedDate DATE,
    shipperID INT,
    freight DECIMAL(10, 2)
    
);



ALTER TABLE Orders
MODIFY orderID INT NOT NULL UNIQUE,
MODIFY customerID VARCHAR(255) NOT NULL,
MODIFY employeeID INT NOT NULL;


DROP TABLE Orders;
SELECT * FROM Orders LIMIT 10;
SHOW COLUMNS FROM Orders;

/*
INSERT INTO...VALUES  OR
D:\Library\DSKTP\Workshop\xls\Northwind Traders

LOAD DATA LOCAL INFILE 'path/to/your/csvfile.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n'
IGNORE 1 LINES
(orderID, customerID, employeeID, orderDate, requiredDate, shippedDate, shipperID, freight);

Enabling the local_infile feature to use LOAD DATA LOCAL INFILE can pose security risks, 
especially in shared or public environments. It allows the execution of arbitrary local files, 
which might lead to potential vulnerabilities if not properly secured.

-- I will  be using import wizard

*/

-- Order_details table
CREATE TABLE Order_details (
    -- order_detailsID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    orderID INT NOT NULL,
    productID INT NOT NULL,
    unitPrice DECIMAL(10, 2),
    quantity TINYINT,
    discount DECIMAL(4, 2),
    PRIMARY KEY (orderID, productID)
);

DROP TABLE Order_details;
SHOW COLUMNS FROM Order_details;
SELECT * FROM Order_details LIMIT 10;

-- Customers table
CREATE TABLE Customers (
    customerID VARCHAR(5) NOT NULL PRIMARY KEY,
    companyName VARCHAR(255),
    contactName VARCHAR(255),
    contactTitle VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50)
);

-- Products table
CREATE TABLE Products (
    productID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(255),
    quantityPerUnit VARCHAR(50),
    unitPrice DECIMAL(10, 2),
    discontinued TINYINT CHECK (discontinued IN (0, 1)),
    categoryID INT
);

SHOW COLUMNS FROM Products;
SELECT * FROM Products LIMIT 10;

-- Categories table
CREATE TABLE Categories (
    categoryID INT PRIMARY KEY,
    categoryName VARCHAR(50),
    description VARCHAR(255)
);


SELECT * FROM Categories LIMIT 10;

-- Employees table

CREATE TABLE Employees (
    employeeID INT PRIMARY KEY,
    employeeName VARCHAR(255),
    title VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50),
    reportsTo INT
);
DROP TABLE Employees;
SHOW COLUMNS FROM Employees;
SELECT * FROM Employees; 


-- 
CREATE TABLE Shippers (
    shipperID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    companyName VARCHAR(255)
);

SHOW COLUMNS FROM Shippers;
SELECT * FROM Shippers; 

/*CONSTRAINTS - - Apply referential intergrity constraints*/

-- Orders FKs
ALTER TABLE Orders
	ADD FOREIGN KEY (customerID) REFERENCES Customers(customerID),
	ADD FOREIGN KEY (employeeID) REFERENCES Employees(employeeID),
	ADD FOREIGN KEY (shipperID) REFERENCES Shippers(shipperID);

SHOW COLUMNS FROM Order_details;
SHOW COLUMNS FROM Orders;

-- Order_details FKs
ALTER TABLE Order_details
	ADD FOREIGN KEY (orderID) REFERENCES Orders(orderID),
	ADD FOREIGN KEY (productID) REFERENCES Products(productID);
 
/* 
SET FOREIGN_KEY_CHECKS=0;
SET FOREIGN_KEY_CHECKS=1;
*/

SHOW COLUMNS FROM Order_details;
    
    
-- Products FKs
ALTER TABLE Products
	ADD FOREIGN KEY (categoryID) REFERENCES Categories(categoryID);
    
SHOW COLUMNS FROM Products;

-- Employees Fks
ALTER TABLE Employees
	ADD FOREIGN KEY (reportsTo) REFERENCES Employees(employeeID);
    
SHOW COLUMNS FROM Employees;


