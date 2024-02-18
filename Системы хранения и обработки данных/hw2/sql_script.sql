--HW 2
-- (1 балл) Вывести все уникальные бренды, у которых стандартная стоимость выше 1500 долларов.
SELECT DISTINCT brand
FROM transaction_tmp
WHERE CAST(standard_cost AS DECIMAL) > 1500;

--(1 балл) Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
SELECT *
FROM transaction_tmp
WHERE transaction_date BETWEEN '2017-04-01' AND '2017-04-09'
AND order_status = 'Approved';

--(1 балл) Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
SELECT DISTINCT job_title
FROM customer_tmp
WHERE job_industry_category IN ('IT', 'Financial Services')
AND job_title LIKE 'Senior%';

--(1 балл) Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
SELECT DISTINCT t.brand
FROM transaction_tmp t
JOIN customer_tmp c ON t.customer_id = c.customer_id
WHERE c.job_industry_category = 'Financial Services';

--(1 балл) Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer_tmp c
JOIN transaction_tmp t ON c.customer_id = t.customer_id
WHERE t.brand IN ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
AND t.online_order = 'True'
LIMIT 10;

--(1 балл) Вывести всех клиентов, у которых нет транзакций.
SELECT distinct c.customer_id, c.first_name, c.last_name 
FROM customer_tmp c
LEFT JOIN transaction_tmp t ON c.customer_id = t.customer_id
WHERE t.transaction_id IS NULL; 

--(2 балла) Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
WITH MaxStandardCost AS (
    SELECT MAX(CAST(standard_cost AS DECIMAL)) AS max_cost
    FROM transaction_tmp
),
ITCustomersWithMaxCostTransaction AS (
    SELECT distinct c.customer_id, c.first_name, c.last_name
    FROM customer_tmp c
    JOIN transaction_tmp t ON c.customer_id = t.customer_id
    JOIN MaxStandardCost msc ON CAST(t.standard_cost AS DECIMAL) = msc.max_cost
    WHERE c.job_industry_category = 'IT'
)
select icmct.customer_id, icmct.first_name, icmct.last_name
FROM ITCustomersWithMaxCostTransaction icmct;

--(2 балла) Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer_tmp c
JOIN transaction_tmp t ON c.customer_id = t.customer_id
WHERE c.job_industry_category IN ('IT', 'Health')
AND t.order_status = 'Approved'
AND t.transaction_date BETWEEN '2017-07-07' AND '2017-07-17';
