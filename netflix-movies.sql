SET search_path=netflix_movies;

--1 Display the first 10 rows of raw titles--
SELECT *
FROM raw_titles
LIMIT 10;

--2 Count the number of rows in best movies by year--
SELECT COUNT(*) AS count_movies
FROM best_movie_by_year;

--3 Who are the characters in netflix best movies by year?--
WITH CTE AS 
(SELECT rc.id, title, type, character
FROM raw_credit AS rc
INNER JOIN raw_titles AS rt
USING(id))

SELECT title, release_year, character
FROM best_movie_by_year AS bmy
INNER JOIN CTE
USING(title);

--4 Who are the characters in Netflix best_show_by_year?--
SELECT bsy.title, name
FROM raw_credit AS rc
INNER JOIN raw_titles AS rt
USING(id)
INNER JOIN best_show_by_year AS bsy
ON rt.title=bsy.title;

--5 Which show and movie have the same title?--
SELECT title
FROM best_movies
INTERSECT 
SELECT title
FROM best_shows;

--6 What are the ranks of best_movies_by_year based on their genre--
SELECT DENSE_RANK() OVER(PARTITION BY main_genre ORDER BY imdb_score DESC) AS rank_n,
title, release_year, imdb_score, main_genre
FROM best_movie_by_year;

--7 How many movies did not make it to best movies by year list?--
SELECT COUNT(DISTINCT title) AS unrated_movies
FROM best_movies
WHERE title NOT IN
(SELECT title FROM best_movie_by_year);

--8 How many shows did not make it to best shows by year list?--
WITH CTE_2 AS 
(SELECT title
FROM best_shows
EXCEPT
SELECT title FROM best_show_by_year)

SELECT COUNT(*) FROM CTE_2;

--9 Was there anytime a country win best_movie_by_year in consecutive years?--
SELECT title, release_year, country_of_production,
LAG(country_of_production) OVER(ORDER BY release_year DESC)
FROM best_movie_by_year;
 
--10 Find the percentage of movies and shows--
WITH CTES AS
(SELECT type, COUNT(type) AS type_count
FROM raw_titles
GROUP BY type);

SELECT ROUND((MIN(type_count)/SUM(type_count)), 2)*100 AS show_percentage,
ROUND((MAX(type_count)/SUM(type_count)), 2)*100 AS movie_percentage 
FROM CTES;

--11 Find the number of each certification--
SELECT certification, COUNT(*) AS certification_count
FROM raw_titles
GROUP BY certification
HAVING certification IS NOT NULL
ORDER BY certification_count DESC;

--12 What does each certification stand for?--
SELECT certification,
(CASE WHEN certification='TV-MA' THEN 'Mature Audience only'
WHEN certification='R' THEN 'Restricted'
WHEN certification='TV-14' THEN 'Unsuitable for children under 14 years of age'
WHEN certification='PG-13' THEN 'Parental Guidance If Under 13'
WHEN certification='PG' THEN 'Parental Guidance Suggested'
WHEN certification='TV-PG' THEN 'Parental Guidance is recommended'
WHEN certification='G' THEN 'Appropriate for people of all ages'
WHEN certification='TV-Y7' THEN 'Most appropriate for children age 7 and up'
WHEN certification='TV-Y' THEN 'Aimed at a very young audience, including children from ages 2-6'
WHEN certification='TV-G' THEN 'programs suitable for all ages'
WHEN certification='NC-17' THEN 'No children under 17'
END) AS certification_meaning
FROM raw_titles GROUP BY certification;

--13 What is the average runtime of best_movies_by_year--
SELECT title, release_year,
(SELECT ROUND(AVG(runtime), 1) AS avg_runtime
FROM raw_titles
WHERE best_movie_by_year.title=raw_titles.title) AS subquery
FROM best_movie_by_year
GROUP BY title, release_year;

--14 What is the average runtime of best_show_by_year?--
SELECT title, bsy.release_year, ROUND(AVG(runtime), 1) AS avg_runtime
FROM best_show_by_year AS bsy
INNER JOIN raw_titles AS rt 
USING(title) 
GROUP BY title, bsy.release_year;

--15 How many shows did each country produce?--
SELECT country_of_production,
COUNT(type) AS show_count
FROM best_show_by_year
INNER JOIN raw_titles
USING(title)
GROUP BY country_of_production;

--16 What is the role of each character in best movie by year and best show by year?--
WITH CTE_3 AS
(SELECT title
FROM best_movie_by_year AS bmy
FULL JOIN best_show_by_year AS bsy
USING(title)),

CTE_4 AS
(SELECT id, type, title, name, character, role 
FROM raw_credit
INNER JOIN raw_titles USING(id))

SELECT CTE_3.title, type, name, character, role
FROM CTE_3
INNER JOIN 
CTE_4 USING(title);

--17 How many movies did each country produce?--
SELECT country_of_production,
COUNT(type) AS movie_count
FROM best_movie_by_year
INNER JOIN raw_titles
USING(title)
GROUP BY country_of_production;

--18 How many characters are uncredited--
SELECT COUNT(character) AS uncredited_characters
FROM raw_credit
WHERE character LIKE '%uncredited%';

--19 What is the duration of best_movie_by_year in hours?--
SELECT best_movie_by_year.title, (duration/60) AS duration_in_hours
FROM best_movie_by_year
INNER JOIN best_movies
USING(title);

--20 Which movies have votes greater than 200000?--
SELECT title, imdb_score, subquery.number_of_votes 
FROM
(SELECT title, bmy.imdb_score, number_of_votes
FROM best_movie_by_year AS bmy
INNER JOIN best_movies AS bm
USING(title)) AS subquery
WHERE subquery.number_of_votes > 200000;

-- 21 Which shows have votes greater than 200000?--
SELECT title, imdb_score, number_of_votes
FROM best_show_by_year
INNER JOIN best_shows
USING(title)
WHERE number_of_votes > 200000;

--22 What is the duration of best_show_by_year?--
SELECT best_show_by_year.title, duration
FROM best_show_by_year
INNER JOIN best_shows
USING(title);

--23 Was there anytime a country win best_show_by_year in consecutive years?
SELECT title, release_year, country_of_production,
LAG(country_of_production) OVER(ORDER BY release_year DESC)
FROM best_show_by_year;

--24 Who are the directors of netflix best movies by year?--
SELECT bsy.title, name, role
FROM raw_credit AS rc
INNER JOIN raw_titles AS rt
USING(id)
INNER JOIN best_movie_by_year AS bsy
ON rt.title=bsy.title
WHERE role='DIRECTOR';

--25 Who are the directors of netflix best show by year?--
SELECT bsy.title, name, role
FROM raw_credit AS rc
INNER JOIN raw_titles AS rt
USING(id)
INNER JOIN best_show_by_year AS bsy
ON rt.title=bsy.title
WHERE role='DIRECTOR';

--26 Which director has the most netflix movies?--
SELECT name, COUNT(role) AS role_count
FROM raw_titles
INNER JOIN raw_credit 
USING(id) 
WHERE role='DIRECTOR' 
GROUP BY name
ORDER BY role_count DESC;

--27 Which genre has the highest vote in netflix best movie by year--
SELECT bmy.main_genre, SUM(number_of_votes) genre_votes
FROM best_movie_by_year bmy
INNER JOIN best_movies AS bm
USING(title) 
GROUP BY bmy.main_genre
ORDER BY genre_votes DESC;

--28 What are the best Netflix movies for kids?--
SELECT title
FROM raw_titles
WHERE certification='TV-Y'
ORDER BY imdb_score DESC
LIMIT 10;

--29 What are the top Netflix movies for teens?--
SELECT title
FROM raw_titles
WHERE certification='PG-13'
ORDER BY imdb_score DESC
LIMIT 10;

--30 What are the highest-rated Netflix horror movies?--
SELECT title
FROM raw_titles
WHERE genres LIKE '%horror%'
ORDER BY imdb_score DESC
LIMIT 10;

--31 What are the best comedy Netflix movies?--
SELECT title
FROM raw_titles
WHERE genres LIKE '%comedy%'
ORDER BY imdb_score DESC
LIMIT 10;