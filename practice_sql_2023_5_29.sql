USE practice_sql;

DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Examinations;
CREATE TABLE IF NOT EXISTS Students
(
    student_id   int,
    student_name varchar(20)
);
CREATE TABLE IF NOT EXISTS Subjects
(
    subject_name varchar(20)
);
CREATE TABLE IF NOT EXISTS Examinations
(
    student_id   int,
    subject_name varchar(20)
);
TRUNCATE TABLE Students;
INSERT INTO Students (student_id, student_name)
VALUES ('1', 'Alice');
INSERT INTO Students (student_id, student_name)
VALUES ('2', 'Bob');
INSERT INTO Students (student_id, student_name)
VALUES ('13', 'John');
INSERT INTO Students (student_id, student_name)
VALUES ('6', 'Alex');
TRUNCATE TABLE Subjects;
INSERT INTO Subjects (subject_name)
VALUES ('Math');
INSERT INTO Subjects (subject_name)
VALUES ('Physics');
INSERT INTO Subjects (subject_name)
VALUES ('Programming');
TRUNCATE TABLE Examinations;
INSERT INTO Examinations (student_id, subject_name)
VALUES ('1', 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('1', 'Physics');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('1', 'Programming');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('2', 'Programming');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('1', 'Physics');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('1', 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('13', 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('13', 'Programming');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('13', 'Physics');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('2', 'Math');
INSERT INTO Examinations (student_id, subject_name)
VALUES ('1', 'Math');

/*
 要求写一段 SQL 语句，查询出每个学生参加每一门科目测试的次数，结果按 student_id 和 subject_name 排序
 */

SELECT *
FROM Subjects;
SELECT *
FROM Students;
SELECT *
FROM Examinations;


SELECT Students.student_id, Subjects.subject_name, COUNT(Subjects.subject_name)
FROM Examinations,
     Students,
     Subjects
WHERE Examinations.student_id = Students.student_id
  AND Examinations.subject_name = Subjects.subject_name
GROUP BY Students.student_id, Subjects.subject_name;


SELECT t.student_id, student_name, t.subject_name, t.attended_exams
FROM Students,
     (SELECT Students.student_id, Subjects.subject_name, COUNT(Subjects.subject_name) AS attended_exams
      FROM Examinations
               LEFT JOIN
           Students ON Examinations.student_id = Students.student_id
               LEFT JOIN
           Subjects
           ON
               Examinations.subject_name = Subjects.subject_name
      GROUP BY Students.student_id, Subjects.subject_name) AS t
WHERE Students.student_id = t.student_id
ORDER BY student_id, subject_name;


SELECT *
FROM Subjects,
     Students AS t
         LEFT JOIN Examinations E ON t.student_id = E.student_id;

SELECT *
FROM Students,
     Subjects AS t
         LEFT JOIN Examinations e ON e.subject_name = t.subject_name;


SELECT *
FROM Examinations E
         LEFT JOIN (SELECT *
                    FROM Students,
                         Subjects) AS t ON t.subject_name = E.subject_name AND t.student_id = E.student_id;



SELECT *
FROM Students,
     Subjects;

SELECT t.student_id, t.subject_name, COUNT(Examinations.subject_name)
FROM (SELECT *
      FROM Students,
           Subjects) AS t
         LEFT JOIN Examinations
                   ON t.subject_name = Examinations.subject_name AND t.student_id = Examinations.student_id
GROUP BY t.student_id, t.subject_name;


SELECT t2.student_id, student_name, t2.subject_name, t2.attended_exams
FROM Students,
     (SELECT t.student_id, t.subject_name, COUNT(E.subject_name) AS attended_exams
      FROM (SELECT *
            FROM Students,
                 Subjects) AS t
               LEFT JOIN Examinations E ON t.subject_name = E.subject_name AND t.student_id = E.student_id
      GROUP BY t.student_id, t.subject_name) AS t2
WHERE Students.student_id = t2.student_id
ORDER BY student_id, subject_name;


DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Orders;
CREATE TABLE IF NOT EXISTS Products
(
    product_id       int,
    product_name     varchar(40),
    product_category varchar(40)
);
CREATE TABLE IF NOT EXISTS Orders
(
    product_id int,
    order_date date,
    unit       int
);
TRUNCATE TABLE Products;
INSERT INTO Products (product_id, product_name, product_category)
VALUES ('1', 'Leetcode Solutions', 'Book');
INSERT INTO Products (product_id, product_name, product_category)
VALUES ('2', 'Jewels of Stringology', 'Book');
INSERT INTO Products (product_id, product_name, product_category)
VALUES ('3', 'HP', 'Laptop');
INSERT INTO Products (product_id, product_name, product_category)
VALUES ('4', 'Lenovo', 'Laptop');
INSERT INTO Products (product_id, product_name, product_category)
VALUES ('5', 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('1', '2020-02-05', '60');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('1', '2020-02-10', '70');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('2', '2020-01-18', '30');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('2', '2020-02-11', '80');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('3', '2020-02-17', '2');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('3', '2020-02-24', '3');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('4', '2020-03-01', '20');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('4', '2020-03-04', '30');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('4', '2020-03-04', '60');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('5', '2020-02-25', '50');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('5', '2020-02-27', '50');
INSERT INTO Orders (product_id, order_date, unit)
VALUES ('5', '2020-03-01', '50');

/*
 要求获取在 2020 年 2 月份下单的数量不少于 100 的产品的名字和数目
 */
SELECT product_name, SUM(unit) AS unit
FROM Products,
     Orders
WHERE Products.product_id = Orders.product_id
  AND order_date BETWEEN '2020-02-02' AND '2020-02-29'
GROUP BY product_name;

SELECT product_name, SUM(unit) AS unit
FROM Products,
     Orders
WHERE Products.product_id = Orders.product_id
  AND order_date BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY product_name
HAVING SUM(unit) >= 100;

SELECT product_name, SUM(unit) >= 100 AS unit
FROM Products,
     Orders
WHERE Products.product_id = Orders.product_id
  AND order_date BETWEEN '2020-02-02' AND '2020-02-29'
GROUP BY product_name;


DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees
(
    id   int,
    name varchar(20)
);
CREATE TABLE IF NOT EXISTS EmployeeUNI
(
    id        int,
    unique_id int
);
TRUNCATE TABLE Employees;
INSERT INTO Employees (id, name)
VALUES ('1', 'Alice');
INSERT INTO Employees (id, name)
VALUES ('7', 'Bob');
INSERT INTO Employees (id, name)
VALUES ('11', 'Meir');
INSERT INTO Employees (id, name)
VALUES ('90', 'Winston');
INSERT INTO Employees (id, name)
VALUES ('3', 'Jonathan');
TRUNCATE TABLE EmployeeUNI;
INSERT INTO EmployeeUNI (id, unique_id)
VALUES ('3', '1');
INSERT INTO EmployeeUNI (id, unique_id)
VALUES ('11', '2');
INSERT INTO EmployeeUNI (id, unique_id)
VALUES ('90', '3');

/*
 写一段SQL查询来展示每位用户的 唯一标识码（unique ID ）；如果某位员工没有唯一标识码，使用 null 填充即可
 */

SELECT unique_id, name
FROM Employees
         LEFT JOIN EmployeeUNI ON Employees.id = EmployeeUNI.id;



DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Rides;
CREATE TABLE IF NOT EXISTS Users
(
    id   int,
    name varchar(30)
);
CREATE TABLE IF NOT EXISTS Rides
(
    id       int,
    user_id  int,
    distance int
);
TRUNCATE TABLE Users;
INSERT INTO Users (id, name)
VALUES ('1', 'Alice');
INSERT INTO Users (id, name)
VALUES ('2', 'Bob');
INSERT INTO Users (id, name)
VALUES ('3', 'Alex');
INSERT INTO Users (id, name)
VALUES ('4', 'Donald');
INSERT INTO Users (id, name)
VALUES ('7', 'Lee');
INSERT INTO Users (id, name)
VALUES ('13', 'Jonathan');
INSERT INTO Users (id, name)
VALUES ('19', 'Elvis');
TRUNCATE TABLE Rides;
INSERT INTO Rides (id, user_id, distance)
VALUES ('1', '1', '120');
INSERT INTO Rides (id, user_id, distance)
VALUES ('2', '2', '317');
INSERT INTO Rides (id, user_id, distance)
VALUES ('3', '3', '222');
INSERT INTO Rides (id, user_id, distance)
VALUES ('4', '7', '100');
INSERT INTO Rides (id, user_id, distance)
VALUES ('5', '13', '312');
INSERT INTO Rides (id, user_id, distance)
VALUES ('6', '19', '50');
INSERT INTO Rides (id, user_id, distance)
VALUES ('7', '7', '120');
INSERT INTO Rides (id, user_id, distance)
VALUES ('8', '19', '400');
INSERT INTO Rides (id, user_id, distance)
VALUES ('9', '7', '230');

/*
 写一段 SQL ,报告每个用户的旅行距离。

返回的结果表单，以travelled_distance降序排列 ，如果有两个或者更多的用户旅行了相同的距离,那么再以name升序排列

 */
SELECT *
FROM Users
         LEFT JOIN Rides ON Rides.user_id = Users.id;

SELECT name, SUM(distance) AS travelled_distance
FROM Users
         LEFT JOIN Rides ON Rides.user_id = Users.id
GROUP BY name
ORDER BY travelled_distance, name DESC;

SELECT name, SUM(distance) AS travelled_distance
FROM Users
         LEFT JOIN Rides ON Rides.user_id = Users.id
GROUP BY name
ORDER BY travelled_distance, name DESC;


SELECT t.name, IFNULL(t.travelled_distance, 0) AS travelled_distance
FROM (SELECT user_id, name, SUM(distance) AS travelled_distance
      FROM Users
               LEFT JOIN Rides ON Rides.user_id = Users.id
      GROUP BY user_id, name) AS t
ORDER BY t.travelled_distance DESC, t.name;


DROP TABLE IF EXISTS Activities;
CREATE TABLE IF NOT EXISTS Activities
(
    sell_date date,
    product   varchar(20)
);
TRUNCATE TABLE Activities;
INSERT INTO Activities (sell_date, product)
VALUES ('2020-05-30', 'Headphone');
INSERT INTO Activities (sell_date, product)
VALUES ('2020-06-01', 'Pencil');
INSERT INTO Activities (sell_date, product)
VALUES ('2020-06-02', 'Mask');
INSERT INTO Activities (sell_date, product)
VALUES ('2020-05-30', 'Basketball');
INSERT INTO Activities (sell_date, product)
VALUES ('2020-06-01', 'Bible');
INSERT INTO Activities (sell_date, product)
VALUES ('2020-06-02', 'Mask');
INSERT INTO Activities (sell_date, product)
VALUES ('2020-05-30', 'T-Shirt');

/*
 编写一个 SQL 查询来查找每个日期、销售的不同产品的数量及其名称。
 每个日期的销售产品名称应按词典序排列。
 返回按 sell_date 排序的结果表
 */

SELECT *
FROM Activities;

SELECT sell_date, COUNT(sell_date) AS num_sold
FROM Activities
GROUP BY sell_date;


SELECT sell_date, COUNT(DISTINCT product) AS num_sold, GROUP_CONCAT(DISTINCT product ORDER BY product) AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;
