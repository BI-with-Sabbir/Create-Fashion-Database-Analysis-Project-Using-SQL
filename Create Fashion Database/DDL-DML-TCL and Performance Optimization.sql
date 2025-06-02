-- DDL & DML
-- Use the target database
USE fashion_db;

-- DDL Examples
ALTER TABLE products
ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE customers
DROP COLUMN phone; -- Example of removing a column

-- DML Examples (See Class 2 examples)
-- INSERT INTO ... VALUES ...
-- UPDATE ... SET ... WHERE ...
-- DELETE FROM ... WHERE ...

-- TCL Examples (See Class 2 examples)
-- START TRANSACTION;
-- COMMIT;
-- ROLLBACK;

-- DQL Preview (Basic SELECT to check changes)
SELECT product_id, product_name, last_updated FROM products ORDER BY last_updated DESC LIMIT 5;
SELECT customer_id, first_name, last_name, email FROM customers LIMIT 5;


-- Multi-row INSERT
INSERT INTO conditions (condition_name) VALUES 
("Refurbished"), 
("Open Box");

-- Example: Standardize country names, validate emails, fix date formats
-- Standardizing Country Names
UPDATE suppliers SET country = "United States" WHERE country = "USA";

-- Validating Emails
DELETE FROM suppliers
WHERE contact_email NOT LIKE '%@%.%';

-- Adding a constraint when creating the table
ALTER TABLE suppliers
ADD CONSTRAINT chk_valid_email
CHECK (contact_email LIKE '%@%.%');

INSERT INTO suppliers (supplier_name, supplier_type, contact_email, contact_phone, country, city, registration_date) VALUES
("ABC CORP", "Consignment Partner", "abc_corp@com", "+86-20-555-1234", "China", "Guangzhou", "2022-03-15"),
("AAA CORP", "Consignment Partner", "aaa_corp@yahoo.com", "+86-20-555-1234", "China", "Guangzhou", "2022-03-15");

TRUNCATE suppliers;

-- DROP chk_valid_email;
ALTER TABLE suppliers
DROP CHECK chk_valid_email;

ALTER TABLE suppliers
ADD CONSTRAINT chk_valid_email
CHECK (
    contact_email REGEXP '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'
);

/*
Explanation of the pattern:
^ and $ = start and end of string

[^@\\s]+ = one or more characters that are not @ or whitespace

@ = must have @

Then again: [^@\\s]+ = something between @ and .

Then \\. = literal dot

Then [^@\\s]+ = something after the dot
*/

INSERT INTO suppliers (supplier_name, supplier_type, contact_email, contact_phone, country, city, registration_date) VALUES
("ABC CORP", "Consignment Partner", "abc_corp@.com", "+86-20-555-1234", "China", "Guangzhou", "2022-03-15");


-- Fixing Date Formats (If the registration_date was in string)
-- UPDATE suppliers
-- SET registration_date = STR_TO_DATE(registration_date, '%d-%m-%Y')
-- WHERE registration_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$';

-- If we want to nullify anything that's clearly not a date:
-- UPDATE suppliers
-- SET registration_date = NULL
-- WHERE registration_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';


-- 5. Concepts of Indexing & Partitioning to make a Database Faster

-- Indexing

-- Analyze query performance (Use in MySQL client)
-- Compare EXPLAIN output before and after creating idx_products_product_name

EXPLAIN SELECT * FROM products WHERE product_name = "Urban Runner Sneakers";
/*
Key columns explained:
type: The join type. ref means it uses a non-unique index lookup. If it shows ALL, that means a full table scan, which is slow.

key: The index used. If this shows NULL, then no index is used.

rows: Estimated rows MySQL will scan.

Extra: Any additional info, e.g., Using where, Using index, etc.
*/





-- TCL in Practice - Managing Transactions

-- Ensures Atomicity (All or nothing).
START TRANSACTION; 
-- or 
BEGIN;

-- Perform DML operations (`INSERT`, `UPDATE`, `DELETE`).
COMMIT;

-- Makes all changes within the transaction permanent.
ROLLBACK;
-- Discards all changes made since `START TRANSACTION`.

/*
-- TCL (Transaction Control Language) Example:

START TRANSACTION;

-- Insert order header
INSERT INTO sales_orders (customer_id, total_amount, ...) 
VALUES (5, 159.98, ...);
SET @last_order_id = LAST_INSERT_ID();

-- Insert order items
INSERT INTO order_items (order_id, inventory_item_id, ...) 
VALUES (@last_order_id, 25, ...), (@last_order_id, 30, ...);

-- If everything OK:
COMMIT;

-- If error occurred:
ROLLBACK;

-- Ensures order header and items are added together or not at all.
*/ 



-- Bulk Data Insertion - Why?

-- Inserting thousands/millions of rows one by one or via simple `INSERT ... VALUES` is very slow.
-- Need efficient methods for loading large datasets (e.g., from CSV files, data migrations).
/*
-- Bulk Insertion Methods:
1. LOAD DATA INFILE: Most Efficient Method for Loading from Files; Reads data directly from a file on the server or client; Highly configurable.
2. MySQL Workbench Import Wizard: GUI tool, convenient for manual imports; Uses `LOAD DATA INFILE` or `INSERT` batches behind the scenes.

-- LOAD DATA INFILE` Syntax:
LOAD DATA [LOCAL] INFILE 
/path/to/your/file.csv
INTO TABLE table_name
FIELDS TERMINATED BY 
,
 -- Or 
\t
 for TSV
[OPTIONALLY] ENCLOSED BY 
"
LINES TERMINATED BY 
\n
 -- Or 
\r\n
IGNORE 1 LINES -- Skip header row
(column1, column2, @dummy, column4, ...); -- Map file columns to table columns

*/


/*
-- Indexing - When and Why?
**When to Use:
    *   On columns frequently used in `WHERE` clauses.
    *   On columns used in `JOIN` conditions (FKs are often automatically indexed, but check).
    *   On columns used in `ORDER BY` or `GROUP BY` clauses.

**Trade-offs:
    *   Benefit: Significantly speeds up reads (`SELECT`).
    *   Cost: Slows down writes (`INSERT`, `UPDATE`, `DELETE`) because indexes also need updating.
    *   Takes up disk space.

*** Don't over-index! Analyze query patterns (`EXPLAIN` command).
*/

-- Create an index on product_name for faster lookups
CREATE INDEX idx_products_product_name ON products (product_name);

EXPLAIN SELECT * FROM products WHERE product_name = "Urban Runner Sneakers";

-- Create a composite index on orders for customer and date lookups
CREATE INDEX idx_sales_orders_customer_date ON sales_orders (customer_id, order_date);

-- View existing indexes on a table
SHOW INDEX FROM products;

-- Drop an index
DROP INDEX idx_products_product_name ON products;





/* 
Performance Optimization: Partitioning (Concept)

-- What is Partitioning? 
Dividing a very large table into smaller, more manageable pieces (partitions) based on column values (e.g., by date range, region).
The table still appears as a single logical table to queries.

**Benefits:
    *  Improved Query Performance: Queries can sometimes scan only relevant partitions instead of the whole table (Partition Pruning).
    *  Easier Maintenance: Operations like backups or data deletion can target specific partitions.

*** Partitioning Requires Careful Planning.

-- Example: Partitioning sales_orders by year of order_date
-- NOTE: Partitioning changes table structure significantly. Apply to empty table or use ALTER.

ALTER TABLE sales_orders PARTITION BY RANGE ( YEAR(order_date) ) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- View partitioning information

SELECT PARTITION_NAME, TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_SCHEMA = "fashion_db" AND TABLE_NAME = "sales_orders";

*/
