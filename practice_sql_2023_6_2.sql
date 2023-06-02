USE practice_sql;


DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees
(
    employee_id int,
    name        varchar(30),
    salary      int
);
TRUNCATE TABLE Employees;
INSERT INTO Employees (employee_id, name, salary)
VALUES ('2', 'Meir', '3000');
INSERT INTO Employees (employee_id, name, salary)
VALUES ('3', 'Michael', '3800');
INSERT INTO Employees (employee_id, name, salary)
VALUES ('7', 'Addilyn', '7400');
INSERT INTO Employees (employee_id, name, salary)
VALUES ('8', 'Juan', '6100');
INSERT INTO Employees (employee_id, name, salary)
VALUES ('9', 'Kannon', '7700');


/*
 写出一个SQL 查询语句，计算每个雇员的奖金。如果一个雇员的id是奇数并且他的名字不是以'M'开头，那么他的奖金是他工资的100%，否则奖金为0。

Return the result table ordered by employee_id.

返回的结果集请按照employee_id排序
 */

SELECT employee_id, CASE WHEN employee_id % 2 = 0 THEN 0 WHEN SUBSTR(name, 1, 1) = 'm' THEN 0 ELSE salary END AS bonus
FROM Employees
ORDER BY employee_id;


DROP TABLE IF EXISTS Logins;
CREATE TABLE IF NOT EXISTS Logins
(
    user_id    int,
    time_stamp datetime
);
TRUNCATE TABLE Logins;
INSERT INTO Logins (user_id, time_stamp)
VALUES ('6', '2020-06-30 15:06:07');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('6', '2021-04-21 14:06:06');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('6', '2019-03-07 00:18:15');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('8', '2020-02-01 05:10:53');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('8', '2020-12-30 00:46:50');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('2', '2020-01-16 02:49:50');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('2', '2019-08-25 07:59:08');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('14', '2019-07-14 09:00:00');
INSERT INTO Logins (user_id, time_stamp)
VALUES ('14', '2021-01-06 11:59:59');

/*
 编写一个 SQL 查询，该查询可以获取在 2020 年登录过的所有用户的本年度 最后一次 登录时间。结果集 不 包含 2020 年没有登录过的用户
 */


SELECT user_id, time_stamp
FROM Logins
WHERE time_stamp BETWEEN '2020-01-01' AND '2020-12-31';

SELECT user_id, time_stamp, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY time_stamp DESC ) AS rn
FROM Logins
WHERE time_stamp BETWEEN '2020-01-01' AND '2020-12-31';

WITH t AS (SELECT user_id, time_stamp, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY time_stamp DESC ) AS rn
           FROM Logins
           WHERE time_stamp BETWEEN '2020-01-01' AND '2021-01-01')
SELECT t.user_id, t.time_stamp AS last_stamp
FROM t
WHERE t.rn = 1;

DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Salaries;
CREATE TABLE IF NOT EXISTS Employees
(
    employee_id int,
    name        varchar(30)
);
CREATE TABLE IF NOT EXISTS Salaries
(
    employee_id int,
    salary      int
);
TRUNCATE TABLE Employees;
INSERT INTO Employees (employee_id, name)
VALUES ('2', 'Crew');
INSERT INTO Employees (employee_id, name)
VALUES ('4', 'Haven');
INSERT INTO Employees (employee_id, name)
VALUES ('5', 'Kristian');
TRUNCATE TABLE Salaries;
INSERT INTO Salaries (employee_id, salary)
VALUES ('5', '76071');
INSERT INTO Salaries (employee_id, salary)
VALUES ('1', '22517');
INSERT INTO Salaries (employee_id, salary)
VALUES ('4', '63539');

/*
 写出一个查询语句，找到所有 丢失信息 的雇员id。当满足下面一个条件时，就被认为是雇员的信息丢失：

雇员的 姓名 丢失了，或者
雇员的 薪水信息 丢失了，或者
返回这些雇员的id employee_id，从小到大排序

 */

/*
 Union：对两个结果集进行并集操作，不包括重复行，同时进行默认规则的排序；
 Union All：对两个结果集进行并集操作，包括重复行，不进行排序；
 Intersect：对两个结果集进行交集操作，不包括重复行，同时进行默认规则的排序；
 Minus：对两个结果集进行差操作，不包括重复行，同时进行默认规则的排序。

 */
SELECT E2.employee_id, E2.name, salary
FROM Employees E2
         LEFT JOIN Salaries ON Salaries.employee_id = E2.employee_id
UNION ALL
SELECT Salaries.employee_id, E.name, salary
FROM Salaries
         LEFT JOIN Employees E ON Salaries.employee_id = E.employee_id;

WITH T AS (SELECT E2.employee_id, E2.name, salary
           FROM Employees E2
                    LEFT JOIN Salaries ON Salaries.employee_id = E2.employee_id
           UNION ALL
           SELECT Salaries.employee_id, E.name, salary
           FROM Salaries
                    LEFT JOIN Employees E ON Salaries.employee_id = E.employee_id)
SELECT employee_id
FROM T
WHERE ISNULL(name)
   OR ISNULL(salary)
ORDER BY employee_id;


SELECT Salaries.employee_id
FROM Salaries
UNION ALL
SELECT employee_id
FROM Employees;

SELECT employee_id
FROM (SELECT Salaries.employee_id FROM Salaries UNION ALL SELECT employee_id FROM Employees) t
GROUP BY employee_id
HAVING COUNT(employee_id) = 1
ORDER BY employee_id;

DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees
(
    employee_id int,
    name        varchar(20),
    manager_id  int,
    salary      int
);
TRUNCATE TABLE Employees;
INSERT INTO Employees (employee_id, name, manager_id, salary)
VALUES ('3', 'Mila', '9', '60301');
INSERT INTO Employees (employee_id, name, manager_id, salary)
VALUES ('12', 'Antonella', NULL, '31000');
INSERT INTO Employees (employee_id, name, manager_id, salary)
VALUES ('13', 'Emery', NULL, '67084');
INSERT INTO Employees (employee_id, name, manager_id, salary)
VALUES ('1', 'Kalel', '11', '21241');
INSERT INTO Employees (employee_id, name, manager_id, salary)
VALUES ('9', 'Mikaela', NULL, '50937');
INSERT INTO Employees (employee_id, name, manager_id, salary)
VALUES ('11', 'Joziah', '6', '28485');

/*
 写一个查询语句，查询出，这些员工的id，他们的薪水严格少于$30000并且他们的上级经理已离职。当一个经理离开公司时，他们的信息需要从员工表中删除掉，但是表中的员工的manager_id 这一列还是设置的离职经理的id。

返回的结果按照employee_id从小到大排序
 */

SELECT employee_id
FROM Employees
WHERE salary < 30000
  AND manager_id NOT IN (SELECT employee_id FROM Employees)
ORDER BY employee_id;


DROP TABLE IF EXISTS Teacher;
CREATE TABLE IF NOT EXISTS Teacher
(
    teacher_id int,
    subject_id int,
    dept_id    int
);
TRUNCATE TABLE Teacher;
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES ('1', '2', '3');
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES ('1', '2', '4');
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES ('1', '3', '3');
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES ('2', '1', '1');
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES ('2', '2', '1');
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES ('2', '3', '1');
INSERT INTO Teacher (teacher_id, subject_id, dept_id)
VALUES ('2', '4', '1');

/*
 写一个 SQL 来查询每位老师在大学里教授的科目种类的数量。
以 任意顺序 返回结果表
 */

SELECT teacher_id, COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;

DROP TABLE IF EXISTS Employee;
CREATE TABLE IF NOT EXISTS Employee
(
    id     int,
    salary int
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (id, salary)
VALUES ('1', '4');

INSERT INTO Employee (id, salary)
VALUES ('2', '3');
INSERT INTO Employee (id, salary)
VALUES ('3', '3');
/*
 编写一个 SQL 查询，获取并返回 Employee 表中第二高的薪水 。如果不存在第二高的薪水，查询应该返回 null 。
 编写一个SQL查询来报告 Employee 表中第 n 高的工资。如果没有第 n 个最高工资，查询应该报告为 null
 */

SELECT *, dense_rank() OVER (ORDER BY salary DESC ) AS RN
FROM Employee;


WITH t AS (
    SELECT *, dense_rank() OVER (ORDER BY salary DESC ) AS RN FROM Employee
)SELECT if(max(RN)>1,(SELECT DISTINCT salary FROM t WHERE RN=2),NULL) AS SecondHighestSalary From t;


SELECT DISTINCT salary
FROM Employee
ORDER BY salary DESC
LIMIT 1,1;

SELECT (SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT 1,1) AS SecondHighestSalary;

CREATE FUNCTION getNthHighestSalary(N int) RETURNS int
READS SQL DATA
BEGIN
    SET N=N-1;
    RETURN (
        SELECT DISTINCT salary FROM Employee ORDER BY salary DESC LIMIT N,1
        );
END;

SELECT getNthHighestSalary(2);

DROP TABLE IF EXISTS Scores;
Create table If Not Exists Scores (id int, score DECIMAL(3,2));
Truncate table Scores;
insert into Scores (id, score) values ('1', '3.5');
insert into Scores (id, score) values ('2', '3.65');
insert into Scores (id, score) values ('3', '4.0');
insert into Scores (id, score) values ('4', '3.85');
insert into Scores (id, score) values ('5', '4.0');
insert into Scores (id, score) values ('6', '3.65');

/*
 编写 SQL 查询对分数进行排序。排名按以下规则计算:

分数应按从高到低排列。
如果两个分数相等，那么两个分数的排名应该相同。
在排名相同的分数后，排名数应该是下一个连续的整数。换句话说，排名之间不应该有空缺的数字。
按score降序返回结果表。
 */

SELECT * FROM Scores;

SELECT score,dense_rank() OVER (ORDER BY score DESC) AS `rank` FROM Scores;
