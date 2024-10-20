USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS total_no_of_rows_movie FROM movie;
-- Total number of rows in movie table are 7997

SELECT COUNT(*) AS total_no_of_rows_genre FROM genre;
-- Total number of rows in genre table are 14662

SELECT COUNT(*) AS total_no_of_rows_director_mapping FROM director_mapping;
-- Total number of rows in director_mapping table are 3867

SELECT COUNT(*) AS total_no_of_rows_role_mapping FROM role_mapping;
-- Total number of rows in role_mapping table are 15615

SELECT COUNT(*) AS total_no_of_rows_names FROM names;
-- Total number of rows in names table are 25735

SELECT COUNT(*) AS total_no_of_rows_ratings FROM ratings;
-- Total number of rows in ratings table are 7997

/* INSIGHTS:
1. The fact that there are more genre entries suggests that some movies may be associated with multiple genres, contradicting the 
assumption of a one-to-one relationship between movies and genres according to the ERD.
2. As we can see, director_mapping table has fewer rows (3867) compared to the movie table (7997), suggests that some movies may have 
multiple directors, while others may not have any directors associated with them.
3. As the role_mapping table has more rows (15615) compared to the movie table (7997), this suggest that some movies may have multiple 
roles associated with them, while others may not have any roles associated with them.
4. As the count of rows in the movie table and ratings table is the same, this suggests that every movie in the dataset has been rated, 
and there are no movies without ratings, and vice versa.
5. The fact that  there are more rows in the names table than in the director_mapping and role_mapping tables supports the possibility 
that not all entries in the names table correspond to directors or roles in movies.
*/



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT COUNT(CASE                              -- count occurrences based on a condition
               WHEN id IS NULL THEN 1
             END) AS id_null_count,
       COUNT(CASE                              
               WHEN title IS NULL THEN 1
             END) AS title_null_count,
       COUNT(CASE                               
               WHEN year IS NULL THEN 1
             END) AS year_null_count,
       COUNT(CASE                                
               WHEN date_published IS NULL THEN 1
             END) AS date_published_null_count,
       COUNT(CASE                                     
               WHEN duration IS NULL THEN 1
             END) AS duration_null_count,
       COUNT(CASE                                    
               WHEN country IS NULL THEN 1
             END) AS country_null_count,
       COUNT(CASE                                       
               WHEN worlwide_gross_income IS NULL THEN 1
             END) AS worlwide_gross_income_null_count,
       COUNT(CASE                                    
               WHEN languages IS NULL THEN 1
             END) AS languages_null_count,
       COUNT(CASE                                      
               WHEN production_company IS NULL THEN 1
             END) AS production_company_null_count
FROM   movie; 
 
    
/*INSIGHTS:
'COUNTRY' column has 20 null values, 'WORLWIDE_GROSS_INCOME' column has 3724 null values, 'LANGUAGES' column 
has 194 null values, 'PRODUCTION_COMPANY' column has 528 null values, rest of the columns have no NULL values.
 */



-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)


/* Output format for the first part:
+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+ 

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- QUERY FOR THE FIRST PART OF THE QUESTION
SELECT year      AS Year,
       COUNT(id) AS number_of_movies
FROM   movie
GROUP  BY year
ORDER  BY year; 

/*Insights: With number of movies released over the three years, we can observe that their is a peak in 2017 
followed by a decrease in subsequent years. */

-- QUERY FOR THE SECOND PART OF THE QUESTION
SELECT MONTH(date_published) AS month_num,
       COUNT(id)             AS number_of_movies
FROM   movie
GROUP  BY MONTH(date_published)
ORDER  BY month_num; 

/*INSIGHTS: There is fluctuations throughout the year , likely influenced by seasonal variations and holidays 
March stands out as the month with the highest number of movie releases, then there is  increase in releases towards 
the end of the rainy season, particularly in September and October, there is also a sudden rise at the 
beginning of the new year.
*/



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT COUNT(id) AS country_movie_count
FROM   movie
-- Since there are movies that are associated with multiple countries, we should use LIKE operator
WHERE  year = '2019'
       AND ( country LIKE '%USA%'
              OR country LIKE '%India%' ); 

-- Insights: There is a total of 1059 movies released in the year 2019 in the countries USA or India.



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT genre AS List_of_genres
FROM   genre; 

-- INSIGHTS: There are 13 unique genres present in the dataset.





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT g.genre,
       COUNT(m.id) AS num_of_movies
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY genre
ORDER  BY num_of_movies DESC
LIMIT  1; 

-- INSIGHTS: 'Drama' genre has the highest number of movies with a count of 4285 movies belonging to that category. 



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT COUNT(movie_id) AS num_movies_with_single_genre
FROM   (SELECT movie_id
        FROM   genre
        GROUP  BY movie_id
        HAVING COUNT(*) = 1
       -- inner query is going to return all movie_id with exactly one genre associated with them
       ) AS single_genre_movies; 

-- INSIGHTS: We have 3289 movies belonging to a single genre in our dataset





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
       ROUND(AVG(m.duration),2) AS avg_duration
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
GROUP  BY genre;                        -- grouping by genre ensures that the average duration is calculated separately for each genre



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
WITH thriller_genre
     AS (SELECT g.genre,
                COUNT(m.id)                    AS movie_count,
                RANK()
                  OVER (
                    ORDER BY COUNT(m.id) DESC) AS genre_rank
         FROM   genre AS g
                INNER JOIN movie AS m
                        ON g.movie_id = m.id
         GROUP  BY genre)
SELECT genre,
       movie_count,
       genre_rank
FROM   thriller_genre
WHERE  genre = 'thriller'; 

-- INSIGHTS: The Thriller genre, with a movie count of 1484, holds the 3rd rank among all genres.




/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT MIN(avg_rating)    AS min_avg_rating,
       MAX(avg_rating)    AS max_avg_rating,
       MIN(total_votes)   AS min_total_votes,
       MAX(total_votes)   AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM   ratings; 

-- INSIGHTS: From the output, we can derive that the entire range of ratings, whether average or median, falls between 1 and 10 our your dataset


    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT   m.title,
         r.avg_rating,
         RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM     movie m
JOIN     ratings r
ON       m.id = r.movie_id
ORDER BY movie_rank LIMIT 10;

/*INSIGHTS: Movies such as 'Kirket' and 'Love in Kilnerry' have the most highest average ratings



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 

-- INSIGHTS: There is a gradual decline in movie counts as median ratings move away from the average rating of 7.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT production_company,
       COUNT(m.id)                    AS movie_count,
       DENSE_RANK()
         OVER (
           ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM   movie m
       JOIN ratings r
         ON m.id = r.movie_id
WHERE  r.avg_rating > 8
       AND production_company IS NOT NULL
GROUP  BY production_company; 

-- INSIGHTS: Both 'Dream Warrior Pictures' and 'National Theatre Live' production companies have produced the same number of movies.



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT g.genre,
       COUNT(m.id) AS movie_count
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  m.year = 2017
       AND MONTH(date_published) = 3         -- to extrach the month of March
       AND m.country REGEXP 'USA'            -- to match any value in the country column with substring "USA"
	   AND r.total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

/* INSIGHTS: Drama stands out as the most popular genre, with 24 movies released, followed by Comedy, 
Action and Thriller. But the output doesn’t provide much information about movie quality or ratings.



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT m.title      AS title,
       r.avg_rating AS avg_rating,
       g.genre      AS genre
FROM   genre AS g
       INNER JOIN movie AS m
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  m.title LIKE 'The%'               -- filtering by titles starting with 'The'
       AND r.avg_rating > 8
ORDER  BY avg_rating DESC; 

/*INSIGHTS:
1. Query is to  focus on those movies across different genres with exceptional ratings. 
2. Titles such as 'The Brighton Miracle', 'The Colour of Darkness' have garnered high average ratings 
across different genres, suggesting that these movies are well-received by audiences and critics.
3. Movies like 'The Blue Elephant 2' and 'Theeran Adhigaaram Ondru' have consistent average ratings 
across multiple genres.
*/



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(m.id) AS pre_yr_movie_count
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
       AND r.median_rating = 8; 

-- INSIGHTS: There are 361 movies with a median rating of 8 released between 1st April 2018 and 1st April 2019



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT country,                               -- retrieving movie information based on the country of origin
       SUM(total_votes) AS total_num_of_votes -- summing up the total number of votes across all movies from Germany and Italy
FROM   movie AS m
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  country = 'Germany'
        OR country = 'Italy' 
GROUP  BY country; 

-- INSIGHTS: 'German' movies received a higher total number of votes compared to Italian movies.




-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(CASE                                        -- count occurrences based on a condition
               WHEN NAME IS NULL THEN 1
             END) AS name_nulls,
       COUNT(CASE
               WHEN height IS NULL THEN 1
             END) AS height_nulls,
       COUNT(CASE
               WHEN date_of_birth IS NULL THEN 1
             END) AS date_of_birth_nulls,
       COUNT(CASE
               WHEN known_for_movies IS NULL THEN 1
             END) AS known_for_movies_nulls
FROM   names; 

/* INSIGHTS: 'name' column has no null values, whereas 'height' column has 17335 null values, the
'date_of_birth' column has 13431 null values and the 'known for movies' column consists of 15226 nulls.alter
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- CTE to find the top three genres with movies having an average rating > 8
WITH top_3_genres AS                                        -- creating a temporary result set
(
           SELECT     genre,
                      COUNT(DISTINCT m.id) AS count_movies  -- count number of distinct movies within each genre
           FROM       genre                AS g
           INNER JOIN movie                AS m
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre
           ORDER BY   COUNT(m.id) DESC 
           LIMIT 3 ),
           
-- CTE to find the top three directors in each of the top three genres
top_3_directors AS
(
           SELECT     n.NAME            AS director_name,
                      COUNT(d.movie_id) AS movie_count         -- count the number of movies directed by each director within those top genres
           FROM       names             AS n
           INNER JOIN director_mapping  AS d
           ON         n.id = d.name_id
           INNER JOIN ratings AS r
           ON         d.movie_id = r.movie_id
           INNER JOIN genre AS g
           ON         r.movie_id = g.movie_id
           INNER JOIN top_3_genres AS t3g
           ON         t3g.genre = g.genre
           WHERE      avg_rating > 8
           GROUP BY   n.NAME
           ORDER BY   movie_count DESC 
           LIMIT 3 )
-- Final query to retrieve top three directors in the top three genres
SELECT *
FROM   top_3_directors;

/*INSIGHTS: 
1. Top three genres are Drama, Action, and Comedy.
2. James Mangold has directed a total of 4 movies within the top genres.
3. Both Anthony Russo and Soubin Shahir have directed 3 movies each within these genres.
*/



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT n.name             AS actor_name,
       COUNT(rm.movie_id) AS movie_count
FROM   names AS n
       INNER JOIN role_mapping AS rm
               ON n.id = rm.name_id
       INNER JOIN movie AS m
               ON rm.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  median_rating >= 8
       AND category = 'actor'
GROUP  BY n.name
ORDER  BY movie_count DESC
LIMIT  2;

/* INSIGHTS: Actor 'Mammootty' and 'Mohanlal' are the top two actors with median rating above 8 and 
having a movie count of 8 and 5 respectively.
 */




/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_prod_comp
     AS (SELECT m.production_company                   AS production_company,
                SUM(r.total_votes)                     AS vote_count,
                Rank()
                  OVER (
                    ORDER BY SUM(r.total_votes) DESC ) AS prod_comp_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
         GROUP  BY m.production_company )
SELECT *
FROM   top_prod_comp
WHERE  prod_comp_rank <= 3; 

/* INSIGHTS: The top three production companies are 'Marvel Studios' with	2656967 votes, 
'Twentieth Century Fox' with 2411163 votes and 'Warner Bros.' with 2396057 votes.
*/


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

/* QUERY REQUIREMENT - We calculate the weighted average rating by multiplying the average rating by 
the total votes for each movie, summing these values across all movies for each actor, and then 
dividing by the total number of votes across all movies for that actor. */

WITH topactor AS
(
           SELECT     n.NAME                  AS actor_name,
                      SUM(r.total_votes)      AS total_votes,
                      COUNT(m.id)             AS movie_count,
                      Round(Sum(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2)   AS actor_avg_rating,
                      RANK() OVER ( ORDER BY SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC) AS actor_rank
           FROM       names                   AS n
           INNER JOIN role_mapping            AS rm
           ON         n.id = rm.name_id
           INNER JOIN movie AS m
           ON         rm.movie_id = m.id
           INNER JOIN ratings AS r
           ON         m.id = r.movie_id
           WHERE      m.country LIKE '%India%'
           AND        rm.category = 'ACTOR'
           GROUP BY   n.NAME
           HAVING     COUNT(m.id) >= 5 )
SELECT *
FROM   topactor 
LIMIT 1;
	
-- INSIGHTS: Top actor is Vijay Sethupathi with weighted average rating of 8.42.

        
        

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
	   n.NAME         			 AS actress_name,
       SUM(r.total_votes) 		 AS total_votes,
       COUNT(m.id)				 AS movie_count,
       ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2)  AS actor_avg_rating,
       Rank()
         OVER (
           ORDER BY SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC)  AS actress_rank
FROM   
	   names AS n
       INNER JOIN role_mapping AS rm
               ON n.id = rm.name_id
       INNER JOIN movie AS m
               ON rm.movie_id = m.id
       INNER JOIN ratings AS r
               ON m.id = r.movie_id
WHERE  m.country LIKE '%India%'
       AND rm.category = 'ACTRESS'
       AND m.languages LIKE '%Hindi%'
GROUP  BY n.NAME
HAVING COUNT(m.id) >= 3
LIMIT 5; 

/* INSIGHTS: Taapsee Pannu leads the ranking with an average rating of 7.74, followed by Kriti Sanon having the 
same movie count but a weighted average rating of 7.05, interestingly with highest votes, Shraddha Kapoor
with an average rating of 6.63 is on the 4th rank.
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title      AS movie_title,
       r.avg_rating AS avg_rating,
       CASE
         WHEN r.avg_rating > 8 THEN 'Superhit movies'
         WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END          AS avg_rating_classification
FROM   ratings AS r
       INNER JOIN movie AS m
               ON r.movie_id = m.id
       INNER JOIN genre AS g
               ON m.id = g.movie_id
WHERE  g.genre = 'Thriller'; 

-- INSIGHTS: There are 1484 movies that are in this list of 'Thriller' genres. 



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT     g.genre                                AS genre,
           ROUND(AVG(m.duration))                 AS avg_duration,
           SUM(ROUND(AVG(m.duration), 2)) OVER w1 AS running_total_duration,
           ROUND(AVG(AVG(duration)) OVER w2, 2)   AS moving_avg_duration
           -- first computing the average duration for each genre, then calculating the overall average of those genre averages using the window function OVER w2, and finally rounding the result

FROM       genre AS g
INNER JOIN movie AS m
ON         g.movie_id = m.id
GROUP BY   g.genre 
WINDOW 	   w1    AS (ORDER BY genre rows UNBOUNDED PRECEDING),
		   w2    AS (ORDER BY genre rows UNBOUNDED PRECEDING);

/*INSIGHTS:  
1.  While some genres like Action, Drama and Crime have longer average durations around 113-107 minutes, 
others like Horror and Sci-Fi have shorter films average durations around 93-98 minutes.
2. Overall moving average duration across all genres remains relatively stable at around 103-106 minutes
*/




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- To find the top three genres based on the most number of movies
WITH top_3_genres AS
(
           SELECT     g.genre,
                      COUNT(DISTINCT m.id) AS count_movies
           FROM       genre                AS g
           INNER JOIN movie                AS m
           ON         g.movie_id = m.id
           GROUP BY   g.genre
           ORDER BY   count_movies DESC 
           LIMIT 3 ),
           
-- To get top five movies of each year within the top three genres
top_5_movie_summary AS
(
           SELECT     g.genre AS genre,
                      m.year  AS year,
                      m.title AS movie_name,
                      -- converting varchar values to decimal data types before performing sorting and to get a consistent format
                      CAST(REPLACE(REPLACE(worlwide_gross_income, 'INR ', ''), '$ ', '') AS DECIMAL(15, 2)) AS gross_income,
                      -- rank movies within each year by partitioning them year wise
                      RANK() OVER (PARTITION BY m.year ORDER BY CAST(REPLACE(REPLACE(worlwide_gross_income, 'INR ', ''), '$ ', '') AS DECIMAL(15, 2)) DESC) AS movie_rank
           
           FROM       movie AS m                                                                                           
           INNER JOIN genre AS g                                                          
           ON         m.id = g.movie_id
           INNER JOIN top_3_genres AS t3g
           ON         g.genre = t3g.genre )
           

SELECT *                       -- To retrieve the top five movies of each year within the top three genres
FROM   top_5_movie_summary
WHERE  movie_rank <= 5;        -- filtering so as to include only movies with a rank less than or equal to 5

/* INSIGHTS: 
1. 'Thriller' movies dominate in 2017 and 2018, while 'Drama' takes the lead in 2019, 'comedy' genre maintains a consistent presence across all three years.
2. 'The Fate of the Furious' in 2017, 'The Villain' in 2018, and 'Avengers: Endgame' in 2019 emerged as the highest-grossing movies.
3. Year wise, 2019 stands out as a significant year for Drama, with 'Avengers: Endgame' and 'The Lion King' movie.
*/



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH multilingual_movies
     AS (SELECT m.production_company           AS production_company,
                COUNT(m.id)                    AS movie_count,
                RANK()
                  OVER (
                    ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                  ON m.id = r.movie_id
         WHERE  median_rating >= 8
                AND POSITION(',' IN languages) > 0        -- Identifying multilingual movies
                AND production_company IS NOT NULL
         GROUP  BY m.production_company)
SELECT *
FROM   multilingual_movies
WHERE  prod_comp_rank <= 2; 

-- INSIGHTS: Star Cinema produced 7 hits among multilingual movies, ranking first, whereas Twentieth Century Fox produced 4 hits among multilingual movies, ranking second.


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH super_hit_movies
     AS (SELECT n.NAME                                AS actress_name,
                SUM(total_votes)                      AS total_votes,
                COUNT(rm.movie_id)                    AS movie_count,
                ROUND(Avg(avg_rating), 2)             AS actress_avg_rating,
                Row_number()
                  OVER(
                    ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank
         FROM   names AS n
                INNER JOIN role_mapping AS rm
                        ON n.id = rm.name_id
                INNER JOIN movie AS m
                        ON rm.movie_id = m.id
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
                INNER JOIN genre AS g
                        ON r.movie_id = g.movie_id
         WHERE  category = 'Actress'
                AND r.avg_rating > 8
                AND genre = 'Drama'
         GROUP  BY n.NAME)
SELECT *
FROM   super_hit_movies
WHERE  actress_rank <= 3; 

/* INSIGHTS: Based on number of superhit movies, top three ACTRESSES are 'Parvathy Thiruvothu', 'Susan Brown' and 'Amanda Lawrence' on 
first , second and third rank respectively.
*/

   
   
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
-- Extracting necessary details
WITH movie_summary AS
(
           SELECT     d.name_id AS director_id,
                      n.NAME    AS director_name,
                      d.movie_id,
                      m.duration,
                      r.avg_rating,
                      r.total_votes,
                      m.date_published,
                      LEAD(m.date_published, 1) OVER (PARTITION BY d.name_id ORDER BY m.date_published) AS next_movie_date 
                                               -- patition by name_id to ensure inter-movie duration is calculated separately for each director's set of movies
           FROM       names               AS n
           INNER JOIN director_mapping    AS d
           ON         n.id = d.name_id
           INNER JOIN movie               AS m
           ON         m.id = d.movie_id
           INNER JOIN ratings             AS r
           ON         r.movie_id = m.id ),
           
-- Calculate interval days between consecutive movies
duration_of_inter_days AS
(
       SELECT *,
              DATEDIFF(next_movie_date, date_published) AS inter_movie_days
       FROM   movie_summary )
       
-- To get the top 9 directors based on the number of movies
SELECT   director_id,
         director_name,
         COUNT(movie_id)                 AS number_of_movies,
         ROUND(Avg(inter_movie_days), 2) AS avg_inter_movie_days,
         ROUND(Avg(avg_rating), 2)       AS avg_rating,
         SUM(total_votes)                AS total_votes,
         MIN(avg_rating)                 AS min_rating,
         MAX(avg_rating)                 AS max_rating,
         SUM(duration)                   AS total_duration
FROM     duration_of_inter_days
GROUP BY director_id,
         director_name
ORDER BY number_of_movies DESC 
LIMIT 9;
        
/*INSIGHTS: 
1. Directors with lower average inter-movie days tend to release movies more frequently, while those with higher values may
 have longer intervals between their movie releases. 
2. Directors like 'A.L. Vijay' has directed five movies, and has good average rating of 5.42 with just few votes.
3. In this query result list, director 'Steven Soderbergh's' movies seem popular with the highest votes obtained among all the top 9 directors 
*/


/*Summary:
1. The month of March appears to have the highest number of movie releases based on the monthly trend analysis.
2. We know there are overall 13 genres in our dataset, among those, DRAMA genre has the highest count of movies.
3. The overall duration of movies across all genres ranges from 92 to 113 minutes.
4. The top directors in Drama, Action, and Comedy genres are 'James Mangold', 'Anthony Russo', and 'Soubin Shahir', respectively, with all their movies 
   having an average rating greater than 8.
5. The top three production houses, based on the number of votes for their movies, are 'Marvel Studios', 'Twentieth Century Fox', and 
   'Warner Bros.'. However, 'Dream Warrior Pictures' and 'National Theatre Live' have produced the most hit movies with an average rating 
   above 8.
6. 'Vijay Sethupathi' emerges as the top actor in India with a good average rating of 8.42 and a movie count of 5.
7. The top Indian actresses in Hindi language movies are 'Taapsee Pannu' and 'Kriti Sanon', with an average rating of above 7.
8. In the multilingual category, 'Star Cinema' and 'Twentieth Century Fox' are leading production companies.
9. Actresses who worked in the Super hit movies of the Drama genre include 'Parvathy Thiruvothu', 'Susan Brown', and 'Amanda Lawrence', 
    making them potential candidates for future RSVP movie projects.
10. Overall, top directors to consider working with include 'James Mangold', known for consistently high ratings across all his movies, 
    and 'Steven Soderbergh', who is popular among audiences and maintains a good average rating.
*/
