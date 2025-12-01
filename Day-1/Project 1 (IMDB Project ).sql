create database day1project;

use day1project;


select * from imdb_cast;
select * from imdb_actors;
select * from imdb_movies;


-- 1) List all movies along with their lead actors.

select  m.title, a.name , c.role
from imdb_movies m 
join imdb_cast c on m.movie_id = c.movie_id
join imdb_actors a on c.actor_id = a.actor_id
where c.role = "Lead";

-- 2) Find movies that feature more than 5 actors.

select m.movie_id, m.title, count(distinct a.actor_id) as cast_count
from imdb_movies m 
join imdb_cast c on m.movie_id = c.movie_id
join imdb_actors a on c.actor_id = a.actor_id
group by m.movie_id, m.title
having count(distinct a.actor_id) > 5;

-- 3) Count how many movies each actor has acted in.

select a.actor_id, a.name , count(m.movie_id) as Movie_count
from imdb_movies m 
join imdb_cast c on m.movie_id = c.movie_id
join imdb_actors a on c.actor_id = a.actor_id
group by a.actor_id, a.name;

-- 4) Find the top 10 actors who played the most lead roles.

select a.actor_id, a.name , count(c.role) as rc
from imdb_cast c
join imdb_actors a on c.actor_id = a.actor_id
where c.role = "Lead"
group by a.actor_id, a.name
order by rc desc
limit 10;

-- 5) Identify actors who acted in both Action and Drama movies.

select distinct a.actor_id,  a.name 
from imdb_movies m 
join imdb_cast c
on m.movie_id = c.movie_id
join imdb_actors a
on c.actor_id = a.actor_id
where m.genre in ("Action", "Drama")
group by a.actor_id,a.name
having count(distinct m.genre)=2;

-- 6) List all movies released after 2010 with at least one actor born after 1995.

select distinct m.title
from imdb_movies m 
join imdb_cast c
on m.movie_id = c.movie_id
join imdb_actors a
on c.actor_id = a.actor_id
where m.release_year > 2010 and a.birth_year >1995;

-- 7) Find all actors who have never played a lead role.

select a.actor_id, a.name
from imdb_actors a
left join imdb_cast c
on a.actor_id = c.actor_id and c.role = 'Lead'
where c.actor_id is null;

-- 8) For each movie, show total number of cast members.

select m.movie_id, m.title, count(distinct a.actor_id)
from imdb_movies m 
join imdb_cast c on m.movie_id = c.movie_id
join imdb_actors a on c.actor_id = a.actor_id
group by m.movie_id, m.title;

-- 10) Find actors who have acted in movies across 5 different genres.

select a.actor_id, a.name, count(distinct m.genre) as cg
from imdb_movies m 
join imdb_cast c
on m.movie_id = c.movie_id
join imdb_actors a
on c.actor_id = a.actor_id
group by a.actor_id, a.name
having cg >= 5;

-- 11) Get the youngest actor in every genre (based on movies they acted in).

with actor_age as (
  select m.genre, a.actor_id, a.name, (m.release_year - a.birth_year) as age_at_release
  from imdb_movies m
  join imdb_cast c   on m.movie_id = c.movie_id
  join imdb_actors a on c.actor_id = a.actor_id
)

select genre, actor_id, name, age_at_release
from (
  select genre, actor_id, name, age_at_release,
    row_number() over (partition by genre order by age_at_release asc, name) as rn
    from actor_age
) t
where rn = 1;



-- 13) For each movie, calculate the age of every actor at the time of movie release.

select m.title, a.name, (m.release_year - a.birth_year) as age
from imdb_movies m 
join imdb_cast c
on m.movie_id = c.movie_id
join imdb_actors a
on c.actor_id = a.actor_id;

-- 14) Identify the most frequently cast actor in Sci-Fi movies.

select a.actor_id, a.name, count(distinct m.genre) as feq
from imdb_movies m 
join imdb_cast c on m.movie_id = c.movie_id
join imdb_actors a on c.actor_id = a.actor_id
where m.genre = "Sci-Fi"
group by a.actor_id, a.name
order by feq desc
limit 1;



