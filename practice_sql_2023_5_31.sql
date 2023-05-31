USE practice_sql;


DROP TABLE IF EXISTS Activity;
CREATE TABLE IF NOT EXISTS Activity
(
    machine_id    int,
    process_id    int,
    activity_type ENUM ('start', 'end'),
    timestamp     float
);
TRUNCATE TABLE Activity;
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '0', 'start', '0.712');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '0', 'end', '1.52');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '1', 'start', '3.14');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('0', '1', 'end', '4.12');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '0', 'start', '0.55');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '0', 'end', '1.55');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '1', 'start', '0.43');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('1', '1', 'end', '1.42');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '0', 'start', '4.1');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '0', 'end', '4.512');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '1', 'start', '2.5');
INSERT INTO Activity (machine_id, process_id, activity_type, timestamp)
VALUES ('2', '1', 'end', '5');


SELECT *
FROM Activity;

/*
 现在有一个工厂网站由几台机器运行，每台机器上运行着相同数量的进程. 请写出一条SQL计算每台机器各自完成一个进程任务的平均耗时.

完成一个进程任务的时间指进程的'end' 时间戳 减去 'start' 时间戳. 平均耗时通过计算每台机器上所有进程任务的总耗费时间除以机器上的总进程数量获得.

结果表必须包含machine_id（机器ID） 和对应的average time（平均耗时）别名processing_time, 且四舍五入保留3位小数

 */

SELECT machine_id, SUM(timestamp) AS start
FROM Activity
WHERE activity_type = 'start'
GROUP BY machine_id, activity_type;
SELECT machine_id, SUM(timestamp) AS end
FROM Activity
WHERE activity_type = 'end'
GROUP BY machine_id, activity_type;

WITH t AS (SELECT machine_id, SUM(timestamp) AS end
           FROM Activity
           WHERE activity_type = 'end'
           GROUP BY machine_id, activity_type),
     t2 AS (SELECT machine_id, SUM(timestamp) AS start, COUNT(timestamp) AS times
            FROM Activity
            WHERE activity_type = 'start'
            GROUP BY machine_id, activity_type)
SELECT t.machine_id, ROUND((t.end - t2.start) / t2.times, 3) AS processing_time
FROM t,
     t2
WHERE t.machine_id = t2.machine_id;


DROP TABLE IF EXISTS Users;
CREATE TABLE IF NOT EXISTS Users
(
    user_id int,
    name    varchar(40)
);
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, name)
VALUES ('1', 'aLice');
INSERT INTO Users (user_id, name)
VALUES ('2', 'bOB');

/*
 编写一个 SQL 查询来修复名字，使得只有第一个字符是大写的，其余都是小写的。
 返回按 user_id 排序的结果表
 */

SELECT *
FROM Users;

SELECT user_id, CONCAT(UPPER(SUBSTRING(name, 1, 1)), LOWER(SUBSTRING(name, 2, LENGTH(name) - 1))) AS name
FROM Users
ORDER BY user_id;


DROP TABLE IF EXISTS Tweets;
CREATE TABLE IF NOT EXISTS Tweets
(
    tweet_id int,
    content  varchar(50)
);
TRUNCATE TABLE Tweets;
INSERT INTO Tweets (tweet_id, content)
VALUES ('1', 'Vote for Biden');
INSERT INTO Tweets (tweet_id, content)
VALUES ('2', 'Let us make America great again!');

/*
 写一条 SQL 语句，查询所有无效推文的编号（ID）。当推文内容中的字符数严格大于 15 时，该推文是无效的
 */

SELECT tweet_id
FROM Tweets
WHERE LENGTH(content) > 15;


DROP TABLE IF EXISTS DailySales;
CREATE TABLE IF NOT EXISTS DailySales
(
    date_id    date,
    make_name  varchar(20),
    lead_id    int,
    partner_id int
);
TRUNCATE TABLE DailySales;
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-8', 'toyota', '0', '1');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-8', 'toyota', '1', '0');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-8', 'toyota', '1', '2');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-7', 'toyota', '0', '2');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-7', 'toyota', '0', '1');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-8', 'honda', '1', '2');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-8', 'honda', '2', '1');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-7', 'honda', '0', '1');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-7', 'honda', '1', '2');
INSERT INTO DailySales (date_id, make_name, lead_id, partner_id)
VALUES ('2020-12-7', 'honda', '2', '1');

SELECT *
FROM DailySales;

/*
 写一条 SQL 语句，使得对于每一个 date_id 和 make_name，返回不同的 lead_id 以及不同的 partner_id 的数量
 */

SELECT date_id, make_name, COUNT(DISTINCT lead_id) AS unique_leads, COUNT(DISTINCT partner_id) AS unique_partners
FROM DailySales
GROUP BY date_id, make_name;

DROP TABLE IF EXISTS Followers;
CREATE TABLE IF NOT EXISTS Followers
(
    user_id     int,
    follower_id int
);
TRUNCATE TABLE Followers;
INSERT INTO Followers (user_id, follower_id)
VALUES ('0', '1');
INSERT INTO Followers (user_id, follower_id)
VALUES ('1', '0');
INSERT INTO Followers (user_id, follower_id)
VALUES ('2', '0');
INSERT INTO Followers (user_id, follower_id)
VALUES ('2', '1');

/*
 写出 SQL 语句，对于每一个用户，返回该用户的关注者数量。

按 user_id 的顺序返回结果表
 */

SELECT *
FROM Followers;

SELECT user_id, COUNT(follower_id) AS count_followers
FROM Followers
GROUP BY user_id
ORDER BY user_id;