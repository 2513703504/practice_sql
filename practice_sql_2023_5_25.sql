USE practice_sql;

DROP TABLE IF EXISTS Salary;
CREATE TABLE IF NOT EXISTS Salary
(
    id     int,
    name   varchar(100),
    sex    char(1),
    salary int
);
TRUNCATE TABLE Salary;
INSERT INTO Salary (id, name, sex, salary)
VALUES ('1', 'A', 'm', '2500');
INSERT INTO Salary (id, name, sex, salary)
VALUES ('2', 'B', 'f', '1500');
INSERT INTO Salary (id, name, sex, salary)
VALUES ('3', 'C', 'm', '5500');
INSERT INTO Salary (id, name, sex, salary)
VALUES ('4', 'D', 'f', '500');

/*
 请你编写一个 SQL 查询来交换所有的 'f' 和 'm' （即，将所有 'f' 变为 'm' ，反之亦然），仅使用 单个 update 语句 ，且不产生中间临时表
 */

SELECT *
FROM Salary;

UPDATE Salary
SET sex=(CASE sex WHEN 'm' THEN 'f' ELSE 'm' END);


DROP TABLE IF EXISTS ActorDirector;
CREATE TABLE IF NOT EXISTS ActorDirector
(
    actor_id    int,
    director_id int,
    timestamp   int
);
TRUNCATE TABLE ActorDirector;
INSERT INTO ActorDirector (actor_id, director_id, timestamp)
VALUES ('1', '1', '0');
INSERT INTO ActorDirector (actor_id, director_id, timestamp)
VALUES ('1', '1', '1');
INSERT INTO ActorDirector (actor_id, director_id, timestamp)
VALUES ('1', '1', '2');
INSERT INTO ActorDirector (actor_id, director_id, timestamp)
VALUES ('1', '2', '3');
INSERT INTO ActorDirector (actor_id, director_id, timestamp)
VALUES ('1', '2', '4');
INSERT INTO ActorDirector (actor_id, director_id, timestamp)
VALUES ('2', '1', '5');
INSERT INTO ActorDirector (actor_id, director_id, timestamp)
VALUES ('2', '1', '6');

/*
 写一条SQL查询语句获取合作过至少三次的演员和导演的 id 对 (actor_id, director_id)
 */

SELECT *
FROM ActorDirector;

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3;


DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Product;
CREATE TABLE IF NOT EXISTS Sales
(
    sale_id    int,
    product_id int,
    year       int,
    quantity   int,
    price      int
);
CREATE TABLE IF NOT EXISTS Product
(
    product_id   int,
    product_name varchar(10)
);
TRUNCATE TABLE Sales;
INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES ('1', '100', '2008', '10', '5000');
INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES ('2', '100', '2009', '12', '5000');
INSERT INTO Sales (sale_id, product_id, year, quantity, price)
VALUES ('7', '200', '2011', '15', '9000');
TRUNCATE TABLE Product;
INSERT INTO Product (product_id, product_name)
VALUES ('100', 'Nokia');
INSERT INTO Product (product_id, product_name)
VALUES ('200', 'Apple');
INSERT INTO Product (product_id, product_name)
VALUES ('300', 'Samsung');

/*
 写一条SQL 查询语句获取 Sales 表中所有产品对应的 产品名称 product_name 以及该产品的所有 售卖年份 year 和 价格 price
 */

SELECT product_name, year, price
FROM Sales,
     Product
WHERE Sales.product_id = Product.product_id;

DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Employee;
CREATE TABLE IF NOT EXISTS Project
(
    project_id  int,
    employee_id int
);
CREATE TABLE IF NOT EXISTS Employee
(
    employee_id      int,
    name             varchar(10),
    experience_years int
);
TRUNCATE TABLE Project;
INSERT INTO Project (project_id, employee_id)
VALUES ('1', '1');
INSERT INTO Project (project_id, employee_id)
VALUES ('1', '2');
INSERT INTO Project (project_id, employee_id)
VALUES ('1', '3');
INSERT INTO Project (project_id, employee_id)
VALUES ('2', '1');
INSERT INTO Project (project_id, employee_id)
VALUES ('2', '4');
TRUNCATE TABLE Employee;
INSERT INTO Employee (employee_id, name, experience_years)
VALUES ('1', 'Khaled', '3');
INSERT INTO Employee (employee_id, name, experience_years)
VALUES ('2', 'Ali', '2');
INSERT INTO Employee (employee_id, name, experience_years)
VALUES ('3', 'John', '1');
INSERT INTO Employee (employee_id, name, experience_years)
VALUES ('4', 'Doe', '2');

/*
 请写一个 SQL 语句，查询每一个项目中员工的 平均 工作年限，精确到小数点后两位
 */

SELECT *
FROM Project,
     Employee
WHERE Project.employee_id = Employee.employee_id;

SELECT project_id, CAST(AVG(experience_years) AS DECIMAL(10, 2)) AS average_years
FROM Project,
     Employee
WHERE Project.employee_id = Employee.employee_id
GROUP BY project_id;

SELECT project_id, ROUND(AVG(experience_years, 2)) AS average_years
FROM Project,
     Employee
WHERE Project.employee_id = Employee.employee_id
GROUP BY project_id;


DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Sales;
CREATE TABLE IF NOT EXISTS Product
(
    product_id   int,
    product_name varchar(10),
    unit_price   int
);
CREATE TABLE IF NOT EXISTS Sales
(
    seller_id  int,
    product_id int,
    buyer_id   int,
    sale_date  date,
    quantity   int,
    price      int
);
TRUNCATE TABLE Product;
INSERT INTO Product (product_id, product_name, unit_price)
VALUES ('1', 'S8', '1000');
INSERT INTO Product (product_id, product_name, unit_price)
VALUES ('2', 'G4', '800');
INSERT INTO Product (product_id, product_name, unit_price)
VALUES ('3', 'iPhone', '1400');
TRUNCATE TABLE Sales;
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price)
VALUES ('1', '1', '1', '2019-01-21', '2', '2000');
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price)
VALUES ('1', '2', '2', '2019-02-17', '1', '800');
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price)
VALUES ('2', '2', '3', '2019-06-02', '1', '800');
INSERT INTO Sales (seller_id, product_id, buyer_id, sale_date, quantity, price)
VALUES ('3', '3', '4', '2019-05-13', '2', '2800');

/*
 编写一个SQL查询，报告2019年春季才售出的产品。即仅在2019-01-01至2019-03-31（含）之间出售的商品
 */

SELECT s.product_id
FROM Product p,
     Sales s
WHERE s.product_id = p.product_id
  AND s.sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31';

SELECT DISTINCT p.product_id, p.product_name
FROM Product p,
     Sales s
WHERE p.product_id = s.product_id
  AND p.product_id NOT IN (SELECT product_id FROM Sales WHERE sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31');