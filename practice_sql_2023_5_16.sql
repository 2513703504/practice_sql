USE practice_sql;

CREATE TABLE F0316
(
    ID  INT,
    NUM INT
);
INSERT INTO F0316
VALUES (1, 5),
       (2, 3),
       (3, 12),
       (4, 2),
       (5, 7),
       (6, 9);

-- 要求1：将NUM每行的值累加到下一行形成新的结果行
-- 注意：不能使用开窗函数！

SELECT b.ID, b.NUM, SUM(a.NUM) result
FROM F0316 a
         JOIN F0316 b
              ON a.ID <= b.ID
GROUP BY b.ID, b.NUM
ORDER BY b.ID;


CREATE TABLE F0321
(
    员工号   NVARCHAR(10),
    姓名     NVARCHAR(10),
    性别     NVARCHAR(2),
    类别     NVARCHAR(10),
    入职日期 DATE
);
INSERT INTO F0321
VALUES ('1001', '张三', '男', '普通', '2021-08-03');
INSERT INTO F0321
VALUES ('1002', '李四', '女', '管理', '2021-08-18');
INSERT INTO F0321
VALUES ('1003', '王五', '男', '普通', '2021-08-19');
INSERT INTO F0321
VALUES ('1004', '赵六', '女', '管理', '2021-08-04');

/*要求如下：
1）如果员工的类别是【普通】，则该员工的转正日期为【入职日期】后三个月；
   如果员工的类别是【管理】，则该员工的转正日期为【入职日期】后六个月；
2）如果员工的【入职日期】是当月15号前（含15号），
       则该员工的【社保缴纳月份】为【入职日期】的当月；
   如果员工的【入职日期】是当月15号后，
       则该员工的【社保缴纳月份】为【入职日期】的次月；
*/

SELECT * FROM F0321;

SELECT *,CASE WHEN 类别='普通' THEN
    date_add(入职日期,INTERVAL 3 MONTH )
    ELSE date_add(入职日期,INTERVAL 6 MONTH )
    END AS 转正日期,
    CASE WHEN extract(DAY FROM 入职日期)<=15
      THEN CONVERT(入职日期,CHAR (7))
      ELSE CONVERT((date_add(入职日期,INTERVAL 1 MONTH )),CHAR(7))
 END AS 社保缴纳月份 FROM F0321;
