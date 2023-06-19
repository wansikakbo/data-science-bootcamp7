/*
  Run > ".read restaurants.sql"
  =============================
*/
DROP TABLE menus;
DROP TABLE customers;
DROP TABLE coupons;
DROP TABLE orders;
DROP TABLE orderitems;

CREATE TABLE menus (
  id INT PRIMARY KEY, 
  name INT, 
  price INT
); 
 
CREATE TABLE customers (
  id INT PRIMARY KEY, 
  name TEXT,
  point INT
);

CREATE TABLE coupons (
  id INT PRIMARY KEY, 
  code VARCHAR(10),
  discount INT,
  ulimit INT NULL,
  start_date TIMESTAMP NULL,
  end_date TIMESTAMP NULL
);
 
CREATE TABLE orders (
  id INT PRIMARY KEY, 
  customer_id INT,
  coupon_id INT NULL,
  order_no VARCHAR(10),
  order_date TIMESTAMP
);

CREATE TABLE orderitems (
  id INT PRIMARY KEY, 
  order_id INT,
  menu_id INT,
  price INT,
  qty INT
);
 
INSERT INTO menus VALUES
  (1, "rice", 20),
  (2, "apples", 20),
  (3, "almond", 20),
  (4, "bacon", 20),
  (5, "cake", 20),
  (6, "cheese", 20),
  (7, "crab", 20);

INSERT INTO customers VALUES
  (1, 'Mr. K', 144),
  (2, 'Sandy', 125),
  (3, 'Blue', 214),
  (4, 'Boss', 532),
  (5, 'Best', 321);

INSERT INTO coupons VALUES
  (1, 'STDSGH23', 10, 100, "2022-01-15", "2022-01-15"),
  (2, 'SF3E414W', 12, 100, "2022-01-15", "2022-01-23"),
  (3, 'GDS344T4', 5, 10, "2022-01-15", "2023-04-11"),
  (4, '3DHDTH43', 3, 999, "2022-01-15", "2023-02-12"),
  (5, 'DFJYJE43', 1, 1, "2022-01-15", "2023-11-13");

INSERT INTO orders VALUES
  (1, 1, 5, "66010001", "2022-01-15"),
  (2, 5, NULL, "66010002", "2022-08-14"),
  (3, 5, 3, "66010003", "2022-12-22"),
  (4, 2, 1, "66010004", "2023-01-11"),
  (5, 3, 1, "66010005", "2023-01-22");

INSERT INTO orderitems VALUES
  (1, 2, 2, 20, 5),
  (2, 2, 4, 20, 3),
  (3, 3, 5, 20, 20),
  (4, 4, 7, 20, 6),
  (5, 1, 1, 20, 1),
  (6, 5, 3, 20, 3),
  (7, 3, 3, 20, 4);


.mode column
.header on
  
.print  \n==============
.print  \n"Query 01: Active coupons ( DATE BETWEEN )"\n
SELECT 
  code,  
  discount || "%" AS _discount,
  ulimit AS _limit, 
  start_date,
  end_date
  FROM coupons
  WHERE ulimit > 0 AND
    (CURRENT_DATE BETWEEN start_date AND end_date);

.print  \n==============
.print  \n"Query 02: Order summary ( COALESCE WITH..AS )"\n

WITH orders_total AS (
      SELECT o.*, SUM(i.price*i.qty) AS _total
      FROM orders AS o
      JOIN orderitems AS i ON o.id = i.order_id
      GROUP BY o.id 
) 
SELECT 
    od.order_date AS _date,
    od.order_no, 
    od._total,  
    COALESCE(cp.discount || '%','-') AS _coupon,  
    od._total - COALESCE(od._total * cp.discount / 100.0, 0.0) AS _grandtotal
    FROM orders_total AS od
    JOIN customers AS cm ON cm.id = od.customer_id
    LEFT JOIN coupons AS cp ON cp.id = od.coupon_id;

.print  \n==============
.print  \n"Query 03: Top 3 menus ( ROW_NUMBER OVER Subquery )"\n 
SELECT 
  ROW_NUMBER() OVER (ORDER BY _income DESC) as _no, 
  top3menus.*
  FROM (
    SELECT   
      m.name,  
      SUM(m.price*i.qty) AS _income,
      SUM(i.qty) AS _total_qty
      FROM orderitems AS i
      JOIN menus AS m ON m.id = i.menu_id
      GROUP BY menu_id
  ) AS top3menus 
  LIMIT 3;

.print  \n==============
.print  \n"Query 04: Member Type ( CASE WHEN THEN ELSE END )"\n
SELECT *, 
  CASE  
    WHEN point >= 500 THEN "PREMIUM"    
    WHEN point >= 300 THEN "GOLD"
    WHEN point >= 200 THEN "SILVER"
    ELSE "BROZE"
  END AS member_type
  FROM customers;  


.print  \n==============
.print  \n"Query 05: Member Stat ( JOIN with WHERE clause )"\n
SELECT 
  c.name, 
  SUM(i.qty) AS _total_qty,
  SUM(i.price*i.qty) AS _total_spending
  FROM customers AS c
      ,orders AS o
      ,orderitems AS i
  WHERE c.id = o.customer_id AND o.id = i.order_id
  GROUP BY c.id 
  ORDER BY _total_spending DESC;
