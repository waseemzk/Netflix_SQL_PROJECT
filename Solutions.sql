-- Netflix Project

DROP TABLE IF EXISTS NETFLIX1;
Create Table NETFLIX1
(
  show_id           varchar(10), 
  typess            varchar(10),
  title             varchar(150),
  director          varchar(250),
  casts             varchar(1000),
  country           varchar(150),
  date_added        varchar(50),
  release_year      INT,
  rating            varchar(10),
  duration          varchar(15),
  listed_in         varchar(100),
  description       varchar(300)
);

-- skip the first line (which contains column names).

COPY netflix1 FROM 'C:\Users\MSI\Desktop\Netflix SQL Project\DataSet\netflix_titles.csv' DELIMITER ',' CSV HEADER;

-- CHECK

SELECT * FROM NETFLIX1;

-- CHECK HOW MANY RECORD WE HAVE

SELECT COUNT(*) AS TOTAL_CONTENT FROM NETFLIX1;

-- CHECK TYPES

SELECT DISTINCT TYPESS FROM NETFLIX1;

-- business problems

-- 1. Count the number of Movies vs TV Shows

SELECT * FROM NETFLIX1;

SELECT TYPESS, COUNT(TYPESS) AS Movies_vs_TVShows FROM NETFLIX1 GROUP BY TYPESS;

-- 2. Find the most common rating for movies and TV shows

SELECT * FROM NETFLIX1;

SELECT TYPESS,RATING

FROM 

(
  SELECT TYPESS,RATING, COUNT(RATING) AS MOST_COMMON, RANK() OVER(PARTITION BY TYPESS ORDER BY COUNT(RATING) DESC ) AS RANKING FROM NETFLIX1 GROUP BY RATING,TYPESS 
) 

AS T1 

WHERE RANKING = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

SELECT * FROM NETFLIX1;

SELECT TYPESS,TITLE,release_year FROM NETFLIX1 WHERE TYPESS = 'Movie' AND release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

SELECT * FROM NETFLIX1;

SELECT UNNEST(STRING_TO_ARRAY(COUNTRY , ',')) AS NEW_COUNTRY, COUNT(COUNTRY) AS MOST_CONTENT FROM NETFLIX1 GROUP BY NEW_COUNTRY ORDER BY 2 DESC LIMIT 5;

-- 5. Identify the longest movie

SELECT * FROM NETFLIX1 WHERE TYPESS = 'Movie' AND DURATION = (SELECT MAX(DURATION) FROM NETFLIX1);

-- 6. Find content added in the last 5 years

SELECT * FROM NETFLIX1 where TO_DATE(DATE_ADDED, 'Month, DD, YYYY') >= current_date - interval '5 years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM NETFLIX1 WHERE DIRECTOR LIKE '%Rajiv Chilaka%';

-- 8. List all TV shows with more than 5 seasons

-- Solution 1

SELECT * FROM NETFLIX1
         WHERE typess = 'TV Show'
		 and Duration NOT IN ('5 Seasons','4 Seasons','3 Seasons','2 Seasons','1 Season')
		 and Duration  not like '%min%';

-- Solution 2

SELECT * FROM NETFLIX1 WHERE TYPESS = 'TV Show' and SPLIT_PART(DURATION, ' ' , 1)::numeric > 5;

-- 9. Count the number of content items in each genre

SELECT UNNEST(STRING_TO_ARRAY(LISTED_IN, ',')) AS GENRE, COUNT(*) FROM NETFLIX1 GROUP BY GENRE ORDER BY 2 DESC;


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


SELECT 
      EXTRACT(YEAR FROM TO_DATE(DATE_ADDED, 'Month, DD, YYYY')) AS YEARS,
      COUNT(*), ROUND(COUNT(*)::numeric/(SELECT COUNT(*)FROM NETFLIX1 WHERE COUNTRY = 'India') * 100, 2) as avg_content
      FROM NETFLIX1 WHERE COUNTRY = 'India' GROUP BY 1;


-- 11. List all movies that are documentaries

SELECT * FROM NETFLIX1;

SELECT * FROM netflix1
WHERE listed_in LIKE '%Documentaries';

-- 12. Find all content without a director

SELECT * FROM netflix1
WHERE director IS NULL;








