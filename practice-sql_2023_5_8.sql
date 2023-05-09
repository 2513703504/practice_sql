USE practice_sql;
CREATE TABLE F0217
(
ID INT,
Uname VARCHAR(20),
Price INT,
BuyDate VARCHAR(20)
);

INSERT INTO F0217 VALUES
(1,'张三',180,'2021/12/1'),
(2,'张三',280,'2021/12/7'),
(3,'李四',480,'2021/12/10'),
(4,'李四',280,'2021/12/11'),
(5,'王五',280,'2021/12/1'),
(6,'王五',880,'2021/12/11'),
(7,'王五',380,'2021/12/15');


select * from F0217;

-- 取所有记录中Uname的Price的最大值所对应的那行完整数据：

SELECT Uname FROM F0217 GROUP  BY Uname;

SELECT Uname,max(Price) as max_price FROM F0217 GROUP BY Uname;

SELECT F0217.* FROM F0217,(SELECT Uname,max(Price) as max_price FROM F0217 GROUP BY Uname) as tmp
    WHERE F0217.Price=tmp.max_price AND F0217.Uname=tmp.Uname;

-- ***************************************************************************************************

CREATE TABLE F0221A(stuID INT,classID VARCHAR(20),stuName VARCHAR(20));

INSERT INTO F0221A VALUES(1,'A','张三'),(2,'A','李四'),(3,'B','王五');

CREATE TABLE F0221B(classID VARCHAR(20),className VARCHAR(20));

INSERT INTO F0221B VALUES ('A','一班'),('B','二班');

CREATE TABLE F0221C(stuID INT,course VARCHAR(20),score INT);

INSERT INTO F0221C VALUES
(1,'语文',80),
(1,'数学',90),
(1,'英语',90),
(2,'语文',89),
(2,'数学',91),
(2,'英语',88),
(3,'语文',95),
(3,'数学',77),
(3,'英语',72);

SELECT * FROM F0221A;-- 学生表
SELECT * FROM F0221B;-- 班级表
SELECT * FROM F0221C;-- 成绩表

-- 要求：查询一班各科成绩最高的学生姓名和对应的分数？

SELECT stuID,stuName,className FROM F0221A,F0221B
         WHERE F0221A.classID=F0221B.classID;

SELECT course,score,stuName FROM F0221C,(SELECT stuID,stuName,className FROM F0221A,F0221B
         WHERE F0221A.classID=F0221B.classID) AS tmp
        WHERE F0221C.stuID=tmp.stuID AND className='一班';


SELECT course,max(score) AS score FROM F0221C GROUP BY course;

SELECT tmp.course,stuID,tmp.score FROM  F0221C JOIN (SELECT course,max(score) AS score FROM F0221C GROUP BY course) AS tmp
    WHERE tmp.score=F0221C.score AND tmp.course=F0221C.course ;


SELECT F0221A.stuName,tmp2.course,tmp2.score FROM F0221A JOIN (SELECT tmp.course,stuID,tmp.score FROM  F0221C JOIN (SELECT course,max(score) AS score FROM F0221C GROUP BY course) AS tmp
    WHERE tmp.score=F0221C.score AND tmp.course=F0221C.course) AS tmp2 JOIN F0221B
    WHERE tmp2.stuID=F0221A.stuID AND F0221B.classID=F0221A.classID AND F0221B.className='一班';


SELECT * FROM F0221A JOIN F0221B
    WHERE F0221B.classID=F0221A.classID;

SELECT F0221C.stuID,course,score,stuName FROM F0221C JOIN
       ( SELECT stuID,stuName,F0221A.classID,className FROM F0221A JOIN F0221B
        WHERE F0221B.classID=F0221A.classID) AS tmp
        WHERE F0221C.stuID=tmp.stuID AND className='一班';


SELECT course,max(score) FROM
        (SELECT F0221C.stuID,course,score,stuName FROM F0221C JOIN
       ( SELECT stuID,stuName,F0221A.classID,className FROM F0221A JOIN F0221B
        WHERE F0221B.classID=F0221A.classID) AS tmp
        WHERE F0221C.stuID=tmp.stuID AND className='一班') AS A
        GROUP BY course;


SELECT stuName,B.course,B.score FROM
        (SELECT F0221C.stuID,course,score,stuName FROM F0221C JOIN
       ( SELECT stuID,stuName,F0221A.classID,className FROM F0221A JOIN F0221B
        WHERE F0221B.classID=F0221A.classID) AS tmp
        WHERE F0221C.stuID=tmp.stuID AND className='一班') AS B,

        (SELECT course,max(score) AS score FROM
        (SELECT course,score FROM F0221C JOIN
       ( SELECT stuID,stuName,F0221A.classID,className FROM F0221A JOIN F0221B
        WHERE F0221B.classID=F0221A.classID) AS tmp
        WHERE F0221C.stuID=tmp.stuID AND className='一班') AS A
        GROUP BY course) AS C
        WHERE B.course=C.course AND B.score=C.score;



CREATE TABLE F0222
(
X INT
);
INSERT INTO F0222 VALUES
(-2),
(0),
(2),
(5);
-- 要求：找到这些点中最近两个点之间的距离

SELECT a.x m,b.x n FROM F0222 a INNER JOIN F0222 b WHERE a.X<>b.X;

SELECT min(abs(tmp.m-tmp.n)) AS min_length FROM
    (SELECT a.x m,b.x n FROM F0222 a INNER JOIN F0222 b WHERE a.X<>b.X) AS tmp;


CREATE TABLE F0224 (
ID INT,
金额 INT
);

INSERT INTO F0224 VALUES (2,30);
INSERT INTO F0224 VALUES (3,30);
INSERT INTO F0224 VALUES (4,30);
INSERT INTO F0224 VALUES (11,9);
INSERT INTO F0224 VALUES (12,1);
INSERT INTO F0224 VALUES (13,1);
INSERT INTO F0224 VALUES (14,15);
INSERT INTO F0224 VALUES (15,33);
INSERT INTO F0224 VALUES (16,5);
INSERT INTO F0224 VALUES (17,8);
INSERT INTO F0224 VALUES (18,14);
INSERT INTO F0224 VALUES (19,3);

SELECT * FROM F0224;
-- 要求：查询出从第一条记录开始到第几条记录 的累计金额刚好超过100？至少两种方法求解

SELECT sum(金额) FROM F0224 WHERE 金额;

SELECT MIN(t.ID)  from
        (SELECT b.ID ID,sum(a.金额) as m from F0224 a JOIN F0224 b ON b.ID>=a.ID GROUP BY b.ID HAVING m>100) t;

SELECT ID,sum(金额) OVER (ORDER BY ID) 金额 FROM F0224;