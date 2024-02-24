--HW3

--Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)
SELECT job_industry_category AS Industry, COUNT(customer_id) AS "Number of Customers"
FROM customer_tmp
GROUP BY job_industry_category
ORDER BY COUNT(customer_id) DESC;

--Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)
SELECT
  DATE_TRUNC('month', CAST(t.transaction_date AS DATE)) AS transaction_month,
  c.job_industry_category,
  SUM(t.list_price) AS total_transaction_amount
FROM transaction_tmp t
JOIN customer_tmp c ON t.customer_id = c.customer_id
GROUP BY 1, 2
ORDER BY 1, 2;

--Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)
SELECT
  t.brand,
  COUNT(t.transaction_id) AS online_orders_count
FROM transaction_tmp t
JOIN customer_tmp c ON t.customer_id = c.customer_id
WHERE c.job_industry_category = 'IT'
  AND t.order_status = 'Approved'
  AND t.online_order = TRUE
GROUP BY t.brand
ORDER BY online_orders_count DESC;

--Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию суммы транзакций и количества клиентов. 
--Выполните двумя способами: используя только group by и используя только оконные функции. Сравните результат. — (2 балла)

--GROUP BY
SELECT
  t.customer_id,
  SUM(t.list_price) AS total_transaction_amount,
  MAX(t.list_price) AS max_transaction_amount,
  MIN(t.list_price) AS min_transaction_amount,
  COUNT(t.transaction_id) AS total_transactions
FROM transaction_tmp t
GROUP BY t.customer_id
ORDER BY total_transaction_amount DESC, total_transactions DESC;

--Оконные функции
SELECT DISTINCT
  customer_id,
  SUM(list_price) OVER (PARTITION BY customer_id) AS total_transaction_amount,
  MAX(list_price) OVER (PARTITION BY customer_id) AS max_transaction_amount,
  MIN(list_price) OVER (PARTITION BY customer_id) AS min_transaction_amount,
  COUNT(transaction_id) OVER (PARTITION BY customer_id) AS total_transactions
FROM transaction_tmp
ORDER BY total_transaction_amount DESC, total_transactions DESC;

--Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). 
--Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)
--MIN
SELECT
  c.first_name,
  c.last_name
FROM customer_tmp c
JOIN (
  SELECT
    customer_id,
    SUM(list_price) AS total_transaction_amount
  FROM transaction_tmp
  WHERE list_price IS NOT NULL
  GROUP BY customer_id
  ORDER BY total_transaction_amount ASC
  LIMIT 1
) AS min_transactions ON c.customer_id = min_transactions.customer_id;

--MAX
SELECT
  c.first_name,
  c.last_name
FROM customer_tmp c
JOIN (
  SELECT
    customer_id,
    SUM(list_price) AS total_transaction_amount
  FROM transaction_tmp
  WHERE list_price IS NOT NULL
  GROUP BY customer_id
  ORDER BY total_transaction_amount DESC
  LIMIT 1
) AS max_transactions ON c.customer_id = max_transactions.customer_id;

--Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)
WITH ranked_transactions AS (
  SELECT
    t.*,
    ROW_NUMBER() OVER (PARTITION BY t.customer_id ORDER BY t.transaction_date ASC) AS rn
  FROM transaction_tmp t
)
SELECT
  rt.transaction_id,
  rt.customer_id,
  rt.transaction_date,
  rt.list_price
FROM ranked_transactions rt
WHERE rt.rn = 1;

--Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).
WITH transaction_intervals AS (
  SELECT
    t.customer_id,
    t.transaction_date,
    LEAD(t.transaction_date) OVER (PARTITION BY t.customer_id ORDER BY t.transaction_date) AS next_transaction_date
  FROM transaction_tmp t
),
intervals AS (
  SELECT
    ti.customer_id,
    ti.transaction_date,
    ti.next_transaction_date,
    EXTRACT(DAY FROM (ti.next_transaction_date - ti.transaction_date)) AS interval_days
  FROM transaction_intervals ti
  WHERE ti.next_transaction_date IS NOT NULL
),
max_interval AS (
  SELECT
    customer_id,
    MAX(interval_days) AS max_interval_days
  FROM intervals
  GROUP BY customer_id
  ORDER BY max_interval_days DESC
  LIMIT 1
)
SELECT
  c.first_name,
  c.last_name,
  c.job_title
FROM customer_tmp c
JOIN max_interval mi ON c.customer_id = mi.customer_id;