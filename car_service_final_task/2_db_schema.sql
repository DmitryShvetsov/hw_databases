-- Схема БД: https://drawdb.vercel.app/editor?shareId=74a1aef3778dd69752bc7b943428fc78

-- Создаю таблицы согласно схеме:
create table workers as
(
select
row_number() OVER (ORDER by w_phone) id
,unique_w.w_name
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

create table cars as
(
select
row_number() OVER (ORDER by vin) id
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
row_number() OVER (ORDER by service_addr) id
,subquery.*
from (
select distinct
service
,service_addr
from all_data ad
) subquery
)

create table orders as
(
select
row_number() OVER (ORDER by pin) id
,subquery.*
from (
select distinct
card
,payment
,pin
,mileage
from all_data ad
) subquery
)

create table clients as
(
select
row_number() OVER (ORDER by email) id
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