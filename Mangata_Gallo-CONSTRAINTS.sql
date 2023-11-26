CREATE DATABASE Mangata_Gallo;
USE Mangata_Gallo;

-- Task 1: Create the Clients table
CREATE TABLE Clients (
	ClientID INT NOT NULL PRIMARY KEY,
	FullName VARCHAR(100) NOT NULL,
	PhoneNumber INT NOT NULL UNIQUE
	);

SHOW COLUMNS FROM Clients;

-- Task 2: Create the Items table
CREATE TABLE Items (
	ItemID INT NOT NULL PRIMARY KEY,
	ItemName VARCHAR(100) NOT NULL,
	Price DECIMAL(5, 2) NOT NULL
	);
    
SHOW COLUMNS FROM Items;

-- Task 3: Create the Orders table
CREATE TABLE Orders (
	OrderID INT NOT NULL PRIMARY KEY,
	ItemID INT NOT NULL,
	ClientID INT NOT NULL,
	Quantity INT NOT NULL CHECK (Quantity <= 3),
	COST DECIMAL(6, 2) NOT NULL,
	FOREIGN KEY (ItemID) REFERENCES Items(ItemID) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE CASCADE ON UPDATE CASCADE
	);

SHOW COLUMNS FROM Orders;

ALTER TABLE Orders
CHANGE COLUMN COST Cost DECIMAL(6,2) NOT NULL;


-- PRACTICE USING MYSQL CONSTRAINTS

-- Task 1:  Create the Staff

CREATE TABLE Staff(
	StaffID INT NOT NULL PRIMARY KEY,
	PhoneNumber INT NOT NULL UNIQUE,
    FullName VARCHAR(100) NOT NULL
    );

    
SHOW COLUMNS FROM ContractInfo;
    
-- Task 2: Create the 'ContractInfo' table
CREATE TABLE ContractInfo(
	ContractID INT NOT NULL PRIMARY KEY,
	StaffID INT NOT NULL,
    Salary DECIMAL (7,2) NOT NULL,
    Location VARCHAR(50) NOT NULL DEFAULT 'Texas',
    StaffType VARCHAR(20) NOT NULL CHECK (StaffType IN ('Junior', 'Senior'))
    );
  
/*Exercise solution*/
CREATE TABLE ContractInfo (
	ContractID INT NOT NULL PRIMARY KEY,
	StaffID INT NOT NULL,
	Salary DECIMAL(7, 2) NOT NULL,
	Location VARCHAR(50) NOT NULL DEFAULT "Texas",
	StaffType VARCHAR(20) NOT NULL CHECK (StaffType = "Junior" OR StaffType = "Senior")
	);
    
    -- Task 3: Create a foreign key that links the Staff table with the ContractInfo table
ALTER TABLE ContractInfo
ADD CONSTRAINT FK_ContractInfo_Staff
FOREIGN KEY (StaffID)
REFERENCES Staff(StaffID)
ON DELETE CASCADE
ON UPDATE CASCADE;

/*Exercise solution*/
CREATE TABLE ContractInfo (
	ContractID INT NOT NULL PRIMARY KEY,
	StaffID INT NOT NULL,
	Salary DECIMAL(7, 2) NOT NULL,
	Location VARCHAR(50) NOT NULL,
	StaffType VARCHAR(20) NOT NULL CHECK (StaffType = "Junior" OR StaffType = "Senior"),
	FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
	);