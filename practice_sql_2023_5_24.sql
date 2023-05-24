USE practice_sql;


CREATE TABLE IF NOT EXISTS Courses
(
    student varchar(255),
    class   varchar(255)
);
TRUNCATE TABLE Courses;
INSERT INTO Courses (student, class)
VALUES ('A', 'Math');
INSERT INTO Courses (student, class)
VALUES ('B', 'English');
INSERT INTO Courses (student, class)
VALUES ('C', 'Math');
INSERT INTO Courses (student, class)
VALUES ('D', 'Biology');
INSERT INTO Courses (student, class)
VALUES ('E', 'Math');
INSERT INTO Courses (student, class)
VALUES ('F', 'Computer');
INSERT INTO Courses (student, class)
VALUES ('G', 'Math');
INSERT INTO Courses (student, class)
VALUES ('H', 'Math');
INSERT INTO Courses (student, class)
VALUES ('I', 'Math');

/*
 编写一个SQL查询来报告 至少有5个学生 的所有班级
 */

SELECT *
FROM Courses;

SELECT *, ROW_NUMBER() OVER (PARTITION BY class ORDER BY student) AS RN
FROM Courses;

SELECT class
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY class ORDER BY student) AS RN FROM Courses) AS t
WHERE RN = 5;

WITH t AS (SELECT *, ROW_NUMBER() OVER (PARTITION BY class ORDER BY student) AS RN FROM Courses)
SELECT class
FROM t
WHERE RN = 5;

SELECT class
FROM Courses
GROUP BY class
HAVING COUNT(class) >= 5;



DROP TABLE IF EXISTS SalesPerson;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS Orders;
CREATE TABLE IF NOT EXISTS SalesPerson
(
    sales_id        int,
    name            varchar(255),
    salary          int,
    commission_rate int,
    hire_date       date
);
CREATE TABLE IF NOT EXISTS Company
(
    com_id int,
    name   varchar(255),
    city   varchar(255)
);
CREATE TABLE IF NOT EXISTS Orders
(
    order_id   int,
    order_date date,
    com_id     int,
    sales_id   int,
    amount     int
);
TRUNCATE TABLE SalesPerson;
INSERT INTO SalesPerson (sales_id, name, salary, commission_rate, hire_date)
VALUES ('1', 'John', '100000', '6', '2006-04-01');
INSERT INTO SalesPerson (sales_id, name, salary, commission_rate, hire_date)
VALUES ('2', 'Amy', '12000', '5', '2010-05-01');
INSERT INTO SalesPerson (sales_id, name, salary, commission_rate, hire_date)
VALUES ('3', 'Mark', '65000', '12', '2008-12-25');
INSERT INTO SalesPerson (sales_id, name, salary, commission_rate, hire_date)
VALUES ('4', 'Pam', '25000', '25', '2005-01-01');
INSERT INTO SalesPerson (sales_id, name, salary, commission_rate, hire_date)
VALUES ('5', 'Alex', '5000', '10', '2007-02-03');
TRUNCATE TABLE Company;
INSERT INTO Company (com_id, name, city)
VALUES ('1', 'RED', 'Boston');
INSERT INTO Company (com_id, name, city)
VALUES ('2', 'ORANGE', 'New York');
INSERT INTO Company (com_id, name, city)
VALUES ('3', 'YELLOW', 'Boston');
INSERT INTO Company (com_id, name, city)
VALUES ('4', 'GREEN', 'Austin');
TRUNCATE TABLE Orders;
INSERT INTO Orders (order_id, order_date, com_id, sales_id, amount)
VALUES (1, '2014-01-01', 3, 4, 10000);
INSERT INTO Orders (order_id, order_date, com_id, sales_id, amount)
VALUES (2, '2014-02-01', '4', '5', '5000');
INSERT INTO Orders (order_id, order_date, com_id, sales_id, amount)
VALUES (3, '2014-03-01', '1', '1', '50000');
INSERT INTO Orders (order_id, order_date, com_id, sales_id, amount)
VALUES (4, '2014-04-01', '1', '4', '25000');

/*
 编写一个SQL查询，报告没有任何与名为 “RED” 的公司相关的订单的所有销售人员的姓名。
 */

SELECT name
FROM SalesPerson
WHERE sales_id NOT IN
      (SELECT sales_id
       FROM Orders
       WHERE com_id IN
             (SELECT com_id FROM Company WHERE name = 'RED'));


DROP TABLE IF EXISTS Triangle;
CREATE TABLE IF NOT EXISTS Triangle
(
    x int,
    y int,
    z int
);
TRUNCATE TABLE Triangle;
INSERT INTO Triangle (x, y, z)
VALUES ('13', '15', '30');
INSERT INTO Triangle (x, y, z)
VALUES ('10', '20', '15');

/*
  写一个SQL查询，每三个线段报告它们是否可以形成一个三角形。
 */

SELECT x, y, z
FROM Triangle;

SELECT x, y, z, CASE WHEN x + y > z AND x + z > y AND z + y > x THEN 'Yes' ELSE 'No' END AS triangle
FROM Triangle;

DROP TABLE IF EXISTS MyNumbers;
CREATE TABLE IF NOT EXISTS MyNumbers
(
    num int
);
TRUNCATE TABLE MyNumbers;
INSERT INTO MyNumbers (num)
VALUES ('8');
INSERT INTO MyNumbers (num)
VALUES ('8');
INSERT INTO MyNumbers (num)
VALUES ('3');
INSERT INTO MyNumbers (num)
VALUES ('3');
INSERT INTO MyNumbers (num)
VALUES ('1');
INSERT INTO MyNumbers (num)
VALUES ('4');
INSERT INTO MyNumbers (num)
VALUES ('5');
INSERT INTO MyNumbers (num)
VALUES ('6');

/*
 请你编写一个 SQL 查询来报告最大的 单一数字 。如果不存在 单一数字 ，查询需报告 null
 */

SELECT *
FROM MyNumbers;

SELECT num, COUNT(1) AS total
FROM MyNumbers
GROUP BY num
ORDER BY num DESC;

SELECT CASE WHEN total = 1 THEN num WHEN 1 = total THEN 2 ELSE NULL END AS num
FROM (SELECT num, COUNT(1) AS total FROM MyNumbers GROUP BY num ORDER BY num DESC) AS t;

SELECT *, ROW_NUMBER() OVER (PARTITION BY total ORDER BY num DESC ) AS RN
FROM (SELECT num, COUNT(1) AS total
      FROM MyNumbers
      GROUP BY num
      ORDER BY num DESC) AS t;

SELECT CASE WHEN total = 1 AND RN = 1 THEN num ELSE NULL END AS num
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY total ORDER BY num DESC ) AS RN
      FROM (SELECT num, COUNT(1) AS total
            FROM MyNumbers
            GROUP BY num
            ORDER BY num DESC) AS t) AS t2
LIMIT 0,1;



DROP TABLE IF EXISTS cinema;
CREATE TABLE IF NOT EXISTS cinema
(
    id          int,
    movie       varchar(255),
    description varchar(255),
    rating      float(2, 1)
);
TRUNCATE TABLE cinema;
INSERT INTO cinema (id, movie, description, rating)
VALUES ('1', 'War', 'great 3D', '8.9');
INSERT INTO cinema (id, movie, description, rating)
VALUES ('2', 'Science', 'fiction', '8.5');
INSERT INTO cinema (id, movie, description, rating)
VALUES ('3', 'irish', 'boring', '6.2');
INSERT INTO cinema (id, movie, description, rating)
VALUES ('4', 'Ice song', 'Fantacy', '8.6');
INSERT INTO cinema (id, movie, description, rating)
VALUES ('5', 'House card', 'Interesting', '9.1');

/*
 找出所有影片描述为非 boring (不无聊) 的并且 id 为奇数 的影片，结果请按等级 rating 排列
 */

SELECT *
FROM cinema;

SELECT *
FROM cinema
WHERE id % 2 = 1
  AND description NOT LIKE 'boring'
ORDER BY rating DESC;