USE practice_sql;
CREATE TABLE F0215
(
StuID INT,
CID VARCHAR(10),
Course INT
);

INSERT INTO F0215 VALUES
(1,'001',67),
(1,'002',89),
(1,'003',94),
(2,'001',95),
(2,'002',88),
(2,'004',78),
(3,'001',94),
(3,'002',77),
(3,'003',90);

/*
查询出既学过'001'课程，也学过'003'号课程的学生ID
*/
SELECT A.StuID
    FROM F0215 A,F0215 B
    WHERE A.CID='001' AND B.CID='003' AND A.StuID=B.StuID;

SELECT StuID
    FROM F0215
    WHERE CID='001' or CID='003' GROUP BY StuID HAVING count(StuID)=2;

CREATE TABLE F0216
(Num INT );

INSERT INTO F0216 VALUES
(1),(2),(3),
(4),(5),(6),
(7),(8),(9);

/*
求出每3个或2个不同数相加的和等于10，该如何求解，有多少个解？
*/

SELECT * FROM F0216;

SELECT a.Num a,b.Num b,NULL as c FROM F0216 a INNER JOIN F0216 b ON a.Num!=b.Num WHERE (a.Num+b.Num=10)
UNION ALL
SELECT tmp.a ,tmp.b,c.Num c FROM F0216 c INNER JOIN
    (SELECT a.Num a,b.Num b FROM F0216 a INNER JOIN F0216 b ON a.Num!=b.Num) as tmp
    ON 1=1
    WHERE tmp.a+tmp.b+c.Num=10 AND tmp.a!=c.Num AND tmp.b!=c.Num AND tmp.a!=tmp.b;