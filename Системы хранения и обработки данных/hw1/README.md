# Дз1

Изначальные две таблицы `customer` и `transactions` уже находились в 1НФ.
Я привожу БД к 3НФ (Смотри диаграмму ниже). Для этого я разбил данные на три основных таблицы transaction, product, customer и несколько справочных таблиц.

Вместо создания заголовков таблиц и потом вставки данных через `CREATE` и `INSERT` я использовал метод `to_sql` из `pandas` с библиотекой `sqlalchemy`

## Основные таблицы:
- Таблица `customer` содержит информацию о клиентах, включая:
    - Уникальный идентификатор клиента (customer_id)
    - Адрес (address_id)
    - Имя (first_name),
    - Фамилию (last_name),
    - Пол (gender_id),
    - Дату рождения (DOB),
    - Должность (job_title_id),
    - Отрасль работы (job_industry_category_id),
    - Сегмент богатства (wealth_segment_id),
    - Индикатор умерших (deceased_indicator),
    - Владение автомобилем (owns_car)
    - Оценку имущества (property_valuation).

- Таблица `product` содержит информацию о продуктах, включая:
    - Уникальный идентификатор продукта (product_id)
    - Бренд (brand_id)
    - Линейку продуктов (product_line_id)
    - Класс продукта (product_class_id)
    - Размер (product_size_id)
    - Рекомендованную розничную цену (list_price)
    - Стандартную стоимость (standard_cost)

- Таблица `transaction` учитывает транзакции, включая:
    - Уникальный идентификатор транзакции (transaction_id)
    - Продукт (product_id)
    - Клиента (customer_id)
    - Дату транзакции (transaction_date)
    - Онлайн заказ (online_order)
    - Статус заказа (order_status_id)

## Справочники:

Для основной таблицы `customer`:
- Таблицы job_title, job_industry_category, wealth_segment, gender, и address содержат справочную информацию, связанную с соответствующими атрибутами клиентов: должности, отрасли работы, сегменты богатства, пола и адреса соответственно.

Для таблицы `address`:
- Таблица state и country предоставляют информацию о географическом расположении, связывая адреса с конкретными штатами и странами.

Для основной таблицы `product`:
- Таблицы brand, product_line, product_class, и product_size содержат справочную информацию о брендах, линейках продуктов, классах продуктов и размерах продуктов соответственно.

Для основной таблицы `transaction`:
- Таблица order_status предоставляет информацию о статусах заказов.

# Диаграмма
[Ссылка на диаграму на сайте `dbdiagram.io`](https://dbdiagram.io/d/TEST-65c7869cac844320aedcc75c)

![Диаграмма](dbdiagram.png)

## Скрины из DBeaver:

Таблицы и их заполненность:

![image](https://github.com/mllightitup/sf_data_science/assets/43480503/af6f29ae-913c-46f9-9753-8f6c5851d593)

Первые 30 строк таблицы transaction:

![image](https://github.com/mllightitup/sf_data_science/assets/43480503/28bfb64c-9ed0-4c19-8cd0-58384b29e6ad)



## Файлы проекта
- ```hw1_data.xlsx``` - оригинальный датасет
- ```pg_py.ipynb``` - код на python для импорта датасета в postgres, а так же создание справочников в цикле
- ```sql_script.sql``` - код на sql для создание основных таблиц и нестандартных справочных таблиц
