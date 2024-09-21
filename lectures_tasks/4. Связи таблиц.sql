--Полная база, локально.
--Заданные задачи внизу.
--1) Вывести список фильмов для каждого актера. (dvdrental)
select distinct first_name
,last_name la
,f.title
from actor a
join film_actor fa
on fa.actor_id = a.actor_id
join film f
on f.film_id = fa.film_id
--5462 строки

--2) Самые крупные самолеты в нашей авиакомпании — это Боинг 777-300. Выяснить, между какими парами городов они летают. (demo, routes)
select distinct
departure_city
,arrival_city
from routes r
join aircrafts  a
on r.aircraft_code = a.aircraft_code
where a.model ilike '%Боинг 777-300%'
--8 строк

--Без join:
select distinct
departure_city
,arrival_city
from routes r
where aircraft_code = (
select distinct aircraft_code from aircrafts where model ilike '%Боинг 777-300%'
)
--8 строк

--3) --Ответить на вопрос о том, каковы максимальные и минимальные цены билетов на все направления.
select
f.departure_airport
,f.arrival_airport
--,ad.city -> 'ru' dep_city  --Попытка вывода города, а не кода аэропорта.
--,ad1.city -> 'ru' arr_city
,max(tf.amount) max_cost
,min(tf.amount) min_cost
from flights f
join ticket_flights tf on f.flight_id = tf.flight_id
--join airports_data ad on f.departure_airport = ad.airport_code
--join airports_data ad1 on f.arrival_airport = ad.airport_code
group by f.departure_airport
,f.arrival_airport
--,ad.city, ad1.city

--4) Получить список пассажиров рейса  27584 с местами, которые им были назначены в салоне самолета. (demo)
select
distinct
t.passenger_name
,bp.seat_no
from flights f
join ticket_flights tf on f.flight_id = tf.flight_id
join boarding_passes bp on tf.flight_id = bp.flight_id and tf.ticket_no = bp.ticket_no
join tickets t on tf.ticket_no = t.ticket_no
where f.flight_id = 27584
--39 строк

--Было задано:
--3)*Выявить те направления, на которые не было продано ни одного билета. (demo, flights_v)
select
distinct
fv.departure_city
,fv.arrival_city
from flights_v fv
left join ticket_flights tf on fv.flight_id = tf.flight_id
where tf.flight_id is null
--Ответ: 463 строчки
--ВОПРОС ЗАЛУ: как подтянуть названия городов из таблицы airports_data, если бы вместо flights_v использовалась flights.
-- Видимо надо сджойнить по airport_code, но как?

--5) Можно предложить другой вариант, в котором используется одна из операций над
--множествами строк: объединение, пересечение или разность. (demo)
SELECT DISTINCT a.city
FROM airports a
where a.city <> 'Москва'
EXCEPT
select
distinct arrival_city
from routes r
where departure_city = 'Москва'
-- Ответ как и в 1 запросе 20 строк.
