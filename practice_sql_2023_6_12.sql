USE practice_sql;


DROP TABLE IF EXISTS Stocks;
CREATE TABLE IF NOT EXISTS Stocks
(
    stock_name    varchar(15),
    operation     ENUM ('Sell', 'Buy'),
    operation_day int,
    price         int
);
TRUNCATE TABLE Stocks;
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Leetcode', 'Buy', '1', '1000');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Corona Masks', 'Buy', '2', '10');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Leetcode', 'Sell', '5', '9000');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Handbags', 'Buy', '17', '30000');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Corona Masks', 'Sell', '3', '1010');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Corona Masks', 'Buy', '4', '1000');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Corona Masks', 'Sell', '5', '500');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Corona Masks', 'Buy', '6', '1000');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Handbags', 'Sell', '29', '7000');
INSERT INTO Stocks (stock_name, operation, operation_day, price)
VALUES ('Corona Masks', 'Sell', '10', '10000');


/*
 编写一个SQL查询来报告每支股票的资本损益。

股票的资本损益是一次或多次买卖股票后的全部收益或损失。

以任意顺序返回结果即可。
 */

SELECT *
FROM Stocks;

SELECT *, CASE WHEN operation = 'Buy' THEN -price ELSE price END AS newPrice
FROM Stocks;

SELECT stock_name, SUM(newPrice) AS capital_gain_loss
FROM (SELECT *, CASE WHEN operation = 'Buy' THEN -price ELSE price END AS newPrice FROM Stocks) AS TMP
GROUP BY stock_name;

DROP TABLE IF EXISTS Accounts;
CREATE TABLE IF NOT EXISTS Accounts
(
    account_id int,
    income     int
);
TRUNCATE TABLE Accounts;
INSERT INTO Accounts (account_id, income)
VALUES ('3', '108939');
INSERT INTO Accounts (account_id, income)
VALUES ('2', '12747');
INSERT INTO Accounts (account_id, income)
VALUES ('8', '87709');
INSERT INTO Accounts (account_id, income)
VALUES ('6', '91796');


/*
 写出一个SQL查询，来报告每个工资类别的银行账户数量。工资类别如下：
"Low Salary"：所有工资 严格低于 20000 美元。
"Average Salary"： 包含 范围内的所有工资[$20000,$50000] 。
"High Salary"：所有工资 严格大于 50000 美元。
结果表 必须 包含所有三个类别。如果某个类别中没有帐户，则报告0 。
按 任意顺序 返回结果表
 */

SELECT CASE
           WHEN income < 20000 THEN 'Low Salary'
           WHEN 20000 <= income <= 50000 THEN 'Average Salary'
           ELSE 'High Salary' END AS 'category',
       account_id,
       income
FROM Accounts;

WITH t AS (SELECT CASE
                      WHEN income < 20000 THEN 'Low Salary'
                      WHEN 20000 <= income <= 50000 THEN 'Average Salary'
                      ELSE 'High Salary' END AS 'category',
                  account_id,
                  income
           FROM Accounts)
SELECT 'Low Salary' AS 'category', SUM(category = 'Low Salary') AS 'accounts_count'
FROM t
UNION ALL
SELECT 'Average Salary' AS 'category', SUM(category = 'Average Salary') AS 'accounts_count'
FROM t
UNION ALL
SELECT 'High Salary' AS 'category', SUM(category = 'High Salary') AS 'accounts_count'
FROM t;


DROP TABLE IF EXISTS Signups;
DROP TABLE IF EXISTS Confirmations;
CREATE TABLE IF NOT EXISTS Signups
(
    user_id    int,
    time_stamp datetime
);
CREATE TABLE IF NOT EXISTS Confirmations
(
    user_id    int,
    time_stamp datetime,
    action     ENUM ('confirmed','timeout')
);
TRUNCATE TABLE Signups;
INSERT INTO Signups (user_id, time_stamp)
VALUES ('3', '2020-03-21 10:16:13');
INSERT INTO Signups (user_id, time_stamp)
VALUES ('7', '2020-01-04 13:57:59');
INSERT INTO Signups (user_id, time_stamp)
VALUES ('2', '2020-07-29 23:09:44');
INSERT INTO Signups (user_id, time_stamp)
VALUES ('6', '2020-12-09 10:39:37');
TRUNCATE TABLE Confirmations;
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES ('3', '2021-01-06 03:30:46', 'timeout');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES ('3', '2021-07-14 14:00:00', 'timeout');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES ('7', '2021-06-12 11:57:29', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES ('7', '2021-06-13 12:58:28', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES ('7', '2021-06-14 13:59:27', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES ('2', '2021-01-22 00:00:00', 'confirmed');
INSERT INTO Confirmations (user_id, time_stamp, action)
VALUES ('2', '2021-02-28 23:59:59', 'timeout');

/*
用户的 确认率是 'confirmed'消息的数量除以请求的确认消息的总数。没有请求任何确认消息的用户的确认率为0。确认率四舍五入到 小数点后两位 。
编写一个SQL查询来查找每个用户的 确认率 。
以 任意顺序返回结果表。

 */

SELECT *
FROM Confirmations,
     Signups
WHERE Signups.user_id = Confirmations.user_id;


SELECT t.user_id, ROUND(SUM(action = 'confirmed') / COUNT(*), 2) AS confirmation_rate
FROM (SELECT Confirmations.user_id, Confirmations.time_stamp, action
      FROM Confirmations,
           Signups
      WHERE Signups.user_id = Confirmations.user_id) AS t
GROUP BY t.user_id;

SELECT t.user_id, IFNULL(ROUND(SUM(action = 'confirmed') / COUNT(*), 2), 0) AS confirmation_rate
FROM (SELECT Signups.user_id, Confirmations.time_stamp, action
      FROM Signups
               LEFT JOIN Confirmations
                         ON Signups.user_id = Confirmations.user_id) AS t
GROUP BY t.user_id;


DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;
CREATE TABLE IF NOT EXISTS Employee
(
    id           int,
    name         varchar(255),
    salary       int,
    departmentId int
);
CREATE TABLE IF NOT EXISTS Department
(
    id   int,
    name varchar(255)
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('1', 'Joe', '85000', '1');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('2', 'Henry', '80000', '2');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('3', 'Sam', '60000', '2');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('4', 'Max', '90000', '1');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('5', 'Janet', '69000', '1');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('6', 'Randy', '85000', '1');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('7', 'Will', '70000', '1');
TRUNCATE TABLE Department;
INSERT INTO Department (id, name)
VALUES ('1', 'IT');
INSERT INTO Department (id, name)
VALUES ('2', 'Sales');

SELECT *, ROW_NUMBER() OVER (PARTITION BY departmentId ORDER BY salary DESC ) AS newSalary
FROM Employee
         LEFT JOIN Department ON departmentId = Department.id;


WITH t AS (SELECT Employee.name                                                       AS Employee,
                  Department.name                                                     AS Department,
                  salary                                                              AS Salary,
                  dense_rank() OVER (PARTITION BY departmentId ORDER BY salary DESC ) AS newSalary
           FROM Employee
                    LEFT JOIN Department ON departmentId = Department.id)
SELECT Department, Employee, Salary
FROM t
WHERE newSalary <= 3;




