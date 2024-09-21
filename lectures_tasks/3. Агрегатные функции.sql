--Полная база, локально
--1) Выбрать id магазинов, у которых более 300 покупателей. (dvdrental)
select store_id
from customer c
group by 1
having count(distinct customer_id) > 300
--Ответ: 1

--2) Найти медиану цены аренды фильма согласно рейтингу. (dvdrental)
select
film_id
,title
,percentile_disc(0.5) within group (order by rental_rate) median
from film
group by 1,2
order by 3 desc

--3) Сколько клиентов потратило на аренду больше среднего за каждый день? (dvdrental)
--Не работает, посмотрю в лекции как выложат запись:
select
p2.payment_date payment_date
,count(p2.customer_id) count_c_id
from (select
customer_id
,amount
,cast(payment_date as date) payment_date
from payment
group by 1,2,3
) p2
group by payment_date, amount
having amount > avg(p2.amount)

--4) --Определить самый прибыльный день по бронированиям. (demo)
select b.book_date from(
select
cast(book_date as date) book_date
,sum(total_amount) total_amount
from bookings b
group by 1
order by 1 desc limit 1) b

--5) Найти среднюю и максимальную задержки вылета. (demo)
select
avg(actual_departure - scheduled_departure) avg_delay
,max(actual_departure - scheduled_departure) max_delay
from flights_v fv
where actual_departure is not null and scheduled_departure is not null
-- 00:12:35.664697	05:03:00

--6) Какова минимальная и максимальная продолжительность полета для каждого из возможных рейсов из Москвы в Санкт-Петербург? (demo, flights_v)
select flight_no
,min(actual_duration) min_actual_duration
,max(actual_duration) max_actual_duration
from flights_v fv
where departure_city = 'Москва' and arrival_city = 'Санкт-Петербург'
group by 1
order by 3 asc

--7) Какое количество бронирований с каждым вариантом количества пассажиров? (demo)
select
count
,count(book_ref)
from (
select
book_ref
,count(passenger_id)
from tickets t
group by 1
) br
group by 1
order by 1

--8) В каких городах больше одного аэропорта? (demo)
select a.city from(
select
city
,count(airport_code) ap_cnt
from airports
group by 1
having count(airport_code) > 1) a

--9) Какие маршруты существуют между городами часового пояса Europe/Moscow? (demo, routes, airports)
select flight_no from routes r
where arrival_city
in
(
select distinct city from airports a
where timezone = 'Europe/Moscow')
and departure_city
in
(
select distinct city from airports a
where timezone = 'Europe/Moscow')

--10) В какие города нет рейсов из Москвы? (demo, routes, airports)
select distinct arrival_city from routes r
where arrival_city not in
(
select distinct arrival_city from routes r2
where departure_city = 'Москва'
)
--21 город в полной базе.