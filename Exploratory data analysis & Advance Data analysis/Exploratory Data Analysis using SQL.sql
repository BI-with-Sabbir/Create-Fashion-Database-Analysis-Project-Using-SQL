/*
-- Exploratory Data Analysis using SQL:
Now that we understand how to define database structures and insert data, we arrive at the core skill for any data analyst or scientist using SQL: Querying Data for Exploration and Analysis. 
This SQL Script focuses on the `SELECT` statement and its various clauses (`WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`, `LIMIT`) to Retrieve, Filter, Aggregate, and Organize Data. 
We will also explore essential Built-in Functions for Manipulating Strings, Dates, and Numbers, and Handling NULL values effectively.
*/
-- Topics: 
-- SELECT, FROM, WHERE, LIKE, IN, DISTINCT, BETWEEN, GROUP BY, ORDER BY, LIMIT, OFFSET, ALIAS
-- Aggregate Functions: COUNT, DISTINCT COUNT, SUM, AVG, MIN, MAX, 
-- WHERE vs HAVING 
-- Built-in Functions: EXTRACT, DATE_PART, TO_DATE, TO_CHAR, STR_TO_DATE, CAST, SUBSTRING, POSITION, COALESCE, NULLIF

-- Use the target database
USE fashion_db;

-- 1. Basic Queries

-- SELECT: The `SELECT` statement is used to retrieve data from one or more tables.
-- SELECT all columns
SELECT * FROM customers LIMIT 5;

-- SELECT specific columns with ALIAS
SELECT 
    product_name AS 'Product Name',
    purchase_price AS 'Cost Price'
FROM
    products
LIMIT 10;

/*
Filtering Data: `WHERE` Clause

The `WHERE` clause is used to filter rows based on specified conditions, retrieving only the records that match.

**Comparison Operators: Used to compare column values.
    *   `=`: Equal to
    *   `>`: Greater than
    *   `<`: Less than
    *   `>=`: Greater than or equal to
    *   `<=`: Less than or equal to
    *   `!=` or `<>`: Not equal to
*/

SELECT 
    customer_id, first_name, registration_date, email
FROM
    customers
WHERE
    registration_date >= '2023-04-01'
        AND email LIKE '%.com';

-- WHERE with BETWEEN
SELECT 
    order_id, order_date, total_amount
FROM
    sales_orders
WHERE
    total_amount BETWEEN 100.00 AND 200.00;

-- WHERE with IN: Checks if a value matches any value in a list.

-- SELECT * FROM PRODUCTS;
-- SELECT * FROM CATEGORIES;

SELECT 
    product_id, product_name, category_id
FROM
    products
WHERE
    category_id IN (5 , 6, 10); -- Womenswear, Menswear, Dresses



-- WHERE with LIKE: Performs pattern matching in strings.
-- `%`: Matches any sequence of zero or more characters.
-- `_`: Matches any single character.

-- Note: By default, `LIKE` in MySQL is case-insensitive for non-binary strings unless collation specifies otherwise.

SELECT 
    product_id, product_name
FROM
    products
WHERE
    product_name LIKE '%Belt%';

-- WHERE with IS NULL: Checks if a column value is NULL (missing or undefined).
SELECT 
    customer_id, first_name, last_name
FROM
    customers
WHERE
    last_login_date IS NULL;

-- DISTINCT: Removing Duplicates; Provide Unique Values
SELECT DISTINCT country FROM suppliers;


-- ORDER BY (single and multiple columns): Sorts the result set based on one or more columns.
SELECT 
    product_name, purchase_price
FROM
    products
ORDER BY purchase_price DESC
LIMIT 10;

SELECT 
    category_id, brand_id, product_name
FROM
    products
ORDER BY category_id ASC , brand_id DESC;



-- LIMIT and OFFSET for pagination
-- LIMIT: Restricts the output to the first `n` rows after sorting (if `ORDER BY` is used).
-- OFFSET: Skips the first `m` rows. Often used with `LIMIT` for pagination (retrieving results in pages).
-- Get records 21-30 (page 3 if page size is 10)
SELECT 
    customer_id, first_name, registration_date
FROM
    customers
ORDER BY registration_date
LIMIT 3 OFFSET 5;



-- 2. Aggregate Functions

-- COUNT
SELECT 
    COUNT(*) AS total_customers
FROM
    customers;

SELECT 
    COUNT(DISTINCT country) AS num_supplier_countries
FROM
    suppliers;

SELECT 
    category_id, COUNT(*) AS products_per_category
FROM
    products
GROUP BY category_id;

-- SUM
SELECT 
    SUM(total_amount) AS total_revenue
FROM
    sales_orders;

-- GROUP BY: The `GROUP BY` clause groups rows that have the same values in one or more columns into a summary row. It is almost always used in conjunction with aggregate functions.
-- The power comes when you apply aggregate functions to each group.
SELECT 
    customer_id, SUM(total_amount) AS customer_spending
FROM
    sales_orders
GROUP BY customer_id;

-- AVG
SELECT 
    AVG(purchase_price) AS avg_product_cost
FROM
    products;

SELECT 
    category_id, AVG(purchase_price) AS avg_category_cost
FROM
    products
GROUP BY category_id;

-- MIN
SELECT 
    MIN(registration_date) AS first_customer_reg_date
FROM
    customers;

-- MAX
SELECT 
    MAX(total_amount) AS highest_order_value
FROM
    sales_orders;

/*
3. Difference between WHERE and HAVING Clause:
While `WHERE` filters rows before they are grouped and aggregated, `HAVING` filters groups after the aggregation has occurred. 
You use `HAVING` to apply conditions to the results of aggregate functions.

*   `WHERE` operates on individual rows.
*   `HAVING` operates on the grouped results produced by `GROUP BY` and aggregate functions.
*   `WHERE` is processed before `GROUP BY`.
*   `HAVING` is processed after `GROUP BY`.
*/

-- Find customers who placed orders after 2023-06-01 AND have spent more than $500 in total
SELECT 
    customer_id,
    SUM(total_amount) AS total_spent,
    COUNT(order_id) AS num_orders
FROM
    sales_orders
WHERE
    order_date > '2023-06-01'
GROUP BY customer_id
HAVING SUM(total_amount) > 500.00; -- Filters groups AFTER aggregation




-- 4. Built-in Functions for Data Manipulation & Analysis

-- Date/Time Functions (MySQL Equivalents)
-- EXTRACT / DATE_PART -> YEAR(), MONTH(), DAY(), HOUR(), EXTRACT()

SELECT 
    order_date,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month
FROM
    sales_orders
LIMIT 5;


SELECT 
    order_date,
    EXTRACT(QUARTER FROM order_date) AS order_quarter
FROM
    sales_orders
LIMIT 5;



/*
String Functions (MySQL):
    *   `CONCAT(str1, str2, ...)`: Concatenates strings.
    *   `CONCAT_WS(separator, str1, str2, ...)`: Concatenates with a separator.
    *   `LENGTH(str)`: Returns the length of the string in bytes.
    *   `CHAR_LENGTH(str)`: Returns the length of the string in characters.
    *   `SUBSTRING(str, start_position, length)` (or `SUBSTR`): Extracts a substring.
    *   `LOCATE(substring, string, [start_position])`: Finds the starting position of a substring (case-insensitive by default).
    *   `POSITION(substring IN string)`: Standard SQL equivalent of `LOCATE`.
    *   `REPLACE(string, from_string, to_string)`: Replaces occurrences of a substring.
    *   `UPPER(str)`, `LOWER(str)`: Converts string to upper/lower case.
    *   `TRIM([BOTH|LEADING|TRAILING] [remstr] FROM str)`: Removes leading/trailing spaces or specified characters.
*/

-- TO_CHAR -> DATE_FORMAT()
SELECT 
    order_date,
    DATE_FORMAT(order_date, '%Y/%m/%d %H:%i') AS formatted_date
FROM
    sales_orders
LIMIT 5;

-- TO_DATE -> STR_TO_DATE()
SELECT STR_TO_DATE("2024-May-24", "%Y-%b-%d") as Date;


-- CASTING: Converting data from one type to another.
SELECT 
    purchase_price,
    CAST(purchase_price AS SIGNED) AS price_integer
FROM
    products
LIMIT 5;

SELECT 
    order_id,
    CONCAT('Order #', CAST(order_id AS CHAR)) AS order_label
FROM
    sales_orders
LIMIT 5;

-- SUBSTRING
SELECT 
    product_name, SUBSTRING(product_name, 1, 10) AS name_start
FROM
    products
LIMIT 5;

-- POSITION / LOCATE
SELECT 
    email, LOCATE('@', email) AS at_position
FROM
    customers
LIMIT 5;
-- SELECT email, POSITION("@" IN email) AS at_position FROM customers LIMIT 5; -- Standard SQL



-- COALESCE / IFNULL: Returns the first non-NULL value in the list. Useful for providing default values.

SELECT 
    product_id,
    acquisition_notes,
    COALESCE(acquisition_notes, 'No notes provided') AS notes_display
FROM
    products
LIMIT 10;


SELECT 
    product_id,
    acquisition_notes,
    IFNULL(acquisition_notes, 'No notes provided') AS notes_display_ifnull
FROM
    products
LIMIT 10;


-- NULLIF: Useful for preventing division by zero or handling specific values as NULL.

-- Example: Calculate discount percentage, avoid division by zero if selling_price is 0
SELECT 
    order_item_id,
    selling_price,
    discount_amount,
    (discount_amount * 100 / NULLIF(selling_price, 0)) AS discount_percentage
FROM
    order_items
LIMIT 10;



-- Mastering these DQL commands and functions is fundamental for any data exploration task. Practice applying them to the fashion database to answer various analytical questions.