#Food Delivery Data  Insights
--------------------------------------------------------------------
--------------------------------------------------------------------
# QUESTIONS
--------------------------------------------------------------------
--1- Find TOP n outlets by cuisine type without using LIMIT or TOP functions

WITH cte AS(
    SELECT Cuisine, Restaurant_id, COUNT(*) as no_of_orders
    FROM orders
    GROUP BY Cuisine, Restaurant_id
)

SELECT Cuisine, Restaurant_id FROM (
    SELECT *,
        ROW_NUMBER()  OVER(PARTITION BY Cuisine ORDER BY no_of_orders DESC) as RN
    FROM cte) a 
WHERE RN = 1;

--------------------------------------------------------------------
--2- Find daily new customer count from launch date

With cte1 AS (
    SELECT Customer_code, CAST(MIN(Placed_at) AS DATE) as first_order_date
    FROM orders
    GROUP BY Customer_code
),
cte2 AS (
    SELECT DISTINCT(CAST(Placed_at AS DATE)) as all_dates
    FROM orders
)
#write a date creator script to get all dates between two dates
#here, all the dates in the original data is considered

SELECT cte2.all_dates as Dates, COUNT(Customer_code) as no_of_new_customers
FROM cte2
LEFT JOIN cte1 ON cte2.all_dates = cte1.first_order_date
GROUP BY cte2.all_dates
ORDER BY Dates;

--------------------------------------------------------------------
--3- Count of users acquired in January 2025 and placed (only 1) order (Jan) 
--and no other order EVER (HELPS marketing find app Deserters)

--ANKIT SOLUTION
SELECT Customer_code, COUNT(*) as no_of_orders
FROM orders
WHERE MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025 AND 
    Customer_code NOT IN (
        SELECT DISTINCT Customer_code
        FROM orders
        WHERE NOT(MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025))
GROUP BY Customer_code
HAVING COUNT(*) = 1

--CHAT GPT OPTIMIZED SOLUTION (JOIN is faster than NOT IN)
WITH jan_2025_customers AS (
    -- Find customers who placed orders in January 2025
    SELECT Customer_code
    FROM orders
    WHERE YEAR(Placed_at) = 2025 AND MONTH(Placed_at) = 1
    GROUP BY Customer_code
    HAVING COUNT(*) = 1
),
all_orders AS (
    -- Find customers who have placed orders in any other month
    SELECT DISTINCT Customer_code
    FROM orders
    WHERE NOT (YEAR(Placed_at) = 2025 AND MONTH(Placed_at) = 1)
)
-- Select customers who ordered in Jan 2025 but NEVER in any other month
SELECT *
FROM jan_2025_customers j
LEFT JOIN all_orders a ON j.Customer_code = a.Customer_code
WHERE a.Customer_code IS NULL;

--------------------------------------------------------------------
--4- List all customers with no orders in last 7 days but were acquired one month
--ago with their first order on promo

WITH cte as (
    SELECT Customer_code, MIN(Placed_at) as first_order_date, MAX(Placed_at) as latest_order_date
    FROM orders
    GROUP BY Customer_code
)

SELECT cte.*, orders.Promo_code_Name
FROM cte
INNER JOIN orders
ON cte.Customer_code = orders.Customer_code AND cte.first_order_date = orders.Placed_at
WHERE latest_order_date < DATEADD(DAY, -7, '2025-03-31')
    AND first_order_date < DATEADD(MONTH, -1, '2025-03-31') 
    AND Promo_code_Name IS NOT NULL
--USE getdate() to get current date

--------------------------------------------------------------------
--5- Growth team is planning to create a trigger that will target customers 
--after their every third order with a personalized communication 
#(Assuming the query is run everyday)

WITH cte as (
    SELECT *,
        ROW_NUMBER() OVER( PARTITION BY Customer_code ORDER BY Placed_at) AS order_number
    FROM orders
)

SELECT *
FROM cte
WHERE order_number % 3 = 0 AND CAST(Placed_at AS DATE) = CAST(GETDATE() AS DATE)

--------------------------------------------------------------------
--6- List customers who placed more than 1 order and all their orders on Promo

SELECT Customer_code, COUNT(*) as no_of_orders, COUNT(Promo_code_Name) as no_of_discounted_orders
FROM orders
GROUP BY Customer_code
HAVING COUNT(*) > 1 
    AND COUNT(*) = COUNT(Promo_code_Name);


--------------------------------------------------------------------
--7- Percent of Customers ordered without promo in Jan 2025

WITH cte as (
    SELECT *,
        ROW_NUMBER() OVER( PARTITION BY Customer_code ORDER BY Placed_at) as rn
    FROM orders
    WHERE MONTH(Placed_at) = 1 AND YEAR(Placed_at) = 2025
)

SELECT ROUND((COUNT( CASE WHEN rn = 1 AND Promo_code_Name IS NULL THEN Customer_code END)*100.0/ COUNT(DISTINCT Customer_code)),2) as percentage_of_new_customers
FROM cte

--------------------------------------------------------------------
--------------------------------------------------------------------
