# 🛒 Retail Sales Analysis using SQL
---
## 📌 Overview

This project delivers a comprehensive analysis of retail sales data using SQL, covering the full analytics workflow — from data preparation to business insight generation.

It demonstrates practical SQL skills expected in real-world data analyst roles, including:

* Data cleaning and validation
* Exploratory data analysis (EDA)
* Aggregations and window functions
* Business-driven query design

The analysis focuses on uncovering patterns in customer behavior, product performance, and sales trends.

---

## 🎯 Objectives

* Design and create a structured retail database
* Ensure data quality through cleaning and validation
* Perform exploratory analysis to understand data distribution
* Solve business problems using optimized SQL queries
* Generate actionable insights for decision-making

---

## 🗂️ Data Model

The dataset is stored in a relational table: `retail_sales`

| Column Name    | Data Type | Description                   |
| -------------- | --------- | ----------------------------- |
| transaction_id | INT (PK)  | Unique transaction identifier |
| sale_date      | DATE      | Transaction date              |
| sale_time      | TIME      | Transaction time              |
| customer_id    | INT       | Unique customer identifier    |
| gender         | VARCHAR   | Customer gender               |
| age            | INT       | Customer age                  |
| category       | VARCHAR   | Product category              |
| quantity       | INT       | Units sold                    |
| price_per_unit | FLOAT     | Unit price                    |
| cogs           | FLOAT     | Cost of goods sold            |
| total_sale     | FLOAT     | Total transaction value       |

---

## ⚙️ Database Setup

```sql
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
```

---

## 🧹 Data Quality & Cleaning

Data integrity checks were performed to ensure analytical reliability:

* Identified missing/null values across key business fields
* Removed incomplete records impacting analysis accuracy
* Standardized column references

```sql
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
```

---

## 🔍 Exploratory Data Analysis (EDA)

```sql
-- Total transactions
SELECT COUNT(*) AS total_transactions FROM retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- Product categories
SELECT DISTINCT category FROM retail_sales;
```

---

## 📊 Business Analysis

### 🧾 Daily Sales Analysis

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

---

### 👕 Category-Based Filtering (Clothing, Nov 2022)

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

---

### 💰 Revenue by Category

```sql
SELECT 
    category,
    SUM(total_sale) AS total_revenue,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

---

### 👥 Customer Demographics (Beauty Category)

```sql
SELECT ROUND(AVG(age), 2) AS avg_customer_age
FROM retail_sales
WHERE category = 'Beauty';
```

---

### 💎 High-Value Transactions

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

---

### 🚻 Transactions by Gender & Category

```sql
SELECT 
    category,
    gender,
    COUNT(transaction_id) AS transaction_count
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

---

### 📈 Monthly Sales Trend & Peak Month Detection

```sql
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_monthly_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, avg_monthly_sales DESC;
```

```sql
-- Best performing month per year
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
) ranked
WHERE rank = 1;
```

---

### 🏆 Top Customers by Revenue

```sql
SELECT 
    customer_id,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 5;
```

---

### 🧑‍🤝‍🧑 Customer Distribution by Category

```sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

---

### ⏰ Sales by Time Shift

```sql
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
```

---

## 📈 Key Insights

* Category-level analysis highlights revenue concentration across product segments
* Customer demographics reveal targeted marketing opportunities
* Temporal analysis identifies peak sales periods and operational demand
* High-value transactions contribute disproportionately to total revenue
* Repeat customers significantly drive overall sales

---

## 🚀 Conclusion

This project demonstrates end-to-end SQL-based data analysis, combining data preparation, exploration, and business intelligence.

Key skills demonstrated:

* Writing efficient SQL queries
* Translating business questions into data problems
* Extracting insights from structured datasets

---

