USE store;
-- SELECT STATEMEMENTS
-- use * to return all columns.
SELECT * 
FROM customers;

-- select columns we want.
SELECT first_name, last_name, birth_date
FROM customers;

-- intoduce a column with an alias.

SELECT first_name, 
last_name, 
birth_date, points,
points*100+50 AS added_points
FROM customers;

-- use DISTINCT to return unique value.
SELECT DISTINCT state
FROM customers;

-- WHERE clause to filter data.
SELECT *
FROM customers
WHERE points>2500;

SELECT *
FROM orders
WHERE order_date>'2019-01-01';

SELECT *
FROM customers
WHERE points>1000 AND state='CO'

SELECT *
FROM order_items
WHERE quantity*unit_price>50;

SELECT *
FROM customers
WHERE state='CO' OR state='VA' ;

-- IN operator
SELECT *
FROM customers
WHERE state IN ('CO','VA') ;

-- between operator
SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01'; 

-- The LIKE operator.
SELECT *
FROM customers
WHERE first_name LIKE 'E%';  -- the % represent any number of characters.

SELECT *
FROM customers
WHERE first_name LIKE '____'; -- _ represent a single character.

-- the REGEXP operator. poweful for search of strings.
-- ^ represent the beginning, $ represent end, |represent logical or,
SELECT *
FROM customers
WHERE first_name REGEXP '^I';

SELECT *
FROM customers
WHERE last_name REGEXP '^I|y$';

-- Missing values

SELECT *
FROM customers
WHERE phone IS NULL;

SELECT *
FROM orders
WHERE shipped_date IS NULL;

-- sorting using ORDER BY clause

SELECT *
FROM customers
ORDER BY first_name, last_name;

SELECT *
FROM customers
ORDER BY 4; -- column position

-- LIMIT CLAUSE
SELECT *
FROM customers
ORDER BY first_name
LIMIT 4

SELECT *
FROM customers
ORDER BY first_name
LIMIT 4,5

-- inner join
SELECT *
FROM orders
JOIN customers
ON orders.customer_id=customers.customer_id;

SELECT first_name, last_name
FROM orders
JOIN customers
ON orders.customer_id=customers.customer_id;

-- use alias to avoid repetation.
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

SELECT *
FROM employees e
JOIN employees em
ON e.reports_to=em.employee_id;

SELECT e.employee_id, e.first_name, em.first_name As manager
FROM employees e
JOIN employees em
ON e.reports_to=em.employee_id;

-- join more than two tables.

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
SELECT *
FROM orders o, customers c
WHERE o.customer_id=c.customer_id;

-- OUTER JOIN

SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
ORDER BY c.first_name;

-- left join
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
ORDER BY c.first_name;

-- right outer join.
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o
ON c.customer_id=o.customer_id
ORDER BY c.first_name;

-- outer join with multiple tables
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
ON e.reports_to=m.employee_id

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
SELECT *
FROM orders o
NATURAL JOIN customers c

-- cross join
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

-- insert rows
INSERT INTO customers
VALUES (DEFAULT, 'MERCY', 'MARAGWA', '1995-03-08', NULL, 'EMBU', 'Nairobi', 'NRB' '180');

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
WHERE invoice_id IN (2,3)
















