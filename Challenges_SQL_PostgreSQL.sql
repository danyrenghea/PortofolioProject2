--Challenge no 1  
--Task 1: Create a list of film_ids, titles,rental_rate,replacement_cost together with a report between 
--rental_rate and replacement_rate
--Task 2 : Create a list with the film titles where rental_rate has to be smaller than the 4% 
--from the replacement_cost value.The result has to be rounded at 2 decimals and ordered descendind 
--by the size of the percentage or by the film_id

--Solution 1 - Challenge no 1 - Task 1 and Task 2 
SELECT 
film_id,title,rental_rate,replacement_cost,
ROUND ( rental_rate/replacement_cost,2)AS replacement_report,
ROUND (replacement_cost * 1.04 ,2)-replacement_cost AS replacement_cost_percentage
FROM film
WHERE rental_rate < ROUND (replacement_cost * 1.04 ,2)-replacement_cost
ORDER BY replacement_cost_percentage DESC
--Solution 2 Challenge No 1 - Task 1 and Task 2 
--Sa se creeze o lista cu film_id-urile sa se stabileasca un raport intre rental_rate 
--si replacement_rate
--si o lista cu filmele unde rental_rate sa fie mai mic decat 4% din 
-- replacement_cost rotunjindu-se rezultatele la 2 zecimale
SELECT 
film_id,title,rental_rate,replacement_cost,
ROUND ( rental_rate/replacement_cost,2)AS replacement_report,
ROUND (replacement_cost * 0.04 ,2)AS replacement_cost_percentage
FROM film 
WHERE rental_rate < ROUND (replacement_cost * 0.04 ,2)
ORDER BY film_id 



--Challenge no 3
-- Extract level of clasification with the names: 
-- a) 'Great rating or long( tier 1)'
-- if the rating is ('PG','PG-13') or the length of the film from column length in table film is 
-- bigger than 210 minutes 
-- b) 'Long drama (tier 2)'if in the interior of the values in the column "description" it is the word 
-- Drama and the film length is greater than 90 minutes
-- c) 'Short drama (tier 2)'if in the interior of the values in the column "description" it is the word 
-- Drama and the film length is smaller or equal with 90 minutes. 
-- d) 'Very cheap ( tier 4)'if the values from rental_rate column is smaller than 1 dollar
-- To eliminate NULL values at the final of the query place a WHERE clause to filtrate the entire
-- first part of the query with the same query conditions in CASE and at the final at the END adding 
-- IS NOT NULL 
-- Solution Challenge No 2
SELECT title,
CASE
   WHEN rating = 'PG'OR rating ='PG-13' OR length > 210 THEN 'Great rating or long( tier 1)'
   WHEN description LIKE '%Drama%' AND length >90 THEN 'Long drama (tier 2)'
   WHEN description LIKE '%Drama%' AND length <= 90 THEN 'Short drama (tier 2)'
   WHEN rental_rate < 1 THEN 'Very cheap ( tier 4)'
   END AS type_of_tier
FROM film   
WHERE 
CASE 
WHEN rating = 'PG'OR rating ='PG-13' OR length > 210 THEN 'Great rating or long( tier 1)'
   WHEN description LIKE '%Drama%' AND length >90 THEN 'Long drama (tier 2)'
   WHEN description LIKE '%Drama%' AND length <= 90 THEN 'Short drama (tier 2)'
   WHEN rental_rate < 1 THEN 'Very cheap ( tier 4)'
   END IS NOT NULL

--Challenge no 3 
--Do a query to realize a pivotation of the values resulted from the following similar two queries, 
--wich has as results how many time has appeard a distinct rating in the table film for the 
--movies:
SELECT rating,
COUNT(*)
FROM film
GROUP BY rating

SELECT rating,
COUNT ( CASE
WHEN rating IN ( 'R','G','NC-17','PG','PG-13') THEN 1
ELSE 0
END )
FROM film
GROUP BY rating

--Solution Challenge no 3
SELECT DISTINCT rating,SUM (replacement_cost) FROM film
GROUP BY rating
SELECT * FROM film
SELECT 
 SUM (CASE
 WHEN rating = 'R' THEN 1 ELSE 0
	   END ) AS "R",
SUM(CASE 
	 WHEN rating = 'G' THEN 1 ELSE 0
	   END ) AS "G",	   
SUM( CASE 
	 WHEN rating = 'NC-17'THEN 1 ELSE 0
	   END ) AS "NC-17",
SUM( CASE 
	 WHEN rating = 'PG' THEN 1 ELSE 0
	   END )AS "PG",
SUM(CASE 
	 WHEN rating = 'PG-13' THEN 1 ELSE 0
	   END )AS "PG-13" 
FROM film
--Challenge no 4
--Display total number of the rental days for each specific customer by customer_id, and the staff_id  
--where the rental days number has to be not equal with 0. 

--Solution Challenge no 4
SELECT EXTRACT ( Day from return_date -rental_date )
AS days_of_rental,
SUM ( EXTRACT ( Day from return_date -rental_date )) AS days_of_rental_per_customer,
payment.staff_id ,payment.customer_id
FROM payment
LEFT OUTER JOIN rental
ON payment.rental_id= rental.rental_id
WHERE EXTRACT ( Day from return_date -rental_date ) !=0
GROUP BY payment.staff_id ,EXTRACT ( Day from return_date -rental_date ), payment.customer_id
ORDER BY payment.staff_id
--Challenge no 5
--Display complete name first_name and last_name as "Name" for the staff with their specific staff_id
--and the total sum amount for each of them cashed it.
SELECT A.staff_id AS "Staff_id",
SUBSTRING ( first_name FROM 1) ||' '|| SUBSTRING ( last_name FROM 1) AS "Name",
SUM (amount) AS "Total amount"
FROM staff A
INNER JOIN rental B
ON A.staff_id = B.staff_id
INNER JOIN payment C
ON B.customer_id=C.customer_id
GROUP BY A.staff_id
--Challenge no 6
--Find out the first_name, the last_name and the total amount for each customer in the district 
--of California wich has spent more then 100 dollars for rentals 

--Solution Challenge no 6
SELECT first_name,last_name,SUM ( amount) FROM payment A
INNER JOIN customer B
ON A.customer_id = B.customer_id
INNER JOIN address C
ON B.address_id= C.address_id
WHERE district = 'California' AND B.customer_id IN 
( SELECT customer_id
FROM payment  
GROUP BY customer_id
HAVING SUM ( amount ) > 100 
)
GROUP BY first_name,last_name
ORDER BY SUM ( amount) DESC
-- Challenge no 7
-- Display all the payments (number of the payments) plus total sum amount payed by each and every
-- one customer identified by its customer_id

-- Solution Challenge no 7
SELECT customer_id, 
( SELECT SUM(amount) FROM payment AS pay1  
 WHERE pay1.customer_id=pay2.customer_id
)sum_amount,( SELECT COUNT (*) FROM payment AS pay1 
  WHERE pay1.customer_id=pay2.customer_id)number_of_payments
FROM payment AS pay2
GROUP BY customer_id, ( SELECT SUM(amount) FROM payment AS pay1 
 WHERE pay1.customer_id=pay2.customer_id
),( SELECT COUNT (*) FROM payment AS pay1 
  WHERE pay1.customer_id=pay2.customer_id)

--Challenge no 8
--Task 1: Create a query that shows average daily revenues/incomes ao all Saturdays and of all Sundays 
--Question: What is the daily average revenue/income ( average amount for Sundays ) of all Sundays?
--Task 2 : Extract all the payment by payment_id made of the day 2020-01-25 by each 
--customer/customer_id
--Solution Challenge no 8 -Task 1 
SELECT name_of_day, ROUND ( AVG (sum_amount),2) avg_sundays_amount
FROM ( SELECT EXTRACT (dow from DATE ( payment_date )),TO_CHAR (DATE (payment_date),'Day')name_of_day,DATE ( payment_date),
SUM ( amount) sum_amount
FROM payment 
WHERE EXTRACT (dow from DATE ( payment_date )) = 0
GROUP BY DATE ( payment_date) ) subquery
GROUP BY name_of_day
----Solution Challenge no 8 - Task 2 
SELECT customer_id,amount FROM payment
WHERE payment_id IN ( SELECT payment_id FROM payment WHERE DATE ( payment_date)='2020-01-25' )
--Challenge nr 9: 
--Create a list of movies - with their length and their replacement cost 
--that are longer than the average length in each replacement cost group.
--Question: Which two movies are the shortest on that list and how long are they?

SELECT title,length, replacement_cost AS over_average_length FROM film AS f1
WHERE length > (SELECT AVG( length )average_length FROM film AS f2
			   WHERE f1.replacement_cost=f2.replacement_cost
			   GROUP BY replacement_cost) 
			   ORDER BY length 
			   LIMIT 2
			   
--Challenge no 9
---Create a list that shows all payments including the payment_id, amount, and the film 
--category (name) plus the total amount that was made in this category.
--Order the results ascendingly by 
--the category (name) and as second order criterion by the payment_id ascendingly.
--Question: What is the total revenue/income of the category 'Action' and what is the lowest payment_id in 
--that category 'Action'?
 --Solution Challenge no 9
 SELECT payment_id,name,amount,
 ( SELECT SUM ( amount) FROM payment A
 LEFT JOIN rental B
 ON A.rental_id = B.rental_id
 LEFT JOIN inventory C
 ON B.inventory_id=C.inventory_id
 LEFT JOIN film_category D
 ON C.film_id= D.film_id
 LEFT JOIN category E
 ON D.category_id = E.category_id
 WHERE E.name= E1.name )
 FROM payment A
 LEFT JOIN rental B
 ON A.rental_id = B.rental_id
 LEFT JOIN inventory C
 ON B.inventory_id=C.inventory_id
 LEFT JOIN film_category D
 ON C.film_id= D.film_id
 LEFT JOIN category E1
 ON D.category_id = E1.category_id
 ORDER BY name, payment_id		   
--Solution Challenge no 9 - Question			   
SELECT payment_id,name,
 ( SELECT SUM ( amount) FROM payment A
 LEFT JOIN rental B
 ON A.rental_id = B.rental_id
 LEFT JOIN inventory C
 ON B.inventory_id=C.inventory_id
 LEFT JOIN film_category D
 ON C.film_id= D.film_id
 LEFT JOIN category E
 ON D.category_id = E.category_id
 WHERE E.name= E1.name AND name = 'Action')
 FROM payment A
 LEFT JOIN rental B
 ON A.rental_id = B.rental_id
 LEFT JOIN inventory C
 ON B.inventory_id=C.inventory_id
 LEFT JOIN film_category D
 ON C.film_id= D.film_id
 LEFT JOIN category E1
 ON D.category_id = E1.category_id
 WHERE name = 'Action' AND amount !=0
 ORDER BY payment_id
 
 
			   
			   
			   