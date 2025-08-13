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

1. **Retrieve all columns for sales made on '2022-11-05'**:
```sql
SELECT 
    *
FROM
    sql_project_p1.retail_sales
WHERE
    sale_date = '2022-11-05';
```

2. **Retrieve all transactions where the category is 'clothing' and the quantity sold is greater than or equal to 4 in the month of November 2022**:
```sql
SELECT 
    *
FROM
    sql_project_p1.retail_sales
WHERE
    category = 'Clothing'
        AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
        AND quantity >= 4;
```

3. **Calculate the total sales for each category**:
```sql
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM
    sql_project_p1.retail_sales
GROUP BY 1;
```

4. **Find the average age of customers who purchased items from the 'beauty' category**:
```sql
SELECT 
    ROUND(AVG(age)) AS avg_age
FROM
    sql_project_p1.retail_sales
WHERE
    category = 'Beauty';
```

5. **Retrieve all transactions where the total_sale amount is greater than 1000**:
```sql
SELECT 
    *
FROM
    sql_project_p1.retail_sales
WHERE
    total_sale > 1000;
```

6. **Count the total numbers of transactions made by each gender in each category**:
```sql
SELECT 
    category, gender, COUNT(*) AS total_trans
FROM
    sql_project_p1.retail_sales
GROUP BY category , gender
ORDER BY 1;
```

7. **Calculate the average sales for each month and identify the best selling month in each year**:
```sql
SELECT 
	year,
    month,
    avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM sql_project_p1.retail_sales
    GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) AS t1
WHERE rnk = 1;
```

8. **Retrieve the top 5 customers based on the highest total sales**:
```sql
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    sql_project_p1.retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Find the number of unique customers who purchased items from each category**:
```sql
SELECT 
    category, COUNT(DISTINCT customer_id) AS cnt_unique
FROM
    sql_project_p1.retail_sales
GROUP BY category;
```

10. **Create time based shifts (Morning, Afternoon, Evening) and count the number of orders in each shift**:
```sql
WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift
FROM sql_project_p1.retail_sales
)
SELECT
	shift,
    COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

A comprehensive SQL project involving database creation, data preprocessing, exploratory analysis, and performance-driven queries. This analysis helps businesses gain actionable insights into customer trends, sales performance, and category-wise product performance to optimize strategies and enhance decision-making.

## How to Run the Project

1.	Import the dataset into your SQL environment (MySQL/PostgreSQL).
2.	Copy-paste the queries from sql_retail_sales_p1.sql into your SQL editor.
3.	Run them one by one to see the results and tweak as needed.



## If you'd like to connect or collaborate on data projects, feel free to reach out on: 
• **LinkedIn**: https://www.linkedin.com/in/aditya-kumar-4a175635b/
• **Email**: adityaakumaarr@gmail.com
