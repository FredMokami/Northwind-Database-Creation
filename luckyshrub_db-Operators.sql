-- Examples of using ANY and ALL operators with the GROUP BY and HAVING clauses

CREATE DATABASE luckyshrub_db; 
USE luckyshrub_db;

/* Task1: Use the ANY operator to identify all employees with the Order Status status 'Completed'*/

SELECT DISTINCT e.EmployeeID, e.EmployeeName
FROM employees e
WHERE e.EmployeeID = ANY (
  SELECT eo.EmployeeID
  FROM employee_orders eo
  WHERE eo.Status = 'Completed'
);
-- JOIN
SELECT DISTINCT e.EmployeeID,
	e.EmployeeName
FROM employees e
INNER JOIN employee_orders eo
	ON e.EmployeeID = eo.employeeID
WHERE eo.STATUS = 'Completed';

/* Task 2: Use the ALL operator to identify the IDs of employees who earned a handling cost of "more than 20% of the order value" 
from all orders they have handled */

SELECT EmployeeID, HandlingCost
FROM employee_orders
WHERE HandlingCost > ALL(SELECT ROUND(OrderTotal/100 * 20) FROM orders); 

/* Task 3 solution: Use the GROUP BY clause to summarize the duplicate records with the same column values
 into a single record by grouping them based on those columns.*/
 
SELECT EmployeeID, HandlingCost
FROM employee_orders
WHERE HandlingCost > ALL(SELECT ROUND(OrderTotal/100 * 20) FROM orders) GROUP BY EmployeeID, HandlingCost;


