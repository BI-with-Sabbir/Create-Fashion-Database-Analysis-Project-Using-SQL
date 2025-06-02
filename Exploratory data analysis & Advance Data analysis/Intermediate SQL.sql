-- JOINING, UNION, CASE WHEN, VIEWS, STORED PROCEDURE AND SQL Code Order of Execution for Intermediate SQL

/*
In the previous script, we explored how to query data from a single table using various clauses and functions. 
However, relational databases derive their power from the relationships between tables. 
This script focuses on techniques to combine data from multiple tables (`JOIN`), merge results from different queries (`UNION`), implement conditional logic within queries (`CASE WHEN`), 
and create reusable query structures (`VIEW`s and Stored Procedures).

-- Topics: 
1. SQL Join: Left, Right, Inner, Full, Cross Join, 
2. UNION, UNION ALL, 
3. SQL Code Order of Execution
4. CASE WHEN, Views, Stored Procedures

*/
-- Use the target database
USE fashion_db;

-- 1. SQL Join: Left, Right, Inner & Full Join
-- Combining Data from Multiple Tables
-- `JOIN` clauses are used to combine rows from two or more tables based on a related column between them. 
-- The relationship is typically defined by a foreign key in one table referencing a primary key in another.

-- INNER JOIN: Returns only the rows where the join condition is met in *both* tables. It retrieves the intersection of the two tables based on the common column values.

-- Get products with their brand names
SELECT 
    p.product_id, 
    p.product_name, 
    b.brand_name
FROM products p
INNER JOIN brands b ON p.brand_id = b.brand_id
LIMIT 10;

-- LEFT JOIN: Returns *all* rows from the left table (the table mentioned before `LEFT JOIN`) and the matched rows from the right table. 
-- If there is no match in the right table for a row in the left table, the columns from the right table will have `NULL` values for that row.
-- This is useful for finding customers who haven't placed orders yet

-- Get all customers and their order IDs, if any
SELECT 
    c.customer_id, 
    c.first_name, 
    c.email,
    so.order_id
FROM customers c
LEFT JOIN sales_orders so ON c.customer_id = so.customer_id
LIMIT 15;

-- Find customers who have NOT placed any orders using LEFT JOIN
SELECT 
    c.customer_id, 
    c.first_name, 
    c.email
FROM customers c
LEFT JOIN sales_orders so ON c.customer_id = so.customer_id
WHERE so.order_id IS NULL;

-- RIGHT JOIN: Returns *all* rows from the right table (the table mentioned after `RIGHT JOIN`) and the matched rows from the left table. 
-- If there is no match in the left table for a row in the right table, the columns from the left table will have `NULL` values.
-- `RIGHT JOIN` is used less frequently than `LEFT JOIN`, as you can usually achieve the same result by swapping the table order and using a `LEFT JOIN`.

-- Get all orders and their customer names, if any - less common
SELECT 
    c.first_name, 
    c.last_name,
    so.order_id,
    so.order_date
FROM customers c
RIGHT JOIN sales_orders so ON c.customer_id = so.customer_id
LIMIT 15;


-- FULL OUTER JOIN: Returns all rows when there is a match in *either* the left or the right table. 
-- It includes matched rows, rows unique to the left table (with NULLs for right table columns), and rows unique to the right table (with NULLs for left table columns).

-- Simulated using UNION which Combines results and removes duplicates
-- Get all customers and all orders, showing matches and non-matches
SELECT c.customer_id, c.first_name, so.order_id, so.order_date
FROM customers c
LEFT JOIN sales_orders so ON c.customer_id = so.customer_id
UNION
SELECT c.customer_id, c.first_name, so.order_id, so.order_date
FROM customers c
RIGHT JOIN sales_orders so ON c.customer_id = so.customer_id;



-- Joining Multiple Tables (Customer -> Order -> OrderItem -> InventoryItem -> Product)
SELECT 
    c.first_name AS CustomerName,
    so.order_id AS OrderID,
    so.order_date AS OrderDate,
    p.product_name AS ProductName,
    oi.selling_price AS PriceSold,
    oi.discount_amount AS Discount
FROM customers c
JOIN sales_orders so ON c.customer_id = so.customer_id
JOIN order_items oi ON so.order_id = oi.order_id
JOIN inventory_items ii ON oi.inventory_item_id = ii.inventory_item_id
JOIN products p ON ii.product_id = p.product_id
WHERE c.customer_id = 1 -- Example: Filter for a specific customer
ORDER BY so.order_date DESC;

-- 2. Be aware of Cross Join!
-- A `CROSS JOIN` returns the Cartesian product of the two tables involved. This means every row from the first table is combined with every row from the second table.
-- If `table1` has `N` rows and `table2` has `M` rows, the `CROSS JOIN` result will have `N * M` rows.
-- **Warning:** This usually produces a massive, often meaningless result set unless used intentionally for specific scenarios (like generating all possible combinations of options).
-- Be very careful when using `CROSS JOIN` or the implicit comma-separated syntax in the `FROM` clause without a `WHERE` condition that links the tables (which effectively turns it into an `INNER JOIN`).

-- Explicit CROSS JOIN (Example: Combine first 3 brands and first 3 categories)
SELECT 
	b.brand_name, c.category_name
FROM (SELECT brand_name FROM brands LIMIT 3) b
	CROSS JOIN 
		(SELECT category_name FROM categories 
			WHERE parent_category_id IS NOT NULL LIMIT 3) c;


-- Implicit CROSS JOIN (Avoid this syntax - generates Cartesian product if WHERE is missing/wrong)
-- SELECT c.customer_id, p.product_id FROM customers c, products p LIMIT 100; -- Potentially huge result!




-- 3. UNION / UNION ALL:
-- `UNION` and `UNION ALL` are used to combine the result sets of two or more `SELECT` statements vertically (stacking results on top of each other).
-- UNION Combines the results and automatically removes duplicate rows from the combined set. This involves an implicit sort/hash operation to find duplicates, which can add overhead.
-- UNION ALL Combines the results including *all* duplicate rows. It is generally faster than `UNION` because it doesn't need to check for duplicates.

-- Get a combined list of customer emails and supplier emails (remove duplicates)
SELECT email, "Customer" as source_type FROM customers WHERE email IS NOT NULL
UNION
SELECT contact_email, "Supplier" as source_type FROM suppliers WHERE contact_email IS NOT NULL;

-- Get a combined list including duplicates
SELECT email, "Customer" as source_type FROM customers WHERE email IS NOT NULL
UNION ALL
SELECT contact_email, "Supplier" as source_type FROM suppliers WHERE contact_email IS NOT NULL;





-- 4. SQL Code Order of Execution:
-- FROM/JOIN -> WHERE -> GROUP BY -> Aggregates -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT
/*
Understanding the logical order in which SQL clauses are processed helps in writing correct queries and debugging issues. 
While the database engine might optimize the physical execution, the conceptual order is generally:

1.  `FROM` / `JOIN`: Determines the source tables and how they are joined.
2.  `WHERE`: Filters individual rows based on conditions.
3.  `GROUP BY`: Groups rows based on common values in specified columns.
4.   Aggregate Functions: Calculations performed on each group (e.g., `COUNT`, `SUM`, `AVG`).
5.  `HAVING`: Filters the grouped results based on conditions involving aggregates.
6.   Window Functions: (Advanced topic, not covered in detail here) Perform calculations across sets of table rows related to the current row.
7.  `SELECT`: Selects the final columns (including calculated columns/aliases).
8.  `DISTINCT`: Removes duplicate rows from the result.
9.  `UNION` / `UNION ALL`: Combines results from multiple `SELECT` statements.
10. `ORDER BY`: Sorts the final result set.
11. `LIMIT` / `OFFSET`: Restricts the number of rows returned.

*/


-- 5. Use case of  `CASE WHEN` Statement
-- The `CASE WHEN` statement provides if-then-else logic directly within your SQL query, allowing you to create conditional outputs or calculations.

-- Data Cleaning: Standardize condition names
SELECT 
    inventory_item_id,
    sku,
    CASE 
		WHEN current_condition_id = 1 THEN "New"
        WHEN current_condition_id = 2 THEN "Like New"
        WHEN current_condition_id = 3 THEN "Excellent"
        WHEN current_condition_id = 4 THEN "Good"
        WHEN current_condition_id = 5 THEN "Fair"
        ELSE "Unknown"
    END AS condition_label
FROM inventory_items
LIMIT 10;

-- Analysis: Categorize orders by total amount
SELECT
    order_id,
    total_amount,
    CASE
        WHEN total_amount < 50 THEN "Small"
        WHEN total_amount < 200 THEN "Medium"
        WHEN total_amount >= 200 THEN "Large"
        ELSE "Unknown"
    END AS order_size_category
FROM sales_orders
LIMIT 15;

-- Feature Engineering: Flag orders with discounts
SELECT
    order_id,
    SUM(discount_amount) AS total_discount,
    CASE 
        WHEN SUM(discount_amount) > 0 THEN "Yes"
        ELSE "No"
    END AS has_discount
FROM order_items
GROUP BY order_id
LIMIT 10;

-- Conditional Aggregation: Count orders by status per customer
SELECT
    customer_id,
    COUNT(CASE WHEN order_status = "Delivered" THEN order_id END) AS delivered_count,
    COUNT(CASE WHEN order_status = "Shipped" THEN order_id END) AS shipped_count,
    COUNT(CASE WHEN order_status = "Cancelled" THEN order_id END) AS cancelled_count,
    COUNT(CASE WHEN order_status = "Returned" THEN order_id END) AS returned_count
FROM sales_orders
GROUP BY customer_id
LIMIT 10;



-- 6. Use Case of Views; How to Create Views?
/*
VIEW: A view is a virtual table based on the result set of a stored SQL query.  It doesn't store data itself (usually), but rather presents data from one or more underlying tables in a predefined way.

**Benefits:
    * Implicity: Hides complex query logic (joins, calculations) behind a simple `SELECT * FROM view_name;`.
    * Reusability: Define complex logic once and reuse it in multiple queries. These are used in BI Tools.
    * Security: Can restrict access to specific columns or rows of underlying tables.
    * Consistency: Ensures users access data through a standardized structure.
*/

-- Create a view for product details including brand and category names
CREATE OR REPLACE VIEW view_product_details AS
SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    p.purchase_price,
    p.material,
    p.color,
    p.size
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id;

-- Query the view like a table
SELECT * 
FROM view_product_details
WHERE brand_name = "Chic Threads";

-- Query the view to find average price per brand
SELECT brand_name, AVG(purchase_price) AS avg_price
FROM view_product_details
GROUP BY brand_name
ORDER BY avg_price DESC;

-- Drop the view
-- DROP VIEW IF EXISTS view_product_details;




-- 7. Stored Procedure (Introduction)
/*
Stored Procedure: A stored procedure is a set of SQL statements saved in the database under a specific name, which can be executed by calling that name. 
They can accept input parameters and return output values or result sets.

**Benefits:
    * Reusability & Modularity: Encapsulate complex logic or common tasks.
    * Performance: Often pre-compiled by the database, potentially leading to faster execution than sending individual SQL statements.
    * Security: Can grant users permission to execute a procedure without granting direct access to underlying tables.
    * Reduced Network Traffic: Send one call (`CALL procedure_name()`) instead of multiple SQL statements.

Basic Syntax (Conceptual): 
Creating stored procedures involves specific syntax, including changing the statement delimiter because procedures often contain multiple SQL statements ending with semicolons.
*/

-- Create a simple stored procedure to get orders for a specific customer
DELIMITER //

CREATE PROCEDURE GetCustomerOrders (IN cust_id INT)
BEGIN
    SELECT 
        order_id, 
        order_date, 
        total_amount,
        order_status
    FROM sales_orders
    WHERE customer_id = cust_id
    ORDER BY order_date DESC;
END //

DELIMITER ;

-- Call the stored procedure
CALL GetCustomerOrders(1); -- Get orders for customer_id 1
CALL GetCustomerOrders(3); -- Get orders for customer_id 3

-- Drop the stored procedure
-- DROP PROCEDURE IF EXISTS GetCustomerOrders;

