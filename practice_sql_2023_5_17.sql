USE practice_sql;
CREATE TABLE F0325
(
    ID           INT,
    NAMES        VARCHAR(20),
    Salary       INT,
    DepartmentID INT
);

INSERT INTO F0325
VALUES (1, '曹操', 85000, 1),
       (2, '关羽', 80000, 2),
       (3, '刘备', 60000, 2),
       (4, '吕布', 90000, 1),
       (5, '张飞', 69000, 1),
       (6, '赵云', 85000, 1),
       (7, '黄忠', 70000, 1);

CREATE TABLE F0325B
(
    ID   INT,
    Name VARCHAR(20)
);

INSERT INTO F0325B
VALUES (1, 'IT'),
       (2, 'Sales');

-- 要求：找出每个部门获得工资前三的所有员工


SELECT *
FROM F0325;

SELECT F0325.ID, F0325.NAMES, F0325.Salary, F0325B.Name AS Department_Name
FROM F0325
         LEFT JOIN F0325B ON F0325.DepartmentID = F0325B.ID;

SELECT *, ROW_NUMBER() OVER (PARTITION BY Department_Name ORDER BY Salary DESC ) AS RN
FROM (SELECT F0325.ID, F0325.NAMES, F0325.Salary, F0325B.Name AS Department_Name
      FROM F0325
               LEFT JOIN F0325B ON F0325.DepartmentID = F0325B.ID) AS tmp;

SELECT tmp2.NAMES, tmp2.Salary
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY Department_Name ORDER BY Salary DESC ) AS RN
      FROM (SELECT F0325.ID, F0325.NAMES, F0325.Salary, F0325B.Name AS Department_Name
            FROM F0325
                     LEFT JOIN F0325B ON F0325.DepartmentID = F0325B.ID) AS tmp) AS tmp2
WHERE tmp2.RN <= 3;

CREATE TABLE F0329
(
    workid  VARCHAR(20),
    RecDate DATE,
    RecTime VARCHAR(20),
    Time4   VARCHAR(20)
);
INSERT INTO F0329
VALUES ('161181', '2021-05-03', '13:01', '13:01');
INSERT INTO F0329
VALUES ('161181', '2021-05-03', '14:01', '15:01');
INSERT INTO F0329
VALUES ('161181', '2021-05-06', '13:01', '13:01');
INSERT INTO F0329
VALUES ('161182', '2021-05-07', '13:01', '17:01');
INSERT INTO F0329
VALUES ('161182', '2021-05-07', '13:01', '18:01');
INSERT INTO F0329
VALUES ('161182', '2021-05-09', '13:01', '19:01');

-- 要求：希望 按工号查找 日期(RecDate)相同且记录数>1， 且Rectime=Time4

SELECT *
FROM F0329;

SELECT workid, RecDate
FROM F0329
GROUP BY workid, RecDate
HAVING COUNT(1) > 1;

SELECT *
FROM F0329
         LEFT JOIN (SELECT workid, RecDate
                    FROM F0329
                    GROUP BY workid, RecDate
                    HAVING COUNT(1) > 1) AS b ON b.workid = F0329.workid AND F0329.RecDate = b.RecDate
WHERE F0329.RecTime = F0329.Time4;

