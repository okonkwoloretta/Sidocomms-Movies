
-- Question 1. my partner and i want to come by each of the stores in person and meet the managers. 
-- please send over the managers names at each stores, wih the full address of the property(street address, district,city, and country please)

-- Using the 'CONCAT_WS' function to concatenate the address fields with appropriate delimiters (comma and space) to form the full address and full name

SELECT CONCAT_WS(' ', s.first_name, s.last_name) AS manager_name, CONCAT_WS(', ', a.address, c.city, co.country) AS full_address
FROM [Sidocomms].[dbo].[store] st
INNER JOIN address a 
  ON st.address_id = a.address_id
INNER JOIN city c 
  ON a.city_id = c.city_id
INNER JOIN country co
  ON c.country_id = co.country_id
INNER JOIN staff s 
  ON st.store_id = s.store_id 

-- QUESTION 2. I would like to get a better understanding of all the inventory that would come along wih the business. 
-- Please pull together a list of each inventory item you have stocked, including the store_id number, the inventory_id, the name of the film, its rental rate and replacement

SELECT i.store_id, i.inventory_id, f.title AS film_name, f.rental_rate, f.replacement_cost
FROM inventory i
INNER JOIN film f 
  ON i.film_id = f.film_id
INNER JOIN store s 
  ON i.store_id = s.store_id

-- Question 3. From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory. 
-- We  would like to know how many inventory items you have with each rating at each store. 

SELECT s.store_id, f.rating, COUNT(*) AS inventory_count
FROM inventory i
INNER JOIN film f 
  ON i.film_id = f.film_id
INNER JOIN store s 
  ON i.store_id = s.store_id
GROUP BY s.store_id, f.rating

--Question 4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. 
--we want to see how big of a hit it would if a certain category of film became unpopular at a certain store.
--we would like to see the number of films, as well as the average replacement cost, and total replacement cost, sliced by store and film category.

SELECT s.store_id, c.name AS category, 
       COUNT(DISTINCT f.film_id) AS num_films,
       AVG(f.replacement_cost) AS avg_replacement_cost,
       SUM(f.replacement_cost) AS total_replacement_cost
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY s.store_id, c.name

--Question 5. We want to make sure you folks have a good handle on who your customers are. 
--Please provide a list of all cusomer names, which store they go to, whether or not they are currently active and their full address-street address,city, and country 

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       s.store_id,
       CASE WHEN c.active = 1 THEN 'Active' ELSE 'Inactive' END AS customer_status,
       CONCAT(a.address, ', ', ct.city, ', ', co.country) AS full_address
FROM customer AS c
JOIN address AS a ON c.address_id = a.address_id
JOIN city AS ct ON a.city_id = ct.city_id
JOIN country AS co ON ct.country_id = co.country_id
JOIN store AS s ON c.store_id = s.store_id
ORDER BY s.store_id, customer_name

--Question 6. We would like to understand how much your customers are spending wih you, and also to know who your most valuable customers are.
--Please pull together a list of customer names, their total lifetime rentals and the sum of all payments you have collected from them
--It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list.

SELECT c.first_name + ' ' + c.last_name AS customer_name,
       SUM(CAST(p.amount AS decimal(10, 2))) AS total_payments,
       COUNT(r.rental_id) AS lifetime_rentals,
       ROUND(SUM(CAST(p.amount AS decimal(10, 2)))/COUNT(r.rental_id), 2) AS avg_payment_per_rental
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_payments DESC

--Question 7: My patner and I would like to get to know your board of advisors and any current investors.
-- Could you please provide a list of advisor and investor name in one table?
-- Could you please note whether they are an investor or an advisor, and for the investors, it would be good to include which company they work with.

SELECT CONCAT(first_name, ' ', last_name) AS name, 'Investor' AS type, company_name AS affiliated_company
FROM investor
UNION
SELECT CONCAT(first_name, ' ', last_name) AS name, 'Advisor' AS type, '' AS affiliated_company
FROM advisor;



-- Question 8: We're interested in how well you have covered the most-awarded actors.
-- Of all the actors with three types of awards, for what % of them do we carry a film?
-- And how about for actors with two types of awards? Same questions.
-- Finally, how about actors with just one award?

WITH actor_awards AS (
    SELECT actor_id, COUNT(DISTINCT awards) AS num_awards
    FROM actor_award
    GROUP BY actor_id
), actor_film_count AS (
    SELECT a.actor_id, COUNT(DISTINCT f.film_id) AS num_films
    FROM actor a
    INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
    INNER JOIN film f ON fa.film_id = f.film_id
    GROUP BY a.actor_id
)
SELECT
    COUNT(DISTINCT CASE WHEN aa.num_awards = 1 THEN a.actor_id END) AS one_award_total,
    COUNT(DISTINCT CASE WHEN aa.num_awards = 1 AND afc.num_films > 0 THEN a.actor_id END) AS one_award_with_film,
    COUNT(DISTINCT CASE WHEN aa.num_awards = 2 THEN a.actor_id END) AS two_awards_total,
    COUNT(DISTINCT CASE WHEN aa.num_awards = 2 AND afc.num_films > 0 THEN a.actor_id END) AS two_awards_with_film,
    COUNT(DISTINCT CASE WHEN aa.num_awards = 3 THEN a.actor_id END) AS three_awards_total,
    COUNT(DISTINCT CASE WHEN aa.num_awards = 3 AND afc.num_films > 0 THEN a.actor_id END) AS three_awards_with_film,
    COUNT(DISTINCT a.actor_id) AS total_actors
FROM actor a
INNER JOIN actor_awards aa ON a.actor_id = aa.actor_id
INNER JOIN actor_film_count afc ON a.actor_id = afc.actor_id;


