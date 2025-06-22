use monday_coffee
-- Monday Coffee SCHEMAS

----------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS city;

----------------------------------------------------------------------------------------------------------------------

# we create city table using code

CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(15),	
	population	BIGINT,
	estimated_rent	FLOAT,
	city_rank INT
);


INSERT INTO city (city_id,city_name,population,estimated_rent,city_rank)
VALUES 
(1,"Bangalore","12300000","29700",1),
(2,"Chennai","11100000","17100",6),
(3,"Pune","7500000","15300",9),
(4,"Jaipur","4000000","10800",8),
(5,"Delhi","31000000","22500",3),
(6,"Mumbai","20400000","31500",2),
(7,"Hyderabad","10000000","22500",4),
(8,"Ahmedabad","8300000","14400",5),
(9,"Kolkata","14900000","16200",7),
(10,"Surat","7200000","13500",10),
(11,"Lucknow","3800000","9000",11),
(12,"Kanpur","3100000","8100",12),
(13,"Nagpur","2900000","7200",13),
(14,"Indore","3300000","6300",14);

SELECT * FROM city

----------------------------------------------------------------------------------------------------------------------

# we first copy paste data in excel from source and export file in .cvs formate then import that customers.cvs file into sql database as table customers. 

CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(25),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);

SELECT * FROM customers 

----------------------------------------------------------------------------------------------------------------------

# we first copy paste data in excel from source and export file in .cvs formate then import that products.cvs file into sql database as table products. 

CREATE TABLE products
(
	product_id	INT PRIMARY KEY,
	product_name VARCHAR(35),	
	Price float
);

SELECT * FROM products

----------------------------------------------------------------------------------------------------------------------

# we first copy paste/import data in excel from source and export file in .cvs formate then import data through LOAD_FILE() function.
# also we format all the rows of column sales_date into YYYY-MM-DD

CREATE TABLE sales
(
	sale_id	INT PRIMARY KEY,
	sale_date	date,
	product_id	INT,
	customer_id	INT,
	total FLOAT,
	rating INT,
	CONSTRAINT fk_products FOREIGN KEY (product_id) REFERENCES products(product_id),
	CONSTRAINT fk_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);


LOAD DATA INFILE 'sales_sql.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM sales

----------------------------------------------------------------------------------------------------------------------

-- END of SCHEMAS 

----------------------------------------------------------------------------------------------------------------------

-- Monday Coffee -- Data Analysis 

SELECT * FROM city;
SELECT * FROM products;
SELECT * FROM customers;
SELECT * FROM sales;

----------------------------------------------------------------------------------------------------------------------

-- Reports & Data Analysis

-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?

SELECT 
	city_name,
    ROUND((population * 0.25)/1000000, 2) AS coffee_consumers_in_millions,
    city_rank
FROM city
ORDER BY 2 DESC

-- population                  
-- population * 0.25                      -- 25% of population
-- (population * 0.25)/1000000            -- 25% of population in millions
-- (population * 0.25)/1000000 AS coffee_consumers_in_millions,           -- 25% of population in millions with alias
-- ROUND((population * 0.25)/1000000) AS coffee_consumers_in_millions,    -- 25% of population in millions with alias and ROUND UP
-- ROUND((population * 0.25)/1000000, 2) AS coffee_consumers_in_millions,  -- 25% of population in millions with alias and ROUND UP to 2 decimals

-- FINDINGS-

-- Top 3 cities with highest estimated coffee consumer are - Delhi, Mumbai, Kolkata
-- Nagpur has the lowest estimated coffee customer.

----------------------------------------------------------------------------------------------------------------------

-- -- Q.2
-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?

-- M-1
-- here i used [WHERE sa.sale_date BETWEEN  '2023-10-01' AND '2023-12-31'] to get last quarter of 2023

WITH temp_table AS 
(
SELECT
	SUM(sa.total) AS total,
    sa.sale_date,
    ci.city_name
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
WHERE sa.sale_date BETWEEN  '2023-10-01' AND '2023-12-31'
GROUP BY sa.sale_date, ci.city_name
)

SELECT 
	city_name,
	SUM(total) AS total_sales
FROM temp_table
GROUP BY city_name
ORDER BY total_sales DESC;
	
-- M-2
-- here we extract year and quarter from date.

SELECT
	SUM(sa.total) AS total,
    ci.city_name
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
WHERE 
	YEAR(sa.sale_date) = 2023
    AND
    QUARTER(sa.sale_date) = 4
GROUP BY ci.city_name
ORDER BY total DESC;

-- FINDINGS-
-- Pune, Chennai, Bangalore have the highest total revenue generated from coffee sales in the last quarter(Q4) of 2023
----------------------------------------------------------------------------------------------------------------------

-- Q.3
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?

-- Method-1

SELECT 
    COUNT(sa.product_id) AS total_units_sold,
    pr.product_name
FROM sales sa
JOIN products pr
ON sa.product_id = pr.product_id
GROUP BY pr.product_name
ORDER BY 1 DESC


-- Method-2

SELECT 
    COUNT(sa.sale_id) AS total_orders,
    pr.product_name
FROM sales sa
JOIN products pr
ON sa.product_id = pr.product_id
GROUP BY pr.product_name
ORDER BY 1 DESC

-- FINDINGS-
-- Top 3 selling products were
-- Cold Brew Coffee Pack (6 Bottles)  -  1326
-- Ground Espresso Coffee (250g)  -  1271
-- Instant Coffee Powder (100g)  -  1226
-- And
-- Coffee Mug (Ceramic)  -  73 units sold, has the lowest sales
----------------------------------------------------------------------------------------------------------------------

-- Q.4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?

-- Method- 1


WITH temp_table_2 AS
(
SELECT
	ci.city_name,
    COUNT(DISTINCT(cu.customer_id)) AS customer_count_per_city,
    SUM(sa.total) AS total_per_city
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
GROUP BY ci.city_name
ORDER BY 3 DESC
)

SELECT 
	city_name,
    ROUND(total_per_city / customer_count_per_city, 2) AS average_sales_amount_per_customer
FROM temp_table_2
-- ORDER BY 2 DESC



-- Method - 2

SELECT 
	ci.city_name,
	SUM(sa.total) as total_revenue,
	COUNT(DISTINCT sa.customer_id) as total_customers,
	ROUND(
			SUM(sa.total)/
				COUNT(DISTINCT sa.customer_id)
			,2) as avg_sales_per_customer
	
FROM sales as sa
JOIN customers as cu
ON sa.customer_id = cu.customer_id
JOIN city as ci
ON ci.city_id = cu.city_id
GROUP BY 1
ORDER BY 2 DESC

-- FINDINGS -
-- Pune, Chennai, and Bangalore have the highest average sales per customer.
-- Whereas lucknow has lowest average sales per customer.


----------------------------------------------------------------------------------------------------------------------

-- -- Q.5
-- City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current cx, estimated coffee consumers (25%)

-- Method - 1

-- current population is not in million but 25 % estimated customer are in millions
-- unique_current_customer and coffee_customer_in_million separate

SELECT 
    ci.city_name,
    ROUND((ci.population * 0.25)/1000000, 2) AS estimated_coffee_consumer_in_million,
        COUNT(DISTINCT(cu.customer_id)) AS unique_current_customer
FROM city ci
JOIN customers cu ON ci.city_id = cu.city_id
GROUP BY ci.city_name, ci.population
ORDER BY 2 DESC

-- Method - 2

WITH temp_table_3 AS
(
SELECT 
    city_name,
    city_id,
	population * 0.25 AS estimated
FROM city

)

SELECT 
	te.city_name,
    ROUND((te.estimated)/1000000, 2) AS estimated_in_millions,
    COUNT(DISTINCT(cu.customer_id)) AS unique_cx
FROM temp_table_3 te
JOIN customers cu ON te.city_id = cu.city_id
GROUP BY te.city_name, te.estimated
ORDER BY 2 DESC

-- Method - 3

WITH city_table as 
(
	SELECT 
		city_name,
		ROUND((population * 0.25)/1000000, 2) as coffee_consumers
	FROM city
),
customers_table
AS
(
	SELECT 
		ci.city_name,
		COUNT(DISTINCT c.customer_id) as unique_current_cx
	FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
)
SELECT 
	customers_table.city_name,
	city_table.coffee_consumers as est_coffee_consumer_in_millions,
	customers_table.unique_current_cx
FROM city_table
JOIN 
customers_table
ON city_table.city_name = customers_table.city_name
ORDER BY 2 DESC

-- FINDINGS-
-- unique_cx -         coffee_customer_in_million-

-- Lowest---            --Lowest---
-- Hyderabad            Nagpur 
-- Lucknow              Kanpur
-- Indore               Indore

-- Highest---           --Highest---
-- Jaipur               Delhi
-- Delhi                Mumbai
-- Pune                 Kolkata

----------------------------------------------------------------------------------------------------------------------

-- -- Q6
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?

-- STEP 1-

SELECT 
	*
FROM
sales sa
JOIN products pr
ON sa.product_id = pr.product_id
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id

-- Step 2-

SELECT 
	sa.product_id,
    pr.product_name,
    ci.city_name
FROM
sales sa
JOIN products pr
ON sa.product_id = pr.product_id
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id

-- Setp 3-
SELECT 
	COUNT(sa.product_id) AS order_count,
    pr.product_name,
    ci.city_name
FROM
sales sa
JOIN products pr
ON sa.product_id = pr.product_id
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
GROUP BY 3, 2
ORDER BY 3, 1 DESC

-- Step 4-
-- now we rank count of product id that is order-count by desc which return rank of each product according to the vloume or orders in each city.

SELECT 
	COUNT(sa.product_id) AS order_count,
    pr.product_name,
    ci.city_name,
    DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(sa.product_id) DESC) AS rank_
FROM
sales sa
JOIN products pr
ON sa.product_id = pr.product_id
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
GROUP BY 3, 2
-- ORDER BY 3, 1 DESC

-- Step 5-
-- now we want top 3 products by volume or order in each city

WITH t_7 AS
(
SELECT 
	COUNT(sa.product_id) AS order_count,
    pr.product_name,
    ci.city_name,
    DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(sa.product_id) DESC) AS rank_
FROM
sales sa
JOIN products pr
ON sa.product_id = pr.product_id
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
GROUP BY 3, 2
-- ORDER BY 3, 1 DESC
)

SELECT * FROM t_7
WHERE rank_ <= 3


-- OR
-- other way to write same query

SELECT *
FROM
(
SELECT 
	COUNT(sa.product_id) AS order_count,
    pr.product_name,
    ci.city_name,
    DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(sa.product_id) DESC) AS rank_
FROM
sales sa
JOIN products pr
ON sa.product_id = pr.product_id
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
GROUP BY 3, 2
-- ORDER BY 3, 1 DESC
)
AS t_7
WHERE rank_ <= 3

----------------------------------------------------------------------------------------------------------------------

-- - Q.7
-- Customer Segmentation by City
-- How many unique customers are there in each city who have purchased coffee products?

-- coffee product means only items in the products table related to coffee.
-- that is till product_id 14

-- Method-1

-- STEP 1-

SELECT 
	DISTINCT(sa.customer_id),
    cu.customer_name,
    ci.city_name
 --    pr.product_name,
--     pr.product_id
FROM customers cu
JOIN city ci
ON ci.city_id = cu.city_id
JOIN sales sa
ON cu.customer_id = sa.customer_id
JOIN products pr
ON sa.product_id = pr.product_id
WHERE sa.product_id BETWEEN '1' AND '14'
ORDER BY 3

-- STEP 2-
-- here we analyse unique customers by product in each city who have purchased coffee products 

SELECT 
	COUNT(DISTINCT(sa.customer_id)) AS unique_cx_id_count,
    ci.city_name,
    pr.product_name
FROM customers cu
JOIN city ci
ON ci.city_id = cu.city_id
JOIN sales sa
ON cu.customer_id = sa.customer_id
JOIN products pr
ON sa.product_id = pr.product_id
WHERE sa.product_id BETWEEN '1' AND '14'
GROUP BY 2, 3

-- STEP 3-

SELECT 
	COUNT(DISTINCT(sa.customer_id)) AS unique_cx_id_count,
    ci.city_name
FROM customers cu
JOIN city ci
ON ci.city_id = cu.city_id
JOIN sales sa
ON cu.customer_id = sa.customer_id
JOIN products pr
ON sa.product_id = pr.product_id
WHERE sa.product_id BETWEEN '1' AND '14'
GROUP BY 2
ORDER BY 1 DESC


-- Method-2

SELECT 
	ci.city_name,
	COUNT(DISTINCT c.customer_id) as unique_cx
FROM city as ci
LEFT JOIN
customers as c
ON c.city_id = ci.city_id
JOIN sales as s
ON s.customer_id = c.customer_id
WHERE 
	s.product_id IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
GROUP BY 1

-- Findings-

-- Jaipur and Delhi have the highest number of unique current customers who have purchased coffee products
-- Whereas Hyderabad Indore Lucknow have lowest

----------------------------------------------------------------------------------------------------------------------

-- -- Q.8
-- Average Sale vs Rent
-- Find each city and their average sale per customer and avg rent per customer


-- we can not use directly avg function for total and group by city. 
-- we need sum of total(revenue), group by city and distinct customer and dividing sum total / distinct customer count to get avg sales for each city
-- and for avg rent per city, divide rent/distinct customer count and group by city
-- NOTE- here we are not doing sum of rent because rent is alredy given for per city

-- Method-1

-- here we get 5 column but if we do not need column estimated_rent there is problem of ONLY_FULL_GROUP_BY.
-- so for that we can use MAX that is MAX(ci.estimated_rent) insted while calculating avg_rent_pr_city as there is only one rent per city which is equal to max rent per city.  


SELECT 
	ci.city_name,
-- 	SUM(sa.total) as total_revenue,
	COUNT(DISTINCT sa.customer_id) as total_cx,
	ROUND(
			SUM(sa.total)/
				COUNT(DISTINCT sa.customer_id)
			,2) as avg_sale_pr_cx,
	ci.estimated_rent,
    ROUND(
			ci.estimated_rent/
				COUNT(DISTINCT sa.customer_id)
			,2) as avg_rent_pr_cx
FROM sales as sa
JOIN customers as cu
ON sa.customer_id = cu.customer_id
JOIN city as ci
ON ci.city_id = cu.city_id
GROUP BY 1, 4
ORDER BY 3 DESC


-- Method-2

WITH city_table
AS
(
	SELECT 
		ci.city_name,
		SUM(s.total) as total_revenue,
		COUNT(DISTINCT s.customer_id) as total_cx,
		ROUND(
				SUM(s.total)/
					COUNT(DISTINCT s.customer_id)
				,2) as avg_sale_pr_cx
		
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
	ORDER BY 2 DESC
),
city_rent
AS
(SELECT 
	city_name, 
	estimated_rent
FROM city
)
SELECT 
	cr.city_name,
	cr.estimated_rent,
	ct.total_cx,
	ct.avg_sale_pr_cx,
	ROUND(
		cr.estimated_rent/
									ct.total_cx
		, 2) as avg_rent_per_cx
FROM city_rent as cr
JOIN city_table as ct
ON cr.city_name = ct.city_name
ORDER BY 4 DESC

-- Findings-

-- Pune, Chennai, and Bangalore have highest average sales per customer.
-- Whereas lucknow has lowest average sales per customer.

-- Jaipur, Kanpur, Pune have the lowest average rent per customer among all cities
-- Mumbai, Hyderabad, Bangalore have the highest average rent per customer 
----------------------------------------------------------------------------------------------------------------------

-- Q.9
-- Monthly Sales Growth
-- Sales growth rate: Calculate the percentage growth (or decline) in sales over different time periods (monthly)
-- by each city

-- Method-1

-- Step - 1

-- quarter wise sales by city

SELECT 
	QUARTER(sa.sale_date) AS quarter_,
    SUM(sa.total) AS total_q_sales,
    ci.city_name
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
On ci.city_id = cu.city_id
GROUP BY 3, 1


-- monthly wise sales by city

SELECT 
	MONTH(sa.sale_date) AS month_,
    YEAR(sa.sale_date) AS year_,
    SUM(sa.total) AS total_q_sales,
    ci.city_name
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
On ci.city_id = cu.city_id
GROUP BY 4, 1, 2


-- Step - 2

-- monthly wise sales by city
-- more modification to get result

SELECT 
	MONTH(sa.sale_date) AS month_,
    YEAR(sa.sale_date) AS year_,
    SUM(sa.total) AS total_q_sales,
    ci.city_name
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
On ci.city_id = cu.city_id
GROUP BY 4, 1, 2
ORDER BY 4, 2, 1


-- STEP - 3

-- we will use window function LAG()

WITH monthly_sales AS
(
SELECT 
	ci.city_name,
	MONTH(sa.sale_date) AS month_,
    YEAR(sa.sale_date) AS year_,
    SUM(sa.total) AS total_sales
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
On ci.city_id = cu.city_id
GROUP BY 1, 2, 3
ORDER BY 1, 3, 2
),
growth_ratio AS
(
SELECT 
	*,
    LAG(total_sales,1) OVER(PARTITION BY city_name) AS last_month_sales-- ORDER BY year_, month_ (if we want we can do under OVER)
FROM monthly_sales
)

SELECT 
	*,
	(total_sales - last_month_sales)AS incr_desc_in_sales,
    ROUND(((total_sales - last_month_sales)/last_month_sales) * 100, 2) AS incr_desc_in_sales_percent
FROM growth_ratio
-- WHERE last_month_sales IS NOT NULL



-- Method-2

WITH
monthly_sales
AS
(
	SELECT 
		ci.city_name,
		EXTRACT(MONTH FROM sale_date) as month,
		EXTRACT(YEAR FROM sale_date) as YEAR,
		SUM(s.total) as total_sale
	FROM sales as s
	JOIN customers as c
	ON c.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1, 2, 3
	ORDER BY 1, 3, 2
),
growth_ratio
AS
(
		SELECT
			city_name,
			month,
			year,
			total_sale as cr_month_sale,
			LAG(total_sale, 1) OVER(PARTITION BY city_name ORDER BY year, month) as last_month_sale
		FROM monthly_sales
)

SELECT
	city_name,
	month,
	year,
	cr_month_sale,
	last_month_sale,
	ROUND(
		(cr_month_sale-last_month_sale)/last_month_sale * 100
		, 2
		) as growth_ratio

FROM growth_ratio
WHERE 
	last_month_sale IS NOT NULL	

    
-- FINDINGS -
    
WITH monthly_sales AS
(
SELECT 
	ci.city_name,
	MONTH(sa.sale_date) AS month_,
    YEAR(sa.sale_date) AS year_,
    SUM(sa.total) AS total_sales
FROM sales sa
JOIN customers cu
ON cu.customer_id = sa.customer_id
JOIN city ci
On ci.city_id = cu.city_id
GROUP BY 1, 2, 3
ORDER BY 1, 3, 2
),
growth_ratio AS
(
SELECT 
	*,
    LAG(total_sales,1) OVER(PARTITION BY city_name) AS last_month_sales-- ORDER BY year_, month_ (if we want we can do under OVER)
FROM monthly_sales
),
final_2 AS
(
SELECT 
	*,
	(total_sales - last_month_sales)AS incr_desc_in_sales,
    ROUND(((total_sales - last_month_sales)/last_month_sales) * 100, 2) AS incr_desc_in_sales_percent
FROM growth_ratio
WHERE last_month_sales IS NOT NULL
)

 SELECT 
  	SUM(incr_desc_in_sales),
      month_
  FROM final_2
  GROUP BY 2
  ORDER BY 1 DESC 

-- According to the monthly sales revenue  top 3 - september, oct, march
-- According to the monthly sales revenue  lowest - april, january

----------------------------------------------------------------------------------------------------------------------

-- Q.10
-- Market Potential Analysis
-- Identify top 3 city based on highest sales, return city name, total sale, total rent, total customers, estimated coffee consumer

-- Method-1

-- STEP 1- 

SELECT
	SUM(sa.total) revenue,
    ci.city_name
FROM sales sa
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
GROUP BY 2
ORDER BY 1 DESC
LIMIT 3


-- STEP 2

SELECT
	SUM(sa.total) revenue,
    ci.city_name,
    ci.estimated_rent,
    COUNT(DISTINCT(sa.customer_id)) AS total_customers,
	ci.population * 0.25 AS estimated_coffee_consumer
FROM sales sa
JOIN customers cu
ON sa.customer_id = cu.customer_id
JOIN city ci
ON ci.city_id = cu.city_id
GROUP BY 2, 3, 5
ORDER BY 1 DESC
LIMIT 3


-- Method-2

-- 2 additional columns - avgerage sales per customer and average rent per customer.
-- estimated coffee consumer are in millions

WITH city_table
AS
(
	SELECT 
		ci.city_name,
		SUM(s.total) as total_revenue,
		COUNT(DISTINCT s.customer_id) as total_cx,
		ROUND(
				SUM(s.total)/
					COUNT(DISTINCT s.customer_id)
				,2) as avg_sale_pr_cx
		
	FROM sales as s
	JOIN customers as c
	ON s.customer_id = c.customer_id
	JOIN city as ci
	ON ci.city_id = c.city_id
	GROUP BY 1
	ORDER BY 2 DESC
),
city_rent
AS
(
	SELECT 
		city_name, 
		estimated_rent,
		ROUND((population * 0.25)/1000000, 3) as estimated_coffee_consumer_in_millions
	FROM city
)
SELECT 
	cr.city_name,
	total_revenue,
	cr.estimated_rent as total_rent,
	ct.total_cx,
	estimated_coffee_consumer_in_millions,
	ct.avg_sale_pr_cx,
	ROUND(
		cr.estimated_rent/
									ct.total_cx
		, 2) as avg_rent_per_cx
FROM city_rent as cr
JOIN city_table as ct
ON cr.city_name = ct.city_name
ORDER BY 2 DESC

----------------------------------------------------------------------------------------------------------------------








