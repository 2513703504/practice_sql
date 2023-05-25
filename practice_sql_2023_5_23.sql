USE practice_sql;

DROP TABLE IF EXISTS Weather;
CREATE TABLE IF NOT EXISTS Weather
(
    id          int,
    recordDate  date,
    temperature int
);
TRUNCATE TABLE Weather;
INSERT INTO Weather (id, recordDate, temperature)
VALUES ('1', '2015-01-01', '10');
INSERT INTO Weather (id, recordDate, temperature)
VALUES ('2', '2015-01-02', '25');
INSERT INTO Weather (id, recordDate, temperature)
VALUES ('3', '2015-01-03', '20');
INSERT INTO Weather (id, recordDate, temperature)
VALUES ('4', '2015-01-04', '30');


SELECT *
FROM Weather;

/*
 编写一个 SQL 查询，来查找与之前（昨天的）日期相比温度更高的所有日期的 id 。
 */

SELECT w2.id
FROM Weather w1,
     Weather w2
WHERE w1.id + 1 = w2.id
  AND w1.temperature < w2.temperature;

SELECT *
FROM Weather
ORDER BY recordDate;

SELECT *, ROW_NUMBER() OVER (ORDER BY recordDate) AS rn
FROM Weather;



SELECT t2.id
FROM (SELECT *, ROW_NUMBER() OVER (ORDER BY recordDate) AS rn FROM Weather) AS t,
     (SELECT *, ROW_NUMBER() OVER (ORDER BY recordDate) AS rn FROM Weather) t2
WHERE t.rn + 1 = t2.rn
  AND t.temperature < t2.temperature;

SELECT b.id
FROM Weather a
         INNER JOIN Weather b ON a.temperature < b.temperature AND DATEDIFF(b.recordDate, a.recordDate) = 1;


DROP TABLE IF EXISTS Activity;
CREATE TABLE IF NOT EXISTS Activity
(
    player_id    int,
    device_id    int,
    event_date   date,
    games_played int
);
TRUNCATE TABLE Activity;
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('1', '2', '2016-03-01', '5');
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('1', '2', '2016-05-02', '6');
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('2', '3', '2017-06-25', '1');
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('3', '1', '2016-03-02', '0');
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('3', '4', '2018-07-03', '5');

/*
 写一条 SQL 查询语句获取每位玩家 第一次登陆平台的日期
 */

SELECT *
FROM Activity;


SELECT *, ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS RN
FROM Activity;

SELECT t.player_id, t.event_date AS first_login
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date) AS RN FROM Activity) AS t
WHERE t.RN = 1;

SELECT player_id, MIN(event_date) AS first_login
FROM Activity
GROUP BY player_id;

DROP TABLE IF EXISTS Employee;
CREATE TABLE IF NOT EXISTS Employee
(
    empId      int,
    name       varchar(255),
    supervisor int,
    salary     int
);
DROP TABLE IF EXISTS Bonus;
CREATE TABLE IF NOT EXISTS Bonus
(
    empId int,
    bonus int
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES ('3', 'Brad', NULL, '4000');
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES ('1', 'John', '3', '1000');
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES ('2', 'Dan', '3', '2000');
INSERT INTO Employee (empId, name, supervisor, salary)
VALUES ('4', 'Thomas', '3', '4000');
TRUNCATE TABLE Bonus;
INSERT INTO Bonus (empId, bonus)
VALUES ('2', '500');
INSERT INTO Bonus (empId, bonus)
VALUES ('4', '2000');

/*
 选出所有 bonus < 1000 的员工的 name 及其 bonus。
 */

SELECT name, bonus
FROM Employee
         LEFT JOIN Bonus ON Employee.empId = Bonus.empId
WHERE bonus < 1000
   OR bonus IS NULL;

DROP TABLE IF EXISTS Customers;
CREATE TABLE IF NOT EXISTS Customer
(
    id         int,
    name       varchar(25),
    referee_id int
);
TRUNCATE TABLE Customer;
INSERT INTO Customer (id, name, referee_id)
VALUES ('1', 'Will', NULL);
INSERT INTO Customer (id, name, referee_id)
VALUES ('2', 'Jane', NULL);
INSERT INTO Customer (id, name, referee_id)
VALUES ('3', 'Alex', '2');
INSERT INTO Customer (id, name, referee_id)
VALUES ('4', 'Bill', NULL);
INSERT INTO Customer (id, name, referee_id)
VALUES ('5', 'Zack', '1');
INSERT INTO Customer (id, name, referee_id)
VALUES ('6', 'Mark', '2');

SELECT *
FROM Customer;
/*
 写一个查询语句，返回一个客户列表，列表中客户的推荐人的编号都 不是 2
 */

SELECT name
FROM Customer
WHERE referee_id <> 2
   OR referee_id IS NULL;

DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders
(
    order_number    int,
    customer_number int
);
TRUNCATE TABLE orders;
INSERT INTO orders (order_number, customer_number)
VALUES ('1', '1');
INSERT INTO orders (order_number, customer_number)
VALUES ('2', '2');
INSERT INTO orders (order_number, customer_number)
VALUES ('3', '3');
INSERT INTO orders (order_number, customer_number)
VALUES ('4', '3');

SELECT *
FROM orders;

/*
 编写一个SQL查询，为下了 最多订单 的客户查找 customer_number 。
 */

SELECT customer_number
FROM orders
GROUP BY customer_number
ORDER BY COUNT(order_number) DESC
LIMIT 1;


DROP TABLE IF EXISTS World;
CREATE TABLE IF NOT EXISTS World
(
    name       varchar(255),
    continent  varchar(255),
    area       int,
    population int,
    gdp        bigint
);
TRUNCATE TABLE World;
INSERT INTO World (name, continent, area, population, gdp)
VALUES ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
INSERT INTO World (name, continent, area, population, gdp)
VALUES ('Albania', 'Europe', '28748', '2831741', '12960000000');
INSERT INTO World (name, continent, area, population, gdp)
VALUES ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
INSERT INTO World (name, continent, area, population, gdp)
VALUES ('Andorra', 'Europe', '468', '78115', '3712000000');
INSERT INTO World (name, continent, area, population, gdp)
VALUES ('Angola', 'Africa', '1246700', '20609294', '100990000000');

SELECT *
FROM World;
/*
 如果一个国家满足下述两个条件之一，则认为该国是 大国 ：
面积至少为 300 万平方公里（即，3000000 km2），或者
人口至少为 2500 万（即 25000000）
编写一个 SQL 查询以报告 大国 的国家名称、人口和面积。
 */

SELECT name, population, area
FROM World
WHERE area >= 3000000
   OR population >= 25000000;