USE solo_run;

-- 1. Select customer name together with each order the customer made.
SELECT customer_name, orderid, quantity
FROM customer as c
JOIN order_details as o ON c.customer_id = o.order_details_id;

-- 2. Select order id together with name of employee who handled the order.
SELECT employee_id, first_name, last_name, order_id
FROM employees as e
JOIN orders as o ON e.employee_id = o.employeeid;

-- 3. Select customers who did not placed any order yet.
SELECT c.customer_id, c.customer_name, o.order_id
FROM customer as c
LEFT JOIN orders as o ON c.customer_id = o.customerid
WHERE o.order_id is null;

-- 4. Select order id together with the name of products.
SELECT orderid, productname
FROM order_details as o
JOIN products as p ON p.product_id = o.productid;

-- 5. Select products that no one bought.  **
SELECT orderid, productname, product_id
FROM order_details as o
JOIN products as p ON p.product_id = o.productid
WHERE productid NOT IN (product_id);

-- 6. Select customer together with the products that he bought.
SELECT customer_name, productname
FROM customer as c
JOIN products as p ON p.product_id = c.customer_id;


-- 7. Select product names together with the name of corresponding category.
SELECT productname, categoryname
FROM products as p
JOIN categories as c ON c.category_id = p.categoryid;

-- 8. Select orders together with the name of the shipping company.
SELECT order_id, shippername
FROM orders as o
JOIN shippers as s on s.shippers_id = o.shipperid;

-- 9. Select customers with id greater than 50 together with each order they made.
SELECT customer_id, quantity
FROM customer as c
JOIN order_details as o ON o.order_details_id = c.customer_id
WHERE customer_id > 50;

-- 10. Select employees together with orders with order id greater than 10400.
SELECT employee_id, first_name, last_name, order_id
FROM employees as e
JOIN orders as o ON o.employeeid = e.employee_id
WHERE order_id > 10400;

-- 11. Select the most expensive product.
SELECT productname, price
FROM products
ORDER BY price DESC
LIMIT 1;

-- 12. Select the second most expensive product.
SELECT productname, price
FROM products
ORDER BY price DESC
LIMIT 1 OFFSET 1;

-- 13. Select name and price of each product, sort the result by price in decreasing order.
SELECT productname, price
FROM products
ORDER BY price DESC;

-- 14. Select 5 most expensive products.
SELECT productname, price
FROM products
ORDER BY price DESC
LIMIT 5;

-- 15. Select 5 most expensive products without the most expensive (in final 4 products).
SELECT productname, price
FROM products
ORDER BY price DESC
LIMIT 4 OFFSET 1;

-- 16. Select name of the cheapest product (only name) without using LIMIT and OFFSET.
SELECT productname
FROM products
WHERE price =
(SELECT MIN(price) FROM 
products);

-- 17. Select name of the cheapest product (only name) using subquery.
SELECT productname
FROM products
WHERE price =
(SELECT MIN(price) FROM 
products);

-- 18. Select number of employees with LastName that starts with 'D'.
SELECT count(last_name)
FROM employees
WHERE last_name LIKE "%D%";

-- 19. Select customer name together with the number of orders made by the corresponding
-- customer, sort the result by number of orders in decreasing order.
SELECT customer_name, quantity
FROM customer as c
JOIN order_details as o ON o.order_details_id = c.customer_id
ORDER BY quantity DESC;

-- 20. Add up the price of all products.
SELECT sum(price) as "Total Price"
FROM products;

-- 21. Select orderID together with the total price of that Order, order the result by total
-- price of order in increasing order
SELECT order_id, price AS "Total Price"
FROM orders as o
JOIN products as p ON product_id = o.customerid
ORDER BY price DESC;

-- 22. Select customer who spend the most money.
SELECT customer_name, (price * quantity) as "Amount Spent"
FROM customer as c
JOIN products as p ON p.product_id = c.customer_id
JOIN order_details as o ON o.order_details_id = c.customer_id
ORDER BY price desc
LIMIT 1;

-- 23. Select customer who spend the most money and lives in Canada.  **
SELECT customer_name, (price * quantity) as "Amount Spent"
FROM customer as c
JOIN products as p ON p.product_id = c.customer_id
JOIN order_details as o ON o.order_details_id = c.customer_id
WHERE country LIKE "Canada"
ORDER BY price desc;

-- 24. Select customer who spend the second most money.
SELECT customer_name, (price * quantity) as "Amount Spent"
FROM customer as c
JOIN products as p ON p.product_id = c.customer_id
JOIN order_details as o ON o.order_details_id = c.customer_id
ORDER BY price desc
LIMIT 1 OFFSET 1;

-- 25. Select shipper together with the total price of proceed orders.
SELECT shippername, sum(price * quantity) AS "Total price"
FROM shippers as s
JOIN orders as o ON o.shipperid = s.shippers_id
JOIN order_details AS oo ON oo.orderid = o.order_id
JOIN products as P ON p.product_id = oo.productid
GROUP BY shippername;

#B. Exploratory Data Analysis
-- 1. Total number of products sold so far.
SELECT count(productname) AS "Total number of products sold"
FROM products;

-- 2. Total Revenue So far.
SELECT sum(price * quantity) AS "Total Revenue"
FROM products as p
JOIN order_details as o ON o.productid = p.product_id;

-- 3. Total Unique Products sold based on category.
SELECT count(distinct(categoryid)) AS"Total Unique products"
FROM products as p
JOIN categories as c ON c.category_id = p.categoryid;

-- 4. Total Number of Purchase Transactions from customers.
SELECT count(distinct(order_id)) AS "Toatl Purchase Transaction"
FROM orders;


-- 5. Compare Orders made between 2022 – 2023  
SELECT COUNT(orderdate) AS "Total Order in 2022"
FROM orders
WHERE orderdate BETWEEN "2022-01-01" AND "2022-12-31";

SELECT COUNT(orderdate) AS "Total Order in 2023"
FROM orders
WHERE orderdate BETWEEN "2023-01-01" AND "2023-12-31";


-- 6. What is total number of customers? Compare those that have made transaction and
-- those that haven’t at all
SELECT count(customer_id) AS "Total Number of Customers"
FROM customer;

SELECT count(distinct(customerid)) AS "Customers that Made transaction"
FROM orders;

SELECT count(c.customer_id) AS "Customer that haven't made order"
FROM customer as c
LEFT JOIN orders as o ON c.customer_id = o.customerid
WHERE o.order_id is null;

-- 7. Who are the Top 5 customers with the highest purchase value?
SELECT customer_name AS "Top 5 Customers", (price * quantity) AS "Purchase Value"
FROM products as p
JOIN order_details as o ON o.productid = p.product_id
JOIN customer as c ON c.customer_id = o.order_details_id
ORDER BY (price * quantity) DESC
LIMIT 5;

-- 8. Top 5 best-selling products
SELECT productname AS "Top 5 Best Selling Products", sum(quantity) AS "Quantity"
FROM products as p
JOIN order_details AS o ON o.productid = p.product_id
GROUP BY productname
ORDER BY sum(quantity) DESC
LIMIT 5;

-- 9. What is the Transaction value per month
SELECT monthname(orderdate) AS "Month", sum(price * quantity) AS "Transaction Value"
FROM orders as o
JOIN order_details as oo ON oo.orderid = o.order_id
JOIN products as p ON p.product_id =oo.productid
GROUP BY monthname(orderdate)
ORDER BY sum(price *quantity) DESC;

-- 10. Best Selling Product Category
SELECT categoryname AS "Best Selling Product", quantity
FROM products as p
JOIN order_details AS o ON o.productid = p.product_id
JOIN categories as c ON c.category_id = o.order_details_id
ORDER BY quantity DESC
LIMIT 1;

-- 11. Buyers who have Transacted more than two times  **
SELECT customer_name, customer_id, count(customerid) AS "No of Transactions"
FROM customer as c
JOIN orders as o ON o.customerid = c.customer_id
GROUP BY customer_id
HAVING count(customerid) > 2
ORDER BY count(customerid) DESC;

-- 12. Most Successful Employee 
SELECT count(concat(first_name, last_name)) AS "Total No of orders made", employeeid, concat(first_name, last_name) AS "Name"
FROM employees AS e
JOIN orders as o ON o.employeeid = e.employee_id
GROUP BY employeeid
ORDER BY count(concat(first_name, last_name)) DESC
LIMIT 1;

-- 13.	Most use Shipper
SELECT count(shipperid) AS "Total No of Times Used", shippers_id AS "Most Used Shipper by ID"
FROM shippers AS s
JOIN orders AS o ON o. shipperid = s.shippers_id
GROUP BY shippers_id
ORDER BY count(shipperid) DESC
LIMIT 1;

-- 14. Most use Supplier
SELECT count(supplier_id) AS "Total No of Times Used", suppliername AS "Most Used Supplier"
FROM suppliers AS s
JOIN products as p ON  p.supplierid = s.supplier_id
JOIN order_details as o on o.productid = p.product_id
GROUP BY suppliername
ORDER BY count(supplier_id) DESC
LIMIT 1;