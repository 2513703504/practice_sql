USE practice_sql;
CREATE TABLE F0310
(
    order_id VARCHAR(10),
    price    INT,
    oldkey   VARCHAR(20)
);

INSERT INTO F0310
VALUES ('1001', '10', '80-100');
INSERT INTO F0310
VALUES ('1001', '20', '90-200');
INSERT INTO F0310
VALUES ('1002', '30', '70-130');
INSERT INTO F0310
VALUES ('1002', '40', '80-140');
INSERT INTO F0310
VALUES ('1002', '50', '90-150');

-- 要求：将相同订单ID(order_id)的oldkey合并成一行，并且用逗号(,)隔开

SELECT *
FROM F0310;

SELECT *
FROM F0310 a,
     F0310 b
WHERE a.order_id = b.order_id
  AND a.oldkey <> b.oldkey;

SELECT *,
       (SELECT GROUP_CONCAT(b.oldkey, ' , ')
        FROM F0310 AS b
        WHERE A.order_id = b.order_id) AS newkey
FROM F0310 AS A;


CREATE TABLE F0314
(
    ID   INT,
    DATA VARCHAR(10)
);

INSERT INTO F0314
VALUES (1, '8'),
       (2, '88'),
       (3, '7,8'),
       (4, '6,7,8'),
       (5, '8,9'),
       (6, '7,88');

-- 要求：如何查询出Data列含有数字8的数据，
-- 注意：88不算，以及其他数字中有8的都不算，只需要数字8。


SELECT *
FROM F0314
WHERE CONCAT(',', DATA, ',') LIKE '%,8,%';