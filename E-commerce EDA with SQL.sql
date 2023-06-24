
-- This is dammy data i created to demonstrate use of SQL in sales/retail industry.
-- The databases are sql_hr, sql_inventory, sql_invoicing and sql_store which contain 
-- diffrent tables


USE sql_store;  -- this specify the database we will be using.
-- SELECT STATEMEMENTS
-- use * to return all columns.
SELECT * 
FROM customers;   -- this query returns all entries in the customers table.

-- select only the columns we want.
SELECT first_name, last_name, birth_date
FROM customers;

-- intoduce a column with an alias.
-- in the code below, we ruturn customers first name, last name, birth date, points and another column named 'added points'
SELECT first_name, 
last_name, 
birth_date, points,
points*100+50 AS added_points
FROM customers;

-- use DISTINCT to return unique value.
-- this returns only unique states from the customers table.
SELECT DISTINCT state
FROM customers;

-- WHERE clause to filter data. It filter the rows returned by a query.
-- It allows you to retrieve specific data based on certain criteria.
SELECT *
FROM customers
WHERE points>2500;  -- returns only customers who have more than 2500 points.

SELECT *
FROM orders
WHERE order_date>'2019-01-01'; -- this returns orders that were made after Jan 1st 2019.

SELECT *
FROM customers
WHERE points>1000 AND state='CO'; -- this will return customers who have more than 1000 and they are from 'CO' state

SELECT *
FROM order_items
WHERE quantity*unit_price>50; -- here, quantity column and unit price column are multplied and the column where result is more than 50 are returned. 


SELECT *
FROM customers
WHERE state='CO' OR state='VA' AND points>1000;

-- IN operator. The IN operator in SQL is used to specify a condition where a column's value must match any value in a given list.
--  It allows you to compare a column's value against multiple values at once. 

SELECT *
FROM customers
WHERE state IN ('CO','VA') ;

-- BETWEEN and AND operator.  he BETWEEN operator and the AND operator are used together to specify a 
-- range of values for a column in a query's WHERE clause. 
-- The BETWEEN operator allows you to specify a range by providing two values: 
-- a lower bound and an upper bound. 

-- retrieve customer who were born between '1990-01-01' and '2000-01-01'
SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01'; 

-- The LIKE operator is used for pattern matching within a column's value. 
-- It allows you to search for rows that match a specific pattern or contain a particular substring.

-- in querry below, we retrieve customers whose first name starts with an E followed by any number of characters.

SELECT *
FROM customers
WHERE first_name LIKE 'E%';  -- the % represent any number of characters.

-- retrieving customers whose first name has four characters.
SELECT *
FROM customers
WHERE first_name LIKE '____'; -- _ represent a single character.

-- the REGEXP operator. poweful for search of strings.
-- ^ represent the beginning, $ represent end, |represent logical or,
SELECT *
FROM customers
WHERE first_name REGEXP '^I'; -- retrieves customers whose first name starts with an 'I'

-- The query below will return customers whose last name starts with an 'I' or ends with 'y', or first name starts with 'I'
SELECT *
FROM customers
WHERE last_name REGEXP '^I|y$' OR first_name REGEXP '^I';

-- Missing values
-- selecting customers who have a missing phone number
SELECT *
FROM customers
WHERE phone IS NULL;

-- retrieve orders that are not shipped yet.
SELECT *
FROM orders
WHERE shipped_date IS NULL;

-- sorting using ORDER BY clause. is used to sort the result set of a query based on one or more columns.
--  It allows you to specify the order in which the rows should be displayed

SELECT *
FROM customers
ORDER BY first_name, last_name;

SELECT *
FROM customers
ORDER BY 4; -- column position

-- LIMIT CLAUSE. is used to restrict the number of rows returned by a query. 
-- It allows you to specify a limit on the number of rows to be retrieved from the result set

-- query first four rows.
SELECT *
FROM customers
ORDER BY first_name
LIMIT 4;

SELECT *
FROM customers
ORDER BY first_name
LIMIT 4,5;  -- this returns four columns after the fifth column.

-- inner join is used to combine rows from two or more tables based on a related column between them.
--  It selects records that have matching values in both tables and produces a result set that includes only the matched rows.

-- selecting customers who have made an order from the two tables. 
SELECT *
FROM orders
JOIN customers
ON orders.customer_id=customers.customer_id;

SELECT customers.customer_id, first_name, last_name
FROM orders
JOIN customers
ON orders.customer_id=customers.customer_id;

-- use alias to avoid repetation.

-- selecting names of the products ordered using join.
SELECT *
FROM order_items oi
JOIN products p
ON oi.product_id=p.product_id;

-- joining across mutiple databases.
SELECT *
FROM order_items oi
JOIN sql_inventory.products p
ON oi.product_id=p.product_id;

-- joining a table with itself. self join
-- selecting an employee and who they report to from employee table.
USE sql_hr;
SELECT *
FROM employees e
JOIN employees em
ON e.reports_to=em.employee_id;

SELECT e.employee_id, e.first_name, em.first_name As manager
FROM employees e
JOIN employees em
ON e.reports_to=em.employee_id;

-- join more than two tables.
-- checking order status for the orders made by different customers.
SELECT *
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
JOIN order_statuses os
ON o.status=os.order_status_id;

SELECT o.order_id, o.order_date, c.first_name, c.last_name, os.name AS ststus
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
JOIN order_statuses os
ON o.status=os.order_status_id;

-- implicit join
--  Instead of explicitly using the INNER JOIN syntax, 
-- implicit joins make use of the WHERE clause to specify the join condition.
SELECT *
FROM orders o, customers c
WHERE o.customer_id=c.customer_id;

-- OUTER JOIN An outer join is used in SQL to combine rows from two or more tables based on a
 -- related column, including unmatched rows from one or both tables.

SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
ORDER BY c.first_name;

-- LEFT JOIN
-- Retrieves all rows from the left (first) table and the matching rows from the right (second) table.
-- Unmatched rows from the left table have NULL values for the columns from the right table.
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
ORDER BY c.first_name;

-- right outer join.
-- Retrieves all rows from the right (second) table and the matching rows from the left (first) table.
-- Unmatched rows from the right table have NULL values for the columns from the left table.
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id=o.customer_id
ORDER BY c.first_name;

-- outer join with multiple tables

-- selecting all customers wether they have made an order or not and if they have an order, add the shipper name
SELECT c.customer_id, c.first_name, o.order_id, sh.shipper_id, sh.name
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
JOIN shippers sh
ON o.shipper_id=sh.shipper_id
ORDER BY c.first_name;

SELECT c.customer_id, c.first_name, o.order_id, sh.shipper_id, sh.name
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
LEFT JOIN shippers sh
 ON o.shipper_id=sh.shipper_id
ORDER BY c.first_name;

SELECT c.customer_id, c.first_name, o.order_id, sh.shipper_id, sh.name 
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
JOIN shippers sh
ON o.shipper_id=sh.shipper_id
ORDER BY c.first_name;

-- self outer join
SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
JOIN employees m
ON e.reports_to=m.employee_id;

SELECT e.employee_id, e.first_name, m.first_name AS manager
FROM employees e
LEFT JOIN employees m
ON e.reports_to=m.employee_id;

-- The USING clause. use when the column have same name across diffrent tables.

SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o
USING (customer_id)
ORDER BY c.first_name;

SELECT p.date, c.name as Client, p.amount, pm.name AS payment_method
FROM payments p
JOIN clients c
USING (client_id)
JOIN payment_methods pm
ON p.payment_method=pm.payment_method_id;

-- natural joins
-- automatically matches and combines tables based on columns with the same name and data type. 
-- It is a shorthand notation for joining tables without explicitly specifying the join condition.

SELECT *
FROM orders o
NATURAL JOIN customers c;

-- cross join
-- combines each row from one table with every row from another table. 
--  It produces a result set that is the product of the two tables, resulting in all possible combinations of rows.
SELECT *
FROM orders o
CROSS JOIN customers c;

-- UNION. Combine results from diffrent queries
SELECT order_id, order_date, 'ACTIVE' AS status
FROM orders
WHERE order_date>='2019-01-01'
UNION
SELECT order_id, order_date, 'ARCHIVE' AS status
FROM orders
WHERE order_date<'2019-01-01';

SELECT customer_id, first_name, points, 'Bronze' AS type
FROM customers
WHERE points<2000


UNION
SELECT customer_id, first_name, points, 'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000

UNION
SELECT customer_id, first_name, points, 'Gold' AS type
FROM customers
WHERE points >3000
ORDER BY first_name;

SELECT *
FROM customers
UNION ALL
SELECT *
FROM customers_archive
order by first_name;

-- insert rows
INSERT INTO customers
VALUES (DEFAULT, 'MERCY', 'MARAGWA', '1995-03-08', NULL, 'EMBU', 'Nairobi', 'NR', '180');

-- copying tables
CREATE TABLE customers_archive AS
SELECT * FROM customers;

-- Copying data with a select statement.
INSERT INTO customers_archive
SELECT * FROM customers
WHERE points<3000;

-- updating a single row.
UPDATE invoices
SET payment_total=100
WHERE invoice_id=1;

-- update several rows

UPDATE invoices
SET payment_total=100
WHERE invoice_id IN (2,3,5);

-- SQL subqueries
-- selecting customers whose points are more than the average points.
use sql_store;
select * from customers;
-- SELECT Subquery:
SELECT * FROM customers WHERE points > (SELECT AVG(points) FROM customers);


-- Subquery with diffrent tables:
-- selecting customers whose order have been shipped.

SELECT c.customer_id, c.first_name, o.order_id, o.shipped_date
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
WHERE shipped_date IN (SELECT shipped_date FROM orders WHERE shipped_date IS NOT NULL);

-- STORED PROCEDURE.
-- a reusable piece of code that can be called multiple times, providing a convenient way to encapsulate and execute complex database operations.


DROP PROCEDURE IF EXISTS get_employee;  -- deleting a procedure

delimiter &&
CREATE PROCEDURE get_employee()
BEGIN
SELECT c.customer_id, c.first_name, o.order_id, o.shipped_date
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
WHERE o.shipped_date IS NOT NULL;
END &&
delimiter ;

CALL get_employee();

-- stored procedure using IN parameter.
-- procedure to get the top 5 customers based on points
delimiter **
CREATE PROCEDURE top_customers(IN var int)
BEGIN
SELECT c.customer_id, c.first_name,c.points, o.order_id, o.shipped_date
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
WHERE o.shipped_date IS NOT NULL
ORDER BY points desc limit var;
END **
delimiter ;

CALL top_customers(5);

# stored procedure with update statement.
-- stored procedure to update customer points.

DROP PROCEDURE IF EXISTS update_points;

DELIMITER $$
CREATE PROCEDURE update_points(IN cust_name VARCHAR(20), IN new_points INT)
BEGIN
  UPDATE customers c
  JOIN orders o ON c.customer_id = o.customer_id
  SET c.points = new_points
  WHERE c.first_name = cust_name AND o.shipped_date IS NOT NULL;
END$$
DELIMITER ;

CALL update_points('Ines', 3000);

# stored procedure using OUT parameter
DELIMITER $$
CREATE PROCEDURE count_points(OUT total_LoyalCustomers INT)
BEGIN
SELECT count(points) into total_LoyalCustomers FROM customers WHERE points> 1000;
END$$
DELIMITER ;

CALL count_points(@result);
SELECT @result;

# triggers in SQL. Triggers in SQL are special types of stored procedures that are 
# executed automatically in response to certain events, such as an INSERT, UPDATE, or DELETE 
# operation on a table. 
# Triggers can be used to enforce business rules, maintain referential integrity, and 
# log changes made to data in a database.
CREATE TABLE logs (
  customer_id INT,
  old_points INT,
  new_points INT,
  update_time TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER update_points
BEFORE UPDATE ON customers
FOR EACH ROW
BEGIN
    DECLARE new_points INT;
    SET new_points = NEW.points;
    IF OLD.points < 1000 THEN
        SET new_points = OLD.points + 1000;
    END IF;
    INSERT INTO logs (customer_id, old_points, new_points, update_time)
    VALUES (OLD.customer_id, OLD.points, new_points, NOW());
    SET NEW.points = new_points;
END$$
DELIMITER ;
UPDATE customers
SET points = 900
WHERE customer_id = 2;

# views in SQL.
#view is a virtual table that is based on the result set of a SELECT statement. 
# It allows you to save a query as a view and then refer to that view as if it were a table.
CREATE VIEW delivered_orders AS
SELECT c.customer_id, c.first_name, o.order_id, o.shipped_date
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
WHERE shipped_date IN (SELECT shipped_date FROM orders WHERE shipped_date IS NOT NULL);

select * from delivered_orders;

# window functions in SQL.
#A window function in SQL is a type of function that performs a calculation 
# across a set of rows that are related to the current row. 
#It allows you to perform calculations and aggregate functions without grouping or filtering the data.


SELECT product_id, name, quantity_in_stock, unit_price,
SUM(quantity_in_stock*unit_price) OVER (PARTITION BY product_id) AS total_quantity
FROM products;

# row number function
# assigns a unique number to each row within a partition, based on the specified order. 
# It can be used to generate a unique identifier for each row, or to rank or order the rows 
# based on a specific criteria.

SELECT 
  product_id, 
  name, 
  unit_price,
  ROW_NUMBER() OVER (ORDER BY unit_price DESC) AS ranks
FROM 
  products;
  
  # rank function
  #  window function that assigns a rank to each row within a partition based on the specified order. 
  # It can be used to assign a rank to each row based on a specific criteria, such as a numerical value or a date.
  SELECT 
  product_id, 
  name, 
  unit_price,
  RANK() OVER (ORDER BY unit_price DESC) AS ranks
FROM 
  products;
  
# first value function
# returns the first value in a window of rows based on a specified order.
# It can be used to select the first value in a window of rows based on a specific criteria, such as a numerical value or a date.  

SELECT 
  product_id, 
  name, 
  unit_price,
  FIRST_VALUE(unit_price) OVER (ORDER BY unit_price desc) AS min_price
FROM 
  products;

SELECT customer_id, first_name, points,
CASE
WHEN points >= 2500 THEN 'Loyal customer'
           WHEN points >= 1500 THEN 'Average customer'
           WHEN points >= 1 THEN 'new customer'
           ELSE 'entry level'
       END AS customer_level
FROM customers
WHERE points IS NOT NULL
ORDER BY points














# case statement
# conditional expression that allows you to perform conditional logic in a query. 
# It enables you to return different values based on specific conditions.















