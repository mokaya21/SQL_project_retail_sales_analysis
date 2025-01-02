-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_sp1;

-- Create Table
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE DEFAULT NULL,	
				sale_time TIME DEFAULT NULL,
				customer_id	INT DEFAULT NULL,
				gender VARCHAR(15) DEFAULT NULL,
				age	INT DEFAULT NULL,
				category VARCHAR(15) DEFAULT NULL,
				quantity INT DEFAULT NULL,
				price_per_unit FLOAT DEFAULT NULL,
				cogs FLOAT DEFAULT NULL,
				total_sale FLOAT DEFAULT NULL
			);

SELECT COUNT(*) FROM retail_sales;
DESCRIBE sql_project_sp1.retail_sales;

-- Data cleaning

-- Handle missing values
SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL 
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Data Exploration

-- How many sales did we make?
SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_sales
FROM retail_sales;

-- How many categories do we have?
SELECT DISTINCT category
FROM retail_sales;

-- Data Analysis- Key Business Problems & Answers

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and quantity sold is more than 4 in the month of November 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'  
		AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
        AND quantity >= 4 ;

-- Q3. Write a SQL query to calculate the total sales for each category
SELECT 
	category,
    SUM(total_sale) AS total_sales, 
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT 
	category,	
	ROUND(AVG(age), 1) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6. Write a SQL query to find the total number of transactions made by each gender in each category
SELECT 
    category,
    gender,
    COUNT(transactions_id) AS number_of_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category ;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year
WITH aggregated_sales AS
	(
    SELECT 
		YEAR(sale_date) AS year,
		MONTH(sale_date) AS month,
		ROUND(AVG(total_sale), 2) AS avg_sales
	FROM retail_sales
	GROUP BY year, month
    ) 
SELECT *
FROM (
		SELECT
			year,
            month,
            avg_sales,
            RANK() OVER (PARTITION BY year ORDER BY avg_sales DESC) AS avg_sales_rank
		FROM aggregated_sales) AS ranked_sales
WHERE avg_sales_rank = 1;

-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	 customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
	category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10. Write a SQL query to create each shift and number of orders (e.g. Morning <= 12, Afternoon between 12 & 17, Evening > 17
SELECT 
	CASE
    WHEN hour(sale_time) < 12 THEN 'Morning'
    WHEN hour(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
    END AS time_of_day,
    COUNT(transactions_id) AS number_of_orders    
FROM retail_sales
GROUP BY time_of_day;

-- END OF PROJECT