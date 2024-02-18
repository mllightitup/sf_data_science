--HW 2
-- (1 балл) Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.
SELECT DISTINCT b.name
FROM brand b
JOIN product p ON b.id = p.brand_id
WHERE p.standard_cost > 1500;

--(1 балл) Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
SELECT t.id, t.customer_id, t.product_id, t.transaction_date
FROM transaction t
JOIN order_status os ON t.order_status_id = os.id
WHERE t.transaction_date BETWEEN '2017-04-01' AND '2017-04-09'
AND os.name = 'Approved';

--(1 балл) Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
SELECT DISTINCT jt.name AS JobTitle
FROM customer c
JOIN job_title jt ON c.job_title_id = jt.id
JOIN job_industry_category jic ON c.job_industry_category_id = jic.id
WHERE jic.name IN ('IT', 'Financial Services')
AND jt.name LIKE 'Senior%'

--(1 балл) Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
SELECT DISTINCT b.name AS BrandName
FROM customer c
JOIN job_industry_category jic ON c.job_industry_category_id = jic.id
JOIN transaction t ON c.id = t.customer_id
JOIN product p ON t.product_id = p.id
JOIN brand b ON p.brand_id = b.id
WHERE jic.name = 'Financial Services'

--(1 балл) Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
SELECT DISTINCT c.id, c.first_name, c.last_name
FROM customer c
JOIN transaction t ON c.id = t.customer_id
JOIN product p ON t.product_id = p.id
JOIN brand b ON p.brand_id = b.id
WHERE t.online_order = TRUE
AND b.name IN ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
LIMIT 10

--(1 балл) Вывести всех клиентов, у которых нет транзакций.
SELECT c.id, c.first_name, c.last_name
FROM customer c
LEFT JOIN transaction t ON c.id = t.customer_id
WHERE t.id IS NULL

--(2 балла) Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
WITH MaxCost AS (
    SELECT MAX(p.standard_cost) AS MaxStandardCost
    FROM transaction t
    JOIN product p ON t.product_id = p.id
)

SELECT DISTINCT c.first_name, c.last_name, p.standard_cost
FROM customer c
JOIN job_industry_category jic ON c.job_industry_category_id = jic.id
JOIN transaction t ON c.id = t.customer_id
JOIN product p ON t.product_id = p.id, MaxCost mc
WHERE jic.name = 'IT'
AND p.standard_cost = mc.MaxStandardCost

--(2 балла) Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
SELECT DISTINCT c.id, c.first_name, c.last_name
FROM customer c
JOIN job_industry_category jic ON c.job_industry_category_id = jic.id
JOIN transaction t ON c.id = t.customer_id
JOIN order_status os ON t.order_status_id = os.id
WHERE jic.name IN ('IT', 'Health')
AND t.transaction_date BETWEEN '2017-07-07' AND '2017-07-17'
AND os.name = 'Approved'