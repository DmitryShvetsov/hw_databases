--Введение в базы данных
--1) Сколько кодов аэропортов начинаются с гласной буквы?
select count(*) count from airports_data where regexp_like(UPPER(airport_code), '^A|E|I|O|U')
