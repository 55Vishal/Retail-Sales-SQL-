
-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales



SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
		
		SELECT *
		FROM retail_sales
		WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

		SELECT 
		  *
		FROM retail_sales
		WHERE 
		    category = 'Clothing'
		    AND 
		    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
		    AND
		    quantity >= 4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

		SELECT 
		    category,
		    SUM(total_sale) as net_sale,
		    COUNT(category) as total_orders
		FROM retail_sales
		GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

		SELECT
		    ROUND(AVG(age), 2) as avg_age
		FROM retail_sales
		WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

		SELECT * FROM retail_sales
		WHERE total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

		Select * From retail_sales
		
		Select category, gender,
		  Count(transactions_id) AS total_trans
		From retail_sales
		Group By category, gender
		Order By category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year 
  
  Select 
	   Extract(Year from sale_date) AS year,
	   Extract(month From sale_date) AS month, 
	   AVG(total_sale) AS avg_sales
  From retail_sales
  Group By year, month
  Order By year, avg_sales DESC

  
----***********-----------**********------------***********-----------------**********---------------------- 


	 Select 
	 		year,
			month 
	 From 
	 (	
	 Select 
		   Extract(Year from sale_date) AS year,
		   Extract(month From sale_date) AS month, 
		   AVG(total_sale) AS avg_sales,
		   RANK() OVER(
		   	PARTITION BY EXTRACT(year FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	  From retail_sales
	  Group By year, month
	  
	 )AS t1
	 Where rank = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

	Select 
	  customer_id,
	  SUM(total_sale) AS total_sales
	From retail_sales
	Group By customer_id
	Order By total_sales DESC
	Limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

	Select 
	  category,
	  Count(Distinct(customer_id))
	From retail_sales
	Group By 1


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

With hourly_sale
AS(
Select *,
CASE
	WHEN Extract(HOUR from sale_time) < 12 THEN 'Morning 1st shift'
	WHEN Extract(Hour from sale_time) Between 12 AND 17 Then 'Afternoon 2nd shift'
	Else 'Evening 3rd shift'
	End AS shift
From retail_sales
)
Select shift,
	   Count(transactions_id) AS total_trans
From hourly_sale
Group By shift


--------------- END OF PROJECT --------------




