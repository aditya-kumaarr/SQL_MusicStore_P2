# Music Store Sales Analysis SQL Project

## Project Overview

**Project Title**: Music Store Analysis  
**Tool**: MySQL Workbench  
**Database**: `sql_music_store_p2`

This project is designed to demonstrate advanced SQL skills and techniques typically used by data analysts to explore, clean, and analyze music store sales data. The project involves setting up a music store database with multiple related tables, performing complex joins, using window functions, and answering specific business questions through SQL queries.

## Objectives

1. **Set up a music store database**: Create and populate a comprehensive music store database with multiple related tables including artists, album, tracks, customers, invoices and employees.
2. **Exploratory Data Analysis (EDA)**: Explore the relationships between different tables and understand the data structure
3. **Complex Query Analysis**: Perform advanced SQL operations including JOINs, CTEs, window functions and subqueries
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the music store sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_p1`.
- **Data Import Process**: 12 CSV Files containing music store data were imported using MySQL Workbench's Table Data Import Wizard
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.
- **Final Database Schema**:
The database contains 12 interconnected tables - 
	- customer - Customer information and demographics
	- invoice - Sales transaction records
	- invoice_line - Individual items in each transaction
	- track - Music track details
	- album - Album information
	- artist - Artist details
	- genre - Music genre classification
	- employee - Employee hierarchy and information
	- media_type - Audio format types
	- playlist & playlist_track - Playlist management
	- Additional supporting tables

```sql
CREATE DATABASE sql_project_p1;
```

### 2. Data Exploration Queries : Basic SELECT statements were executed on each table to understand -
- Table structures and column names
- Data types and constraints
- Sample data for context
- Relationships between tables for future JOIN operations

```sql
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
```

### 3. Data Analysis & Key Business Problems with Solutions

The following SQL queries were developed to answer specific business questions:

1. **Who is the senior most employee based on job title?**:
```sql
SELECT *
FROM employee
WHERE levels = (SELECT MAX(levels)
				FROM employee);
```

2. **Which countries have the most Invoices?**:
```sql
SELECT billing_country, COUNT(billing_country) AS INVOICE_NO
FROM invoice
GROUP BY billing_country
ORDER BY INVOICE_NO DESC
LIMIT 1;
```

3. **What are top 3 values of total invoice?**:
```sql
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;
```

4. **Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals**:
```sql
SELECT billing_country, SUM(total) AS total
FROM invoice
GROUP BY billing_country
ORDER BY total DESC
LIMIT 1;
```

5. **Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.**:
```sql
SELECT c.first_name, SUM(i.total) AS total
FROM invoice as i
LEFT JOIN customer as c
ON i.customer_id = c.customer_id
GROUP BY first_name
ORDER BY total DESC;
```

6. **Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A.**:
```sql
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
```

7. **Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.**:
```sql
SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds)
							FROM track)
ORDER BY milliseconds DESC;
```

8. **Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent**:
```sql
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
```

9. **We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres.**:
```sql
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
```

10. **Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.**:
```sql
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
```

## Findings

- **Global Market Reach**: The dataset spans multiple countries with distinct purchasing patterns and genre preferences across different regions.
- **Premium Customer Segments**: Analysis reveals high-value customers and transactions, enabling targeted VIP programs and personalized marketing strategies.
- **Genre Performance**: Rock music shows strong customer engagement, with clear regional variations in music taste preferences.
- **Artist Revenue Insights**: Detailed revenue attribution across artists provides strategic insights for partnership and royalty decisions.
- **Content Strategy**: Track length analysis reveals premium content opportunities and pricing optimization potential.

## Reports

- **Customer Demographics**: Comprehensive analysis of customer distribution across countries with spending behavior patterns.
- **Genre Performance Dashboard**: Regional music preferences and genre popularity metrics for inventory optimization.
- **Revenue Analytics**: Artist-wise revenue attribution and high-value transaction analysis for strategic decision-making.
- **Organizational Insights**: Employee hierarchy analysis and management structure optimization recommendations.

## Conclusion

This comprehensive SQL project demonstrates advanced database management capabilities applied to music industry analytics. The analysis provides actionable insights into customer segmentation, regional market preferences, artist performance metrics, and revenue optimization strategies. The project showcases expertise in complex multi-table JOINs, window functions, CTEs, and strategic business intelligence that enables data-driven decision-making in the entertainment industry.

## How to Run the Project

1.	Import the music store dataset into your SQL environment (MySQL/PostgreSQL).
2.	Copy-paste the queries from sql_music_store_p2.sql into your SQL editor.
3.	Execute the database creation script first, then run queries sequentially.
4.	Analyze results and customize queries based on specific business requirements.
5.	Use the insights to optimize inventory, marketing campaigns, and customer retention strategies.


## If you'd like to connect or collaborate on data projects, feel free to reach out on: 
• **LinkedIn**: www.linkedin.com/in/aditya-kumar-2852c
• **Email**: adityaakumaarr@gmail.com
