/* Evaluation Module 2
Student: Ariana Papantonio
*/
--
USE sakila; 
--

-- Exercise 1: Select all movie names without including duplicates.  

SELECT 
	DISTINCT title AS unique_titles
FROM film; 
    
    
-- Exercise 2: Display the names of all the movies that have a rating of “PG-13".

SELECT 
	title,
	rating 
FROM film
WHERE
	rating = 'PG-13'; 
    
        
-- Exercise 3: Find the title and description of all movies that contain the word “amazing” in their description.

-- Using LIKE:
 
SELECT 
	title,
    description 
FROM film
WHERE
	description LIKE '%amazing%'; -- % % to find a sequence of characters at any position
    
-- Using REGEX: 

SELECT 
	title,
    description AS descripcion
FROM film
WHERE
	description REGEXP '\\bamazing\\b'; -- \\b as a word boundary 
    
    
-- Exercise 4: Find the title of all movies longer than 120 minutes. 

SELECT
	title 
 FROM film
 WHERE 
	length > '120'; 
    
    
-- Exercise 5: Find the name of all the actors.  

SELECT 
	first_name AS actors_names
FROM actor; 


-- Exercise 6: nd the first and last names of actors who have “Gibson” in their last name.

-- Using LIKE: 

SELECT 
	first_name, 
    last_name 
FROM actor
WHERE
	last_name LIKE '%Gibson%';	
    
-- Using REGEX: 

SELECT 
	first_name, 
    last_name
FROM actor
WHERE
	last_name REGEXP '\\bGibson\\b';	
    

-- Exercise 7: Find the names of actors with an actor_id between 10 and 20.

SELECT 
	first_name
FROM actor
WHERE
	actor_id BETWEEN 10 AND 20; -- value range
    

-- Exercise 8: Find the title of the films in the film table that are neither “R” nor “PG-13” in terms of rating

SELECT 
	title 
FROM film
WHERE 
	rating NOT IN ('PG-13','R'); -- used as a filter to confirm the value is not present in that list


-- Exercise 9: Find the total number of films in each classification in the film table and show the classification along with the count.

SELECT
	COUNT(film_id) AS film_count,
    rating 
FROM film
GROUP BY 
	rating
ORDER BY 
	film_count; 


-- Exercise 10: Find the total number of movies rented by each customer and display the customer ID, first and last name along with the number of movies rented.

/* Checking the total number of movies rented for each customer id:  

SELECT
	COUNT(rental_id) AS total_rentals, 
    customer_id
FROM rental
GROUP BY customer_id; 

*/

-- Final query: 

SELECT 
	c.customer_id, 
	c.first_name, 
    c.last_name, 
    COUNT(r.rental_id) AS total_rentals
FROM customer AS c
LEFT JOIN rental AS r -- left join para confirm if there are any customers that did not rent any movie. 
USING 
	(customer_id) 
GROUP BY
	c.customer_id, c.first_name, c.last_name
ORDER BY 
	total_rentals; 


-- Exercise 11: Find the total number of movies rented by category and display the category name along with the rental count.

/* Checking table unions:  
Table category: category_name & category_id
Table film_category: category_id & film_id
Table inventory: film_id & inventory_id
Table rental: inventory_id & rental_id
*/

SELECT 
    c.name AS category_name,
    COUNT(r.rental_id) AS total_rentals
FROM category AS c
	JOIN film_category as f
	USING
		(category_id)
	JOIN inventory AS i
	USING
		(film_id)
	JOIN rental AS r
	USING
		(inventory_id)
GROUP BY 
    category_name
ORDER BY total_rentals; 


-- Exercise 12: Find the average length of the films for each rating in the film table and display the rating along with the average length:

SELECT
	rating,
    AVG(length) AS avg_duration
FROM film
GROUP BY 
	rating
ORDER BY 
	avg_duration DESC; 
    
    
-- Exercise 13: Find the first and last names of the actors appearing in the movie titled “Indian Love”.

/* Checking table unions: 
Table film: title & film_id
Table film_actor: film_id & actor_id
Table actor: actor_id & first last name 
*/

SELECT 
	a.first_name,
    a.last_name 
FROM film AS f
JOIN film_actor AS fa
USING 
	(film_id)
JOIN actor AS a
USING
	(actor_id)
WHERE
	f.title = 'Indian Love'; 


-- Exercise 14: Show the title of all movies that contain the word “dog” or “cat” in their description.

-- Using 'LIKE': 
SELECT 
	title 
FROM film
WHERE 
	description LIKE '%dog%' OR description LIKE '%cat%';

-- 'Using REGEX': 
SELECT 
	title 
FROM film
WHERE
	description REGEXP '\\bdog\\b|\\bcat\\b'; -- \\b to define the word boundaries and the vertical bar | works as an “or” operator.


-- Exercise 15: Is there an actor or actress who does not appear in any movie in the film_actor table? 

SELECT 
	a.actor_id,  
	a.first_name,
    a.last_name 
FROM actor AS a -- to retrieve all the actors
LEFT JOIN film_actor AS fa --  to include all the entries from the table actor (even if there aren't any matches on the table film_actor).
USING 
	(actor_id)
WHERE 
	fa.actor_id IS NULL; 
    
    
-- Exercise 16: Find the title of all the movies that were released between 2005 and 2010.

SELECT 
	title AS movies_2005_2010
FROM film
WHERE 
	release_year BETWEEN 2005 AND 2010; 


-- Exercise 17: Find the title of all the movies that are in the same category as “Family”.

/* Checking table unions: 
Table film: title & film_id
Table film_category: film_id & category_id
Table category: category_id & name
*/

SELECT 
	f.title AS family_movies
FROM film AS f
JOIN film_category AS fa
USING
	(film_id)
JOIN category AS c
USING 
	(category_id) 
WHERE 
	c.name = 'Family'; 


-- Exercise 18: Show the first and last names of actors appearing in more than 10 movies.

/* Checking table unions: 
Table actor: name & actor_id
Table film_actor: actor_id & film_id

Checking subquery (actor_id with more than 10 films)
SELECT actor_id, COUNT(film_id) as total
FROM film_actor
GROUP BY actor_id
HAVING total > 10; 
*/

-- Option A: subquery 

SELECT 
	a.first_name,
	a.last_name
FROM actor AS a
WHERE a.actor_id IN (SELECT 
						fa.actor_id 
                        FROM film_actor AS fa
						GROUP BY fa.actor_id
						HAVING COUNT(fa.film_id > 10) -- There can only be one column in the select from the IN subquery so we include the COUNT function on the Having clause. 
					); 

-- Option B: grouping result by actor ID to avoid having duplicates in the actor's names or surnames (susan davis is duplicated)

SELECT 
	a.first_name,
    a.last_name 
FROM actor AS a
JOIN film_actor AS fa
USING
	(actor_id)
GROUP BY  
	a.actor_id, a.first_name, a.last_name
HAVING 
	COUNT(fa.film_id) > 10;


-- Exercise 19: Find the title of all the movies that are classified as “R” and have a duration longer than 2 hours in the film table.

SELECT 
	title 
FROM film
WHERE length > 120 AND rating = 'R'; 


-- Exercise 20: Find the categories of movies that have an average length time greater than 120 minutes and display the category name along with the average length time.

/* Checking table unions: 
Table category: name & category_id
Table film_category: category_id & film_id
Table film: film_id & length
*/

SELECT 
	c.name AS category_name,
    AVG(length) AS avg_length
FROM category AS c
JOIN film_category AS fc
USING
	(category_id)
JOIN film AS f
USING 
	(film_id)
GROUP BY 
	c.name
HAVING 
	avg_length > 120; 


-- Exercise 21: Find the actors who have acted in at least 5 movies and show the actor's name along with the number of movies they have acted in.

SELECT 
	a.first_name,
    COUNT(fa.film_id) AS total_movies
FROM actor AS a
JOIN film_actor AS fa
USING 
	(actor_id)
GROUP BY 
	a.actor_id, a.first_name -- we add the actor_id in the group by to avoid grouping actors that have the same first name
HAVING 
	total_movies > 5; 


-- Exercise 22: Find the title of all movies that were rented for more than 5 days. Use a subquery to find the rental_ids with a duration longer than 5 days and then select the corresponding movies

/* Checking table unions: 
Table rental:  rental_id & inventory_id
Table inventory: inventory_id & film_id
Table film: film_id & title
*/

/* Subquery: 
SELECT
rental_id
FROM sakila.rental
WHERE DATEDIFF(return_date, rental_date)> 5; -- DATEDIFF function is used to calculate the date difference between the return date and the rental date. 
*/

SELECT DISTINCT -- to avoid duplicates in the title of the movies
	f.title
FROM film AS f
JOIN inventory AS i
USING 
	(film_id)
JOIN rental AS r
USING 
	(inventory_id)
WHERE r.rental_id IN (SELECT
						r.rental_id
						FROM sakila.rental
						WHERE DATEDIFF(return_date, rental_date)> 5
                        );


-- Exercise 23: Find the first and last name of the actors who have not acted in any movie in the “Horror” category. Use a subquery to find actors who have acted in movies in the “Horror” category and then exclude them from the list of actors.

/* Checking table unions: 
SELECT * FROM actor; -- actor name & actor id
SELECT * FROM film_actor; -- actor id & film id
SELECT * FROM film_category; -- film id - category id
SELECT * FROM category; -- category id category name 
*/

/* Subquery: 
SELECT 
	a.actor_id
FROM actor AS a
JOIN film_actor AS fa
USING
	(actor_id)
JOIN film_category AS fc
USING
	(film_id)
JOIN category AS c
USING
	(category_id)
WHERE
	c.name = 'Horror'; 
*/

SELECT
	a.first_name,
    a.last_name 
FROM actor AS a
WHERE
	a.actor_id NOT IN (SELECT 
							a.actor_id 
						FROM actor AS a
						JOIN film_actor AS fa
						USING
							(actor_id)
						JOIN film_category AS fc
						USING
							(film_id)
						JOIN category AS c
						USING
							(category_id)
						WHERE
							c.name = 'Horror'); 


-- Exercise 24: Find the title of the comedy movies and have a running time longer than 180 minutes in the film table:

SELECT 
	f.title 
FROM film AS f
JOIN film_category AS fa
USING
	(film_id) 
JOIN category AS c
USING 
	(category_id)
WHERE 
	f.length > 180 AND c.name = 'Comedy'; 
    
-- 