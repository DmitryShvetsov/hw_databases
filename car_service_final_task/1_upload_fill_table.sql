-- PostgreSQL 15.5
-- Здесь загрузка БД и заполнение полей.
-- Запросы update по заполнению пустых значений однотипные. Привожу часть, при необходимости отправлю все.
-- Примечание: у одного pin бывает до 12 card.

-- Создаю базу данных локально. ОС: Убунту.
psql
create database car_service owner=postgres;
-- Устанавливаю пароль
\password postgres;

-- Подключаюсь к БД в DBeaver (в DBeaver: новое соединение - проверить тип БД, имя пользователя, пароль и т.д.
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

 -- На всякий случай создал копию исходной таблицы.
create table copy_all_data_origin as
select * from all_data ad

-- Заполнение пустых значений.
-- Использовался поиск уникальности заполняемого столбца для набора ключей. Например, email уникальны в разрезе name.
-- Связка email-name уникальна, т.е. у одного email только одно значение name (либо пусто):
select email, count(distinct name) count_name
from all_data ad
where name != '' and name is not null
group by 1 order by 2 desc

-- Заполняю name по email:
update all_data as ad
set name = subquery.name
from(
select distinct email, name
from all_data
where name != '' and email != ''
and name is not null and email is not null
) AS subquery
where ad.email = subquery.email
and (ad.name is null or ad.name = '') -- На всякий случай, чтобы не переписать уже заполненные.


-- Ниже указываю только используемые связки ключей. Скрипты однотипные, все их не привожу.
-- Заполняю телефоны по почтам. Пароли по email.
-- Оказалось, что одной почте соответствует 1 машина, поэтому заполняю car по email.
-- vin по email. Аналогично заполняю car_number.
-- color по vin.
-- pin уникален для набора из 3 ключей date, email, payment.
-- Заполняю service_addr по w_name. Также дополняю по w_phone.
-- Заполняю service по w_phone, потом по w_name.
-- Заполняю w_name по w_phone.
-- Заполняю w_exp по w_name. w_phone по w_name. wages по w_name.
-- Заполняю card по date, email, payment. По date, payment.

-- Как полностью заполнить card я не нашел. По одной покупке (pin) бывает до 12 карт:
select pin, count(distinct card) cnt
from all_data ad
where pin != '' and pin is not null
and card != '' and card is not null
group by 1 order by 2 desc

-- Все pin восстановить не удалось, т.к. они не уникальны даже в разрезе date, name, vin, w_name
select date, name, vin, w_name, count(distinct pin) cnt
from all_data ad
where date is not null
and pin != '' and pin is not null
and name is not null and name != ''
and vin is not null and vin != ''
and w_name is not null and w_name != ''
group by 1,2,3,4 order by 5 desc

-- pin уникальны в разрезе mileage, vin, но запрос обновил 0 строк:
update all_data as ad
set pin = subquery.pin
from (
select distinct mileage, vin, pin
from all_data
where
mileage is not null
and vin != '' and vin is not null
and pin != '' and pin is not null
) AS subquery
where (ad.mileage = subquery.mileage and ad.vin = subquery.vin)
and (ad.pin is null or ad.pin = '')
-- Набор date, vin также не уникален для pin. Видимо, это несколько ремонтов одной машины за 1 день.

-- Заполнил mileage по date, pin, vin. Правда с null как было 10425, так и осталось.
-- Заполнение card по date, name, pin, card не снизило число null.

-- Итого полностью не заполнились: card, payment (считаем за неудачные оплаты), pin, mileage.

-- Схема БД: https://drawdb.vercel.app/editor?shareId=74a1aef3778dd69752bc7b943428fc78


-- Примечание. Гипотетически можно использовать следующий метод, но он чреват ошибками и дал бы небольшое заполнение.
-- У некоторых наборов ключей заполняемые значения неуникальны. Тогда мы отсекаем набор ключей, где
-- заполняемые значения неуникальны.
-- Например, по связке vin-pin payment был неуникален в 78 случаях. Мы их отсекаем:
with vin_pin as (
select
vin
,pin
,count(distinct payment) cnt
from all_data
where
vin != '' and vin is not null
and pin != '' and pin is not null
and payment is not null
group by 1,2
having count(distinct payment) = 1 -- Оставляем уникальные связки.
order by 3 desc -- Сортировка используется при первоначальной проверке уникальности связки.
)
update all_data as ad
set payment = subquery.payment
from (
select
distinct
ad1.vin
,ad1.pin
,ad1.payment
from all_data ad1
join vin_pin using(vin, pin)
) AS subquery
where ad.vin = subquery.vin
and ad.pin = subquery.pin
and ad.payment is null
