USE practice_sql;

DROP TABLE IF EXISTS `employee`;

-- 创建员工表employee
CREATE TABLE `employee`
(
    `id`         int,
    `name`       varchar(64),
    `department` varchar(20),
    `salary`     float,
    PRIMARY KEY (`id`)
);


INSERT INTO employee
VALUES (1, 'Alice', 'Sales', 5000),
       (2, 'Bob', 'Marketing', 6000),
       (3, 'Carol', 'Sales', 7000),
       (4, 'David', 'IT', 8000),
       (5, 'Eve', 'Marketing', 9000),
       (6, 'Frank', 'IT', 10000);


/*
 请编写一个 SQL 语句，查询每个部门的平均薪水，并按照平均薪水降序排列
 */
SELECT *
FROM employee;

SELECT department, AVG(salary) AS average_salary
FROM employee
GROUP BY department
ORDER BY average_salary DESC;



DROP TABLE IF EXISTS `courses`;

CREATE TABLE
    `courses`
(
    `id`            int UNSIGNED                                              NOT NULL AUTO_INCREMENT COMMENT '主键',
    `name`          varchar(64) CHARACTER SET utf8mb3 COLLATE utf8_general_ci NOT NULL COMMENT '课程名',
    `student_count` int UNSIGNED                                              NOT NULL COMMENT '学生人数',
    `created_at`    date                                                      NOT NULL COMMENT '课程创建时间',
    `teacher_id`    int UNSIGNED                                              NOT NULL COMMENT '教师id',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  AUTO_INCREMENT = 13
  DEFAULT CHARSET = utf8mb3
  ROW_FORMAT = DYNAMIC


/*
 请你编写 SQL 语句，查询 courses 表中课程名为 Web 的学生数量。
 */

SELECT student_count
FROM courses
WHERE name = 'web';

DROP TABLE IF EXISTS Logs;
CREATE TABLE IF NOT EXISTS Logs
(
    id  int,
    num int
);
TRUNCATE TABLE Logs;
INSERT INTO Logs (id, num)
VALUES ('1', '1');
INSERT INTO Logs (id, num)
VALUES ('2', '1');
INSERT INTO Logs (id, num)
VALUES ('3', '1');
INSERT INTO Logs (id, num)
VALUES ('4', '2');
INSERT INTO Logs (id, num)
VALUES ('5', '1');
INSERT INTO Logs (id, num)
VALUES ('6', '2');
INSERT INTO Logs (id, num)
VALUES ('7', '2');

/*
编写一个 SQL 查询，查找所有至少连续出现三次的数字。
返回的结果表中的数据可以按 任意顺序 排列
 */

SELECT *
FROM Logs;


SELECT DISTINCT num AS ConsecutiveNums
FROM Logs
WHERE (id + 1, num) IN (SELECT * FROM Logs)
  AND (id + 2, num) IN (SELECT * FROM Logs);



SELECT id,
       num,
       LEAD(num, 1) OVER () AS num_1,
       LEAD(num, 2) OVER () AS num_2
FROM Logs;


SELECT num AS ConsecutiveNums
FROM (SELECT id,
             num,
             LEAD(num, 1) OVER () AS num_1,
             LEAD(num, 2) OVER () AS num_2
      FROM Logs) AS t
WHERE num = num_1
  AND num = num_2;


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
VALUES ('1', 'Joe', '70000', '1');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('2', 'Jim', '90000', '1');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('3', 'Henry', '80000', '2');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('4', 'Sam', '60000', '2');
INSERT INTO Employee (id, name, salary, departmentId)
VALUES ('5', 'Max', '90000', '1');
TRUNCATE TABLE Department;
INSERT INTO Department (id, name)
VALUES ('1', 'IT');
INSERT INTO Department (id, name)
VALUES ('2', 'Sales');

/*
 编写SQL查询以查找每个部门中薪资最高的员工。
按 任意顺序 返回结果表。
查询结果格式如下例所示
 */

SELECT Employee.name, Department.name, salary, DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC ) AS rn
FROM Employee,
     Department
WHERE Department.id = departmentId;

WITH t AS (SELECT Employee.name                                                       AS Employee,
                  Department.name                                                     AS Department,
                  salary,
                  DENSE_RANK() OVER (PARTITION BY departmentId ORDER BY salary DESC ) AS rn
           FROM Employee,
                Department
           WHERE Department.id = departmentId)
SELECT Department, Employee, salary
FROM t
WHERE rn = 1;

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
VALUES ('1', '2', '2016-03-02', '6');
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('2', '3', '2017-06-25', '1');
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('3', '1', '2016-03-02', '0');
INSERT INTO Activity (player_id, device_id, event_date, games_played)
VALUES ('3', '4', '2018-07-03', '5');

/*
 编写一个 SQL 查询，报告在首次登录的第二天再次登录的玩家的比率，四舍五入到小数点后两位。
 换句话说，您需要计算从首次登录日期开始至少连续两天登录的玩家的数量，然后除以玩家总数
 */

SELECT *
FROM Activity;

SELECT *,
       CASE WHEN event_date THEN ADDDATE(event_date, INTERVAL 1 DAY) END AS date
FROM Activity;

WITH t AS (SELECT *,
                  CASE WHEN event_date THEN ADDDATE(event_date, INTERVAL 1 DAY) END AS date
           FROM Activity)
SELECT *
FROM t t1,
     t t2
WHERE t1.event_date = t2.date
  AND t1.player_id = t2.player_id;


WITH t AS (SELECT *,
                  CASE WHEN event_date THEN ADDDATE(event_date, INTERVAL 1 DAY) END AS date
           FROM Activity)
SELECT ROUND(COUNT(DISTINCT t1.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM t t1,
     t t2
WHERE t1.event_date = t2.date
  AND t1.player_id = t2.player_id;


WITH t AS (SELECT player_id, ADDDATE(MIN(event_date), INTERVAL 1 DAY) AS secondDay
           FROM Activity
           GROUP BY player_id)
SELECT ROUND(COUNT(DISTINCT t.player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM t,
     Activity
WHERE t.secondDay = Activity.event_date
  AND t.player_id = Activity.player_id;


DROP TABLE IF EXISTS Employee;
CREATE TABLE IF NOT EXISTS Employee
(
    id         int,
    name       varchar(255),
    department varchar(255),
    managerId  int
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (id, name, department, managerId)
VALUES ('101', 'John', 'A', NULL);
INSERT INTO Employee (id, name, department, managerId)
VALUES ('102', 'Dan', 'A', '101');
INSERT INTO Employee (id, name, department, managerId)
VALUES ('103', 'James', 'A', '101');
INSERT INTO Employee (id, name, department, managerId)
VALUES ('104', 'Amy', 'A', '101');
INSERT INTO Employee (id, name, department, managerId)
VALUES ('105', 'Anne', 'A', '101');
INSERT INTO Employee (id, name, department, managerId)
VALUES ('106', 'Ron', 'B', '101');

/*
编写一个SQL查询，查询至少有5名直接下属的经理 。
以 任意顺序 返回结果表。
 */

SELECT e2.id
FROM Employee e1,
     Employee e2
WHERE e1.managerId = e2.id
  AND ISNULL(e2.managerId)
GROUP BY e2.id
HAVING COUNT(e2.id) >= 5;

SELECT name
FROM Employee
WHERE id IN (SELECT e2.id
             FROM Employee e1,
                  Employee e2
             WHERE e1.managerId = e2.id
             GROUP BY e2.id
             HAVING COUNT(e2.id) >= 5);


DROP TABLE IF EXISTS Insurance;
CREATE TABLE IF NOT EXISTS Insurance
(
    pid      int,
    tiv_2015 float,
    tiv_2016 float,
    lat      float,
    lon      float
);
TRUNCATE TABLE Insurance;
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon)
VALUES ('1', '10', '5', '10', '10');
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon)
VALUES ('2', '20', '20', '20', '20');
INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon)
VALUES ('3', '10', '30', '20', '20');

INSERT INTO Insurance (pid, tiv_2015, tiv_2016, lat, lon)
VALUES (1, 224.17, 952.73, 32.4, 20.2),
       (2, 224.17, 900.66, 52.4, 32.7),
       (3, 824.61, 645.13, 72.4, 45.2),
       (4, 424.32, 323.66, 12.4, 7.7),
       (5, 424.32, 282.9, 12.4, 7.7),
       (6, 625.05, 243.53, 52.5, 32.8),
       (7, 424.32, 968.94, 72.5, 45.3),
       (8, 624.46, 714.13, 12.5, 7.8),
       (9, 425.49, 463.85, 32.5, 20.3),
       (10, 624.46, 776.85, 12.4, 7.7),
       (11, 624.46, 692.71, 72.5, 45.3),
       (12, 225.93, 933, 12.5, 7.8),
       (13, 824.61, 786.86, 32.6, 20.3),
       (14, 824.61, 935.34, 52.6, 32.8);

/*
 写一个查询语句，将2016 年 (TIV_2016) 所有成功投资的金额加起来，保留 2 位小数。

对于一个投保人，他在 2016 年成功投资的条件是：
他在 2015 年的投保额(TIV_2015) 至少跟一个其他投保人在 2015 年的投保额相同。
他所在的城市必须与其他投保人都不同（也就是说维度和经度不能跟其他任何一个投保人完全相同）。
 */

SELECT tiv_2015
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(tiv_2015) >= 2;

SELECT pid
FROM Insurance,
     (SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(tiv_2015) >= 2) AS t
WHERE t.tiv_2015 = Insurance.tiv_2015;

SELECT DISTINCT t1.pid
FROM Insurance t1,
     Insurance t2
WHERE t1.lat = t2.lat
  AND t1.lon = t2.lon
  AND t1.pid <> t2.pid;

SELECT *
FROM (SELECT pid AS pid1
      FROM Insurance,
           (SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(tiv_2015) >= 2) AS t
      WHERE t.tiv_2015 = Insurance.tiv_2015) AS tab1,
     (SELECT DISTINCT t1.pid AS pid2
      FROM Insurance t1,
           Insurance t
      WHERE t1.lat = t.lat
        AND t1.lon = t.lon
        AND t1.pid <> t.pid)
         AS tab2
WHERE pid2 = pid1;


WITH tab2 AS (SELECT DISTINCT t1.pid AS pid2, t1.tiv_2016
              FROM Insurance t1,
                   Insurance t
              WHERE t1.lat = t.lat
                AND t1.lon = t.lon
                AND t1.pid <> t.pid),
     tab1 AS (SELECT pid AS pid1, tiv_2016
              FROM Insurance,
                   (SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(tiv_2015) >= 2) AS t
              WHERE t.tiv_2015 = Insurance.tiv_2015),
     tab3 AS (SELECT pid1 AS pid3
              FROM tab1,
                   tab2
              WHERE pid2 = pid1)
SELECT CASE WHEN ISNULL(pid3) THEN pid1 END AS pid, tiv_2016
FROM tab1
         LEFT JOIN
     tab3
     ON tab3.pid3 = tab1.pid1;


SELECT ROUND(SUM(tmp.tiv_2016), 2) AS tiv_2016
FROM (WITH tab2 AS (SELECT DISTINCT t1.pid AS pid2, t1.tiv_2016
                    FROM Insurance t1,
                         Insurance t
                    WHERE t1.lat = t.lat
                      AND t1.lon = t.lon
                      AND t1.pid <> t.pid),
           tab1 AS (SELECT pid AS pid1, tiv_2016
                    FROM Insurance,
                         (SELECT tiv_2015 FROM Insurance GROUP BY tiv_2015 HAVING COUNT(tiv_2015) >= 2) AS t
                    WHERE t.tiv_2015 = Insurance.tiv_2015),
           tab3 AS (SELECT pid1 AS pid3
                    FROM tab1,
                         tab2
                    WHERE pid2 = pid1)
      SELECT CASE WHEN ISNULL(pid3) THEN pid1 END AS pid, tiv_2016
      FROM tab1
               LEFT JOIN
           tab3
           ON tab3.pid3 = tab1.pid1) AS tmp
WHERE ISNULL(pid) = 0;


SELECT ROUND(SUM(DISTINCT i1.TIV_2016), 2) AS TIV_2016
FROM Insurance i1,
     Insurance i2
WHERE i1.TIV_2015 = i2.TIV_2015
  AND i1.PID != i2.PID
  AND (i1.LAT, i1.LON) NOT IN (SELECT LAT, LON FROM Insurance i WHERE i1.PID != i.PID);



DROP TABLE IF EXISTS RequestAccepted;
CREATE TABLE IF NOT EXISTS RequestAccepted
(
    requester_id int  NOT NULL,
    accepter_id  int  NULL,
    accept_date  date NULL
);
TRUNCATE TABLE RequestAccepted;
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES ('1', '2', '2016/06/03');
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES ('1', '3', '2016/06/08');
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES ('2', '3', '2016/06/08');
INSERT INTO RequestAccepted (requester_id, accepter_id, accept_date)
VALUES ('3', '4', '2016/06/09');


/*
 写一个查询语句，找出拥有最多的好友的人和他拥有的好友数目。
 生成的测试用例保证拥有最多好友数目的只有 1 个人
 */

SELECT *
FROM RequestAccepted;

SELECT requester_id AS id
FROM RequestAccepted
UNION ALL
SELECT accepter_id
FROM RequestAccepted;

WITH t AS (SELECT requester_id AS id FROM RequestAccepted UNION ALL SELECT accepter_id FROM RequestAccepted)
SELECT id, COUNT(id) AS num
FROM t
GROUP BY id
ORDER BY num DESC
LIMIT 0,1;


DROP TABLE IF EXISTS Tree;
CREATE TABLE IF NOT EXISTS Tree
(
    id   int,
    p_id int
);
TRUNCATE TABLE Tree;
INSERT INTO Tree (id, p_id)
VALUES ('1', NULL);
INSERT INTO Tree (id, p_id)
VALUES ('2', '1');
INSERT INTO Tree (id, p_id)
VALUES ('3', '1');
INSERT INTO Tree (id, p_id)
VALUES ('4', '2');
INSERT INTO Tree (id, p_id)
VALUES ('5', '2');

/*
 树中每个节点属于以下三种类型之一：
叶子：如果这个节点没有任何孩子节点。
根：如果这个节点是整棵树的根，即没有父节点。
内部节点：如果这个节点既不是叶子节点也不是根节点。
 */

SELECT *
FROM Tree;

SELECT id,
       CASE WHEN ISNULL(p_id) = 1 THEN 'Root' WHEN id IN (SELECT p_id FROM Tree) THEN 'Inner' ELSE 'Leaf' END AS Type
FROM Tree;