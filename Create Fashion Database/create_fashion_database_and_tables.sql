-- SQL Script for Creating a Database and it's Tables for Second-Hand Luxury Fashion Retail Database

DROP DATABASE IF EXISTS FASHION_DB;
CREATE DATABASE IF NOT EXISTS FASHION_DB; 

-- We need to define/select the Database for ease of Querying
USE FASHION_DB; 

-- suppliers table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    supplier_type ENUM("Individual", "Consignment Partner", "Business") NOT NULL,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    country VARCHAR(50) NOT NULL, -- Sourcing Country
    city VARCHAR(50),
    registration_date DATE NOT NULL
);

-- brands table
CREATE TABLE brands (
    brand_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_name VARCHAR(50) NOT NULL UNIQUE,
    country_of_origin VARCHAR(50)
);

-- categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    parent_category_id INT, -- For hierarchical categories (e.g., Bags > Handbags)
    FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

-- conditions table
CREATE TABLE conditions (
    condition_id INT PRIMARY KEY AUTO_INCREMENT,
    condition_name VARCHAR(30) NOT NULL UNIQUE, -- e.g., Pristine, Excellent, Very Good, Good, Fair
    description TEXT
);

-- products table (Captures details at the time of acquisition)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    supplier_id INT NOT NULL,
    purchase_date DATE NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    product_name VARCHAR(150) NOT NULL, -- e.g., "Chanel Classic Flap Bag Medium Black Caviar SHW"
    description TEXT,
    material VARCHAR(50),
    color VARCHAR(30),
    size VARCHAR(30),
    serial_number VARCHAR(50) UNIQUE, -- Can be NULL if not applicable/available
    initial_condition_id INT NOT NULL,
    acquisition_notes TEXT,
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (initial_condition_id) REFERENCES conditions(condition_id)
);

-- authentication_log table
CREATE TABLE authentication_log (
    auth_log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    auth_date DATE NOT NULL,
    authenticator_name VARCHAR(100),
    auth_status ENUM("Pending", "Authenticated", "Counterfeit", "Unable to Verify") NOT NULL,
    auth_cost DECIMAL(8, 2) DEFAULT 0,
    notes TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- inventory_items table (Tracks the lifecycle of a product after acquisition)
CREATE TABLE inventory_items (
    inventory_item_id INT PRIMARY KEY AUTO_INCREMENT, -- Unique ID for the inventory record
    product_id INT NOT NULL, -- Foreign key to products, NOT UNIQUE here
    sku VARCHAR(50) UNIQUE NOT NULL, -- Unique Stock Keeping Unit
    date_received DATE NOT NULL, -- Date item physically received/processed
    current_condition_id INT NOT NULL,
    listing_price DECIMAL(10, 2),
    date_listed DATE,
    status ENUM("Processing", "In Stock", "Reserved", "Sold", "Returned", "Withdrawn") NOT NULL DEFAULT "Processing",
    location VARCHAR(50), -- e.g., Warehouse A, Photography, Repair
    last_status_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (current_condition_id) REFERENCES conditions(condition_id)
);

-- customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    registration_date DATE NOT NULL,
    last_login_date TIMESTAMP
);

-- sales_orders table
CREATE TABLE sales_orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL,
    shipping_address TEXT NOT NULL,
    billing_address TEXT,
    shipping_cost DECIMAL(8, 2) DEFAULT 0,
    order_status ENUM("Pending Payment", "Processing", "Shipped", "Delivered", "Cancelled", "Returned") NOT NULL,
    tracking_number VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- order_items table (Links orders to specific inventory items)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    inventory_item_id INT NOT NULL UNIQUE, -- An inventory item can only be sold once
    selling_price DECIMAL(10, 2) NOT NULL, -- Price at the time of sale
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    FOREIGN KEY (order_id) REFERENCES sales_orders(order_id),
    FOREIGN KEY (inventory_item_id) REFERENCES inventory_items(inventory_item_id)
);

-- Add indexes for performance on frequently queried columns
CREATE INDEX idx_product_brand ON products(brand_id);
CREATE INDEX idx_product_category ON products(category_id);
CREATE INDEX idx_product_supplier ON products(supplier_id);
CREATE INDEX idx_inventory_status ON inventory_items(status);
CREATE INDEX idx_inventory_date_listed ON inventory_items(date_listed);
CREATE INDEX idx_order_customer ON sales_orders(customer_id);
CREATE INDEX idx_order_date ON sales_orders(order_date);
CREATE INDEX idx_order_status ON sales_orders(order_status);

