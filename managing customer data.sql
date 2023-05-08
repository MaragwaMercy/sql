-- SQL subqueries
use store;
select * from customers;
-- SELECT Subquery:
SELECT * FROM customers WHERE points > (SELECT AVG(points) FROM customers);
-- Subquery with diffrent tables:
SELECT first_name, phone, address from customers
WHERE shipped_date IN (SELECT shipped_date FROM orders WHERE shipped_date IS NOT NULL);

SELECT c.customer_id, c.first_name, o.order_id, o.shipped_date
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
WHERE shipped_date IN (SELECT shipped_date FROM orders WHERE shipped_date IS NOT NULL);

-- stored procedure

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













