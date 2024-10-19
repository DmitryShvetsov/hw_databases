-- 1. Создать таблицу скидок и дать скидку самым частым клиентам
create table discounts as
(
select
row_number() OVER (ORDER by discount_percent) discount_id
,subquery.*
from (
select
5 discount_percent
union all select
10 discount_percent
union all select
15 discount_percent
) subquery
)

-- Добавим столбец.
alter table clients
ADD COLUMN discount_id integer

-- Даем скидку клиентам.
with client_frequency as (
select
client_id
,count(distinct order_id)
from orders
group by 1 order by 2 desc)
,client_disc as (
select
client_id
,case
	when count > 200 then 4
	when count > 180 then 3
	when count > 150 then 2
	else 1
end discount_id
from client_frequency
)
update clients
set discount_id = subquery.discount_id
from (
select
client_id
,discount_id from client_disc
) as subquery
where clients.client_id = subquery.client_id


-- 2. Поднять зарплату трем самым результативным механикам на 10%
-- Будем считать самыми результативными тех, кто дал больше выручки.
update workers
set wages = wages*1.1
from (
select
worker_id
,sum(payment) revenue
from orders
group by 1 order by 2 desc
limit 3
) subquery
where workers.worker_id = subquery.worker_id

-- 3. Сделать представление для директора: филиал, количество заказов за последний месяц,
-- заработанная сумма, заработанная сумма за вычетом зарплат
create view last_month_performancce as
with t_last_month as (
select
DATE_TRUNC('month', date) last_month
from orders
order by 1 desc limit 1 offset 1
)
select
tlm.last_month
,s.service
,count(o.order_id) orders_amount
,sum(o.payment) revenue
,sum(o.payment) - sum(wages) profit
from orders o
join t_last_month tlm on tlm.last_month = DATE_TRUNC('month', date)
join workers w using(worker_id)
join services s using(service_id)
group by 1,2

-- 4. Сделать рейтинг самых надежных и ненадежных авто.
-- Будем считать относительно пробега, т.е. сколько миль пробега приходится на 1 ремонт.
-- Чем больше - тем надежнее.

-- Три самых надежных (больше всех миль на 1 км. пробега).
with orders_data as (
select
o.car_id
,c.car
,c.vin
,max(o.mileage) mileage
,count(o.order_id) orders_amount
from orders o
join cars c using(car_id)
group by 1,2,3)
select
car
,sum(mileage) / sum(orders_amount) reliability
from orders_data
group by 1 order by 2 desc limit 3


-- Три самых ненадежных (меньше всех миль на 1 км. пробега).
with orders_data as (
select
o.car_id
,c.car
,c.vin
,max(o.mileage) mileage
,count(o.order_id) orders_amount
from orders o
join cars c using(car_id)
group by 1,2,3)
select
car
,sum(mileage) / sum(orders_amount) reliability
from orders_data
group by 1 order by 2 limit 3

-- 5. Самый "удачный" цвет для каждой модели авто.
-- Найдем цвета, которые реже всего приезжают в сервис.
with cars_orders_amount as (
select
c.car
,colors.color
,count(o.order_id) orders_amount
from orders o
join cars c using(car_id)
join colors on c.color_id = colors.color_id
group by 1,2
)
, cars_luck as (
select *
,row_number() OVER (PARTITION BY
car ORDER BY orders_amount)
from cars_orders_amount
)
select car, color from cars_luck where row_number = 1


-- Первичный ключ в виде автоинкрементного столбца уже добавлен.
-- Построить связи между таблицами: см. снимок схемы БД 3ТА из DBeaver.
-- Добавить в каждую таблицу индекс хотя бы одному столбцу.
CREATE UNIQUE INDEX color_id_indx ON colors (color_id);

CREATE UNIQUE INDEX discount_id_indx ON discounts (discount_id);

CREATE INDEX car_indx ON cars (car);

CREATE INDEX email_indx ON clients (email);

create unique INDEX card_id_indx ON cards (card_id);

create INDEX service_indx ON services (service);

create INDEX wages_indx ON workers (wages);

create INDEX dates_indx ON orders (date);

-- Сохраняю дамп.
sudo -i -u postgres
pg_dump car_service --format=t | gzip > /var/lib/postgresql/postgres_15_5_ad2e0f01-e82d-4007-9af1-2cf6ad65a5b2.tar;
