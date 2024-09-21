--1) Вывести список фильмов для каждого актера. (dvdrental)
select * from film f

select first_name
,last_name la
,f.title
from actor a
join film_actor fa
on fa.actor_id = a.actor_id
join film f
on f.film_id = fa.film_id

