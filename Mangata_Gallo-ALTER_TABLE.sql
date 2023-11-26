
/*mangata_gallo*/
USE mangata_gallo;
SHOW COLUMNS FROM staff;

-- Add a new column called 'Role' 
ALTER TABLE staff
ADD COLUMN Role VARCHAR(50) NOT NULL;

--  Drop PhoneNumber column from the 'Staff' table
ALTER TABLE staff
DROP COLUMN PhoneNumber;

/*little_lemon*/
USE little_lemon;
SHOW TABLES FROM little_lemon;
SHOW COLUMNS FROM FoodOrders;

-- FoodOrders table
CREATE TABLE FoodOrders (OrderID INT, Quantity INT, Cost Decimal(4,2));

-- Task 1: Use the ALTER TABLE statement with MODIFY command to make the OrderID the primary key of the 'FoodOrders' table
ALTER TABLE FoodOrders
MODIFY OrderID INT NOT NULL PRIMARY KEY;

-- Task 2: Apply the NOT NULL constraint to the quantity and cost columns
ALTER TABLE FoodOrders
MODIFY cost DECIMAL(4,2) NOT NULL;

/*Task 3: Create two new columns, OrderDate with a DATE datatype and CustomerID with an INT datatype. Declare both must as NOT NULL.
Declare the CustomerID as a foreign key in the FoodOrders table to reference the CustomerID column existing in the Customers table*/
ALTER TABLE FoodOrders
ADD COLUMN OrderDate DATE NOT NULL,
ADD COLUMN CustomerID INT NOT NULL,
ADD CONSTRAINT FK_FoodOrders_Customers
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE FoodOrders 
	ADD COLUMN OrderDate DATE NOT NULL
	,ADD COLUMN CustomerID INT NOT NULL
	,ADD FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID);

-- Task 4: Delete the OrderDate column
ALTER TABLE FoodOrders
DROP COLUMN OrderDate;

-- Task 5: Use the CHANGE command with ALTER statement to rename the column Order_Status in the OrderStatus table to DeliveryStatus
ALTER TABLE OrderStatus
CHANGE Order_Status Delivery_Status VARCHAR(10);

-- Task 6: Use the RENAME command with ALTER statement to change the table name from OrderStatus to OrderDeliveryStatus
ALTER TABLE OrderStatus RENAME OrderDeliveryStatus; -- Cousera

RENAME TABLE OrderStatus TO OrderDeliveryStatus; -- chatgpt
