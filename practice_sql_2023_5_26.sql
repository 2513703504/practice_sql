USE practice_sql;

DROP TABLE IF EXISTS Activity;
CREATE TABLE IF NOT EXISTS Activity
(
    user_id       int,
    session_id    int,
    activity_date date,
    activity_type ENUM ('open_session', 'end_session', 'scroll_down', 'send_message')
);
TRUNCATE TABLE Activity;
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('1', '1', '2019-07-20', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('1', '1', '2019-07-20', 'scroll_down');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('1', '1', '2019-07-20', 'end_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('2', '4', '2019-07-20', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('2', '4', '2019-07-21', 'send_message');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('2', '4', '2019-07-21', 'end_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('3', '2', '2019-07-21', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('3', '2', '2019-07-21', 'send_message');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('3', '2', '2019-07-21', 'end_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('4', '3', '2019-06-25', 'open_session');
INSERT INTO Activity (user_id, session_id, activity_date, activity_type)
VALUES ('4', '3', '2019-06-25', 'end_session');


SELECT *
FROM Activity;

/*
 请写SQL查询出截至 2019-07-27（包含2019-07-27），近 30 天的每日活跃用户数（当天只要有一条活动记录，即为活跃用户）
 */

SELECT *
FROM Activity
WHERE activity_date <= '2019-07-27';

SELECT DISTINCT user_id, activity_date
FROM (SELECT *
      FROM Activity
      WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27') AS t
GROUP BY activity_date, user_id;

SELECT t2.activity_date AS day, COUNT(t2.user_id) AS active_users
FROM (SELECT DISTINCT user_id, activity_date
      FROM (SELECT *
            FROM Activity
            WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 30 DAY) AND '2019-07-27') AS t
      GROUP BY activity_date, user_id) AS t2
GROUP BY t2.activity_date;


DROP TABLE IF EXISTS Views;
CREATE TABLE IF NOT EXISTS Views
(
    article_id int,
    author_id  int,
    viewer_id  int,
    view_date  date
);
TRUNCATE TABLE Views;
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES ('1', '3', '5', '2019-08-01');
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES ('1', '3', '6', '2019-08-02');
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES ('2', '7', '7', '2019-08-01');
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES ('2', '7', '6', '2019-08-02');
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES ('4', '7', '1', '2019-07-22');
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES ('3', '4', '4', '2019-07-21');
INSERT INTO Views (article_id, author_id, viewer_id, view_date)
VALUES ('3', '4', '4', '2019-07-21');

/*
 请编写一条 SQL 查询以找出所有浏览过自己文章的作者，结果按照 id 升序排列
 */

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;

DROP TABLE IF EXISTS Department;
CREATE TABLE IF NOT EXISTS Department
(
    id      int,
    revenue int,
    month   varchar(5)
);
TRUNCATE TABLE Department;
INSERT INTO Department (id, revenue, month)
VALUES ('1', '8000', 'Jan');
INSERT INTO Department (id, revenue, month)
VALUES ('2', '9000', 'Jan');
INSERT INTO Department (id, revenue, month)
VALUES ('3', '10000', 'Feb');
INSERT INTO Department (id, revenue, month)
VALUES ('1', '7000', 'Feb');
INSERT INTO Department (id, revenue, month)
VALUES ('1', '6000', 'Mar');

/*
 编写一个 SQL 查询来重新格式化表，使得新的表中有一个部门 id 列和一些对应 每个月 的收入（revenue）列
 */

SELECT *
FROM Department;

SELECT DISTINCT id,
                CASE WHEN month = 'Jan' THEN revenue ELSE NULL END AS 'Jan_revenue',
                CASE WHEN month = 'Feb' THEN revenue ELSE NULL END AS 'Feb_revenue',
                CASE WHEN month = 'Mar' THEN revenue ELSE NULL END AS 'Mar_revenue',
                CASE WHEN month = 'Apr' THEN revenue ELSE NULL END AS 'Apr_revenue',
                CASE WHEN month = 'May' THEN revenue ELSE NULL END AS 'May_revenue',
                CASE WHEN month = 'Jun' THEN revenue ELSE NULL END AS 'Jun_revenue',
                CASE WHEN month = 'Jul' THEN revenue ELSE NULL END AS 'Jul_revenue',
                CASE WHEN month = 'Aug' THEN revenue ELSE NULL END AS 'Aug_revenue',
                CASE WHEN month = 'Sep' THEN revenue ELSE NULL END AS 'Sep_revenue',
                CASE WHEN month = 'Oct' THEN revenue ELSE NULL END AS 'Oct_revenue',
                CASE WHEN month = 'Nov' THEN revenue ELSE NULL END AS 'Nov_revenue',
                CASE WHEN month = 'Dec' THEN revenue ELSE NULL END AS 'Dec_revenue'
FROM Department;

SELECT t.id,
       SUM(t.Jan_revenue) AS 'Jan_revenue',
       SUM(t.Feb_revenue) AS 'Feb_revenue',
       SUM(t.Mar_revenue) AS 'Mar_revenue',
       SUM(t.Apr_revenue) AS 'Apr_revenue',
       SUM(t.May_revenue) AS 'May_revenue',
       SUM(t.Jun_revenue) AS 'Jun_revenue',
       SUM(t.Jul_revenue) AS 'Jul_revenue',
       SUM(t.Aug_revenue) AS 'Aug_revenue',
       SUM(t.Sep_revenue) AS 'Sep_revenue',
       SUM(t.Oct_revenue) AS 'Oct_revenue',
       SUM(t.Nov_revenue) AS 'Nov_revenue',
       SUM(t.Dec_revenue) AS 'Dec_revenue'
FROM (SELECT DISTINCT id,
                      CASE WHEN month = 'Jan' THEN revenue ELSE NULL END AS 'Jan_revenue',
                      CASE WHEN month = 'Feb' THEN revenue ELSE NULL END AS 'Feb_revenue',
                      CASE WHEN month = 'Mar' THEN revenue ELSE NULL END AS 'Mar_revenue',
                      CASE WHEN month = 'Apr' THEN revenue ELSE NULL END AS 'Apr_revenue',
                      CASE WHEN month = 'May' THEN revenue ELSE NULL END AS 'May_revenue',
                      CASE WHEN month = 'Jun' THEN revenue ELSE NULL END AS 'Jun_revenue',
                      CASE WHEN month = 'Jul' THEN revenue ELSE NULL END AS 'Jul_revenue',
                      CASE WHEN month = 'Aug' THEN revenue ELSE NULL END AS 'Aug_revenue',
                      CASE WHEN month = 'Sep' THEN revenue ELSE NULL END AS 'Sep_revenue',
                      CASE WHEN month = 'Oct' THEN revenue ELSE NULL END AS 'Oct_revenue',
                      CASE WHEN month = 'Nov' THEN revenue ELSE NULL END AS 'Nov_revenue',
                      CASE WHEN month = 'Dec' THEN revenue ELSE NULL END AS 'Dec_revenue'
      FROM Department) AS t
GROUP BY t.id;


DROP TABLE IF EXISTS Queries;
CREATE TABLE IF NOT EXISTS Queries
(
    query_name varchar(30),
    result     varchar(50),
    position   int,
    rating     int
);
TRUNCATE TABLE Queries;
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Dog', 'Golden Retriever', '1', '5');
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Dog', 'German Shepherd', '2', '5');
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Dog', 'Mule', '200', '1');
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Cat', 'Shirazi', '5', '2');
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Cat', 'Siamese', '3', '3');
INSERT INTO Queries (query_name, result, position, rating)
VALUES ('Cat', 'Sphynx', '7', '4');

/*
将查询结果的质量 quality 定义为：
各查询结果的评分与其位置之间比率的平均值。
将劣质查询百分比poor_query_percentage 为：
评分小于 3 的查询结果占全部查询结果的百分比。
编写一组 SQL 来查找每次查询的名称(query_name)、质量(quality) 和劣质查询百分比(poor_query_percentage)。
质量(quality) 和劣质查询百分比(poor_query_percentage) 都应四舍五入到小数点后两位
 */

SELECT *
FROM Queries;

SELECT query_name, ROUND(rating / position, 2) AS quality, rating
FROM Queries;

SELECT query_name, ROUND(SUM(quality) / COUNT(1), 2) AS quality
FROM (SELECT query_name, ROUND(rating / position, 2) AS quality, rating FROM Queries) AS t
GROUP BY query_name;

SELECT query_name, CASE WHEN rating < 3 THEN 1 END AS rn
FROM Queries;

SELECT query_name, ROUND(COUNT(rn = 1) / COUNT(query_name) * 100, 2) AS poor_query_percentage
FROM (SELECT query_name, CASE WHEN rating < 3 THEN 1 END AS rn FROM Queries) AS T
GROUP BY query_name;

WITH t AS (SELECT query_name, ROUND(SUM(quality) / COUNT(1), 2) AS quality
           FROM (SELECT query_name, ROUND(rating / position, 2) AS quality, rating FROM Queries) AS t
           GROUP BY query_name)
SELECT tmp.query_name, t.quality, tmp.poor_query_percentage
FROM (SELECT query_name, ROUND(COUNT(rn = 1) / COUNT(query_name) * 100, 2) AS poor_query_percentage
      FROM (SELECT query_name, CASE WHEN rating < 3 THEN 1 END AS rn FROM Queries) AS T
      GROUP BY query_name) AS tmp,
     t
WHERE t.query_name = tmp.query_name; /* 聚合函数avg() 未使用 */


SELECT query_name,
       ROUND(AVG(rating / Queries.position), 2) quality,
       ROUND(AVG(rating < 3) * 100, 2)          poor_query_percentage
FROM Queries
GROUP BY query_name;



DROP TABLE IF EXISTS Prices;
DROP TABLE IF EXISTS UnitsSold;
CREATE TABLE IF NOT EXISTS Prices
(
    product_id int,
    start_date date,
    end_date   date,
    price      int
);
CREATE TABLE IF NOT EXISTS UnitsSold
(
    product_id    int,
    purchase_date date,
    units         int
);
TRUNCATE TABLE Prices;
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES ('1', '2019-02-17', '2019-02-28', '5');
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES ('1', '2019-03-01', '2019-03-22', '20');
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES ('2', '2019-02-01', '2019-02-20', '15');
INSERT INTO Prices (product_id, start_date, end_date, price)
VALUES ('2', '2019-02-21', '2019-03-31', '30');
TRUNCATE TABLE UnitsSold;
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES ('1', '2019-02-25', '100');
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES ('1', '2019-03-01', '15');
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES ('2', '2019-02-10', '200');
INSERT INTO UnitsSold (product_id, purchase_date, units)
VALUES ('2', '2019-03-22', '30');

/*
 编写SQL查询以查找每种产品的平均售价。
 average_price 应该四舍五入到小数点后两位。
 */

SELECT *, Prices.price * UnitsSold.units AS total
FROM Prices,
     UnitsSold
WHERE Prices.product_id = UnitsSold.product_id
  AND purchase_date BETWEEN Prices.start_date AND Prices.end_date;

SELECT t.product_id, ROUND(SUM(total) / SUM(units), 2) AS average_price
FROM (SELECT Prices.product_id, price, units, Prices.price * UnitsSold.units AS total
      FROM Prices,
           UnitsSold
      WHERE Prices.product_id = UnitsSold.product_id
        AND purchase_date BETWEEN Prices.start_date AND Prices.end_date) AS t
GROUP BY t.product_id;