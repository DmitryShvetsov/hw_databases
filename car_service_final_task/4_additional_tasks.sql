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

-- Сделать представление для директора: филиал, количество заказов за последний месяц,
-- заработанная сумма, заработанная сумма за вычетом зарплат
