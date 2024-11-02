/* Evaluación Módulo 2
Alumna: Ariana Papantonio
*/
--
USE sakila; 
--

-- Ejercicio 1: Selecciona todos los nombres de las películas sin que aparezcan duplicados. 

SELECT 
	DISTINCT title AS titulos_únicos
FROM film; 
    
    
-- Ejercicio 2: Muestra los nombres de todas las películas que tengan una clasificación de "PG-13.

SELECT 
	title AS titulo,
	rating AS clasificacion
FROM film
WHERE
	rating = 'PG-13'; 
    
        
-- Ejercicio 3:  Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

-- Utilizando LIKE:
 
SELECT 
	title AS titulo,
    description AS descripcion
FROM film
WHERE
	description LIKE '%amazing%'; -- % % para encontrar esa secuencia de caracteres en cualquier posición
    
-- Utilizando REGEX: 

SELECT 
	title AS titulo,
    description AS descripcion
FROM film
WHERE
	description REGEXP '\\bamazing\\b'; -- \\b para delimitar la palabra
    
    
-- Ejercicio 4:  Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. 

SELECT
	title AS titulo
 FROM film
 WHERE 
	length > '120'; 
    
    
-- Ejercicio 5: Recupera los nombres de todos los actores. 

SELECT 
	first_name AS nombres_actores
FROM actor; 


-- Ejercicio 6: Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.

-- Utilizando LIKE: 

SELECT 
	first_name AS nombre, 
    last_name AS apellido
FROM actor
WHERE
	last_name LIKE '%Gibson%';	
    
-- Utilizando REGEX: 

SELECT 
	first_name AS nombre, 
    last_name AS apellido
FROM actor
WHERE
	last_name REGEXP '\\bGibson\\b';	
    

-- Ejercicio 7: Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20

SELECT 
	first_name AS nombre
FROM actor
WHERE
	actor_id BETWEEN 10 AND 20; -- rango de valores
    

-- Ejercicio 8: Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación

SELECT 
	title AS titulo
FROM film
WHERE 
	rating NOT IN ('PG-13','R'); -- filtrar que el valor no esté presente en esa lista


-- Ejercicio 9: Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento

SELECT
	COUNT(film_id) AS recuento_peliculas,
    rating AS clasificacion
FROM film
GROUP BY 
	clasificacion
ORDER BY 
	recuento_peliculas; 


-- Ejercicio 10: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas

/* Comprobación cantidad total de películas alquiladas por cada id de cliente: 

SELECT
	COUNT(rental_id) AS total_alquileres, 
    customer_id
FROM rental
GROUP BY customer_id; 

*/

-- Query final: 

SELECT 
	c.customer_id, 
	c.first_name, 
    c.last_name, 
    COUNT(r.rental_id) AS total_alquileres
FROM customer AS c
LEFT JOIN rental AS r -- left join para comprobar en caso que algún cliente no haya alquilado películas. 
USING 
	(customer_id) 
GROUP BY
	c.customer_id, c.first_name, c.last_name
ORDER BY 
	total_alquileres; 


-- Ejercicio 11:  Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres

/* Comprobación uniones: 
Tabla category: category_name & category_id
Tabla film_category: category_id & film_id
Tabla inventory: film_id & inventory_id
Tabla rental: inventory_id & rental_id
*/

SELECT 
    c.name AS nombre_categoria,
    COUNT(r.rental_id) AS total_alquileres
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
    c.name
ORDER BY total_alquileres; 


-- Ejercicio 12: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración: 

SELECT
	rating AS clasificación,
    AVG(length) AS promedio_duración
FROM film
GROUP BY 
	clasificación
ORDER BY 
	promedio_duración DESC; 
    
    
-- Ejercicio 13: Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

/* Comprobacion uniones: 
Tabla film: title & film_id
Tabla film_actor: film_id & actor_id
Tabla actor: actor_id & first last name 
*/

SELECT 
	a.first_name AS nombre,
    a.last_name AS apellido
FROM film AS f
JOIN film_actor AS fa
USING 
	(film_id)
JOIN actor AS a
USING
	(actor_id)
WHERE
	f.title = 'Indian Love'; 


-- Ejercicio 14: Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

-- Utilizando 'LIKE': 
SELECT 
	title AS titulo
FROM film
WHERE 
	description LIKE '%dog%' OR description LIKE '%cat%';

-- 'Utilizando REGEX': 
SELECT 
	title AS título
FROM film
WHERE
	description REGEXP '\\bdog\\b|\\bcat\\b'; -- \\b sirve para delimitar las palabras y la barra vertical | funciona como un operador "o" 


-- Ejercicio 15: Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor. 

SELECT 
	a.actor_id AS id_actor, 
	a.first_name AS nombre, 
    a.last_name AS apellido
FROM actor AS a -- para obtener todos los actores
LEFT JOIN film_actor AS fa --  para incluir todos los registros de la tabla actor, aunque no haya coincidencias en film_actor.
USING 
	(actor_id)
WHERE 
	fa.actor_id IS NULL; 
    
    
-- Ejercicio 16: Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010

SELECT 
	title AS películas_2005_2010
FROM film
WHERE 
	release_year BETWEEN 2005 AND 2010; 


-- Ejercicio 17:  Encuentra el título de todas las películas que son de la misma categoría que "Family"

/* Comprobacion uniones: 
Tabla film: title & film_id
Tabla film_category: film_id & category_id
Tabla category: category_id & name
*/

SELECT 
	f.title AS películas_familiares
FROM film AS f
JOIN film_category AS fa
USING
	(film_id)
JOIN category AS c
USING 
	(category_id) 
WHERE 
	c.name = 'Family'; 


-- Ejercicio 18:  Muestra el nombre y apellido de los actores que aparecen en más de 10 películas

/* Comprobacion uniones: 
Tabla actor: name & actor_id
Tabla film_actor: actor_id & film_id

Comprobación query para subconsulta (actor ID con más de 10 películas)
SELECT actor_id, COUNT(film_id) as total
FROM film_actor
GROUP BY actor_id
HAVING total > 10; 
*/

-- Opción A: Subconsulta: 

SELECT 
	a.first_name AS nombre,
	a.last_name AS apellido
FROM actor AS a
WHERE a.actor_id IN (SELECT 
						fa.actor_id 
                        FROM film_actor AS fa
						GROUP BY fa.actor_id
						HAVING COUNT(fa.film_id > 10) -- solo se puede una columna en el select, por lo que añado el count en el having. 
					); 

-- Opción B: con group by actor ID para evitar repetidos en nombres/apellidos (susan davis está repetida) 

SELECT 
	a.first_name AS nombre,
    a.last_name AS apellido
FROM actor AS a
JOIN film_actor AS fa
USING
	(actor_id)
GROUP BY  
	a.actor_id, a.first_name, a.last_name
HAVING 
	COUNT(fa.film_id) > 10;


-- Ejercicio 19:  Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT 
	title AS título
FROM film
WHERE length > 120 AND rating = 'R'; 


-- Ejercicio 20:  Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración

/* Comprobando uniones: 
Tabla category: name & category_id
Tabla film_category: category_id & film_id
Tabla film: film_id & length
*/

SELECT 
	c.name AS nombre_categoria,
    AVG(length) AS promedio_duración
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
	promedio_duración > 120; 


-- Ejercicio 21: Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado

SELECT 
	a.first_name AS nombre_actores, 
    COUNT(fa.film_id) AS total_películas
FROM actor AS a
JOIN film_actor AS fa
USING 
	(actor_id)
GROUP BY 
	a.actor_id, a.first_name -- añadir actor ID para evitar que se agrupen los actores que tienen el mismo first_name
HAVING 
	total_películas > 5; 


-- Ejercicio 22: Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes

/* Comprobando uniones: 
Tabla rental:  rental_id & inventory_id
Tabla inventory: inventory_id & film_id
Tabla film: film_id & title
*/

/* Query para subconsulta: 
SELECT
rental_id
FROM sakila.rental
WHERE DATEDIFF(return_date, rental_date)> 5; -- función DATEDIFF para calcular la diferencia en días entre el return_date y el rental_date). 
*/

SELECT DISTINCT -- para evitar que el mismo título aparezca múltiples veces
	f.title AS título
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


-- Ejercicio 23: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.

/* Comprobacion uniones: 
SELECT * FROM actor; -- actor name & actor id
SELECT * FROM film_actor; -- actor id & film id
SELECT * FROM film_category; -- film id - category id
SELECT * FROM category; -- category id category name 
*/

/* Query para subconsulta: 
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
	a.first_name AS nombre,
    a.last_name AS apellido
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


-- Ejercicio 24: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film: 

SELECT 
	f.title AS titulo
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