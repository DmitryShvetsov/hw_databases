-- Разобьём отношения так, чтобы значения зависели только от первичного ключа.

-- Выведем color в отдельную таблицу.
create table colors as
(
select
row_number() OVER (ORDER by color) color_id
,subquery.*
from (
select distinct
color
from cars
where color != '' and color is not null
) subquery
)

-- Заменим столбец color на color_id в cars.
create table cars as
(
select
row_number() OVER (ORDER by vin) car_id
,subquery.*
from (
select distinct
car
,vin
,car_number
,color_id
from all_data ad
left join colors using (color)
) subquery
)

 -- Другие столбцы в отдельные отношения не выделяю, т.к. считаю пары client_id - first_name,
 -- vin - car и т.д. статичными.
