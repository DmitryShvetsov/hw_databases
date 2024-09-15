--Введение в SQL
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
