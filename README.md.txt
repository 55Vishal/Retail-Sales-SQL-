🛒 Retail Sales SQL Analysis
📌 Project Overview

This project focuses on analyzing retail sales data using SQL. It includes database creation, data cleaning, exploration, and solving key business problems through queries.

The goal is to extract meaningful insights such as customer behavior, sales trends, and category performance.

🗂️ Dataset Description

The dataset is stored in a table named retail_sales with the following schema:

Column Name	Data Type	Description
transaction_id	INT (PK)	Unique transaction identifier
sale_date	DATE	Date of the transaction
sale_time	TIME	Time of the transaction
customer_id	INT	Unique customer ID
gender	VARCHAR	Customer gender
age	INT	Customer age
category	VARCHAR	Product category
quantity	INT	Number of items sold
price_per_unit	FLOAT	Price per unit
cogs	FLOAT	Cost of goods sold
total_sale	FLOAT	Total transaction value
⚙️ Database Setup
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
🧹 Data Cleaning

The following steps were performed:

Identified null values across important columns
Removed records with missing critical data
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
🔍 Data Exploration

Basic exploration queries:

Total number of sales:
SELECT COUNT(*) FROM retail_sales;
Unique customers:
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
Available categories:
SELECT DISTINCT category FROM retail_sales;
📊 Business Questions & Solutions
✅ Q1: Sales on a specific date
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
✅ Q2: Clothing sales with quantity ≥ 4 in Nov 2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
✅ Q3: Total sales by category
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
✅ Q4: Average age of Beauty category customers
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
✅ Q5: Transactions with total sale > 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
✅ Q6: Transactions by gender and category
SELECT 
    category, 
    gender,
    COUNT(transaction_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
✅ Q7: Average monthly sales & best month each year
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, avg_sales DESC;

Best selling month per year:

SELECT year, month
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sales,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY year, month
) t
WHERE rank = 1;
✅ Q8: Top 5 customers by sales
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
✅ Q9: Unique customers per category
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
✅ Q10: Sales shifts analysis
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(transaction_id) AS total_transactions
FROM hourly_sale
GROUP BY shift;
📈 Key Insights
Sales distribution across categories helps identify top-performing segments
Customer demographics (age, gender) influence purchasing behavior
Time-based analysis reveals peak sales periods
High-value customers can be identified for targeted marketing
🚀 Conclusion

This project demonstrates how SQL can be used to:

Clean and prepare raw data
Perform exploratory data analysis
Answer real-world business questions
Generate actionable insights
📁 Project Status

✅ Completed