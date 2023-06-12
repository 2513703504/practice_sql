USE practice_sql;

DROP TABLE IF EXISTS Customer;
CREATE TABLE IF NOT EXISTS Customer
(
    customer_id int,
    name        varchar(20),
    visited_on  date,
    amount      int
);
TRUNCATE TABLE Customer;
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('1', 'Jhon', '2019-01-01', '100');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('2', 'Daniel', '2019-01-02', '110');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('3', 'Jade', '2019-01-03', '120');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('4', 'Khaled', '2019-01-04', '130');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('5', 'Winston', '2019-01-05', '110');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('6', 'Elvis', '2019-01-06', '140');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('7', 'Anna', '2019-01-07', '150');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('8', 'Maria', '2019-01-08', '80');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('9', 'Jaze', '2019-01-09', '110');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('1', 'Jhon', '2019-01-10', '130');
INSERT INTO Customer (customer_id, name, visited_on, amount)
VALUES ('3', 'Jade', '2019-01-10', '150');


/*
 你是餐馆的老板，现在你想分析一下可能的营业额变化增长（每天至少有一位顾客）。
 写一条 SQL 查询计算以 7 天（某日期 + 该日期前的 6 天）为一个时间段的顾客消费平均值。average_amount 要 保留两位小数。
 查询结果按 visited_on 排序
 */
SELECT *
FROM Customer;

SELECT DISTINCT visited_on,                                                                                        # 因为窗口函数是按照日期计算的。所以相同日期的结果也是相同的，直接去重即可
                SUM(amount) OVER (ORDER BY visited_on RANGE INTERVAL 6 DAY PRECEDING)               amount,        # 按照日期排序，范围是当前日期和当前日期的前六天
                ROUND(SUM(amount) OVER (ORDER BY visited_on RANGE INTERVAL 6 DAY PRECEDING) / 7, 2) average_amount # 同理
FROM Customer;


# 只取排序第7天开始的数据，也就是从第七天开始
SELECT visited_on, amount, average_amount
FROM (
#重点来了，使用了3个窗口函数，分别是排序函数，移动总和，移动平均
# 不懂的话，先学下窗口函数，特别是移动总和、移动平均的结果
         SELECT visited_on,
                ROW_NUMBER() OVER (ORDER BY visited_on)                           rnum,
                SUM(amount) OVER (ORDER BY visited_on ROWS 6 PRECEDING)           amount,
                ROUND(AVG(amount) OVER (ORDER BY visited_on ROWS 6 PRECEDING), 2) average_amount
         FROM
#先把表整理下，求出每天的交易总额,并按照时间排序（可以不用排，时间都是由小到大的）
(SELECT visited_on, SUM(amount) AS amount FROM Customer GROUP BY visited_on ORDER BY visited_on) t1) t3
WHERE rnum > 6;


DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS MovieRating;
CREATE TABLE IF NOT EXISTS Movies
(
    movie_id int,
    title    varchar(30)
);
CREATE TABLE IF NOT EXISTS Users
(
    user_id int,
    name    varchar(30)
);
CREATE TABLE IF NOT EXISTS MovieRating
(
    movie_id   int,
    user_id    int,
    rating     int,
    created_at date
);
TRUNCATE TABLE Movies;
INSERT INTO Movies (movie_id, title)
VALUES ('1', 'Avengers');
INSERT INTO Movies (movie_id, title)
VALUES ('2', 'Frozen 2');
INSERT INTO Movies (movie_id, title)
VALUES ('3', 'Joker');
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, name)
VALUES ('1', 'Daniel');
INSERT INTO Users (user_id, name)
VALUES ('2', 'Monica');
INSERT INTO Users (user_id, name)
VALUES ('3', 'Maria');
INSERT INTO Users (user_id, name)
VALUES ('4', 'James');
TRUNCATE TABLE MovieRating;
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('1', '1', '3', '2020-01-12');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('1', '2', '4', '2020-02-11');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('1', '3', '2', '2020-02-12');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('1', '4', '1', '2020-01-01');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('2', '1', '5', '2020-02-17');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('2', '2', '2', '2020-02-01');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('2', '3', '2', '2020-03-01');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('3', '1', '3', '2020-02-22');
INSERT INTO MovieRating (movie_id, user_id, rating, created_at)
VALUES ('3', '2', '4', '2020-02-25');


/*
 请你编写一组 SQL 查询：

查找评论电影数量最多的用户名。如果出现平局，返回字典序较小的用户名。
查找在 February 2020 平均评分最高 的电影名称。如果出现平局，返回字典序较小的电影名称。
字典序 ，即按字母在字典中出现顺序对字符串排序，字典序较小则意味着排序靠前。

 */

SELECT (SELECT name
        FROM MovieRating,Users U WHERE MovieRating.user_id = U.user_id
        GROUP BY U.user_id, name
        ORDER BY COUNT(U.user_id) DESC, name
        LIMIT 1) AS result
UNION ALL
(SELECT title
 FROM MovieRating,Movies WHERE Movies.movie_id = MovieRating.movie_id
 AND MONTH(created_at) = 2
 GROUP BY MovieRating.movie_id, title
 ORDER BY AVG(rating) DESC, title
 LIMIT 1);