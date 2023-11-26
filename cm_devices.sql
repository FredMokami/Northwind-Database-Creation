CREATE DATABASE cm_devices;
USE cm_devices;
-- Create a table to store address information for customers.
CREATE TABLE address (
    customerID INT NOT NULL,
    street VARCHAR(100),
    postcode VARCHAR(10),
    town VARCHAR(50) DEFAULT 'Harrow'
);

SHOW columns FROM address;

DROP TABLE address;

CREATE TABLE address (
    customerID INT NOT NULL,
    street VARCHAR(100),
    postcode VARCHAR(10) DEFAULT "HA97DE",
    town VARCHAR(50) DEFAULT 'Harrow'
);

SHOW columns
FROM address;

-- Create a table to manage invoice data for customer orders
CREATE TABLE invoice (
	customer_name VARCHAR(255)
	,order_date DATE
	,quantity INT
	,total_price DECIMAL
	);

SHOW columns
FROM invoice;

DROP TABLE invoice;

-- Create "invoice table" (2dp for total_price)
CREATE TABLE invoice (
	customer_name VARCHAR(255)
	,order_date DATE
	,quantity INT
	,total_price DECIMAL (10, 2)
	);
