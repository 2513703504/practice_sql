USE practice_sql;

DROP TABLE IF EXISTS Transactions;
CREATE TABLE IF NOT EXISTS Transactions
(
    id         int,
    country    varchar(4),
    state      enum ('approved', 'declined'),
    amount     int,
    trans_date date
);
TRUNCATE TABLE Transactions;
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES ('121', 'US', 'approved', '1000', '2018-12-18');
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES ('122', 'US', 'declined', '2000', '2018-12-19');
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES ('123', 'US', 'approved', '2000', '2019-01-01');
INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES ('124', 'DE', 'approved', '2000', '2019-01-07');

INSERT INTO Transactions (id, country, state, amount, trans_date)
VALUES (121, 'US', 'declined', 1000, '2018-12-18'),
       (122, 'US', 'declined', 2000, '2018-12-19'),
       (123, 'US', 'declined', 2000, '2019-01-01'),
       (124, 'DE', 'declined', 2000, '2019-01-07');
/*
 编写一个 sql 查询来查找每个月和每个国家/地区的事务数及其总金额、已批准的事务数及其总金额。
以 任意顺序 返回结果表。
 */

SELECT *
FROM Transactions;


SELECT SUBSTR(trans_date, 1, 7) AS month,
       country,
       COUNT(state)             AS trans_count,
       SUM(state = 'approved')  AS approved_count,
       SUM(amount)              AS trans_total_amount
FROM Transactions
GROUP BY country, month;

WITH t AS (SELECT SUBSTR(trans_date, 1, 7) AS month,
                  country,
                  COUNT(state)             AS trans_count,
                  SUM(state = 'approved')  AS approved_count,
                  SUM(amount)              AS trans_total_amount
           FROM Transactions
           GROUP BY country, month),
     t1 AS (SELECT SUBSTR(trans_date, 1, 7) AS month, country, SUM(amount) AS approved_total_amount
            FROM Transactions
            WHERE state = 'approved'
            GROUP BY country, month)
SELECT t.*, IFNULL(t1.approved_total_amount, 0) AS approved_total_amount
FROM t
         LEFT JOIN
     t1
     ON t1.month = t.month
         AND t.country = t1.country;

DROP TABLE IF EXISTS Queue;
CREATE TABLE IF NOT EXISTS Queue
(
    person_id   int,
    person_name varchar(30),
    weight      int,
    turn        int
);
TRUNCATE TABLE Queue;
INSERT INTO Queue (person_id, person_name, weight, turn)
VALUES ('5', 'Alice', '250', '1');
INSERT INTO Queue (person_id, person_name, weight, turn)
VALUES ('4', 'Bob', '175', '5');
INSERT INTO Queue (person_id, person_name, weight, turn)
VALUES ('3', 'Alex', '350', '2');
INSERT INTO Queue (person_id, person_name, weight, turn)
VALUES ('6', 'John Cena', '400', '3');
INSERT INTO Queue (person_id, person_name, weight, turn)
VALUES ('1', 'Winston', '500', '6');
INSERT INTO Queue (person_id, person_name, weight, turn)
VALUES ('2', 'Marie', '200', '4');

SELECT *
FROM Queue;

/*
 有一群人在等着上公共汽车。然而，巴士有1000公斤的重量限制，所以可能会有一些人不能上。

写一条 SQL 查询语句查找 最后一个 能进入电梯且不超过重量限制的 person_name 。题目确保队列中第一位的人可以进入电梯，不会超重。
 */

SELECT *
FROM Queue
ORDER BY turn;

WITH t AS (SELECT *
           FROM Queue
           ORDER BY turn),
     t2 AS (SELECT t.turn, SUM(t1.weight) AS weightCount
            FROM t
                     LEFT JOIN t AS t1 ON t.turn >= t1.turn
            GROUP BY t.turn
            ORDER BY t.turn)
SELECT Queue.person_name
FROM t2,
     Queue
WHERE t2.turn = Queue.turn
  AND weightCount <= 1000
ORDER BY weightCount DESC
LIMIT 0,1;

WITH t2 AS (SELECT t.turn, SUM(t1.weight) AS weightCount
            FROM Queue AS t
                     LEFT JOIN Queue AS t1 ON t.turn >= t1.turn
            GROUP BY t.turn
            ORDER BY t.turn)
SELECT Queue.person_name
FROM t2,
     Queue
WHERE t2.turn = Queue.turn
  AND weightCount <= 1000
ORDER BY weightCount DESC
LIMIT 0,1;

-- 窗口函数
SELECT person_name
FROM (SELECT person_name,
             SUM(weight) OVER (ORDER BY turn) total
      FROM Queue) a
WHERE total <= 1000
ORDER BY total DESC
LIMIT 1;

