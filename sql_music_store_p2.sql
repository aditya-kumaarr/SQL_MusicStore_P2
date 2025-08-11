-- created database
CREATE DATABASE music_store_data;


-- checking the types of data present in all the tables
SELECT *
FROM album;

SELECT *
FROM album2;

SELECT *
FROM artist;

SELECT *
FROM customer;

SELECT *
FROM employee;

SELECT *
FROM genre;

SELECT *
FROM invoice;

SELECT *
FROM invoice_line;

SELECT *
FROM media_type;

SELECT *
FROM playlist;

SELECT *
FROM playlist_track;

SELECT *
FROM track;


-- after going through all the files, we start solving with the queries and questions that we want to answer 

-- Question Set 1 - EASY

-- Q1: Who is the senior most employee based on job title? 
SELECT *
FROM employee
WHERE levels = (SELECT MAX(levels)
				FROM employee);
		

-- Q2: Which countries have the most Invoices? 
SELECT billing_country, COUNT(billing_country) AS INVOICE_NO
FROM invoice
GROUP BY billing_country
ORDER BY INVOICE_NO DESC
LIMIT 1;


-- Q3: What are top 3 values of total invoice?
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;


/* 
Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals
*/
SELECT billing_country, SUM(total) AS total
FROM invoice
GROUP BY billing_country
ORDER BY total DESC
LIMIT 1;


/*
Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.
*/
SELECT c.first_name, SUM(i.total) AS total
FROM invoice as i
LEFT JOIN customer as c
ON i.customer_id = c.customer_id
GROUP BY first_name
ORDER BY total DESC;


-- Question Set 2 - Moderate

/* 
Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. 
*/ 
SELECT DISTINCT c.email, c.first_name, c.last_name, g.name
FROM track AS t
CROSS JOIN invoice_line AS i
ON i.track_id = t.track_id
CROSS JOIN invoice
ON i.invoice_id = invoice.invoice_id
CROSS JOIN customer AS c
ON invoice.customer_id = c.customer_id
CROSS JOIN genre AS g
ON t.genre_id = g.genre_id
WHERE t.genre_id = 1
ORDER BY email;


/*
Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. 
*/
SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds)
							FROM track)
ORDER BY milliseconds DESC;


-- Question Set 3 - Advance

-- Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent
SELECT c.first_name AS Customer_Name, SUM(i.total * quantity) AS total, art.name AS Artist_Name
FROM customer AS c
INNER JOIN invoice AS i
ON c.customer_id = i.customer_id
INNER JOIN invoice_line AS l
ON i.invoice_id = l.invoice_id
INNER JOIN track AS t
ON l.track_id = t.track_id
INNER JOIN album AS a
ON t.album_id = a.album_id
INNER JOIN artist AS art
ON a.artist_id = art.artist_id
GROUP BY Customer_Name,Artist_Name
ORDER BY total DESC;


/* 
Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. 
*/
WITH most_popular_genre AS 
					( SELECT COUNT(l.quantity) AS top_purchases, c.country, g.name, g.genre_id,
                      ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(l.quantity) DESC) AS row_no
                      FROM invoice_line AS l
                      INNER JOIN invoice AS i
                      ON i.invoice_id = l.invoice_id
                      INNER JOIN customer AS c
                      ON i.customer_id = c.customer_id
                      INNER JOIN track AS t
                      ON t.track_id = l.track_id
                      INNER JOIN genre AS g
                      ON g.genre_id = t.genre_id
                      GROUP BY 2,3,4
                      ORDER BY 1 DESC, 2 ASC
					)
SELECT * FROM most_popular_genre WHERE row_no <= 1;


/* 
Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.
*/


WITH most_money_spent AS 
						( SELECT c.first_name, c.country, SUM(i.total) AS total_spent,
                        ROW_NUMBER() OVER (PARTITION BY first_name ORDER BY SUM(i.total) DESC) AS row_no
                        FROM customer AS C
                        INNER JOIN invoice AS i
                        ON c.customer_id = i.invoice_id
                        GROUP BY 1, 2
                        ORDER BY 1 DESC, 2 ASC
                        )
SELECT * 
FROM most_money_spent 
WHERE row_no <= 1;

