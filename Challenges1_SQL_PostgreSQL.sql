--Enunciation: Create a list with the top overall revenue / total max income 
--of a film title (sum of amount per title) for each category (name).
--Question: Which is the top-performing film in the animation category?

--Solution of the challenge :
SELECT
title,
name,
SUM (amount) AS sum_amount
	  FROM payment A
	  LEFT JOIN rental B
	  ON A.rental_id = B.rental_id
	  LEFT JOIN inventory C
	  ON B.inventory_id= C.inventory_id
	  LEFT JOIN film D
	  ON C.film_id = D.film_id 
	  LEFT JOIN film_category E 
	  ON D.film_id= E.film_id
	  LEFT JOIN category F1
	  ON E.category_id = F1.category_id
	  GROUP BY name,title
	  HAVING SUM(amount) =   
	  	 ( SELECT MAX (sum_amount) FROM 
	  ( SELECT name, title, SUM ( amount ) sum_amount
	  FROM payment A
	  LEFT JOIN rental B
	  ON A.rental_id = B.rental_id
	  LEFT JOIN inventory C
	  ON B.inventory_id= C.inventory_id
	  LEFT JOIN film D
	  ON C.film_id = D.film_id 
	  LEFT JOIN film_category E 
	  ON D.film_id= E.film_id
	  LEFT JOIN category F
	  ON E.category_id = F.category_id
	  GROUP BY name, title  ) sub
	  WHERE F1.name=sub.name
	  )	  
--Solution to the challenge question:   
SELECT
title,
name,
SUM (amount) AS sum_amount
	  FROM payment A
	  LEFT JOIN rental B
	  ON A.rental_id = B.rental_id
	  LEFT JOIN inventory C
	  ON B.inventory_id= C.inventory_id
	  LEFT JOIN film D
	  ON C.film_id = D.film_id 
	  LEFT JOIN film_category E 
	  ON D.film_id= E.film_id
	  LEFT JOIN category F1
	  ON E.category_id = F1.category_id
	  GROUP BY name,title
	  HAVING SUM(amount) =   
	  	 ( SELECT MAX (sum_amount) FROM 
	  ( SELECT name, title, SUM ( amount ) sum_amount
	  FROM payment A
	  LEFT JOIN rental B
	  ON A.rental_id = B.rental_id
	  LEFT JOIN inventory C
	  ON B.inventory_id= C.inventory_id
	  LEFT JOIN film D
	  ON C.film_id = D.film_id 
	  LEFT JOIN film_category E 
	  ON D.film_id= E.film_id
	  LEFT JOIN category F
	  ON E.category_id = F.category_id
	  GROUP BY name, title  ) sub
	  WHERE F1.name=sub.name 
	  AND name = 'Animation')
	  
