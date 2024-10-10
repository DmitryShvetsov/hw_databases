-- Создаю базу данных локально.
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


