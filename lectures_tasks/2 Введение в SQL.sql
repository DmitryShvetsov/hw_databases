--Введение в SQL
--1) Стоимость самого дорогого бронирования за 31.07.2017
select total_amount from bookings b
order by total_amount desc
limit 1
--1308700.00

--2) Сколько бронирований с минимальной ценой?
select min(total_amount) from bookings b
select count(*) count from bookings b where total_amount = 3400.00
-- 427

--3) Какие статусы полетов существуют?
select distinct status from flights

--4) Сколько различных моделей самолетов находятся в воздухе?
select
count (distinct aircraft_code) count
from flights
where actual_departure is not null and actual_arrival is null
--8

--5) В какой город прилетает самолет, прибывший 14.08.2017, который вылетел из аэропорт с кодом, который оканчивается
--на букву “K” и для которого время полета было вторым по длительности (для времени по расписанию и времени
--по факту полета)
select arrival_airport
,scheduled_arrival - scheduled_arrival
,actual_arrival - actual_departure
from flights
where cast(actual_arrival as date) = '2017-08-14'
and upper(departure_airport) like '%K'
order by 2,3 desc limit 1 offset 1

select airport_name from airports_data where airport_code = 'SVO'
--Москва, Шереметьево.

--6) На каких рейсах происходили самые длительные задержки? Выведите список из десяти рейсов, задержанных
-- на самые длительные сроки?
select
flight_id
,flight_no
,actual_departure - scheduled_departure
from flights
where actual_departure is not null and scheduled_departure is not null
order by 3 desc
limit 10

--7) Полет с каким id имеет самую большую разницу между запланированным временем вылета и фактическим?
select flight_no, actual_departure - scheduled_departure from flights
where actual_departure is not null and scheduled_departure is not null
order by 2 desc limit 1
--PG0073

--8) Вывести цены самых дорогих билетов в каждом классе обслуживания.
select fare_conditions , max(amount)
from ticket_flights
group by 1
order by 2 desc
--203300.00 74500.00 47600.00

--9) Вывести второго по алфавиту пассажира с именем и фамилией на букву "A"
select passenger_name from tickets
where upper(passenger_name) like 'A%'
order by passenger_name limit 1 offset 1
-- ADELINA AFANASEVA

--10) Вывести самое долгое время полета за 08.08.2017.
select actual_arrival - actual_departure flight_time from flights
where cast(actual_departure as date) = '2017-08-08'
order by 1 desc limit 1
--08:54:00
--08:56:00 если дату считать по дате прибытия.
