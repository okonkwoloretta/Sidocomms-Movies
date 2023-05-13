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
|2	|11	|ACE GOLDFINGER	  |4.98999977111816	  |12.9899997711182
|2	|12	|ADAPTATION HOLES |2.99000000953674	  |18.9899997711182
|2	|13	|ADAPTATION HOLES |2.99000000953674	  |18.9899997711182
|2	|14	|ADAPTATION HOLES	|2.99000000953674	  |18.9899997711182
|2	|15	|ADAPTATION HOLES	|2.99000000953674	  |18.9899997711182
|1	|16	|AFFAIR PREJUDICE	|2.99000000953674	  |26.9899997711182
|1	|17	|AFFAIR PREJUDICE	|2.99000000953674	  |26.9899997711182
|1	|18	|AFFAIR PREJUDICE	|2.99000000953674	  |26.9899997711182
|1	|19	|AFFAIR PREJUDICE	|2.99000000953674	  |26.9899997711182
|2	|20	|AFFAIR PREJUDICE	|2.99000000953674  	|26.9899997711182
|2	|21	|AFFAIR PREJUDICE	|2.99000000953674 	|26.9899997711182
|2	|22	|AFFAIR PREJUDICE	|2.99000000953674 	|26.9899997711182
|2	|23	|AFRICAN EGG	    |2.99000000953674 	|22.9899997711182


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
|**store_id**|**rating**|**inventory_count**
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
