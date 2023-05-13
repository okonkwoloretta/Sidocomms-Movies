## Question 1. 
My partner and i want to come by each of the stores in person and meet the managers. 
Please send over the managers names at each stores, wih the full address of the property(street address, district,city, and country please)

* Using the 'CONCAT_WS' function to concatenate the address fields with appropriate delimiters (comma and space) to form the full address and full name

```sql
SELECT CONCAT_WS(' ', s.first_name, s.last_name) AS manager_name, CONCAT_WS(', ', a.address, c.city, co.country) AS full_address
FROM [Sidocomms].[dbo].[store] st
JOIN address a 
  ON st.address_id = a.address_id
JOIN city c 
  ON a.city_id = c.city_id
JOIN country co
  ON c.country_id = co.country_id
JOIN staff s 
  ON st.store_id = s.store_id 
```
## OUTPUT

|**manager_name**|**full_address**
|----------------|--------------
  Jon Stephens	 | 28 MySQL Boulevard, Woodridge, Australia
  Mike Hillyer	 | 47 MySakila Drive, Lethbridge, Canada
