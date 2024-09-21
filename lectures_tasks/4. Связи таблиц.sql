--Полная база, локально.
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


--*Выявить те направления, на которые не было продано ни одного билета. (demo, flights_v)
select
f.departure_airport
,f.arrival_airport
from flights f
left join ticket_flights tf on f.flight_id = tf.flight_id
where tf.flight_id is null

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


