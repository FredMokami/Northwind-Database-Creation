CREATE TABLE reservation (
  reservation_id INT, 
  date_time DATETIME, 
  no_of_pax INT, 
  order_id INT, 
  table_id INT, 
  customer_id INT, 
  PRIMARY KEY (reservation_id), 
  FOREIGN KEY (order_id) REFERENCES table_order(table_id), 
  FOREIGN KEY (table_id) REFERENCES tbl(table_id), 
  FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);
