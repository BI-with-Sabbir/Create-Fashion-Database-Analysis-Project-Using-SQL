-- Sample Data Generation for Fashion Retail Database
-- Order of insertion respects foreign key constraints.

-- Use the target database
USE fashion_db;

-- 1. Conditions
INSERT INTO conditions (condition_name, description) VALUES
("New", "Brand new item with tags."),
("Like New", "Item appears new, may lack original tags."),
("Excellent", "Item shows minimal signs of wear."),
("Good", "Item shows moderate signs of wear."),
("Fair", "Item shows significant signs of wear but is functional.");

-- 2. Categories (with hierarchy)
INSERT INTO categories (category_name, parent_category_id) VALUES
("Clothing", NULL),
("Shoes", NULL),
("Accessories", NULL),
("Bags", NULL),
("Menswear", 1),
("Womenswear", 1),
("Outerwear", 1),
("Tops", 1),
("Bottoms", 1),
("Dresses", 6),
("Mens Outerwear", 7),
("Womens Outerwear", 7),
("Mens Tops", 8),
("Womens Tops", 8),
("Mens Bottoms", 9),
("Womens Bottoms", 9),
("Sneakers", 2),
("Boots", 2),
("Sandals", 2),
("Formal Shoes", 2),
("Handbags", 4),
("Backpacks", 4),
("Wallets", 3),
("Belts", 3),
("Scarves", 3);

-- 3. Brands
INSERT INTO brands (brand_name, country_of_origin) VALUES
("Chic Threads", "Italy"),
("Urban Edge", "USA"),
("EcoWear", "Canada"),
("Nordic Style", "Sweden"),
("Tokyo Street", "Japan"),
("Parisian Flair", "France"),
("London Look", "UK"),
("Berlin Basics", "Germany"),
("Aussie Vibes", "Australia"),
("Seoul Select", "South Korea");

-- 4. Suppliers
INSERT INTO suppliers (supplier_name, supplier_type, contact_email, contact_phone, country, city, registration_date) VALUES
("Fabricorp", "Consignment Partner", "sales@fabricorp.com", "+86-20-555-1234", "China", "Guangzhou", "2022-03-15"),
("Leather Lux", "Individual", "contact@leatherlux.it", "+39-055-555-5678", "Italy", "Florence", "2022-04-01"),
("EcoTextiles Inc.", "Consignment Partner", "info@ecotextiles.ca", "+1-604-555-9876", "Canada", "Vancouver", "2022-05-10"),
("Global Garments", "Individual", "orders@globalgarments.com", "+44-20-555-1122", "UK", "London", "2022-06-20"),
("Accessory World", "Consignment Partner", "support@accessoryworld.de", "+49-30-555-3344", "Germany", "Berlin", "2022-07-01"),
("Footwear Fusion", "Consignment Partner", "footwear@fusion.jp", "+81-3-5555-6677", "Japan", "Tokyo", "2022-08-15"),
("Style Source", "Business", "style@source.us", "+1-212-555-8899", "USA", "New York", "2022-09-05"),
("DownUnder Designs", "Consignment Partner", "hello@dudesigns.au", "+61-2-5555-1010", "Australia", "Sydney", "2022-10-11"),
("Korean Chic Ltd.", "Business", "sales@koreanchic.kr", "+82-2-555-2020", "South Korea", "Seoul", "2022-11-22"),
("French Fashion House", "Consignment Partner", "contact@ffhouse.fr", "+33-1-5555-3030", "France", "Paris", "2022-12-01");

-- 5. Customers
-- Using placeholder generation logic for brevity. A script would generate more varied data.
INSERT INTO customers (first_name, last_name, email, phone, registration_date, last_login_date) VALUES
("Alice", "Smith", "alice.s@example.com", "555-0101", "2023-01-10", "2024-05-20 10:00:00"),
("Bob", "Johnson", "bob.j@example.com", "555-0102", "2023-01-15", "2024-05-15 14:30:00"),
("Charlie", "Williams", "charlie.w@example.com", "555-0103", "2023-02-01", "2024-05-22 09:15:00"),
("Diana", "Brown", "diana.b@example.com", NULL, "2023-02-05", "2024-04-10 11:00:00"),
("Ethan", "Jones", "ethan.j@example.com", "555-0105", "2023-03-10", NULL), -- Never logged in
("Fiona", "Garcia", "fiona.g@example.com", "555-0106", "2023-03-12", "2024-05-01 16:45:00"),
("George", "Miller", "george.m@example.com", "555-0107", "2023-04-01", "2024-05-23 11:30:00"),
("Hannah", "Davis", "hannah.d@example.com", "555-0108", "2023-04-20", "2024-03-28 19:00:00"),
("Ian", "Rodriguez", "ian.r@example.com", NULL, "2023-05-05", "2024-05-18 08:00:00"),
("Julia", "Martinez", "julia.m@example.com", "555-0110", "2023-05-15", "2024-05-24 12:00:00"); 
-- ... (Add ~140 more customer records with varied dates)

-- 6. Products
-- Needs brand_id, category_id, supplier_id, initial_condition_id
INSERT INTO products (brand_id, category_id, supplier_id, purchase_date, purchase_price, product_name, description, material, color, size, serial_number, initial_condition_id, acquisition_notes) VALUES
(1, 14, 2, "2023-06-01", 85.50, "Silk Blend Blouse", "Elegant silk blend blouse with button front.", "Silk Blend", "Cream", "M", NULL, 1, "Part of Summer Collection order"),
(2, 17, 7, "2023-06-05", 120.00, "Urban Runner Sneakers", "Lightweight running sneakers for city life.", "Mesh/Synthetic", "Black/White", "10", "URS10BLKWH", 1, NULL),
(3, 15, 3, "2023-06-10", 65.00, "Organic Cotton Jeans", "Classic straight-leg jeans made from organic cotton.", "Organic Cotton", "Indigo", "32/32", NULL, 1, "First batch from EcoTextiles"),
(4, 11, 4, "2023-07-01", 250.00, "Nordic Wool Peacoat", "Heavy wool peacoat for cold winters.", "Wool", "Navy", "L", "NWPNAVYL", 1, NULL),
(5, 13, 6, "2023-07-15", 45.00, "Tokyo Graphic Tee", "Cotton t-shirt with unique Tokyo-inspired graphic.", "Cotton", "White", "M", NULL, 1, NULL),
(6, 10, 10, "2023-08-01", 180.00, "Parisian Midi Dress", "Flowy midi dress with floral print.", "Viscose", "Floral Print", "S", NULL, 1, "Imported for event"),
(7, 24, 5, "2023-08-10", 35.00, "London Plaid Belt", "Classic plaid pattern woven belt.", "Fabric/Leather", "Red Plaid", "OS", NULL, 1, NULL),
(8, 23, 5, "2023-09-01", 25.00, "Berlin Cashmere Wallet", "Minimalist wallet made from soft cashmere blend.", "Cashmere Blend", "Grey", "N/A", "BCWGREY", 1, NULL),
(9, 18, 8, "2023-09-15", 95.00, "Aussie Outback Boots", "Durable leather boots for outdoor adventures.", "Leather", "Tan", "9", NULL, 1, NULL),
(10, 21, 9, "2023-10-01", 220.00, "Seoul Leather Handbag", "Structured leather handbag with gold hardware.", "Leather", "Black", "Medium", "SLHBLKMED", 1, "Premium Line");

-- 7. Inventory Items
-- Needs product_id, current_condition_id. Assume multiple items per product possible.
-- status ENUM("Processing", "In Stock", "Reserved", "Sold", "Returned", "Withdrawn")
INSERT INTO inventory_items (product_id, sku, date_received, current_condition_id, listing_price, date_listed, status, location, last_status_update) VALUES
(1, "SKU001", "2023-06-02", 1, 149.99, "2023-06-05", "In Stock", "A1-01", NOW()),
(1, "SKU002", "2023-06-02", 1, 149.99, "2023-06-05", "In Stock", "A1-02", NOW()),
(2, "SKU003", "2023-06-06", 1, 179.99, "2023-06-10", "In Stock", "S2-05", NOW()),
(3, "SKU004", "2023-06-11", 1, 89.99, "2023-06-15", "In Stock", "B3-10", NOW()),
(3, "SKU005", "2023-06-11", 2, 79.99, "2023-06-15", "In Stock", "B3-11", NOW()), -- Like New condition
(4, "SKU006", "2023-07-02", 1, 399.99, "2023-07-05", "In Stock", "C1-01", NOW()),
(5, "SKU007", "2023-07-16", 1, 59.99, "2023-07-20", "In Stock", "T5-01", NOW()),
(6, "SKU008", "2023-08-02", 1, 249.99, "2023-08-05", "In Stock", "D4-03", NOW()),
(7, "SKU009", "2023-08-11", 1, 49.99, "2023-08-15", "In Stock", "X1-15", NOW()),
(8, "SKU010", "2023-09-02", 1, 39.99, "2023-09-05", "In Stock", "X1-16", NOW()),
(9, "SKU011", "2023-09-16", 1, 159.99, "2023-09-20", "In Stock", "S3-08", NOW()),
(10, "SKU012", "2023-10-02", 1, 299.99, "2023-10-05", "In Stock", "H2-04", NOW());

-- 8. Sales Orders
-- Needs customer_id. Dates should span ~1-2 years for cohort analysis.
INSERT INTO sales_orders (customer_id, order_date, total_amount, shipping_address, billing_address, shipping_cost, order_status, tracking_number) VALUES
(1, "2023-06-15 10:30:00", 149.99, "123 Main St, Anytown", "123 Main St, Anytown", 9.99, "Delivered", "TRK111222333"),
(2, "2023-06-20 14:00:00", 89.99, "456 Oak Ave, Otherville", "456 Oak Ave, Otherville", 7.99, "Delivered", "TRK444555666"),
(1, "2023-07-05 09:00:00", 59.99, "123 Main St, Anytown", "123 Main St, Anytown", 5.99, "Delivered", "TRK777888999"),
(3, "2023-07-10 11:45:00", 179.99, "789 Pine Ln, Somewhere", "789 Pine Ln, Somewhere", 9.99, "Shipped", "TRK101112131"),
(4, "2023-08-01 16:20:00", 399.99, "101 Maple Dr, New City", "101 Maple Dr, New City", 14.99, "Processing", NULL),
(2, "2023-08-15 10:00:00", 49.99, "456 Oak Ave, Otherville", "456 Oak Ave, Otherville", 5.99, "Delivered", "TRK141516171"),
(5, "2023-09-05 13:00:00", 249.99, "222 Birch Rd, Old Town", "222 Birch Rd, Old Town", 12.99, "Delivered", "TRK181920212"),
(1, "2023-10-10 15:00:00", 299.99, "123 Main St, Anytown", "123 Main St, Anytown", 12.99, "Delivered", "TRK222324252"),
(6, "2023-11-01 18:00:00", 159.99, "333 Cedar Ct, Next Town", "333 Cedar Ct, Next Town", 9.99, "Cancelled", NULL),
(7, "2023-11-15 12:10:00", 39.99, "444 Willow Way, Faraway", "444 Willow Way, Faraway", 4.99, "Delivered", "TRK262728293");

-- 9. Order Items
-- Needs order_id, inventory_item_id. Ensure inventory_item_id is unique.
-- Match total_amount in sales_orders roughly.
INSERT INTO order_items (order_id, inventory_item_id, selling_price, discount_amount) VALUES
(1, 1, 149.99, 0.00),
(2, 4, 89.99, 0.00),
(3, 7, 59.99, 0.00),
(4, 3, 179.99, 0.00),
(5, 6, 399.99, 0.00),
(6, 9, 49.99, 0.00),
(7, 8, 249.99, 0.00),
(8, 12, 299.99, 0.00),
-- Order 9 was cancelled, no items needed or link items then update inventory status
(10, 10, 39.99, 0.00);
-- Add more items, potentially multiple per order
-- Example: Order 11 has two items
-- INSERT INTO sales_orders ... (order_id 11, total_amount = 239.98) ...
-- INSERT INTO order_items (order_id, inventory_item_id, selling_price, discount_amount) VALUES (11, 2, 149.99, 0.00); 
-- INSERT INTO order_items (order_id, inventory_item_id, selling_price, discount_amount) VALUES (11, 5, 89.99, 0.00); 
-- Remember to update inventory_items.status to 'Sold' for items included here.

UPDATE inventory_items SET status = 'Sold', last_status_update = NOW() WHERE inventory_item_id IN (1, 4, 7, 3, 6, 9, 8, 12, 10); -- Add IDs from other generated items

-- 10. Authentication Log
-- auth_status ENUM("Pending", "Authenticated", "Counterfeit", "Unable to Verify")
-- Needs product_id
INSERT INTO authentication_log (product_id, auth_date, authenticator_name, auth_status, auth_cost, notes) VALUES
(2, "2023-06-07", "AuthentiCheck Pro", "Authenticated", 15.00, "Verified via serial number."),
(4, "2023-07-03", "Luxury Verify", "Authenticated", 25.00, "Hologram confirmed."),
(6, "2023-08-03", "AuthentiCheck Pro", "Authenticated", 20.00, NULL),
(9, "2023-09-18", "In-house Expert", "Authenticated", 5.00, "Standard check."),
(10, "2023-10-03", "Luxury Verify", "Authenticated", 30.00, "Premium item verification."),
(1, "2023-10-15", "AuthentiCheck Pro", "Authenticated", 15.00, "Inconsistent stitching pattern."),
(3, "2023-11-01", "In-house Expert", "Pending", 0.00, "Awaiting documentation.");


