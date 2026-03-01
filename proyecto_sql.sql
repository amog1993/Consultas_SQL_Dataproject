--- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’

SELECT f.title, f.rating 
FROM film f
WHERE f.rating = 'R';

--- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40

SELECT a.actor_id , a.first_name , a.last_name 
FROM actor a 
WHERE a.actor_id >= 30 AND a.actor_id <= 40; 

--- 4. Obtén las películas cuyo idioma coincide con el idioma original.

SELECT f.title , f.original_language_id , f.language_id 
FROM film f 
WHERE f.original_language_id = f.language_id ;

--- 5. Ordena las películas por duración de forma ascendente

SELECT f.title , f.length 
FROM film f
ORDER BY f.length ASC 
; 

--- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

SELECT a.first_name , a.last_name 
FROM actor a 
WHERE a.last_name = 'ALLEN'
; 

--- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla
--- “film” y muestra la clasificación junto con el recuento.

SELECT f.rating , count(*) AS total_peliculas
FROM film f 
GROUP BY f.rating 
ORDER BY total_peliculas 
;

--- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una
--- duración mayor a 3 horas en la tabla film.

SELECT f.title, f.rating , f.length 
FROM film f 
WHERE 
	f.rating = 'PG-13' OR f.length >= '180'
ORDER BY f.length 
;

--- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT round(variance(f.replacement_cost ), 2) AS variabilidad_reemplazo
FROM film f ; 

--- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT MIN(f.length ) AS menor_duración , MAX(f.length ) AS mayor_duración
FROM film f 
; 

--- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT r.customer_id , p.amount , r.rental_date 
FROM rental r 
JOIN payment p 
ON r.customer_id = p.customer_id
ORDER BY r.rental_date DESC 
LIMIT 1 OFFSET 2
;

---12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ 
---en cuanto a su clasificación.

SELECT f.title , f.rating 
FROM film f 
WHERE f.rating NOT IN ('NC-17', 'G')
ORDER BY f.rating DESC 
; 

--- 13. Encuentra el promedio de duración de las películas para cada
---clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT f.rating AS Categoria , ROUND(AVG(f.length), 2) AS "Promedio_duración"
FROM film f
GROUP BY categoria
ORDER BY "Promedio_duración" 
; 

--- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT f.title , f.length 
FROM film f
WHERE f.length > '180'
ORDER BY f.length DESC
;

--- 15. ¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(p.amount ) AS Suma_total
FROM payment p ;  

---  16. Muestra los 10 clientes con mayor valor de id.

SELECT c.customer_id , concat(c.first_name , ' ', c.last_name ) AS Nombre_cliente
FROM customer c
ORDER BY c.customer_id DESC 
LIMIT 10
; 

--- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’

SELECT a.first_name , a.last_name , f.title 
FROM film f 
JOIN film_actor fa 
	ON f.film_id = fa.film_id
JOIN actor a 
	ON fa.actor_id = a.actor_id
WHERE f.title = 'EGG IGBY'
;

--- 18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT f.title AS peliculas_únicos
FROM film f ; 

--- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”

SELECT f.title , c."name" , f.length 
FROM film_category fc 
JOIN category c 
	ON fc.category_id = c.category_id
JOIN film f 
	ON f.film_id = fc.film_id 
WHERE c."name" = 'Comedy'AND 
	f.length > '180'
;

--- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría
---junto con el promedio de duración.

SELECT c."name" , round(AVG(f.length), 2) AS promedio_duracion 
FROM film f 
JOIN film_category fc 
	ON f.film_id = fc.film_id 
JOIN category c 
	ON c.category_id = fc.category_id 
GROUP BY c."name" 
HAVING AVG(f.length) > 110

; 

--- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG(r.rental_date - r.return_date) AS Promedio_duracion_alquiler 
FROM rental r 
WHERE return_date IS NOT NULL
;

--- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT concat(a.first_name , ' ', a.last_name ) AS nombre_completo 
FROM actor a 
; 

--- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT count(r.rental_date) AS conteo_alquileres , r.rental_date 
FROM rental r 
GROUP BY r.rental_date 
ORDER BY conteo_alquileres DESC 
;

--- 24. Encuentra las películas con una duración superior al promedio.

WITH avg_duracion AS (
	SELECT AVG(f.length) AS promedio
	FROM film f 
)
SELECT f.title , f.length 
FROM film f 
WHERE f.length > (SELECT promedio FROM avg_duracion)
ORDER BY f.length DESC 

;

--- 25. Averigua el número de alquileres registrados por mes.

SELECT date_trunc('month', r.rental_date ) AS mes_anio, 
	count(*) AS total_alquileres
FROM rental r 
GROUP BY mes_anio 
ORDER BY mes_anio DESC 
;

--- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT 
	round(AVG(p.amount ),2) AS promedio_total, 
	round(variance(p.amount ), 2) AS varianza_total, 
	round(stddev(p.amount ), 2) AS desviacion_total
FROM payment p 

;

--- 27. ¿Qué películas se alquilan por encima del precio medio?

WITH precio_medio AS (
	SELECT AVG(p.amount) AS promedio 
	FROM rental r 
		JOIN payment p 
			ON r.rental_id = p.rental_id

)
SELECT DISTINCT f.title
FROM film f 
JOIN inventory i 
	ON f.film_id = i.film_id
JOIN rental r 
	ON i.inventory_id = r.inventory_id 
JOIN payment p 
	ON r.rental_id = p.rental_id
WHERE p.amount > (SELECT promedio FROM precio_medio)
ORDER BY f.title 
;

--- 28. Muestra el id de los actores que hayan participado en más de 40 películas.


SELECT a.actor_id,
        COUNT(fa.film_id) AS total_peliculas
FROM actor a
JOIN film_actor fa 
    ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) > 40
ORDER BY total_peliculas DESC
;

--- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT f.film_id , f.title ,  count(i.inventory_id) AS inventario 
FROM film f
LEFT JOIN inventory i 
	ON f.film_id = i.film_id
GROUP BY f.film_id, f.title 
ORDER BY inventario DESC 
; 

--- 30. Obtener los actores y el número de películas en las que ha actuado.

SELECT 
	CONCAT(a.first_name , ' ', a.last_name) AS nombre_actores,
	COUNT(fa. film_id) AS total_peliculas
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id , nombre_actores
ORDER BY total_peliculas DESC 
;
	

--- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

SELECT f.title AS nombre_pelicula , a.first_name , a.last_name 
FROM film f 
LEFT JOIN film_actor fa 
	ON f.film_id = fa.film_id
LEFT JOIN actor a 
	ON fa.actor_id = a.actor_id
; 

--- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película


SELECT a.first_name , a.last_name , f.title 
FROM actor a 
LEFT JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
LEFT JOIN film f
	ON f.film_id = fa.film_id 
; 


--- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f.title , COUNT(r.rental_id) AS total_registros
FROM film f 
LEFT JOIN inventory i 
	ON f.film_id = i.film_id
LEFT JOIN rental r 
	ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title  
ORDER BY f.title 
; 

--- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT  c.customer_id , c.first_name , c.last_name, SUM(p.amount) AS suma_gasto
FROM customer c 
JOIN payment p 
	ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name , c.last_name 
ORDER BY suma_gasto DESC 
LIMIT 5 
; 

--- 35. Selecciona todos los actores cuyo primer nombre es ' Johnny'

SELECT a.first_name, a.last_name 
FROM actor a 
WHERE a.first_name = 'JOHNNY'
; 

--- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido

SELECT 
	a.first_name AS Nombre, 
	a.last_name AS Apellido
FROM actor a 
; 

--- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT 
	MAX(a.actor_id) AS Id_mas_alto, 
	MIN(a.actor_id ) AS Id_mas_bajo
FROM actor a 
; 

--- 38. Cuenta cuántos actores hay en la tabla “actor”

SELECT 
	COUNT(a.actor_id) AS Conteo_actores
FROM actor a 
; 

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT a.first_name , a.last_name 
FROM actor a 
ORDER BY a.last_name
; 

--- 40. Selecciona las primeras 5 películas de la tabla “film”

SELECT f.title 
FROM film f 
ORDER BY f.film_id 
LIMIT 5
; 

--- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

WITH conteo_nombres AS (
    SELECT 
        first_name,
        COUNT(*) AS total
    FROM actor
    GROUP BY first_name
),
max_conteo AS (
    SELECT MAX(total) AS maximo
    FROM conteo_nombres
)

SELECT 
    first_name,
    total
FROM conteo_nombres
WHERE total = (SELECT maximo FROM max_conteo);

--- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT r.rental_id  , c.first_name , c.last_name 
FROM customer c 
JOIN rental r 
	ON c.customer_id = r.customer_id
; 

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT c.first_name , c.last_name, r.rental_id  
FROM customer c 
LEFT JOIN rental r 
	ON c.customer_id = r.customer_id
; 

-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? 
-- Deja después de la consulta la contestación.

SELECT f.title , c."name" 
FROM film f 
CROSS JOIN category c ; 

--- Esta consulta no aporta valor en este contexto porque genera un producto cartesiano entre películas y categorías, 
-- combinando cada película con todas las categorías existentes, sin respetar la relación real entre ellas generando datos irreales. 

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT DISTINCT a.first_name , a.last_name 
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
JOIN film_category fc 
	ON  fa.film_id = fc.film_id 
JOIN category c 
	ON fc.category_id = c.category_id
WHERE c."name" = 'Action'
; 

-- 46. Encuentra todos los actores que no han participado en películas.

SELECT a.first_name , a.last_name 
FROM actor a 
LEFT JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
WHERE fa.film_id  IS NULL 
; 

--- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT 
	a.first_name , 
	a.last_name, 
	count(fa.film_id ) AS total_peliculas
FROM actor a 
LEFT JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id , a.first_name , a.last_name 
ORDER BY total_peliculas DESC 
; 

-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado.

CREATE VIEW actor_num_peliculas AS 
SELECT 
	a.first_name , 
	a.last_name, 
	count(fa.film_id ) AS total_peliculas
FROM actor a 
LEFT JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
GROUP BY a.actor_id , a.first_name , a.last_name 
ORDER BY total_peliculas DESC 
; 

--- 49. Calcula el número total de alquileres realizados por cada cliente.

SELECT 
	c.first_name , c.last_name ,
	count(r.rental_id ) AS total_alquileres
FROM customer c 
LEFT JOIN rental r 
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id , c.first_name , c.last_name 
ORDER BY total_alquileres DESC 
; 

-- 50. Calcula la duración total de las películas en la categoría 'Action'.

SELECT
	SUM(f.length) AS duracion_total 
FROM category c 
JOIN film_category fc 
	ON c.category_id = fc.category_id
JOIN film f 
	ON fc.film_id = f.film_id
WHERE c."name" = 'Action'
; 

--- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente.

CREATE TEMPORARY TABLE cliente_rentas_temporal AS 
SELECT customer_id, count(rental_id) AS total_alquileres
FROM rental r
GROUP BY customer_id
;
 
-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces.

CREATE TEMPORARY TABLE peliculas_alquiladas AS 
SELECT 
	count(r.rental_id ) AS total_alquileres, 
	i.film_id 
FROM rental r 
JOIN inventory i 
ON i.inventory_id = r.inventory_id 
GROUP BY film_id 
HAVING count(r.rental_id ) > 10
ORDER BY total_alquileres DESC 
;

-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. 
--Ordena los resultados alfabéticamente por título de película.

SELECT c.first_name , c.last_name , f.title , r.rental_date , r.return_date 
FROM film f 
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
JOIN customer c 
ON r.customer_id = c.customer_id
WHERE c.first_name = 'TAMMY' AND 
	c.last_name = 'SANDERS' AND 
	r.return_date IS NULL
ORDER BY f.title ASC
; 

--- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. 
---Ordena los resultados alfabéticamente por apellido.

SELECT 
    a.first_name,
    a.last_name
FROM actor a
WHERE EXISTS (
    SELECT 1
    FROM film_actor fa
    JOIN film_category fc 
        ON fa.film_id = fc.film_id
    JOIN category c 
        ON fc.category_id = c.category_id
    WHERE fa.actor_id = a.actor_id
      AND c."name" = 'Sci-Fi'
)
ORDER BY a.last_name ASC;

--- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus
---Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.

WITH primera_fecha AS (
	SELECT 
		MIN(r.rental_date ) AS fecha_inicial 
	FROM rental r 
	JOIN inventory i 
		ON r.inventory_id = i.inventory_id
	JOIN film f 
		ON i.film_id = f.film_id
	WHERE f.title ILIKE 'Spartacus Cheaper'
)

SELECT DISTINCT 
	a.first_name , 
	a.last_name 
FROM actor a 
JOIN film_actor fa 
	ON a.actor_id = fa.actor_id
JOIN film f 
	ON fa.film_id = f.film_id
JOIN inventory i 
	ON f.film_id = i.film_id
JOIN rental r 
	ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (SELECT fecha_inicial FROM primera_fecha)
ORDER BY a.last_name ASC
; 
	

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’

SELECT 
	a.first_name , 
	a.last_name
FROM actor a 
WHERE NOT EXISTS (
	SELECT 1
	FROM film_actor fa
	JOIN film_category fc 
		ON fa.film_id = fc.film_id 
	JOIN category c 
		ON fc.category_id = c.category_id
	WHERE fa.actor_id = a.actor_id 
		AND c."name" = 'Music'
)
ORDER BY a.last_name ASC 
; 

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT 
	(r.return_date - r.rental_date ) AS diferencia_dias, 
	f.title 
FROM rental r
JOIN inventory i 
	ON r.inventory_id = i.inventory_id
JOIN film f 
	ON i.film_id = f.film_id
WHERE (r.return_date - r.rental_date) > INTERVAL '8 days'
ORDER BY diferencia_dias ASC 
; 

--- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’

SELECT f.title 
FROM film f 
JOIN film_category fc 
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE c."name" = 'Animation'
; 

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. 
--Ordena los resultados alfabéticamente por título de película.

WITH duracion_pelicula AS (
	SELECT 
		f.length AS duracion_total
	FROM film f
	WHERE f.title ILIKE 'Dancing Fever'
)

SELECT 
	f.title
FROM film f 
WHERE f.length = (SELECT duracion_total FROM duracion_pelicula)
	AND f.title NOT ILIKE 'Dancing Fever'
ORDER BY f.title ASC
; 

--- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.

SELECT
	c.first_name , 
	c.last_name, 
	count(DISTINCT i.film_id ) AS alquileres_peliculas 
FROM customer c 
JOIN rental r 
	ON c.customer_id = r.customer_id
JOIN inventory i 
	ON r.inventory_id = i.inventory_id 
GROUP BY r.customer_id , c.first_name , c.last_name 
HAVING count(DISTINCT i.film_id ) >= 7 
ORDER BY c.last_name ASC
; 

-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT 
	c."name" AS nombre_categoria, 
	count(r.rental_id) AS recuento_alquileres
FROM category c 
JOIN film_category fc 
	ON c.category_id = fc.category_id
JOIN film f 
	ON fc.film_id = f.film_id
JOIN inventory i 
	ON f.film_id = i.film_id
JOIN rental r 
	ON i.inventory_id = r.inventory_id
GROUP BY nombre_categoria 
ORDER BY count(DISTINCT r.rental_id) DESC 
; 

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.

SELECT
	c."name",
	COUNT(f.film_id ) AS recuento_peliculas 
FROM film f 
JOIN film_category fc 
	ON f.film_id = fc.film_id
JOIN category c 
	ON fc.category_id = c.category_id
WHERE f. release_year = 2006
GROUP BY c."name" 
ORDER BY COUNT(f.film_id) DESC 
; 


-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT 
	s.staff_id, 
	s2.store_id 
FROM staff s
CROSS JOIN store s2 
ORDER BY s.staff_id 
; 

-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de
-- películas alquiladas.

SELECT 
	c.customer_id , 
	CONCAT(c.first_name, ' ', c.last_name ) AS nombre_cliente, 
	count(r.rental_id ) AS conteo_total_peliculas_alquiladas 
FROM customer c 
JOIN rental r 
	ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name , c.last_name 
ORDER BY c.customer_id ASC 
; 













