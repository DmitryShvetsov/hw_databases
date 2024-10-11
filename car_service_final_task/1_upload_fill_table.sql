--  PostgreSQL 15.5
-- Здесь загрузка БД и заполнение полей.
-- Запросы update по заполнению пустых значений однотипные, все можно не просматривать.
-- До нормалзации у одного pin бывает до 12 card.

-- Создаю базу данных локально. ОС: Убунту.
psql
create database car_service owner=postgres;
-- Устанавливаю пароль
\password postgres;

-- Поключаюсь к БД в DBeaver (В DBeaver: новое соединение - проверить тип БД, имя пользователя, пароль и т.д.
-- - тест соединения.)

-- Создаю таблицу в БД.
create table all_data (
date timestamp
,service text
,service_addr text
,w_name text
,w_exp integer
,w_phone text
,wages integer
,card text
,payment integer
,pin text
,name text
,phone text
,email text
,password text
,car text
,mileage integer
,vin text
,car_number text
,color text
)

 -- Импорт файла в DBeaver: в DB правой мышью - импорт - мастер.

-- Проверяю, что связка email-имя уникальна. Т.е. у одного email только одно имя (либо пусто).
select email, count(distinct name) count_name
from all_data ad
where name != '' and name is not null
group by 1 order by 2 desc

-- На всякий случай создал копию исходной таблицы.
create table copy_all_data_origin as
select * from all_data ad

-- Заполняю имена по email:
update all_data as ad
set name = subquery.name
from(
select distinct email, name
from all_data
where name != '' and email != ''
and name is not null and email is not null
) AS subquery
where ad.email = subquery.email
and (ad.name is null or ad.name = '')

-- Заполнил email по именам.
update all_data as ad
set email = subquery.email
from (
select distinct name, email
from all_data
where name != '' and email != ''
and name is not null and email is not null
) AS subquery
where ad.name = subquery.name
and (ad.email is null or ad.email = '')

-- Проверяю, что одной почте соответствует 1 телефон.
select email, count(distinct phone) count_phone
from all_data ad
where phone != '' and phone is not null
group by 1 order by 2 desc

-- Заполняю телефоны по почтам.
update all_data as ad
set phone = subquery.phone
from (
select distinct email, phone
from all_data
where phone != '' and email != ''
and phone is not null and email is not null
) AS subquery
where ad.email = subquery.email
and (ad.phone is null or ad.phone = '')

-- Заполняю пароли.
update all_data as ad
set password = subquery.password
from (
select distinct email, password
from all_data
where password != '' and email != ''
and password is not null and email is not null
) AS subquery
where ad.email = subquery.email
and (ad.password is null or ad.password = '')

-- Оказалось, что одной почте соответствует 1 машина, поэтому заполняю car по email:
update all_data as ad
set car = subquery.car
from (
select distinct email, car
from all_data
where car != '' and email != ''
and car is not null and email is not null
) AS subquery
where ad.email = subquery.email
and (ad.car is null or ad.car = '')

-- Заполняю vin:
update all_data as ad
set vin = subquery.vin
from (
select distinct email, vin
from all_data
where vin != '' and email != ''
and vin is not null and email is not null
) AS subquery
where ad.email = subquery.email
and (ad.vin is null or ad.vin = '')

-- Аналогично заполняю car_number.
-- Заполняю color по vin.

-- Видно, что pin уникален для date, email, payment:
select date, email, payment, count(distinct pin) cnt
from all_data ad
where date is not null
and email != '' and email is not null
and payment is not null
and pin != '' and pin is not null
group by 1,2,3 order by 4 desc

-- Заполняю pin:
update all_data as ad
set pin = subquery.pin
from (
select distinct date, email, payment, pin
from all_data
where date is not null
and email != '' and email is not null
and payment is not null
and pin != '' and pin is not null
) AS subquery
where (ad.date = subquery.date and ad.email = subquery.email and ad.payment = subquery.payment)
and (ad.pin is null or ad.pin = '')

-- Заполняю service_addr по w_name. Также дополняю по w_phone.
-- Заполняю service по w_phone, потом по w_name.
-- Заполняю w_name по w_phone.
-- Заполняю w_exp по w_name. w_phone по w_name. wages по w_name.
-- Заполняю card по date, email, payment. По date, payment.

-- Как полностью заполнить card я не нашел, т.к. даже по одной покупке (pin) бывает до 12 карт:
select pin, count(distinct card) cnt
from all_data ad
where pin != '' and pin is not null
and card != '' and card is not null
group by 1 order by 2 desc

-- Заполняю payment по date, vin, pin. Но как было 31005 пустых, так и осталось.

-- Все pin восстановить не удалось, т.к. они не уникальны в разрезе date, name, vin, w_name
select date, name, vin, w_name, count(distinct pin) cnt
from all_data ad
where date is not null
and pin != '' and pin is not null
and name is not null and name != ''
and vin is not null and vin != ''
and w_name is not null and w_name != ''
group by 1,2,3,4 order by 5 desc

-- Заполнил mileage по date, pin, vin. Правда с null как было 10425, так и осталось.
-- Заполнение card по date, name, pin, card не снизило число null.

-- Итого полностью не заполнились: card, payment (считаем за неудачные оплаты), pin, mileage.

-- Схема БД: https://drawdb.vercel.app/editor?shareId=74a1aef3778dd69752bc7b943428fc78
