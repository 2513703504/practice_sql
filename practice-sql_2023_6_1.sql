USE practice_sql;


DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees
(
    employee_id int,
    name        varchar(20),
    reports_to  int,
    age         int
);
TRUNCATE TABLE Employees;
INSERT INTO Employees (employee_id, name, reports_to, age)
VALUES ('9', 'Hercy', NULL, '43');
INSERT INTO Employees (employee_id, name, reports_to, age)
VALUES ('6', 'Alice', '9', '41');
INSERT INTO Employees (employee_id, name, reports_to, age)
VALUES ('4', 'Bob', '9', '36');
INSERT INTO Employees (employee_id, name, reports_to, age)
VALUES ('2', 'Winston', NULL, '37');

/*
 对于此问题，我们将至少有一个其他员工需要向他汇报的员工，视为一个经理。

编写SQL查询需要听取汇报的所有经理的ID、名称、直接向该经理汇报的员工人数，以及这些员工的平均年龄，其中该平均年龄需要四舍五入到最接近的整数。

返回的结果集需要按照employee_id 进行排序。

 */


SELECT e2.employee_id, e2.name, COUNT(e.employee_id) AS reports_count, ROUND(AVG(e.age)) average_age
FROM Employees e,
     Employees e2
WHERE e.reports_to = e2.employee_id
GROUP BY e2.employee_id, e2.name
ORDER BY e2.employee_id;


DROP TABLE IF EXISTS Employees;
CREATE TABLE IF NOT EXISTS Employees
(
    emp_id    int,
    event_day date,
    in_time   int,
    out_time  int
);
TRUNCATE TABLE Employees;
INSERT INTO Employees (emp_id, event_day, in_time, out_time)
VALUES ('1', '2020-11-28', '4', '32');
INSERT INTO Employees (emp_id, event_day, in_time, out_time)
VALUES ('1', '2020-11-28', '55', '200');
INSERT INTO Employees (emp_id, event_day, in_time, out_time)
VALUES ('1', '2020-12-3', '1', '42');
INSERT INTO Employees (emp_id, event_day, in_time, out_time)
VALUES ('2', '2020-11-28', '3', '33');
INSERT INTO Employees (emp_id, event_day, in_time, out_time)
VALUES ('2', '2020-12-9', '47', '74');

/*
 编写一个SQL查询以计算每位员工每天在办公室花费的总时间（以分钟为单位）。 请注意，在一天之内，同一员工是可以多次进入和离开办公室的。 在办公室里一次进出所花费的时间为out_time 减去 in_time。
 */

SELECT event_day AS day, emp_id, SUM(out_time - in_time) AS total_time
FROM Employees
GROUP BY emp_id, event_day;


DROP TABLE IF EXISTS Products;
CREATE TABLE IF NOT EXISTS Products
(
    product_id int,
    low_fats   ENUM ('Y', 'N'),
    recyclable ENUM ('Y','N')
);
TRUNCATE TABLE Products;
INSERT INTO Products (product_id, low_fats, recyclable)
VALUES ('0', 'Y', 'N');
INSERT INTO Products (product_id, low_fats, recyclable)
VALUES ('1', 'Y', 'Y');
INSERT INTO Products (product_id, low_fats, recyclable)
VALUES ('2', 'N', 'Y');
INSERT INTO Products (product_id, low_fats, recyclable)
VALUES ('3', 'Y', 'Y');
INSERT INTO Products (product_id, low_fats, recyclable)
VALUES ('4', 'N', 'N');
/*
 写出 SQL 语句，查找既是低脂又是可回收的产品编号
 */


SELECT product_id
FROM Products
WHERE low_fats = 'Y'
  AND recyclable = 'Y';

DROP TABLE IF EXISTS Employee;
CREATE TABLE IF NOT EXISTS Employee
(
    employee_id   int,
    department_id int,
    primary_flag  ENUM ('Y','N')
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (employee_id, department_id, primary_flag)
VALUES ('1', '1', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag)
VALUES ('2', '1', 'Y');
INSERT INTO Employee (employee_id, department_id, primary_flag)
VALUES ('2', '2', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag)
VALUES ('3', '3', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag)
VALUES ('4', '2', 'N');
INSERT INTO Employee (employee_id, department_id, primary_flag)
VALUES ('4', '3', 'Y');
INSERT INTO Employee (employee_id, department_id, primary_flag)
VALUES ('4', '4', 'N');

/*
 一个员工可以属于多个部门。

当一个员工加入超过一个部门的时候，他需要决定哪个部门是他的直属部门。

请注意，当员工只加入一个部门的时候，那这个部门将默认为他的直属部门，虽然表记录的值为'N'
 */

SELECT employee_id, department_id
FROM Employee
WHERE primary_flag = 'Y'
   OR employee_id IN (SELECT employee_id FROM Employee GROUP BY employee_id HAVING COUNT(employee_id) = 1);


DROP TABLE IF EXISTS Products;
CREATE TABLE IF NOT EXISTS Products
(
    product_id int,
    store1     int,
    store2     int,
    store3     int
);
TRUNCATE TABLE Products;
INSERT INTO Products (product_id, store1, store2, store3)
VALUES ('0', '95', '100', '105');
INSERT INTO Products (product_id, store1, store2, store3)
VALUES ('1', '70', NULL, '80');


/*
 请你重构 Products 表，查询每个产品在不同商店的价格，使得输出的格式变为(product_id, store, price) 。如果这一产品在商店里没有出售，则不输出这一行。

输出结果表中的 顺序不作要求 。

 */

SELECT *
FROM Products;

SELECT product_id, 'store1' AS store, store1 AS price
FROM Products
WHERE ISNULL(store1) = 0
UNION
SELECT product_id, 'store2' AS store, store2 AS price
FROM Products
WHERE ISNULL(store2) = 0
UNION ALL
SELECT product_id, 'store3' AS store, store3 AS price
FROM Products
WHERE ISNULL(store3) = 0
ORDER BY product_id;