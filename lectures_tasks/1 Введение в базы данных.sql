--Введение в базы данных
--1) Сколько кодов аэропортов начинаются с гласной буквы?
select count(distinct airport_code) count from airports_data where regexp_like(UPPER(airport_code), '^A|E|I|O|U')
--52

--2) Код самолета с наибольшей дальностью полета.
select aircraft_code, max(scheduled_arrival - scheduled_departure) from flights group by 1 order by 2 desc limit 1
-- 319

--3) Количество мест класса “бизнес” в самолете CRJ-200.
select count(distinct seat_no) from seats where aircraft_code = 'CR2' and fare_conditions = 'Business'
-- 0

--4) Количество отмененных рейсов до Казани.
select count(distinct flight_no) count from flights where arrival_airport = 'KZN' and status = 'Cancelled'
--5

--5) 000352 - по этой брони был куплен билет класса “бизнес”. Куда и во сколько прибыл пассажир KOROLEVA?
select * from tickets where book_ref = '000352' and upper(passenger_name) like '%KOROLEVA%'
select * from ticket_flights tf where ticket_no = '0005433342102' and fare_conditions = 'Business'
select arrival_airport, actual_arrival from flights where flight_id = '7071'
select airport_name from airports_data where airport_code = 'SCW'
-- В Сыктывкар в 2017-07-30 11:50:00.000 +0300
