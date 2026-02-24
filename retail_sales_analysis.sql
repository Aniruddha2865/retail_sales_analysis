-- create table
drop table if exists retail_sales;
create table retail_sales(
	transactions_id int primary key,
	sale_date date,
	sale_time time,
	customer_id int,
	gender varchar(15),
	age int,
	category varchar(15),
	quantiy int,
	price_per_unit float,
	cogs float,
	total_sale float
	);
alter table retail_sales rename column quantiy to quantity;
select * from retail_sales
limit 10;
--data cleaning
select count(*) from retail_sales;

select * from retail_sales
where 
	transactions_id is null
	or	sale_date is null
	or	sale_time is null
	or customer_id is NULL
	or gender is null
	or age is null
	or category is null
	or quantity is null 
	or price_per_unit is null
	or cogs is null
	or total_sale is null;
--
delete from retail_sales
where 
	transactions_id is null
	or	sale_date is null
	or	sale_time is null
	or customer_id is NULL
	or gender is null
	or age is null
	or category is null
	or quantity is null 
	or price_per_unit is null
	or cogs is null
	or total_sale is null;

--- Data exploration & understanding
--Total rows:
select count(*) from retail_sales;

--Unique categories:
select distinct category from retail_sales;

--Gender distribution:
select gender, count(*) as gender_count 
from retail_sales
group by gender;

--Average quantity, price, total sale:
SELECT
	round(avg(quantity)) as avg_qty,
	round(avg(price_per_unit)) as avg_price,
	round(avg(total_sale)) as avg_sale
from retail_sales;

---Time based Sales Insights
--Monthly Sales trend
select 
	to_char(sale_date, 'yyyy-mm') as month, 
	sum(total_sale) as monthly_sales
from retail_sales
group by month
order by month;

--Yearly Sales
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    SUM(total_sale) AS yearly_sales
FROM retail_sales
GROUP BY year
ORDER BY year;

---Category performance
--revenue & units sold by category
SELECT 
    category,
    SUM(quantity) AS total_units_sold,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- average price per unit in each category
SELECT 
    category,
    ROUND(AVG(price_per_unit)) AS avg_price
FROM retail_sales
GROUP BY category;

---Customer Demographics
--Age Groups
SELECT 
    CASE 
        WHEN age < 20 THEN 'Teen'
        WHEN age BETWEEN 20 AND 35 THEN 'Young Adult'
        WHEN age BETWEEN 36 AND 50 THEN 'Middle Age'
        ELSE 'Senior'
    END AS age_group,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY age_group
ORDER BY total_sales DESC;

--Gender based 
SELECT gender, SUM(total_sale) AS gender_sales
FROM retail_sales
GROUP BY gender;

---Profitability
--Profit per TRANSACTION
SELECT 
    transactions_id,
    total_sale as revenue,
    cogs,
    (total_sale - cogs) AS profit
FROM retail_sales
group by category
order by profit desc;

--Profit per category
SELECT 
    category,
    SUM(total_sale) AS revenue,
    SUM(cogs) AS cogs,
    SUM(total_sale - cogs) AS profit
FROM retail_sales
GROUP BY category
ORDER BY profit DESC;

---RFM Analysis
--Recency
SELECT 
    customer_id,
    (SELECT MAX(sale_date) FROM retail_sales) - MAX(sale_date) AS recency_days
FROM retail_sales
GROUP BY customer_id
ORDER BY recency_days;

--Frequency
SELECT 
    customer_id,
    COUNT(*) AS frequency
FROM retail_sales
GROUP BY customer_id
ORDER BY frequency DESC;

--Monetary VALUE
SELECT 
    customer_id,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC;

--RFM Table
SELECT 
    customer_id,
    (SELECT MAX(sale_date) FROM retail_sales) - MAX(sale_date) AS recency,
    COUNT(*) AS frequency,
    SUM(total_sale) AS monetary
FROM retail_sales
GROUP BY customer_id;

--Repeat customer count
SELECT 
    COUNT(*) FILTER (WHERE visits > 1) AS repeat_customers,
    COUNT(*) AS total_customers
FROM (
    SELECT customer_id, COUNT(*) AS visits
    FROM retail_sales
    GROUP BY customer_id
) AS t;

