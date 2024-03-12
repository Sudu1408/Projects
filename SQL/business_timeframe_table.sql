DROP TABLE IF EXISTS business_timeframe;

with today AS
(
SELECT *
FROM calendar_dimension
WHERE calendar_date = CAST(GETDATE() as DATE)
),
cal AS
(
SELECT 
c.*, 
t.calendar_year as current_year,
t.calendar_quarter as current_quarter,
t.calendar_year_day as current_year_day,
t.calendar_month as current_month
FROM calendar_dimension c
CROSS JOIN today t
WHERE c.calendar_year BETWEEN t.calendar_year-2 AND t.calendar_year
),
timeframe AS

(
--Full Year
SELECT
'Full_Year' AS timeframe,
'FY' AS timeframe_id,
MIN(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_start_date,
MAX(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_end_date,
MIN(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_start_date,
MAX(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_end_date,
MIN(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_start_date,
MAX(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_end_date
FROM cal

--Year To Date
UNION ALL
SELECT
'Year To Date' AS timeframe,
'YTD' AS timeframe_id,
MIN(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_start_date,
MAX(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_end_date,
MIN(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_start_date,
MAX(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_end_date,
MIN(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_start_date,
MAX(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_end_date
FROM cal
WHERE ((calendar_year BETWEEN current_year-2 AND current_year) AND calendar_year_day <= current_year_day)

--Quarter To Date
UNION ALL
SELECT
'Quarter To Date' AS timeframe,
'QTD' AS timeframe_id,
MIN(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_start_date,
MAX(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_end_date,
MIN(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_start_date,
MAX(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_end_date,
MIN(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_start_date,
MAX(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_end_date
FROM cal
WHERE calendar_quarter = current_quarter AND calendar_year_day <= current_year_day

--Month To Date
UNION ALL
SELECT
'Month To Date' AS timeframe,
'MTD' AS timeframe_id,
MIN(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_start_date,
MAX(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_end_date,
MIN(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_start_date,
MAX(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_end_date,
MIN(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_start_date,
MAX(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_end_date
FROM cal
WHERE calendar_month = current_month AND calendar_year_day <= current_year_day

-- Quarters
UNION ALL
SELECT
'Quarter' AS timeframe,
CAST(calendar_quarter as VARCHAR(1)) AS timeframe_id,
MIN(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_start_date,
MAX(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_end_date,
MIN(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_start_date,
MAX(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_end_date,
MIN(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_start_date,
MAX(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_end_date
FROM cal
GROUP BY calendar_quarter

-- Months
UNION ALL
SELECT
'Month' AS timeframe,
CAST(calendar_month as VARCHAR(2)) AS timeframe_id,
MIN(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_start_date,
MAX(CASE WHEN calendar_year = current_year THEN calendar_date END) as current_year_end_date,
MIN(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_start_date,
MAX(CASE WHEN calendar_year = current_year-1 THEN calendar_date END) as previous_year_end_date,
MIN(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_start_date,
MAX(CASE WHEN calendar_year = current_year-2 THEN calendar_date END) as year_before_lastyear_end_date
FROM cal
GROUP BY calendar_month
)

SELECT * INTO business_timeframe
FROM timeframe