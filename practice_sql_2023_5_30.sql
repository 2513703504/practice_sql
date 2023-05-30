USE practice_sql;

DROP TABLE IF EXISTS Users;
CREATE TABLE IF NOT EXISTS Users
(
    user_id int,
    name    varchar(30),
    mail    varchar(50)
);
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, name, mail)
VALUES ('1', 'Winston', 'winston@leetcode.com');
INSERT INTO Users (user_id, name, mail)
VALUES ('2', 'Jonathan', 'jonathanisgreat');
INSERT INTO Users (user_id, name, mail)
VALUES ('3', 'Annabelle', 'bella-@leetcode.com');
INSERT INTO Users (user_id, name, mail)
VALUES ('4', 'Sally', 'sally.come@leetcode.com');
INSERT INTO Users (user_id, name, mail)
VALUES ('5', 'Marwan', 'quarz#2020@leetcode.com');
INSERT INTO Users (user_id, name, mail)
VALUES ('6', 'David', 'david69@gmail.com');
INSERT INTO Users (user_id, name, mail)
VALUES ('7', 'Shapiro', '.shapo@leetcode.com');
INSERT INTO Users (user_id, name, mail)
VALUES ('7', 'Shapiro', 'quarz#2020@leetcode.com');
INSERT INTO Users (user_id, name, mail)
VALUES ('7', 'Shapiro', 'quarz^2020@leetcode.com');

/*
 写一条SQL 语句，查询拥有有效邮箱的用户。

有效的邮箱包含符合下列条件的前缀名和域名：

前缀名是包含字母（大写或小写）、数字、下划线'_'、句点'.'和/或横杠'-'的字符串。前缀名必须以字母开头。
域名是'@leetcode.com'。
 */

SELECT *
FROM Users;

SELECT *
FROM Users
WHERE mail REGEXP '^[a-zA-Z]+[a-zA-Z0-9_\\.\\/\\-]*@leetcode\\.com$';


DROP TABLE IF EXISTS Patients;
CREATE TABLE IF NOT EXISTS Patients
(
    patient_id   int,
    patient_name varchar(30),
    conditions   varchar(100)
);
TRUNCATE TABLE Patients;
INSERT INTO Patients (patient_id, patient_name, conditions)
VALUES ('1', 'Daniel', 'YFEV COUGH');
INSERT INTO Patients (patient_id, patient_name, conditions)
VALUES ('2', 'Alice', '');
INSERT INTO Patients (patient_id, patient_name, conditions)
VALUES ('3', 'Bob', 'DIAB100 MYOP');
INSERT INTO Patients (patient_id, patient_name, conditions)
VALUES ('4', 'George', 'ACNE DIAB100');
INSERT INTO Patients (patient_id, patient_name, conditions)
VALUES ('5', 'Alain', 'DIAB201');
INSERT INTO Patients (patient_id, patient_name, conditions)
VALUES ('6', 'Daniel', 'SADIAB100');


/*
 写一条SQL 语句，查询患有 I 类糖尿病的患者ID （patient_id）、患者姓名（patient_name）以及其患有的所有疾病代码（conditions）。I 类糖尿病的代码总是包含前缀DIAB1

 */
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions REGEXP '\\bDIAB1';

DROP TABLE IF EXISTS Visits;
DROP TABLE IF EXISTS Transactions;
CREATE TABLE IF NOT EXISTS Visits
(
    visit_id    int,
    customer_id int
);
CREATE TABLE IF NOT EXISTS Transactions
(
    transaction_id int,
    visit_id       int,
    amount         int
);
TRUNCATE TABLE Visits;
INSERT INTO Visits (visit_id, customer_id)
VALUES ('1', '23');
INSERT INTO Visits (visit_id, customer_id)
VALUES ('2', '9');
INSERT INTO Visits (visit_id, customer_id)
VALUES ('4', '30');
INSERT INTO Visits (visit_id, customer_id)
VALUES ('5', '54');
INSERT INTO Visits (visit_id, customer_id)
VALUES ('6', '96');
INSERT INTO Visits (visit_id, customer_id)
VALUES ('7', '54');
INSERT INTO Visits (visit_id, customer_id)
VALUES ('8', '54');
TRUNCATE TABLE Transactions;
INSERT INTO Transactions (transaction_id, visit_id, amount)
VALUES ('2', '5', '310');
INSERT INTO Transactions (transaction_id, visit_id, amount)
VALUES ('3', '5', '300');
INSERT INTO Transactions (transaction_id, visit_id, amount)
VALUES ('9', '5', '200');
INSERT INTO Transactions (transaction_id, visit_id, amount)
VALUES ('12', '1', '910');
INSERT INTO Transactions (transaction_id, visit_id, amount)
VALUES ('13', '2', '970');

/*
 有一些顾客可能光顾了购物中心但没有进行交易。请你编写一个 SQL 查询，来查找这些顾客的 ID ，以及他们只光顾不交易的次数
 */

{"headers":{"Visits":["visit_id","customer_id"],"Transactions":["transaction_id","visit_id","amount"]},"rows":
    {"Visits":[[1,23],[2,9],[4,30],[5,54],[6,96],[7,54],[8,54]],
    "Transactions":[[2,5,310],[3,5,300],[9,5,200],[12,1,910],[13,2,970]]}}

SELECT Visits.visit_id
FROM Visits,
     Transactions
WHERE Visits.visit_id = Transactions.visit_id;

SELECT customer_id, COUNT(customer_id) AS count_no_trans
FROM Visits
WHERE visit_id NOT IN (SELECT Visits.visit_id
                       FROM Visits,
                            Transactions
                       WHERE Visits.visit_id = Transactions.visit_id)
GROUP BY customer_id;


DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Transactions;
CREATE TABLE IF NOT EXISTS Users
(
    account int,
    name    varchar(20)
);
CREATE TABLE IF NOT EXISTS Transactions
(
    trans_id      int,
    account       int,
    amount        int,
    transacted_on date
);
INSERT INTO Users (account, name)
VALUES ('900001', 'Alice');
INSERT INTO Users (account, name)
VALUES ('900002', 'Bob');
INSERT INTO Users (account, name)
VALUES ('900003', 'Charlie');
TRUNCATE TABLE Transactions;
INSERT INTO Transactions (trans_id, account, amount, transacted_on)
VALUES ('1', '900001', '7000', '2020-08-01');
INSERT INTO Transactions (trans_id, account, amount, transacted_on)
VALUES ('2', '900001', '7000', '2020-09-01');
INSERT INTO Transactions (trans_id, account, amount, transacted_on)
VALUES ('3', '900001', '-3000', '2020-09-02');
INSERT INTO Transactions (trans_id, account, amount, transacted_on)
VALUES ('4', '900002', '1000', '2020-09-12');
INSERT INTO Transactions (trans_id, account, amount, transacted_on)
VALUES ('5', '900003', '6000', '2020-08-07');
INSERT INTO Transactions (trans_id, account, amount, transacted_on)
VALUES ('6', '900003', '6000', '2020-09-07');
INSERT INTO Transactions (trans_id, account, amount, transacted_on)
VALUES ('7', '900003', '-4000', '2020-09-11');


/*
 写一个 SQL,  报告余额高于 10000 的所有用户的名字和余额. 账户的余额等于包含该账户的所有交易的总和
 */

SELECT name, SUM(amount) AS balance
FROM Users,
     Transactions
WHERE Users.account = Transactions.account
GROUP BY Transactions.account
HAVING SUM(amount) > 10000;


SELECT Users.name name, SUM(Transactions.amount) balance
FROM Users
         INNER JOIN Transactions ON Users.account = Transactions.account
GROUP BY Transactions.account
HAVING SUM(Transactions.amount) > 10000;


DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Register;
CREATE TABLE IF NOT EXISTS Users
(
    user_id   int,
    user_name varchar(20)
);
CREATE TABLE IF NOT EXISTS Register
(
    contest_id int,
    user_id    int
);
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, user_name)
VALUES ('6', 'Alice');
INSERT INTO Users (user_id, user_name)
VALUES ('2', 'Bob');
INSERT INTO Users (user_id, user_name)
VALUES ('7', 'Alex');
TRUNCATE TABLE Register;
INSERT INTO Register (contest_id, user_id)
VALUES ('215', '6');
INSERT INTO Register (contest_id, user_id)
VALUES ('209', '2');
INSERT INTO Register (contest_id, user_id)
VALUES ('208', '2');
INSERT INTO Register (contest_id, user_id)
VALUES ('210', '6');
INSERT INTO Register (contest_id, user_id)
VALUES ('208', '6');
INSERT INTO Register (contest_id, user_id)
VALUES ('209', '7');
INSERT INTO Register (contest_id, user_id)
VALUES ('209', '6');
INSERT INTO Register (contest_id, user_id)
VALUES ('215', '7');
INSERT INTO Register (contest_id, user_id)
VALUES ('208', '7');
INSERT INTO Register (contest_id, user_id)
VALUES ('210', '2');
INSERT INTO Register (contest_id, user_id)
VALUES ('207', '2');
INSERT INTO Register (contest_id, user_id)
VALUES ('210', '7');

/*
 写一条 SQL 语句，查询各赛事的用户注册百分率，保留两位小数。

返回的结果表按percentage的降序排序，若相同则按contest_id的升序排序
 */
WITH t AS (SELECT COUNT(user_id) AS total
           FROM Users)
SELECT contest_id, ROUND(COUNT(contest_id) / t.total, 2) * 100 AS percentage
FROM Register,
     Users,
     t
WHERE Users.user_id = Register.user_id
GROUP BY contest_id
ORDER BY contest_id DESC, contest_id;

SELECT contest_id, ROUND(t.count_contest_id / COUNT(Users.user_id)*100, 2) AS percentage
FROM (SELECT contest_id, COUNT(contest_id) AS count_contest_id
      FROM Register,
           Users
      WHERE Users.user_id = Register.user_id
      GROUP BY contest_id) AS t,
     Users GROUP BY contest_id ORDER BY percentage DESC ,contest_id;

SELECT round(2/3,2);
SELECT round(2/3*100,2);