--Введение в базы данных
--1) Сколько кодов аэропортов начинаются с гласной буквы?
select count(distinct airport_code) count from airports_data where regexp_like(UPPER(airport_code), '^A|E|I|O|U')
--52

--2) Код самолета с наибольшей дальностью полета.

