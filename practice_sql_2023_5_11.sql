USE practice_sql;

CREATE TABLE F0308
(
    user_id INT,
    times   DATETIME
);

INSERT INTO F0308
VALUES (1, '2021-12-7 21:13:07');
INSERT INTO F0308
VALUES (1, '2021-12-7 21:15:26');
INSERT INTO F0308
VALUES (1, '2021-12-7 21:17:44');
INSERT INTO F0308
VALUES (2, '2021-12-13 21:14:06');
INSERT INTO F0308
VALUES (2, '2021-12-13 21:18:19');
INSERT INTO F0308
VALUES (2, '2021-12-13 21:20:36');
INSERT INTO F0308
VALUES (3, '2021-12-21 21:16:51');
INSERT INTO F0308
VALUES (4, '2021-12-16 22:22:08');
INSERT INTO F0308
VALUES (4, '2021-12-2 21:17:22');
INSERT INTO F0308
VALUES (4, '2021-12-30 15:15:44');
INSERT INTO F0308
VALUES (4, '2021-12-30 15:17:57');

-- 要求：求每个用户相邻两次浏览时间之差小于三分钟的次数

SELECT *
FROM F0308;


SELECT user_id, times, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY times) rn
FROM F0308
GROUP BY user_id, times;

WITH t AS (SELECT user_id, times, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY times) rn
           FROM F0308
           GROUP BY user_id, times)
SELECT a.user_id, a.cn
FROM (SELECT a.user_id,
             ABS(MINUTE(IFNULL(a.times, '1970-01-01 00:00:00')) - MINUTE(IFNULL(b.times, '1970-01-01 00:00:00'))) AS cn
      FROM t a
               LEFT JOIN t b ON a.rn = b.rn + 1 AND a.user_id = b.user_id) AS a;

WITH t AS (SELECT user_id, times, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY times) rn
           FROM F0308
           GROUP BY user_id, times)
SELECT a.user_id, SUM(CASE WHEN a.cn < 3 THEN 1 ELSE 0 END) cnt
FROM (SELECT a.user_id,
             ABS(MINUTE(IFNULL(a.times, '1970-01-01 00:00:00')) - MINUTE(IFNULL(b.times, '1970-01-01 00:00:00'))) AS cn
      FROM t a
               LEFT JOIN t b ON a.rn = b.rn + 1 AND a.user_id = b.user_id) AS a
GROUP BY a.user_id;

SELECT DATEDIFF('2021-12-30 15:15:44', '2021-12-30 15:17:57');
SELECT MINUTE((IFNULL('2021-12-30 15:15:44', '1970-01-01 00:00:00')));