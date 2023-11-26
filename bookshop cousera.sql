CREATE DATABASE bookshop;
USE bookshop;

CREATE TABLE customers (
	customer_id INT NOT NULL
	,name VARCHAR(100)
	,address VARCHAR(255)
	);
    
SHOW tables;

-- Inserting a new customer record into the 'customers' table.
INSERT INTO customers (
    customer_id,
    name,
    address
)
VALUES (
    1,
    "Jack",
    "115 Old street Belfast"
);

SELECT *
FROM customers;

INSERT INTO customers (
    customer_id,
    name,
    address
	)
VALUES (
	2
	,"James"
	,"24 Carlson Rd London"
	);