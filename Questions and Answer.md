# Note 🗒: 
I will only be displaying the first ten result of my query, if the output is more than 10, to save space and time

## Question 1. 
My partner and i want to come by each of the stores in person and meet the managers. 
Please send over the managers names at each stores, wih the full address of the property(street address, district,city, and country please)

### Steps
To get the list of managers at each store, along with the full address of the property, we  need to join the stores and managers tables

* Using the 'CONCAT_WS' function to concatenate the address fields with appropriate delimiters (comma and space) to form the full address and full name

```sql
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
```
## OUTPUT

|**manager_name**|**full_address**
|----------------|--------------|
  Jon Stephens	 | 28 MySQL Boulevard, Woodridge, Australia
  Mike Hillyer	 | 47 MySakila Drive, Lethbridge, Canada

## QUESTION 2. 
I would like to get a better understanding of all the inventory that would come along wih the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, the inventory_id, the name of the film, its rental rate and replacement.

### Steps
To provide a list of each inventory item with the store_id number, inventory_id, name of the film, its rental rate, and replacement cost, we need to join the inventory, film, and store tables.

```sql
SELECT i.store_id, i.inventory_id, f.title AS film_name, f.rental_rate, f.replacement_cost
FROM inventory i
INNER JOIN film f 
  ON i.film_id = f.film_id
INNER JOIN store s 
  ON i.store_id = s.store_id
 ``` 
## OUTPUT
|**store_id**|**inventory_id**|**film_name**|**rental_rate**|**replacement_cost**|
|------------|----------------|-------------|---------------|--------------------|
|1  |1	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|1  |2	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|1	|3	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|1	|4	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|2	|5	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|2	|6	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|2	|7	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|2	|8	|ACADEMY DINOSAUR	|0.990000009536743	|20.9899997711182
|2	|9	|ACE GOLDFINGER	  |4.98999977111816	  |12.9899997711182
|2	|10	|ACE GOLDFINGER	  |4.98999977111816	  |12.9899997711182

## Question 3. 
From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory. 
We  would like to know how many inventory items you have with each rating at each store.

### Steps
We need to join the inventory, film, and store tables to get the rating of each film and which store it belongs to. Then, group the results by store and rating to get a summary level overview of the inventory.

```sql
SELECT s.store_id, f.rating, COUNT(*) AS inventory_count
FROM inventory i
INNER JOIN film f 
  ON i.film_id = f.film_id
INNER JOIN store s 
  ON i.store_id = s.store_id
GROUP BY s.store_id, f.rating
```
## OUTPUT
|**store_id**|**rating**|**inventory_count**|
|------------|----------|----------------|
|1|	G    |	394
|2|	G    |  397
|1|	PG-13|	525
|1| NC-17|  465
|2| NC-17|  479
|1| PG	 |  444
|1| R	   |  442
|2| R	   |  462
|2| PG	 |  480
|2| PG-13|  493

## Question 4. 
Similarly, we want to understand how diversified the inventory is in terms of replacement cost. 
We want to see how big of a hit it would if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, sliced by store and film category.

### Steps
We need to join the store, film, inventory, film_category and category tables and group the results by store and category. 
Then, calculate the count of films, the average replacement cost, and the total replacement cost for each group. 

```sql
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
```

## OUTPUT
|**store_id**|**category**|**num_films**|**avg_replacement_cost**|**total_replacement_cost**|
|------------|------------|-------------|------------------------|--------------------------|
|2	|Drama	 |47	|21.4610142638718	|2961.61996841431
|1	|Horror	 |38	|19.7489283425467	|2211.87997436523
|2	|Classics|45	|21.2921580444995	|2959.60996818542
|1	|Comedy	 |49	|19.4407039964703	|2760.57996749878
|1	|Foreign |50	|18.5586272220986	|2839.46996498108
|2	|Horror	 |43	|19.5635291828829	|2660.63996887207
|2	|Sports	 |59	|20.6971820915602	|3746.18995857239
|2	|Foreign |50	|18.6362582745195	|2739.52996635437
|1	|Drama	 |51	|21.9344442155626	|3553.37996292114
|1	|Sports	 |57	|20.5789568263329	|3354.36996269226

## Question 5. 
We want to make sure you folks have a good handle on who your customers are. 
Please provide a list of all cusomer names, which store they go to, whether or not they are currently active and their full address-street address, city and country 

### Steps
Selecting customer's first name and last name concatenated as customer_name
store_id
customer's active status as customer_status
full address as a concatenated string of address, city, and country
From the customer table, join the address table on the address_id column.

From the address table, join the city table on the city_id column.

From the city table, join the country table on the country_id column.

From the customer table, join the store table on the store_id column.

Use CASE statement to display customer status as 'Active' or 'Inactive' based on the value of the active column.

Concatenate the address, city, and country columns using the CONCAT() function.

Order the output by store_id and customer_name.

```sql
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
```
## OUTPUT
|**customer_name**|**store_id**|**customer_status**|**full_address**|
|-----------------|------------|-------------------|----------------|
|ADAM GOOCH	      |1	|Active	|230 Urawa Drive, Adoni, India
|ALAN KAHN	      |1	|Active	|753 Ilorin Avenue, Emeishan, China
|ALBERT CROUSE	  |1	|Active	|1641 Changhwa Place, Bamenda, Cameroon
|ALICE STEWART	  |1	|Active	|1135 Izumisano Parkway, Fontana, United States
|ALICIA MILLS	    |1	|Active	|1963 Moscow Place, Nagaon, India
|ALLAN CORNISH	  |1	|Active	|947 Trshavn Place, Tarlac, Philippines
|ALMA AUSTIN	    |1	|Active	|1074 Binzhou Manor, Mannheim, Germany
|AMBER DIXON	    |1	|Active	|1029 Dzerzinsk Manor, Touliu, Taiwan
|AMY LOPEZ	      |1	|Active	|176 Mandaluyong Place, Jhansi, India
|ANDRE RAPP	      |1	|Active	|568 Dhule (Dhulia) Loop, Coquimbo, Chile

## Question 6. 
We would like to understand how much your customers are spending wih you, and also to know who your most valuable customers are.
Please pull together a list of customer names, their total lifetime rentals and the sum of all payments you have collected from them
It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list.

```sql
SELECT c.first_name + ' ' + c.last_name AS customer_name,
       SUM(CAST(p.amount AS decimal(10, 2))) AS total_payments,
       COUNT(r.rental_id) AS lifetime_rentals,
       SUM(CAST(p.amount AS decimal(10, 2)))/COUNT(r.rental_id) AS avg_payment_per_rental
FROM customer AS c
JOIN payment AS p ON c.customer_id = p.customer_id
JOIN rental AS r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_payments DESC
```
## OUTPUT
|**customer_name**|**total_payments**|**lifetime_rentals**|**avg_payment_per_rental**|
|-----------------|------------------|--------------------|--------------------------|
|KARL SEAL	   |9969.75	|2025	|4.923333
|ELEANOR HUNT	 |9960.84	|2116	|4.707391
|CLARA SHAW	   |8214.36	|1764	|4.656666
|RHONDA KENNEDY|7589.79	|1521	|4.990000
|MARION SNYDER |7589.79	|1521	|4.990000
|MARCIA DEAN	 |7374.36	|1764	|4.180476
|WESLEY BULL	 |7104.00	|1600	|4.440000
|TOMMY COLLAZO |7091.56	|1444	|4.911052
|TIM CARY	     |6848.79	|1521	|4.502820
|JUNE CARROLL	 |6424.31	|1369	|4.692702

## Question 7: 
My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor name in one table?
Could you please note whether they are an investor or an advisor, and for the investors, it would be good to include which company they work with.

### Steps
To get a list of advisors and investors with their respective roles and company names (for investors), 
we can join the advisor and investor tables on the first_name and last_name columns

```sql
SELECT CONCAT(first_name, ' ', last_name) AS name, 'Investor' AS type, company_name AS affiliated_company
FROM investor
UNION
SELECT CONCAT(first_name, ' ', last_name) AS name, 'Advisor' AS type, '' AS affiliated_company
FROM advisor
```

## OUTPUT
|**name**|**type**|**affiliated_company**|
|--------|--------|----------------------|
|Anthony Stark    |	Investor|Iron Investors
|Barry Beenthere  |	Advisor	|
|Cindy Smartypants|	Advisor	|
|Mary Moneybags	  |Advisor	|
|Montgomery Burns	|Investor	|Springfield Syndicators
|Walter White	    |Advisor	|
|William Wonka	  |Investor	|Chocolate Ventures

## Question 8: 
We're interested in how well you have covered the most-awarded actors.
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions.
Finally, how about actors with just one award?

### Steps
Using Common Table Expressions (CTE) to calculate the number of awards and number of films for each actor. Then using conditional aggregation to calculate the number of actors with one, two, or three awards and the number of actors in each category who have appeared in at least one film. The COUNT(DISTINCT) at the end gives the total number of actors in the data.

```sql
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
```
## OUTPUT
|one_award_total	one_award_with_film	two_awards_total	two_awards_with_film	three_awards_total	three_awards_with_film	total_actors
|--------|--------|-------------------
135	135	0	0	0	0	135





