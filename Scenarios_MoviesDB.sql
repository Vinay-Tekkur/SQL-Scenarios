-- Get minimum and maximum rated movied from subquery
SELECT * FROM movies
WHERE imdb_rating IN (
(SELECT MAX(imdb_rating) FROM movies),
(SELECT MIN(imdb_rating) FROM movies)
);

-- Get actors age between 75 and 85
SELECT * FROM(
SELECT *, YEAR(current_date()) - birth_year as age FROM actors) AS actors_age
WHERE age BETWEEN 75 AND 85;

-- Get all movies whose rating is greater than any ofthe marvel movies rating
SELECT * FROM movies WHERE imdb_rating > ANY(
SELECT imdb_rating FROM movies WHERE studio like "%Marvel%")
AND studio not like "%Marvel%";

SELECT * FROM movies WHERE imdb_rating IN (
SELECT imdb_rating FROM movies WHERE studio like "%Marvel%")
AND studio not like "%Marvel%";

-- Select actor_id, actor name, total number of movies they acted in
SELECT a.actor_id,a.name, COUNT(*) AS movies_acted
FROM movie_actor ma
JOIN actors a ON a.actor_id=ma.actor_id
GROUP BY a.actor_id
ORDER BY movies_acted DESC;

-- Using co-related subquery
SELECT
	actor_id,
    name,
    (SELECT COUNT(*) FROM movie_actor WHERE actor_id=actors.actor_id) AS movies_count
FROM actors
ORDER BY movies_count DESC;

-- Exersise
-- 1. Select all the movies with minimum and maximum release_year. Note that there
-- can be more than one movie in min and a max year hence output rows can be more than 2
SELECT * FROM movies
WHERE release_year in
((SELECT MIN(release_year) FROM movies), (SELECT MAX(release_year) FROM movies));

-- 2. Select all the rows from the movies table whose imdb_rating is higher than the average rating
SELECT * FROM movies
WHERE imdb_rating > (SELECT ROUND(AVG(imdb_rating), 2) FROM movies);

-- Get all actors age between 70 and 85
SELECT
*
FROM 
(SELECT name, YEAR(current_date()) - birth_year AS age FROM actors) actors_age
WHERE age between 70 and 85;

WITH actors_age(actor_name, actor_age) AS
(SELECT name, YEAR(current_date()) - birth_year AS age FROM actors)
SELECT actor_name, actor_age FROM actors_age
WHERE actor_age BETWEEN 70 AND 85;

-- Get movies list who made 500% profit and rating less than average rating of all movies
SELECT movie_id, ROUND((revenue - budget) * 100 / budget, 2) AS per_profit FROM financials;

SELECT * FROM movies 
WHERE imdb_rating < (SELECT ROUND(AVG(imdb_rating),2) FROM movies);

-- Using sub-query
SELECT * FROM
(SELECT movie_id, ROUND((revenue - budget) * 100 / budget, 2) AS per_profit FROM financials) x
JOIN (SELECT * FROM movies 
WHERE imdb_rating < (SELECT ROUND(AVG(imdb_rating),2) FROM movies)) y
ON x.movie_id=y.movie_id
WHERE per_profit >= 500;

-- Using CTE
WITH x as
(SELECT movie_id, ROUND((revenue - budget) * 100 / budget, 2) AS per_profit FROM financials),
y as (SELECT * FROM movies 
WHERE imdb_rating < (SELECT ROUND(AVG(imdb_rating),2) FROM movies))
SELECT x.movie_id, x.per_profit, y.title, y.imdb_rating FROM x
join y on x.movie_id=y.movie_id
WHERE per_profit >= 500;

-- Select all Hollywood movies released after the year 2000 that made more than 
-- 500 million $ profit or more profit. Note that all Hollywood movies have millions as 
-- a unit hence you don't need to do the unit conversion. Also, you can write this query without 
-- CTE as well but you should try to write this using CTE only

-- Using sub-query
SELECT
	m.movie_id, m.title, m.industry,f.profit
FROM movies m 
JOIN (SELECT movie_id, (revenue - budget) AS profit FROM financials) f 
ON f.movie_id=m.movie_id 
WHERE m.industry="Hollywood" AND profit>=500;

-- Using CTE
WITH hollywood_movies AS
(SELECT movie_id,title,industry,release_year,studio FROM movies WHERE industry="Hollywood"),
movie_financials AS (SELECT movie_id, (revenue - budget) AS profit FROM financials)
SELECT * FROM hollywood_movies h
JOIN movie_financials mf ON mf.movie_id=h.movie_id
WHERE profit >= 500;


SELECT DISTINCT(imdb_rating) FROM movies
ORDER BY imdb_rating DESC
LIMIT 1
OFFSET 5;

-- Extracting JSON data types
SELECT * FROM items
WHERE properties -> "$.is_salted"=1;

SELECT * FROM items
WHERE properties -> "$.is_salted"=0;

SELECT * FROM items
WHERE JSON_EXTRACT(properties, "$.is_salted")=0;


