-- 1. How many movies were released between 2015 and 2022
SELECT
	COUNT(title) AS movies_released
FROM movies 
WHERE release_year BETWEEN 2015 AND 2022;

-- 2. Print the max and min movie release year
SELECT
	MIN(release_year) AS min_release_year,
    MAX(release_year) AS max_release_year
FROM movies;

-- 3. Print a year and how many movies were released in that year starting with the latest year
SELECT
	release_year,
    COUNT(*) AS count_of_movies_released
FROM movies
GROUP BY release_year
order by count_of_movies_released DESC;

-- Get age of each actor
SELECT name, YEAR(CURDATE()) - birth_year AS Age FROM actors;

-- Get profit of each movies
SELECT *, (revenue - budget) AS profit FROM financials;

-- if currency is USD then keep revenue otherwise use INR
SELECT *,
	IF(currency="USD", revenue * 77, revenue) AS India_rupees
FROM financials;

SELECT DISTINCT unit FROM financials;

SELECT *,
CASE 
	WHEN unit="Billions" THEN 1000000000
    WHEN unit="Millions" THEN 1000000
    ELSE
	1000 END AS unit_conversion
-- ROUND(unit_conversion * revenue, 2) AS revenue_conversion,
-- ROUND(unit_conversion * budget, 2) AS budget_conversion
FROM financials;

-- 1. Print profit % for all the movies
SELECT *, 
(revenue - budget) AS profit,
(revenue - budget)*100 / budget AS profit_percent
FROM financials ;

SELECT * from actors WHERE actor_id % 2 = 1;

SELECT * FROM movies;
SELECT COUNT(*) FROM movies;
SELECT COUNT(imdb_rating) FROM movies;
SELECT * FROM movies WHERE imdb_rating IS NULL;

-- Joins Exercises
-- 1. Show all the movies with their language names
SELECT
	title, industry, studio
FROM movies m
JOIN languages l USING (language_id);

-- 2. Show all Telugu movie names (assuming you don't know the language id for Telugu)
SELECT title, industry, studio,imdb_rating ,name FROM movies m
JOIN languages l using(language_id) 
WHERE l.name like "%telugu%";

-- 3. Show the language and number of movies released in that language
SELECT
	l.name, m.release_year, COUNT(*) AS movies_released
FROM movies m 
INNER JOIN languages l USING(language_id) 
GROUP BY l.name, m.release_year;

-- Get highest profit movie of bollywood
SELECT
	m.movie_id, title, industry, studio, budget, revenue, unit,
    CASE
		WHEN unit="thousands" THEN ROUND((revenue - budget) / 1000,2)
        WHEN unit="Billions" THEN ROUND((revenue - budget) * 1000,2)
        ELSE ROUND((revenue - budget),2)
	END AS Profit
FROM movies m 
INNER JOIN financials f ON m.movie_id=f.movie_id
ORDER BY profit DESC;

-- Get film names with actors name seperated by " | " symbol
SELECT 
m.title, group_concat(a.name SEPARATOR '  |  ') 
 FROM movies m
JOIN movie_actor ma USING(movie_id)
JOIN actors a USING(actor_id)
GROUP BY m.title;

-- Get actor name their movies seperated by dual pipes
SELECT 
a.name, GROUP_CONCAT(m.title separator "  || ") AS Movies_Name_acted,
COUNT(m.title) AS movies_count_acted
 FROM actors a
JOIN movie_actor ma USING(actor_id)
JOIN movies m USING(movie_id)
GROUP BY a.name
ORDER BY movies_count_acted DESC;

-- 1. Generate a report of all Hindi movies sorted by their revenue amount in millions.
-- Print movie name, revenue, currency, and unit
SELECT 
m.title, f.revenue, f.currency, f.unit,
CASE 
	WHEN unit="thousands" THEN ROUND(revenue/1000,2)
    WHEN unit="billions" THEN ROUND(revenue * 1000,2)
    ELSE revenue
END AS revenue_in_millions
FROM financials f
INNER JOIN movies m USING(movie_id)
JOIN languages l USING(language_id)
WHERE l.name="Hindi"
ORDER BY revenue_in_millions DESC;


