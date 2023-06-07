USE practice_sql;

DROP TABLE IF EXISTS Seat;
CREATE TABLE IF NOT EXISTS Seat
(
    id      int,
    student varchar(255)
);
TRUNCATE TABLE Seat;
INSERT INTO Seat (id, student)
VALUES ('1', 'Abbot');
INSERT INTO Seat (id, student)
VALUES ('2', 'Doris');
INSERT INTO Seat (id, student)
VALUES ('3', 'Emerson');
INSERT INTO Seat (id, student)
VALUES ('4', 'Green');
INSERT INTO Seat (id, student)
VALUES ('5', 'Jeames');

/*
 编写SQL查询来交换每两个连续的学生的座位号。如果学生的数量是奇数，则最后一个学生的id不交换。
按 id 升序 返回结果表
 */

SELECT *
FROM Seat;


WITH t AS (SELECT MAX(id) AS maxId
           FROM Seat)
SELECT CASE
           WHEN id % 2 = 0 THEN id - 1
           WHEN id = t.maxId AND maxId % 2 = 1 THEN t.maxId
           WHEN id % 2 = 1 THEN id + 1
           END AS id,
       student
FROM Seat,
     t
ORDER BY id;

SELECT ROW_NUMBER() OVER (ORDER BY IF(id % 2 = 0, id - 1, id + 1)) AS id
     , student
FROM Seat;



DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Product;
CREATE TABLE IF NOT EXISTS Customer
(
    customer_id int,
    product_key int
);
CREATE TABLE Product
(
    product_key int
);
TRUNCATE TABLE Customer;
INSERT INTO Customer (customer_id, product_key)
VALUES ('1', '5');
INSERT INTO Customer (customer_id, product_key)
VALUES ('2', '6');
INSERT INTO Customer (customer_id, product_key)
VALUES ('3', '5');
INSERT INTO Customer (customer_id, product_key)
VALUES ('3', '6');
INSERT INTO Customer (customer_id, product_key)
VALUES ('1', '6');
TRUNCATE TABLE Product;
INSERT INTO Product (product_key)
VALUES ('5');
INSERT INTO Product (product_key)
VALUES ('6');

/*
 写一条 SQL 查询语句，从 Customer 表中查询购买了 Product 表中所有产品的客户的 id
 */

SELECT c.customer_id
FROM Customer c
         LEFT JOIN Product p ON c.product_key = p.product_key
GROUP BY c.customer_id
HAVING COUNT(DISTINCT c.product_key) = (SELECT COUNT(1) FROM Product);


DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Product;
CREATE TABLE IF NOT EXISTS Sales
(
    sale_id    int,
    product_id int,
    year       int,
    quantity   int,
    price      int
);
CREATE TABLE IF NOT EXISTS Product
(
    product_id   int,
    product_name varchar(10)
);
TRUNCATE TABLE Sales;
INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES ('1', '100', '2008', '10', '5000');
INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES ('2', '100', '2009', '12', '5000');
INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES ('7', '200', '2011', '15', '9000');
INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES ('7', '200', '2011', '15', '8000');
TRUNCATE TABLE Product;
INSERT INTO Product (product_id, product_name)
VALUES ('100', 'Nokia');
INSERT INTO Product (product_id, product_name)
VALUES ('200', 'Apple');
INSERT INTO Product (product_id, product_name)
VALUES ('300', 'Samsung');

/*
 编写一个 SQL 查询，选出每个销售产品 第一年 销售的 产品 id、年份、数量 和 价格。
 结果表中的条目可以按 任意顺序 排列
 */

/**
 rank()排序相同时会重复，总数不变，即会出现1、1、3这样的排序结果；
 dense_rank()排序相同时会重复，总数会减少，即会出现1、1、2这样的排序结果；
 row_number()排序相同时不会重复，会根据顺序排序。
 */

SELECT *, DENSE_RANK() OVER (PARTITION BY Sales.product_id ORDER BY year) AS rn
FROM Sales,
     Product
WHERE Sales.product_id = Product.product_id;


WITH t AS (SELECT Sales.product_id                                            AS product_id,
                  year,
                  quantity,
                  price,
                  RANK() OVER (PARTITION BY Product.product_id ORDER BY year) AS rn
           FROM Sales,
                Product
           WHERE Sales.product_id = Product.product_id)
SELECT product_id, year AS first_year, quantity, price
FROM t
WHERE rn = 1;


DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Items;
CREATE TABLE IF NOT EXISTS Users
(
    user_id        int,
    join_date      date,
    favorite_brand varchar(10)
);
CREATE TABLE IF NOT EXISTS Orders
(
    order_id   int,
    order_date date,
    item_id    int,
    buyer_id   int,
    seller_id  int
);
CREATE TABLE IF NOT EXISTS Items
(
    item_id    int,
    item_brand varchar(10)
);
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, join_date, favorite_brand)
VALUES ('1', '2018-01-01', 'Lenovo');
INSERT INTO Users (user_id, join_date, favorite_brand)
VALUES ('2', '2018-02-09', 'Samsung');
INSERT INTO Users (user_id, join_date, favorite_brand)
VALUES ('3', '2018-01-19', 'LG');
INSERT INTO Users (user_id, join_date, favorite_brand)
VALUES ('4', '2018-05-21', 'HP');
TRUNCATE TABLE Orders;
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES ('1', '2019-08-01', '4', '1', '2');
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES ('2', '2018-08-02', '2', '1', '3');
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES ('3', '2019-08-03', '3', '2', '3');
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES ('4', '2018-08-04', '1', '4', '2');
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES ('5', '2018-08-04', '1', '3', '4');
INSERT INTO Orders (order_id, order_date, item_id, buyer_id, seller_id)
VALUES ('6', '2019-08-05', '2', '2', '4');
TRUNCATE TABLE Items;
INSERT INTO Items (item_id, item_brand)
VALUES ('1', 'Samsung');
INSERT INTO Items (item_id, item_brand)
VALUES ('2', 'Lenovo');
INSERT INTO Items (item_id, item_brand)
VALUES ('3', 'LG');
INSERT INTO Items (item_id, item_brand)
VALUES ('4', 'HP');


/*
请写出一条SQL语句以查询每个用户的注册日期和在 2019 年作为买家的订单总数。
以任意顺序 返回结果表
 */

SELECT *
FROM Users u
         LEFT JOIN Orders o ON o.buyer_id = u.user_id AND YEAR(order_date) = '2019';

SELECT user_id AS buyer_id, join_date, COUNT(order_id) AS orders_in_2019
FROM (SELECT *
      FROM Users u
               LEFT JOIN Orders o ON o.buyer_id = u.user_id AND YEAR(order_date) = '2019') AS t
GROUP BY user_id, join_date;

DROP TABLE IF EXISTS Products;
CREATE TABLE IF NOT EXISTS Products
(
    product_id  int,
    new_price   int,
    change_date date
);
TRUNCATE TABLE Products;
INSERT INTO Products (product_id, new_price, change_date)
VALUES ('1', '20', '2019-08-14');
INSERT INTO Products (product_id, new_price, change_date)
VALUES ('2', '50', '2019-08-14');
INSERT INTO Products (product_id, new_price, change_date)
VALUES ('1', '30', '2019-08-15');
INSERT INTO Products (product_id, new_price, change_date)
VALUES ('1', '35', '2019-08-16');
INSERT INTO Products (product_id, new_price, change_date)
VALUES ('2', '65', '2019-08-17');
INSERT INTO Products (product_id, new_price, change_date)
VALUES ('3', '20', '2019-08-18');

/*
 写一段 SQL来查找在 2019-08-16 时全部产品的价格，假设所有产品在修改前的价格都是 10 。
 以任意顺序 返回结果表。
 */

SELECT *
FROM Products;

SELECT *
FROM Products p1
         LEFT JOIN Products p2 ON p1.product_id = p2.product_id AND p1.change_date = p2.change_date AND
                                  p1.change_date <= '2019-08-16';


WITH t AS (SELECT p1.product_id,
                  p2.product_id  AS productId,
                  p2.new_price   AS newPrice,
                  p2.change_date AS changeDate
           FROM Products p1
                    LEFT JOIN Products p2 ON p1.product_id = p2.product_id AND p1.change_date = p2.change_date AND
                                             p1.change_date <= '2019-08-16')
SELECT *, ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY t.changeDate DESC ) AS rn
FROM t;


SELECT tmp.product_id, IFNULL(newPrice, 10) AS price
FROM (WITH t AS (SELECT p1.product_id,
                        p2.product_id  AS productId,
                        p2.new_price   AS newPrice,
                        p2.change_date AS changeDate
                 FROM Products p1
                          LEFT JOIN Products p2 ON p1.product_id = p2.product_id AND p1.change_date = p2.change_date AND
                                                   p1.change_date <= '2019-08-16')
      SELECT *, ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY t.changeDate DESC ) AS rn
      FROM t) AS tmp
WHERE rn = 1;


DROP TABLE IF EXISTS Delivery;
CREATE TABLE IF NOT EXISTS Delivery
(
    delivery_id                 int,
    customer_id                 int,
    order_date                  date,
    customer_pref_delivery_date date
);
TRUNCATE TABLE Delivery;
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES ('1', '1', '2019-08-01', '2019-08-02');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES ('2', '2', '2019-08-02', '2019-08-02');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES ('3', '1', '2019-08-11', '2019-08-12');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES ('4', '3', '2019-08-24', '2019-08-24');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES ('5', '3', '2019-08-21', '2019-08-22');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES ('6', '2', '2019-08-11', '2019-08-13');
INSERT INTO Delivery (delivery_id, customer_id, order_date, customer_pref_delivery_date)
VALUES ('7', '4', '2019-08-09', '2019-08-09');


/*
 如果顾客期望的配送日期和下单日期相同，则该订单称为 「即时订单」，否则称为「计划订单」。

「首次订单」是顾客最早创建的订单。我们保证一个顾客只会有一个「首次订单」。

写一条 SQL 查询语句获取即时订单在所有用户的首次订单中的比例。保留两位小数。
 */


SELECT *
FROM Delivery;

SELECT *,
       CASE WHEN order_date = customer_pref_delivery_date THEN 'right' ELSE 'plan' END AS newOrder,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)                AS rk
FROM Delivery;


WITH t AS (SELECT *,
                  CASE WHEN order_date = customer_pref_delivery_date THEN 'right' ELSE 'plan' END AS newOrder,
                  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)                AS rk
           FROM Delivery)
SELECT COUNT(*) AS immediate_percentage
FROM t
GROUP BY rk
HAVING rk = 1;

WITH t AS (SELECT *,
                  CASE WHEN order_date = customer_pref_delivery_date THEN 'right' ELSE 'plan' END AS newOrder,
                  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)                AS rk
           FROM Delivery)
SELECT COUNT(*) AS immediate_percentage
FROM t
WHERE rk = 1
  AND newOrder = 'right';

WITH t AS (SELECT *,
                  CASE WHEN order_date = customer_pref_delivery_date THEN 'right' ELSE 'plan' END AS newOrder,
                  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)                AS rk
           FROM Delivery)
SELECT ROUND((SELECT COUNT(*) AS immediate_percentage FROM t WHERE rk = 1 AND newOrder = 'right') /
             (SELECT COUNT(*) AS immediate_percentage FROM t WHERE rk = 1) * 100,
             2) AS immediate_percentage;