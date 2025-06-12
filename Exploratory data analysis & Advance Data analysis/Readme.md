# 🧠 Intermediate SQL Project with Exploratory Data Analysis (EDA) and Query Optimization

## 📘 Project Title: FashionDB SQL Practice – Joins, Union, Case, Views & Procedures with EDA

---

## 📌 Overview

This project is a structured intermediate-level SQL exercise designed around a sample relational database named `fashion_db`. It includes hands-on **Exploratory Data Analysis (EDA)** and **intermediate SQL query techniques** such as:

* Complex JOINs
* UNION / UNION ALL
* CASE WHEN logic
* VIEWS for abstraction
* Stored Procedures for reusable SQL logic

This project aims to mimic real-world analytical scenarios from a retail/e-commerce dataset.

---

## 🗂️ Table of Contents

* [📂 About the Dataset](#-about-the-dataset)
* [🔍 Exploratory Data Analysis (EDA)](#-exploratory-data-analysis-eda)
* [🛠️ Intermediate SQL Techniques](#️-intermediate-sql-techniques)
* [❓ Key Questions Answered](#-key-questions-answered)
* [📌 Code Samples](#-code-samples)
* [📈 Insights Summary](#-insights-summary)
* [🏁 How to Run](#-how-to-run)
* [📄 License](#-license)

---

## 📂 About the Dataset

**Database Name:** `fashion_db`

**Main Tables Used:**

* `customers`
* `sales_orders`
* `order_items`
* `products`
* `inventory_items`
* `categories`
* `brands`
* `suppliers`

---

## 🔍 Exploratory Data Analysis (EDA)
[CLICK HERE To See EDA](https://github.com/BI-with-Sabbir/Create-Fashion-Database-Analysis-Project-Using-SQL/blob/main/Exploratory%20data%20analysis%20%26%20Advance%20Data%20analysis/Output%20of%20Exploratory%20data%20Analysis%20Fashion%20Data%20base.pdf)


EDA is performed to understand the shape, distribution, and key characteristics of the dataset.

### 🔢 Descriptive Statistics

```sql
-- Number of customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Number of orders by status
SELECT status, COUNT(*) FROM sales_orders GROUP BY status;

-- Most popular product categories
SELECT c.category_name, COUNT(*) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_orders DESC;
```

### 📊 Distribution Patterns

* Order status distribution (Completed, Canceled)
* Sales per brand
* Average order value
* Top 10 products by volume
* Monthly sales trend (using `order_date`)

### 🧹 Data Cleaning & Missing Checks

* Handled NULLs in `supplier_id`
* Replaced missing product descriptions with 'No Description'

---

## 🛠️ Intermediate SQL Techniques
[Click here to Out Analysis Intermediate SQL](https://github.com/BI-with-Sabbir/Create-Fashion-Database-Analysis-Project-Using-SQL/blob/main/Exploratory%20data%20analysis%20%26%20Advance%20Data%20analysis/Intermediate%20SQL.pdf)

### 🔗 1. JOINs

Used to combine relational tables.

```sql
SELECT c.first_name, so.order_id, oi.quantity, p.product_name
FROM customers c
JOIN sales_orders so ON c.customer_id = so.customer_id
JOIN order_items oi ON so.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;
```

### 🔄 2. UNION / UNION ALL

Used to combine vertical results.

```sql
SELECT first_name, email FROM customers
UNION ALL
SELECT supplier_name, contact_email FROM suppliers;
```

### 🎯 3. CASE WHEN

Used for creating dynamic, derived columns.

```sql
SELECT order_id, total_amount,
  CASE
    WHEN total_amount < 50 THEN 'Low'
    WHEN total_amount BETWEEN 50 AND 200 THEN 'Medium'
    ELSE 'High'
  END AS order_segment
FROM sales_orders;
```

### 🧠 4. Views

```sql
CREATE VIEW view_top_products AS
SELECT p.product_name, COUNT(*) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;
```

### ⚙️ 5. Stored Procedures

```sql
DELIMITER $$
CREATE PROCEDURE get_customer_orders(IN cust_id INT)
BEGIN
    SELECT * FROM sales_orders
    WHERE customer_id = cust_id;
END$$
DELIMITER ;
```

---

## ❓ Key Questions Answered

* Who are the top 5 customers by total spending?
* Which categories have the most sales?
* How many customers have never placed an order?
* Which products are out of stock?
* Which suppliers provide the most products?
* What is the monthly trend of completed orders?

---

## 📌 Code Samples

```sql
-- Customers with no orders
SELECT c.customer_id, c.first_name
FROM customers c
LEFT JOIN sales_orders so ON c.customer_id = so.customer_id
WHERE so.order_id IS NULL;
```

```sql
-- Average order amount by category
SELECT cat.category_name, AVG(oi.list_price * oi.quantity) AS avg_order_value
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name;
```

---

## 📈 Insights Summary

* Around **23%** of customers have never placed an order.
* The **'Streetwear'** category is the top-selling category.
* Most orders fall into the **'Medium'** value segment (50–200 range).
* Brand **'Trendster'** and supplier **'GlobalTex'** are key revenue contributors.
* The number of **completed orders peaks in November**, likely due to seasonal promotions.

---

## 🏁 How to Run

1. Clone the repository

```bash
git clone https://github.com/your-username/intermediate-sql-fashiondb.git
cd intermediate-sql-fashiondb
```

2. Import the `fashion_db` into your local SQL database (MySQL/PostgreSQL).
3. Run the SQL script `fashion_sql_analysis.sql` in your SQL IDE section by section.
4. Optional: Integrate views into Power BI or Tableau for dashboard creation.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

> ✅ **Contributors:** Feel free to fork this repo, suggest improvements, or extend the analysis with CTEs, window functions, or optimization techniques!


