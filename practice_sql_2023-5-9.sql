USE practice_sql;


CREATE TABLE F0225
(
    requester_id INT,
    accepter_id  INT,
    accept_date  DATE
);

INSERT INTO F0225
VALUES (1, 2, '2016-6-3');
INSERT INTO F0225
VALUES (1, 3, '2016-6-8');
INSERT INTO F0225
VALUES (2, 3, '2016-6-8');
INSERT INTO F0225
VALUES (3, 4, '2016-6-9');

-- 要求：求出好友数最多的ID及其好友数量

SELECT *
FROM F0225;

USE practice_sql;
SELECT requester_id id, COUNT(requester_id) count
FROM F0225
GROUP BY requester_id
UNION ALL
SELECT accepter_id id, COUNT(accepter_id) count
FROM F0225
GROUP BY accepter_id;

SELECT id, SUM(count) AS m
FROM (SELECT requester_id id, COUNT(requester_id) count
      FROM F0225
      GROUP BY requester_id
      UNION ALL
      SELECT accepter_id id, COUNT(accepter_id) count
      FROM F0225
      GROUP BY accepter_id) AS tmp
GROUP BY tmp.id
ORDER BY m DESC
LIMIT 1;


-- 参考答案
-- SQL SERVER
# SELECT TOP 1 IDS ID,COUNT(*) CNT  FROM
# (
# SELECT REQUESTER_ID IDS FROM F0225
# UNION ALL
# SELECT ACCEPTER_ID IDS FROM F0225
# ) S
# GROUP BY IDS
# ORDER BY COUNT(*) DESC;

CREATE TABLE F0228
(
    ID   INT,
    场次 INT,
    结果 VARCHAR(10)
);

INSERT INTO F0228
VALUES (1, 34, '败');
INSERT INTO F0228
VALUES (3, 35, '胜');
INSERT INTO F0228
VALUES (5, 36, '胜');
INSERT INTO F0228
VALUES (8, 37, '败');
INSERT INTO F0228
VALUES (9, 38, '败');
INSERT INTO F0228
VALUES (11, 39, '败');
INSERT INTO F0228
VALUES (12, 40, '败');
INSERT INTO F0228
VALUES (15, 41, '胜');
INSERT INTO F0228
VALUES (17, 42, '胜');
INSERT INTO F0228
VALUES (20, 43, '败');
INSERT INTO F0228
VALUES (21, 44, '败');
INSERT INTO F0228
VALUES (23, 45, '败');
INSERT INTO F0228
VALUES (24, 46, '败');

-- 要求：查询出连续失败场次大于3的记录行
-- 创建表表达式CTEA，给表F0228添加虚列进行排序

SELECT *
FROM F0228;

-- 创建表表达式CTEA，给表F0228添加虚列进行排序
SELECT *, ROW_NUMBER() OVER (ORDER BY 场次) num1
FROM F0228;

WITH CTEA AS (SELECT *, ROW_NUMBER() OVER (ORDER BY 场次) num1
              FROM F0228)
SELECT *
FROM CTEA
WHERE CTEA.结果 = '败';

WITH CTEA AS (SELECT *, ROW_NUMBER() OVER (ORDER BY 场次) num1
              FROM F0228),
     CTEB AS (SELECT *,
                     ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次)        xl,
                     num1 - ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次) num2
              FROM CTEA)
SELECT *
FROM CTEB;

WITH CTEA AS (SELECT *, ROW_NUMBER() OVER (ORDER BY 场次) num1
              FROM F0228),
     CTEB AS (SELECT *,
                     ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次) xl
              FROM CTEA)
SELECT *
FROM CTEB;

WITH CTEA AS (SELECT *, ROW_NUMBER() OVER (ORDER BY 场次) num1
              FROM F0228),
     CTEB AS (SELECT *,
                     ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次)        xl,
                     num1 - ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次) num2
              FROM CTEA)
SELECT *
FROM CTEB;


WITH CTEA AS (SELECT *, ROW_NUMBER() OVER (ORDER BY 场次) num1
              FROM F0228),
     CTEB AS (SELECT *,
                     ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次)        xl,
                     num1 - ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次) num2
              FROM CTEA)
SELECT num2
FROM CTEB
GROUP BY num2
HAVING COUNT(1) > 3;

WITH CTEA AS (SELECT *, ROW_NUMBER() OVER (ORDER BY 场次) num1
              FROM F0228),
     CTEB AS (SELECT *,
                     ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次)        xl,
                     num1 - ROW_NUMBER() OVER (PARTITION BY 结果 ORDER BY 场次) num2
              FROM CTEA)
SELECT ID,
       场次,
       结果
FROM CTEB
WHERE num2 IN
      (SELECT num2
       FROM CTEB
       GROUP BY num2
       HAVING COUNT(1) > 3)