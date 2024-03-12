DROP TABLE IF EXISTS calendar_dimension;

With cte as
(
SELECT
CAST('2000-01-01' as DATE) as calendar_date,
DATEPART(YEAR, '2000-01-01') as calendar_year,
DATEPART(DAYOFYEAR, '2000-01-01') as calendar_year_day,
DATEPART(QUARTER, '2000-01-01') as calendar_quarter,
DATEPART(MONTH, '2000-01-01') as calendar_month,
DATENAME(MONTH, '2000-01-01') as calendar_month_name,
DATEPART(DAY, '2000-01-01') as calendar_month_day,
DATEPART(WEEK, '2000-01-01') as calendar_week,
DATEPART(WEEKDAY, '2000-01-01') as calendar_week_day,
DATENAME(WEEKDAY, '2000-01-01') as calendar_day_name
UNION ALL
SELECT
DATEADD(DAY,1,calendar_date) as calendar_date,
DATEPART(YEAR, DATEADD(DAY,1,calendar_date)) as calendar_year,
DATEPART(DAYOFYEAR, DATEADD(DAY,1,calendar_date)) as calendar_year_day,
DATEPART(QUARTER, DATEADD(DAY,1,calendar_date)) as calendar_quarter,
DATEPART(MONTH, DATEADD(DAY,1,calendar_date)) as calendar_month,
DATENAME(MONTH, DATEADD(DAY,1,calendar_date)) as calendar_month_name,
DATEPART(DAY, DATEADD(DAY,1,calendar_date)) as calendar_month_day,
DATEPART(WEEK, DATEADD(DAY,1,calendar_date)) as calendar_week,
DATEPART(WEEKDAY, DATEADD(DAY,1,calendar_date)) as calendar_week_day,
DATENAME(WEEKDAY, DATEADD(DAY,1,calendar_date)) as calendar_day_name
FROM cte
WHERE calendar_date < CAST('2050-12-31' as DATE)
)

SELECT 
ROW_NUMBER() OVER(ORDER BY calendar_date ASC) as id 
,* INTO calendar_dimension
FROM cte 
OPTION(MAXRECURSION 32676)