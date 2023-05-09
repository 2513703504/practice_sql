use practice_sql;

# sql每日训练 2023-5-5

CREATE TABLE Sales
(
store_name VARCHAR(100),
sale_date VARCHAR(20),
doc_id VARCHAR(40),
product_code VARCHAR(40),
qty INT,
amt DECIMAL(18,2)
);

INSERT INTO Sales VALUES
('浙江杭州XX店','2022-03-03','10001','001',20,4000),
('浙江宁波XX店','2022-03-04','10002','002',15,3000),
('浙江温州XX店','2022-03-05','10003','002',3,600),
('浙江台州XX店','2022-03-05','10003','002',2,400),
('江苏南京XX店','2022-03-06','10004','001',3,600),
('江苏无锡XX店','2022-03-08','10005','002',30,6000),
('江苏苏州XX店','2022-03-09','10006','001',10,2000),
('安徽合肥XX店','2022-03-10','10007','002',2,400),
('安徽芜湖XX店','2022-03-17','10008','002',18,3600),
('安徽蚌埠XX店','2022-03-23','10009','002',10,2000),
('安徽安庆XX店','2022-03-24','10010','001',2,400);

-- 要求：求上个月每个省，城市销售额占比省份销售额大于等于10%的城市；

USE practice_sql;

SELECT substring(store_name,1,2) as store,sum(amt) as allSale FROM Sales GROUP BY substring(store_name,1,2);

SELECT substring(Sales.store_name,3,2) as city,tmp.province,Sales.sale_date,Sales.amt,tmp.allSale,Sales.amt/tmp.allSale as rate FROM Sales,
        (SELECT substring(store_name,1,2) as province,sum(amt) as allSale FROM Sales GROUP BY substring(store_name,1,2)) as tmp
        WHERE tmp.province=substring(Sales.store_name,1,2);

SELECT tmp2.city,tmp2.province,tmp2.amt,tmp2.allSale,tmp2.rate
    FROM (SELECT substring(Sales.store_name,3,2) as city,tmp.province,Sales.sale_date,Sales.amt,tmp.allSale,Sales.amt/tmp.allSale as rate FROM Sales,
        (SELECT substring(store_name,1,2) as province,sum(amt) as allSale FROM Sales GROUP BY substring(store_name,1,2)) as tmp
        WHERE tmp.province=substring(Sales.store_name,1,2)) as tmp2
    WHERE tmp2.sale_date>'2022-02-29' AND tmp2.sale_date<'2022-04-01' AND tmp2.rate>=0.1;

