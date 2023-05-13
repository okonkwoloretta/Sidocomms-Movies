
-- Question 1. my partner and i want to come by each of the stores in person and meet the managers. 
-- please send over the managers names at each stores, wih the full address of the property(street address, district,city, and country please)

-- Using the 'CONCAT_WS' function to concatenate the address fields with appropriate delimiters (comma and space) to form the full address and full name

SELECT CONCAT_WS(' ', s.first_name, s.last_name) AS manager_name, CONCAT_WS(', ', a.address, c.city, co.country) AS full_address
FROM [Sidocomms].[dbo].[store] st
INNER JOIN [Sidocomms].[dbo].[address] a 
  ON st.address_id = a.address_id
INNER JOIN [Sidocomms].[dbo].[city] c 
  ON a.city_id = c.city_id
INNER JOIN [Sidocomms].[dbo].[country] co
  ON c.country_id = co.country_id
INNER JOIN [Sidocomms].[dbo].[staff] s 
  ON st.store_id = s.store_id 

-- QUESTION 2. I would like to get a better understanding of all the inventory that would come along wih the business. 
-- Please pull together a list of each inventory item you have stocked, including the store_id number, the inventory_id, the name of the film, the film's rating, its rental rate and replacement

SELECT i.store_id, i.inventory_id, f.title AS film_name, f.rating, f.rental_rate, f.replacement_cost
FROM [Sidocomms].[dbo].[inventory] i
INNER JOIN [Sidocomms].[dbo].[film] f 
  ON i.film_id = f.film_id
INNER JOIN [Sidocomms].[dbo].[store] s 
  ON i.store_id = s.store_id


-- Question 3. From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory. 
-- We  would like to know how many inventory items you have with each rating at each store. 

SELECT s.store_id, f.rating, COUNT(*) AS inventory_count
FROM [Sidocomms].[dbo].[inventory] i
INNER JOIN [Sidocomms].[dbo].[film] f 
  ON i.film_id = f.film_id
INNER JOIN [Sidocomms].[dbo].[store] s 
  ON i.store_id = s.store_id
GROUP BY s.store_id, f.rating

--Question 4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. 
--we want to see how big of a hit it would if a certain category of film became unpopular at a certain store.
--we would like to see the number of films, as well as the average replacement cost, and total replacement cost, sliced by store and film category.

SELECT s.store_id, c.name AS category, 
       COUNT(DISTINCT f.film_id) AS num_films,
       AVG(f.replacement_cost) AS avg_replacement_cost,
       SUM(f.replacement_cost) AS total_replacement_cost
FROM [Sidocomms].[dbo].[store] s
INNER JOIN [Sidocomms].[dbo].[inventory] i 
  ON s.store_id = i.store_id
INNER JOIN [Sidocomms].[dbo].[film] f 
  ON i.film_id = f.film_id
INNER JOIN [Sidocomms].[dbo].[film_category] fc 
  ON f.film_id = fc.film_id
INNER JOIN [Sidocomms].[dbo].[category] c 
  ON fc.category_id = c.category_id
GROUP BY s.store_id, c.name

--Question 5. We want to make sure you folks have a good handle on who your customers are. 
--Please provide a list of all cusomer names, which store they go to, whether or not they are currently active and their full address-street address,city, and country 

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       s.store_id,
       CASE WHEN c.active = 1 THEN 'Active' ELSE 'Inactive' END AS customer_status,
       CONCAT(a.address, ', ', ct.city, ', ', co.country) AS full_address
FROM [Sidocomms].[dbo].[customer] AS c
INNER JOIN [Sidocomms].[dbo].[address] AS a
  ON c.address_id = a.address_id
INNER JOIN [Sidocomms].[dbo].[city] AS ct 
  ON a.city_id = ct.city_id
INNER JOIN [Sidocomms].[dbo].[country] AS co 
  ON ct.country_id = co.country_id
INNER JOIN [Sidocomms].[dbo].[store] AS s 
  ON c.store_id = s.store_id
ORDER BY s.store_id, customer_name

--Question 6. We would like to understand how much your customers are spending wih you, and also to know who your most valuable customers are.
--Please pull together a list of customer names, their total lifetime rentals and the sum of all payments you have collected from them
--It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list.

SELECT c.first_name + ' ' + c.last_name AS customer_name,
       SUM(CAST(p.amount AS decimal(10, 2))) AS total_payments,
       COUNT(r.rental_id) AS lifetime_rentals
FROM [Sidocomms].[dbo].[customer] AS c
LEFT JOIN [Sidocomms].[dbo].[payment] AS p 
  ON c.customer_id = p.customer_id
LEFT JOIN [Sidocomms].[dbo].[rental] AS r 
  ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_payments DESC

--Question 7: My patner and I would like to get to know your board of advisors and any current investors.
-- Could you please provide a list of advisor and investor name in one table?
-- Could you please note whether they are an investor or an advisor, and for the investors, it would be good to include which company they work with.

SELECT CONCAT(first_name, ' ', last_name) AS name, 'Investor' AS type, company_name AS affiliated_company
FROM [Sidocomms].[dbo].[investor]
UNION
SELECT CONCAT(first_name, ' ', last_name) AS name, 'Advisor' AS type, '' AS affiliated_company
FROM [Sidocomms].[dbo].[advisor]



-- Question 8: We're interested in how well you have covered the most-awarded actors.
-- Of all the actors with three types of awards, for what % of them do we carry a film?
-- And how about for actors with two types of awards? Same questions.
-- Finally, how about actors with just one award?

WITH aa AS (
  SELECT
    COUNT(DISTINCT awards) AS award_count,
    actor_id
  FROM [Sidocomms].[dbo].[actor_award]
  GROUP BY actor_id
),
fa AS (
  SELECT
    aa.actor_id,
    COUNT(DISTINCT f.film_id) AS num_films
  FROM aa
  LEFT JOIN [Sidocomms].[dbo].[film_actor] fa
    ON aa.actor_id = fa.actor_id
  LEFT JOIN [Sidocomms].[dbo].[film] f
    ON fa.film_id = f.film_id
  GROUP BY aa.actor_id
)
SELECT
  COUNT(DISTINCT aa.actor_id) AS num_actors,
  SUM(aa.award_count) AS total_awards,
  SUM(fa.num_films) AS total_films,
  (SUM(fa.num_films) / COUNT(DISTINCT aa.actor_id)) * 100 AS films_with_awards_percentage,
  aa.award_count
FROM aa
JOIN fa
  ON aa.actor_id = fa.actor_id
GROUP BY aa.actor_id, aa.award_count
ORDER BY aa.award_count;
