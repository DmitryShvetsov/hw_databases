-- Схема БД по 1NF (пока без указания связей): https://drawdb.vercel.app/editor?shareId=fcbf5ded81849d1443f402c7ea53297c

-- Разбить имя в 2 таблицах.
-- Добавить id других таблиц через join.
-- Уникализировать все столбцы.

-- Создаю таблицы согласно схеме.
-- Сразу разбиваю столбцы с именем. Задаю столбцам уникальное имя.
create table workers as
(
select
row_number() OVER (ORDER by w_phone) worker_id
,split_part(unique_w.w_name, ' ', 1) w_first_name
,split_part(unique_w.w_name, ' ', 2) w_second_name
,unique_w.w_exp
,unique_w.w_phone
,unique_w.wages
from (
select distinct
w_name
,w_exp
,w_phone
,wages
from all_data ad
) unique_w
)

create table cards as
(
select
row_number() OVER (ORDER by card) card_id
,subquery.*
from (
select distinct
card
from all_data ad
where card != '' and card is not null
) subquery
)

create table cars as
(
select
row_number() OVER (ORDER by vin) car_id
,subquery.*
from (
select distinct
car
,vin
,car_number
,color
from all_data ad
) subquery
)

create table services as
(
select
row_number() OVER (ORDER by service_addr) service_id
,subquery.*
from (
select distinct
service
,service_addr
from all_data ad
) subquery
)

create table clients as
(
select
row_number() OVER (ORDER by email) client_id
,subquery.*
from (
select distinct
name
,phone
,email
,password
from all_data ad
) subquery
)

create table orders as
(
select
row_number() OVER (ORDER by pin) order_id
,subquery.*
from (
select distinct
date
,payment
,pin
,mileage
,card_id
,service_id
,worker_id
,car_id
,client_id
from all_data ad
left join cards using(card)
left join services using(service, service_addr)
left join workers using(w_phone)
left join cars using(vin)
left join clients using(email)
) subquery
)

 -- Сделали связи в DBeaver (см. снимок в репозитории "2nf_..."). Поскольку составных ключей у нас нет, это уже
 -- и есть 2NF.
 -- В следующем файле переходим к 3 NF.
