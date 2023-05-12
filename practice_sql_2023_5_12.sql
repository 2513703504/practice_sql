USE practice_sql;
CREATE TABLE F0309
(
    ID      INT,
    Company VARCHAR(10),
    Salary  INT
);

INSERT INTO F0309
VALUES (1, 'A', 10000),
       (2, 'A', 9000),
       (3, 'A', 11000),
       (4, 'A', 8000),
       (5, 'B', 12000),
       (6, 'B', 13000),
       (7, 'B', 14000),
       (8, 'C', 12000),
       (9, 'C', 9000),
       (10, 'C', 9000),
       (11, 'C', 11000);

-- 求：每个公司员工薪资的中位数


SELECT *
FROM F0309;

SELECT *,
       -- 各薪水记录在其公司内的顺序编号
       ROW_NUMBER() OVER (PARTITION BY COMPANY ORDER BY SALARY) RNK,
       -- 各公司的薪水记录数
       COUNT(*) OVER (PARTITION BY COMPANY)                     NUM
FROM F0309;

SELECT Company, SUM(Salary) / COUNT(1) media
FROM (SELECT *,
             -- 各薪水记录在其公司内的顺序编号
             ROW_NUMBER() OVER (PARTITION BY COMPANY ORDER BY SALARY) RNK,
             -- 各公司的薪水记录数
             COUNT(*) OVER (PARTITION BY COMPANY)                     NUM
      FROM F0309) AS t
     -- 当行数为奇数时求中位数
WHERE (NUM % 2 = 1 OR RNK = FLOOR(NUM % 2) + 1)
   -- 当行数为偶数时求中位数
   OR (NUM % 2 = 0 AND (RNK = FLOOR(NUM / 2) OR RNK = FLOOR(NUM / 2) + 1))
GROUP BY Company;

