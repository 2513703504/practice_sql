USE
practice_sql;
CREATE TABLE F0303
(
    工序     INT,
    部门编号 INT NOT NULL,
    完成数量 INT NOT NULL
);
INSERT INTO F0303
VALUES (10, 222, 1500);
INSERT INTO F0303
VALUES (20, 223, 1497);
INSERT INTO F0303
VALUES (30, 223, 1499);
INSERT INTO F0303
VALUES (40, 223, 1498);
INSERT INTO F0303
VALUES (50, 213, 1497);
INSERT INTO F0303
VALUES (60, 224, 1497);
INSERT INTO F0303
VALUES (70, 224, 1497);
INSERT INTO F0303
VALUES (80, 220, 1496);
INSERT INTO F0303
VALUES (90, 220, 1496);
INSERT INTO F0303
VALUES (100, 224, 0);

-- 要求：按工序排序，相邻的行，如果有部门相同的情况，取工序号最大的那一行记录？

SELECT *
FROM F0303;
-- 行偏移开窗函数：LEAD(被偏移的列,向前偏移行数,超出分区返回的默认值) OVER ()
WITH list AS (SELECT *,
                     LEAD(部门编号, 1, NULL) OVER (ORDER BY 工序) PreviousDept, LEAD(部门编号, 2, NULL) OVER (ORDER BY 工序) Previous2Dept, LAG(部门编号, 1, 0) OVER (ORDER BY 工序) NextDept
              FROM F0303)
SELECT 工序, 部门编号, 完成数量
FROM list
WHERE 部门编号 <> PreviousDept
   OR PreviousDept IS NULL;



CREATE TABLE F0307
(
    ID          INT,
    PRODUCTNAME VARCHAR(64),
    PARENTID    INT
);

INSERT INTO F0307
VALUES (1, '汽车', NULL);
INSERT INTO F0307
VALUES (2, '车身', 1);
INSERT INTO F0307
VALUES (3, '发动机', 1);
INSERT INTO F0307
VALUES (4, '车门', 2);
INSERT INTO F0307
VALUES (5, '驾驶舱', 2);
INSERT INTO F0307
VALUES (6, '行李舱', 2);
INSERT INTO F0307
VALUES (7, '气缸', 3);
INSERT INTO F0307
VALUES (8, '活塞', 3);

-- 要求：根据父ID（PARENTID）来逐级显示产品名和层级序号

SELECT PRODUCTNAME, ID
FROM F0307
WHERE PARENTID IS NULL;

SELECT PRODUCTNAME, ID
FROM F0307
WHERE PARENTID = (SELECT ID FROM F0307 WHERE PARENTID IS NULL);

SELECT ID, PARENTID, PRODUCTNAME, 0 CTELEVEL, CAST(ID AS CHAR) ORDERID
FROM F0307
WHERE ID = 1;

SELECT *
FROM F0307;
WITH RECURSIVE CTE AS (SELECT ID, PARENTID, PRODUCTNAME, 0 CTELEVEL, CAST(ID AS CHAR) ORDERID
                       FROM F0307
                       WHERE ID = 1
                       UNION ALL
                       -- 递归成员，执行循环操作的部分
                       SELECT A.ID,
                              A.PARENTID,
                              A.PRODUCTNAME,
                              B.CTELEVEL + 1,
                              CAST(concat(B.ORDERID, '->', LTRIM(A.ID)) AS CHAR)
                       FROM F0307 A
                                JOIN CTE B ON B.ID = A.PARENTID)
SELECT *
FROM CTE;



WITH RECURSIVE CTE AS (SELECT ID, PARENTID, PRODUCTNAME, 0 CTELEVEL, CAST(ID AS CHAR) ORDERID
                       FROM F0307
                       WHERE ID = 1
                       UNION ALL
                       -- 递归成员，执行循环操作的部分
                       SELECT A.ID,
                              A.PARENTID,
                              A.PRODUCTNAME,
                              B.CTELEVEL + 1,
                              CAST(concat(B.ORDERID, '->', LTRIM(A.ID)) AS CHAR)
                       FROM F0307 A
                                JOIN CTE B ON B.ID = A.PARENTID)

               -- 关联CTE自己，通常是子ID与父ID进行关联
SELECT ID,
       PARENTID,
       CTELEVEL,
       concat(RIGHT('           ',4*CTELEVEL),PRODUCTNAME) AS PRODUCTNAME,
       ORDERID
FROM CTE
ORDER BY ORDERID;