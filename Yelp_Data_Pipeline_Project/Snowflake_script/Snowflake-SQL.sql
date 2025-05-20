#ALL SNOWFLAKE SQL SCRIPTS
--------------------------------------------------------------------
--------------------------------------------------------------------
# Creating table for reviews and drawing data from S3 bucket

DROP TABLE IF EXISTS yelp_reviews

CREATE or REPLACE table yelp_reviews (review_text variant)

COPY INTO yelp_reviews

FROM 's3://' #S3 Bucket name
CREDENTIALS = (
    AWS_KEY_ID = ''
    AWS_SECRET_KEY = ''
)

FILE_FORMAT = (TYPE = JSON);

--------------------------------------------------------------------
# Creating table for businesses and drawing data from S3 bucket

DROP TABLE IF EXISTS yelp_businesses

CREATE or REPLACE table yelp_businesses (business_text variant)

COPY INTO yelp_businesses

FROM 's3://' #S3 Bucket name
CREDENTIALS = (
    AWS_KEY_ID = ''
    AWS_SECRET_KEY = ''
)

FILE_FORMAT = (TYPE = JSON);

--------------------------------------------------------------------
# Creating a SQL function for sentiment analysis using python lib (textblob)

CREATE OR REPLACE FUNCTION analyze_sentiment (text STRING)
RETURNS STRING

LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
PACKAGES = ('textblob')
HANDLER = 'sentiment_analyzer'
AS $$
from textblob import TextBlob
def sentiment_analyzer(text):
    if text is None or text.strip() == '':
        return 'Neutral'
    analysis = TextBlob(text)
    if analysis.sentiment.polarity > 0:
        return 'Positive'
    elif analysis.sentiment.polarity == 0:
        return 'Neutral'
    else:
        return 'Negative'
$$;

--------------------------------------------------------------------
# Creating a table format of the businesses-json

CREATE OR REPLACE TABLE yelp_businesses_table AS
SELECT business_text:business_id :: STRING as business_id, 
    business_text:name :: STRING as name,
    business_text:city :: STRING as city,
    business_text:state :: STRING as state,
    business_text:review_count :: NUMBER as no_of_reviews,
    business_text:stars :: NUMBER as stars,
    business_text:categories :: STRING as categories
FROM yelp_businesses

--------------------------------------------------------------------
# Creating a table format of the reviews-json

CREATE OR REPLACE TABLE yelp_reviews_table AS
SELECT review_text:business_id :: STRING as business_id, 
    review_text:date :: DATE as review_date,
    review_text:stars :: NUMBER as rating,
    review_text:user_id :: STRING as user_id,
    review_text:text :: STRING as review,
    analyze_sentiment(review) as sentiments,
FROM yelp_reviews

--------------------------------------------------------------------
--------------------------------------------------------------------
#ANSWERING QUESTIONS (ANALYSIS)

--To have a look at both tables

SELECT * FROM yelp_reviews_table LIMIT 10;
SELECT * FROM yelp_businesses_table LIMIT 10;

-- 10 Questions
--------------------------------------------------------------------
--1- Find the number of businesses in each category

WITH cte as
(
    SELECT business_id, TRIM(A.value) as category
    FROM yelp_businesses_table
    , lateral split_to_table(categories,',') A

)
SELECT category, COUNT(*) as no_of_businesses
FROM cte
GROUP BY 1
ORDER BY 2 DESC

--------------------------------------------------------------------
--2- Find the TOP 10 users who have reviewed the most businesses in the 'RESTAURANT' category

SELECT r.user_id,COUNT( DISTINCT r.business_id) as no_of_businesses_reviews
FROM yelp_reviews_table r
INNER JOIN yelp_businesses_table b 
ON r.business_id = b.business_id
WHERE b.categories IS NOT NULL AND r.user_id IS NOT NULL AND b.categories ilike '%restaurant%'
GROUP BY r.user_id
ORDER BY 2 DESC
LIMIT 10;

--------------------------------------------------------------------
--3- Find the most popular categories of businesses (based on no.of reviews)

WITH cte as
(
    SELECT business_id, TRIM(A.value) as category
    FROM yelp_businesses_table
    , lateral split_to_table(categories,',') A

)
SELECT category, COUNT(*) as no_of_reviews
FROM cte 
INNER JOIN yelp_reviews_table r 
ON cte.business_id = r.business_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--------------------------------------------------------------------
--4- Find TOP 3 recent reviews for each business

WITH cte as
(
    SELECT r.*, b.name,
        ROW_NUMBER () OVER( partition by r.business_id ORDER BY r.review_date DESC) as rn
    FROM yelp_reviews_table r
    INNER JOIN yelp_businesses_table b 
    ON r.business_id = b.business_id
    WHERE b.categories IS NOT NULL AND r.user_id IS NOT NULL
)

SELECT name, user_id, review_date, review, sentiments 
FROM cte
WHERE rn < 4;

--------------------------------------------------------------------
--5- Find the month with highest number of reviews

SELECT MONTH(review_date) as review_month, COUNT(*) as no_of_reviews
FROM yelp_reviews_table
GROUP BY 1
ORDER BY 2 DESC;

--------------------------------------------------------------------
--6- Find % of 5-Star reviews for each business

--MY METHOD
WITH cte as
(
    SELECT business_id, COUNT(*) as no_of_5star_reviews
    FROM yelp_reviews_table
    WHERE rating = 5
    GROUP BY 1
),
cte2 as
(
    SELECT business_id, COUNT(*) as no_of_reviews
    FROM yelp_reviews_table
    GROUP BY 1
)

SELECT cte.business_id, b.name, ROUND((1.0*((cte.no_of_5star_reviews/cte2.no_of_reviews)*100)),2) as percentage_of_5star_reviews
FROM cte
INNER JOIN cte2
ON cte.business_id = cte2.business_id
INNER JOIN yelp_businesses_table b
ON cte.business_id = b.business_id
ORDER BY 3 DESC;

--ANKIT METHOD
WITH cte as
(
    SELECT b.business_id, b.name, COUNT(*) as total_reviews,
    COUNT( CASE WHEN r.rating = 5 THEN 1 ELSE NULL END) as no_of_5star_reviews
    --SUM( CASE WHEN r.rating = 5 THEN 1 ELSE 0) as 5star_reviews
    FROM yelp_reviews_table r
    INNER JOIN yelp_businesses_table b 
    ON r.business_id = b.business_id
    GROUP BY 1,2
)

SELECT business_id, name, ROUND((1.0*((no_of_5star_reviews/total_reviews)*100)),2) as percentage_of_5star_reviews
FROM cte;

--------------------------------------------------------------------
--7- Find TOP 5 most reviewed business in each city

WITH cte as
(
    SELECT b.city, b.business_id, b.name, COUNT(*) as total_reviews
    FROM yelp_reviews_table r
    INNER JOIN yelp_businesses_table b 
    ON r.business_id = b.business_id
    GROUP BY 1,2,3
)

SELECT *    
FROM cte
QUALIFY ROW_NUMBER() OVER(partition BY city ORDER BY total_reviews DESC) <= 5;

--------------------------------------------------------------------
--8- Find the average ratings of businesses that have atleast 100 reviews

SELECT b.business_id, b.name, ROUND(AVG(r.rating),2) as average_rating,
    COUNT(*) as total_reviews
FROM yelp_reviews_table r
INNER JOIN yelp_businesses_table b 
ON r.business_id = b.business_id
GROUP BY 1,2
HAVING COUNT(*) >= 100;

--------------------------------------------------------------------
--9- List the TOP 10 users who have written the most reviews, along with the businesses they reviewed...

WITH users as
(
    SELECT r.user_id, COUNT(*) as total_reviews
    FROM yelp_reviews_table r
    INNER JOIN yelp_businesses_table b 
    ON r.business_id = b.business_id
    WHERE r.user_id IS NOT NULL
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
)

SELECT user_id, business_id
FROM yelp_reviews_table
WHERE user_id IN (SELECT user_id FROM users)
GROUP BY 1,2
ORDER BY user_id

--------------------------------------------------------------------
--10- Find TOP 10 businesses with most positive sentiments

SELECT r.business_id, b.name, COUNT(*) as total_reviews
FROM yelp_reviews_table r
INNER JOIN yelp_businesses_table b 
ON r.business_id = b.business_id
WHERE r.sentiments = 'Positive'
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 10;

--------------------------------------------------------------------
--------------------------------------------------------------------
