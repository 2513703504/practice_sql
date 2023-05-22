USE practice_sql;

CREATE TABLE IF NOT EXISTS Person
(
    personId  int,
    firstName varchar(255),
    lastName  varchar(255)
);
CREATE TABLE IF NOT EXISTS Address
(
    addressId int,
    personId  int,
    city      varchar(255),
    state     varchar(255)
);
TRUNCATE TABLE Person;
INSERT INTO Person (personId, lastName, firstName)
VALUES ('1', 'Wang', 'Allen');
INSERT INTO Person (personId, lastName, firstName)
VALUES ('2', 'Alice', 'Bob');
TRUNCATE TABLE Address;
INSERT INTO Address (addressId, personId, city, state)
VALUES ('1', '2', 'New York City', 'New York');
INSERT INTO Address (addressId, personId, city, state)
VALUES ('2', '3', 'Leetcode', 'California');

SELECT *
FROM Address;
SELECT *
FROM Person;

/*编写一个SQL查询来报告 Person 表中每个人的姓、名、城市和州。如果 personId 的地址不在Address表中，则报告为空 null。

以任意顺序 返回结果表。
 */

SELECT firstName, lastName, city, state
FROM Person
         LEFT JOIN Address ON Person.personId = Address.personId;

CREATE TABLE IF NOT EXISTS Employee
(
    id        int,
    name      varchar(255),
    salary    int,
    managerId int
);
TRUNCATE TABLE Employee;
INSERT INTO Employee (id, name, salary, managerId)
VALUES ('1', 'Joe', '70000', '3');
INSERT INTO Employee (id, name, salary, managerId)
VALUES ('2', 'Henry', '80000', '4');
INSERT INTO Employee (id, name, salary, managerId)
VALUES ('3', 'Sam', '60000', NULL);
INSERT INTO Employee (id, name, salary, managerId)
VALUES ('4', 'Max', '90000', NULL);


/*编写一个SQL查询来查找收入比经理高的员工。

以任意顺序 返回结果表。*/

SELECT *
FROM Employee;
SELECT e1.name AS employee
FROM Employee e1
         LEFT JOIN Employee e2 ON e1.managerId = e2.id
WHERE e1.salary > e2.salary;

DROP TABLE IF EXISTS Person;
CREATE TABLE IF NOT EXISTS Person
(
    id    int,
    email varchar(255)
);
TRUNCATE TABLE Person;
INSERT INTO Person (id, email)
VALUES ('1', 'a@b.com');
INSERT INTO Person (id, email)
VALUES ('2', 'c@d.com');
INSERT INTO Person (id, email)
VALUES ('3', 'a@b.com');

/*
 编写一个 SQL 查询来报告所有重复的电子邮件。 请注意，可以保证电子邮件字段不为 NULL。
 以任意顺序 返回结果表。
 */

SELECT email
FROM Person;
SELECT email, COUNT(email) AS count
FROM (SELECT email FROM Person) AS t
GROUP BY email;
SELECT email
FROM (SELECT email, COUNT(email) AS count FROM (SELECT email FROM Person) AS t GROUP BY email) AS t2
WHERE t2.count > 1;

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
CREATE TABLE IF NOT EXISTS Customers
(
    id   int,
    name varchar(255)
);
CREATE TABLE IF NOT EXISTS Orders
(
    id         int,
    customerId int
);
TRUNCATE TABLE Customers;
INSERT INTO Customers (id, name)
VALUES ('1', 'Joe');
INSERT INTO Customers (id, name)
VALUES ('2', 'Henry');
INSERT INTO Customers (id, name)
VALUES ('3', 'Sam');
INSERT INTO Customers (id, name)
VALUES ('4', 'Max');
TRUNCATE TABLE Orders;
INSERT INTO Orders (id, customerId)
VALUES ('1', '3');
INSERT INTO Orders (id, customerId)
VALUES ('2', '1');

/*
 某网站包含两个表，Customers 表和 Orders 表。编写一个 SQL 查询，找出所有从不订购任何东西的客户。
 */

SELECT name AS Customers
FROM Customers
         LEFT JOIN Orders ON Customers.id = Orders.customerId
WHERE Orders.customerId IS NULL;

DROP TABLE IF EXISTS Person;
CREATE TABLE IF NOT EXISTS Person
(
    Id    int,
    Email varchar(255)
);
TRUNCATE TABLE Person;
INSERT INTO Person (id, email)
VALUES ('1', 'john@example.com');
INSERT INTO Person (id, email)
VALUES ('2', 'bob@example.com');
INSERT INTO Person (id, email)
VALUES ('3', 'john@example.com');
INSERT INTO Person (id, email)
VALUES ('4', 'john@example.com');
INSERT INTO Person (id, email)
VALUES ('5', 'john@example.com');
INSERT INTO Person (id, email)
VALUES ('6', 'john@example.com');
SELECT *
FROM Person;

/*
 编写一个 SQL 删除语句来 删除 所有重复的电子邮件，只保留一个id最小的唯一电子邮件。
以 任意顺序 返回结果表。 （注意： 仅需要写删除语句，将自动对剩余结果进行查询）
 */


SELECT *, ROW_NUMBER() OVER (PARTITION BY Person.Email ORDER BY Person.Id) AS RN
FROM Person;

SELECT t.Id
FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY Person.Email ORDER BY Person.Id) AS RN FROM Person) AS t
WHERE RN > 1;

DELETE
FROM Person
WHERE Person.Id IN (SELECT t.Id
                    FROM (SELECT *, ROW_NUMBER() OVER (PARTITION BY Person.Email ORDER BY Person.Id) AS RN
                          FROM Person) AS t
                    WHERE RN > 1);

SELECT *
FROM Person;

DELETE Person
FROM Person,
     Person p2
WHERE Person.Email = p2.Email
  AND p2.Id < Person.Id;

SELECT *
FROM Person;