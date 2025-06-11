# Fashion_DataBase Create SQL Project Documentation

This project demonstrates comprehensive SQL operations on a retail fashion database (`fashion_db`). The objective is to showcase real-world usage of SQL including DDL, DML, DQL, TCL, Indexing, Partitioning, and Bulk Data Loading to optimize database performance and integrity.

## Create a Database name 'fashion_db'
## Click here to see Sql Script: [create_fashion_database_and_tables.sql](https://github.com/BI-with-Sabbir/Create-Fashion-Database-Analysis-Project-Using-SQL/blob/main/Create%20Fashion%20Database/create_fashion_database_and_tables.sql)

## 📁 Project Structure

* **DDL Operations**: Altering table structure, adding/removing columns, and adding constraints.
* **DML Operations**: Insert, Update, Delete operations including data validation and cleaning.
* **TCL Transactions**: Using transaction blocks to ensure atomicity and data consistency.
* **DQL Queries**: Basic `SELECT` queries for data inspection.
* **Performance Optimization**:

  * Indexing: Create, analyze, and drop indexes to optimize queries.
  * Partitioning: Improve performance and maintainability of large tables.

* ** Data Insertion**: Using [sample_data.sql](https://github.com/BI-with-Sabbir/Create-Fashion-Database-Analysis-Project-Using-SQL/blob/main/Create%20Fashion%20Database/sample_data.sql) Data for efficient Analysis.

---

## 🛠️ SQL Concepts Demonstrated
## Click Here to see: [DDL-DML-TCL and Performance Optimization.sql](https://github.com/BI-with-Sabbir/Create-Fashion-Database-Analysis-Project-Using-SQL/blob/main/Create%20Fashion%20Database/DDL-DML-TCL%20and%20Performance%20Optimization.sql)

### 🔧 DDL - Data Definition Language

```sql
ALTER TABLE products
ADD COLUMN last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

ALTER TABLE customers
DROP COLUMN phone;
```

### ✏️ DML - Data Manipulation Language

```sql
-- Multi-row insert
INSERT INTO conditions (condition_name) VALUES ("Refurbished"), ("Open Box");

-- Standardize country name
UPDATE suppliers SET country = "United States" WHERE country = "USA";

-- Delete invalid emails
DELETE FROM suppliers WHERE contact_email NOT LIKE '%@%.%';
```

### 🔐 Constraints & Validation

```sql
ALTER TABLE suppliers ADD CONSTRAINT chk_valid_email CHECK (
    contact_email REGEXP '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$'
);
```

### 🔄 TCL - Transaction Control Language

```sql
START TRANSACTION;
INSERT INTO sales_orders (...);
COMMIT;
ROLLBACK;
```

### 🔎 DQL - Querying for Validation

```sql
SELECT product_id, product_name, last_updated FROM products ORDER BY last_updated DESC LIMIT 5;
```

### ⚙️ Indexing

```sql
CREATE INDEX idx_products_product_name ON products (product_name);
EXPLAIN SELECT * FROM products WHERE product_name = "Urban Runner Sneakers";
DROP INDEX idx_products_product_name ON products;
```

### 📊 Partitioning

```sql
ALTER TABLE sales_orders PARTITION BY RANGE ( YEAR(order_date) ) (
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025),
    PARTITION p_future VALUES LESS THAN MAXVALUE
);
```

### 📥 Bulk Data Insertion

```sql
LOAD DATA INFILE '/path/to/file.csv'
INTO TABLE table_name
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
```

---

## 💡 Key Learnings

* Proper data validation using regex patterns.
* Safe operations using transactions.
* Real-world indexing and performance analysis using `EXPLAIN`.
* Partitioning strategy for managing historical data.
* Efficient handling of large datasets using bulk insertion.

---

## 🧠 Future Improvements

* Automate data integrity checks via triggers.
* Introduce stored procedures for repetitive business logic.
* Integrate with BI tools like Power BI or Tableau for visualization.

---


## 🏷️ Tags

`SQL` `DDL` `DML` `TCL` `DQL` `Indexing` `Partitioning` `ETL` `Data Cleaning` `Performance Optimization`

