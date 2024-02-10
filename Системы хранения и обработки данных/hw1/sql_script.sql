--ОСПРАВОЧНИКИ СОЗДАЮТСЯ В СКРИПТЕ JUPYTER NOTEBOOK

--Создаем справочник штатов - state
create table state as 
	select ROW_NUMBER() over() as id, 1 country_id, state name from
	(
		select distinct state 
		from customer_tmp 
		where state is not null
	) x
	
--Создаем справочник адресов - state
create table address as 
	select ROW_NUMBER() over() as id, postcode, x.id state_id, address name from
	(
		select distinct address, postcode, state.id
		from customer_tmp
		join state on customer_tmp.state = state.name
		where address is not null
	) x
	

--Создаем таблицу продукотов с внешними ключами справочников - product
create table product as 
	select product_id id, brand_id, product_line_id, product_class_id, product_size_id, list_price, standard_cost from
	(
		select distinct
		product_id,
		product_size.id product_size_id,
		product_line.id product_line_id,
		brand.id brand_id,
		product_class.id product_class_id,
		list_price,
		standard_cost
		from transaction_tmp
		join product_size on transaction_tmp.product_size = product_size.name
		join brand on transaction_tmp.brand = brand.name
		join product_line on transaction_tmp.product_line = product_line.name
		join product_class on transaction_tmp.product_class = product_class.name
		--where product_id is not null
	) x

--Создаем таблицу клиентов с внешними ключами справочников - customer
create table customer as 
	select 
	customer_id id,
	address_id,
	first_name,
	last_name,
	gender_id,
	"DOB",
	job_title_id,
	job_industry_category_id,
	wealth_segment_id,
	deceased_indicator,
	owns_car,
	property_valuation 
	from
	(
		select distinct
		customer_id,
		address.id address_id,
		gender.id gender_id,
		job_title job_title_id,
		wealth_segment wealth_segment_id,
		job_industry_category job_industry_category_id,
		first_name,
		last_name,
		"DOB",
		deceased_indicator,
		owns_car,
		property_valuation
		from customer_tmp
		join address on customer_tmp.address = address.name
		join gender on customer_tmp.gender = gender.name
		join job_title on customer_tmp.job_title = job_title.name
		join wealth_segment on customer_tmp.wealth_segment = wealth_segment.name
		join job_industry_category on customer_tmp.job_industry_category = job_industry_category.name
		--where product_id is not null
	) x

--Создаем таблицу транзакций с внешними ключом справочника order_status - transaction
create table "transaction" as 
	select 
	transaction_id id,
	product_id,
	customer_id,
	transaction_date,
	online_order,
	order_status_id
	from
	(
		select distinct
		transaction_id,
		product_id,
		customer_id,
		transaction_date,
		online_order,
		order_status.id order_status_id
		from transaction_tmp
		join order_status on transaction_tmp.order_status = order_status.name
		--where product_id is not null
	) x
