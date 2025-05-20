Hi
My name is Sudarsan Haridas.
I have compiled all tools and languages I have learnt and worked on in this repository.

--------------------------------------------------------------------------------------------------------------------------------------------------------

## --Food Delivery Insights (SQL)

A mini-project focused on deriving business-critical insights from a mock food delivery platform dataset using advanced SQL techniques.

### Objective

To extract actionable insights from transactional order data that help drive decisions in marketing strategy, customer retention, and operational planning.

### Core Analyses Performed

1. Top Restaurants by Cuisine
   Utilized ROW\_NUMBER() to rank restaurants within each cuisine based on order count, without using LIMIT or TOP.
   -> Helps highlight top-performing outlets per cuisine for partnership or promotion.

2. Daily New Customer Trends
   Tracked new user acquisition by computing first order dates and aggregating daily activity.
   -> Useful for understanding customer growth trajectory.

3. Churned Users (January 2025)
   Identified users who placed only one order in January 2025 and did not return.
   -> Aids in flagging potential churners for win-back campaigns.

4. Inactivity After First Promo Order
   Detected users whose first (promo-driven) order was followed by 7 or more days of inactivity.
   -> Ideal targets for re-engagement messaging.

### Techniques and Features

* SQL Concepts: Common Table Expressions (CTEs), Window Functions (ROW\_NUMBER), Subqueries, Date Aggregations, Anti-Joins
* Query Optimization: Replaced NOT IN logic with LEFT JOIN WHERE NULL for performance
* Tools Used: SQL-compatible RDBMS

### Mock Dataset Details

* Simulated table: orders
* Fields include: order\_id, customer\_code, placed\_at, restaurant\_id, cuisine, order\_status, promo\_code\_name
* Covers a mix of cuisines, restaurants, customer activity, and promo usage (e.g., NEWUSER, HUNGRY20)
* Order activity is concentrated in January 2025

### Key Business Insights Extracted

* Ranked restaurants by cuisine performance
* Analyzed user acquisition and churn patterns
* Measured promo effectiveness and long-term engagement

### Why This Project?

This project simulates real-world SQL analytics scenarios and is great for demonstrating proficiency in:

* Writing complex SQL queries
* Drawing data-driven insights for business decisions
* Working with customer and order-level transactional data

--------------------------------------------------------------------------------------------------------------------------------------------------------

--BI-Tools
----------

----A short KNIME tutorial pdf made while I used KNIME for the first time.

----TERM PROJECT
------*Power BI and Tableau* project in detail.

--------------------------------------------------------------------------------------------------------------------------------------------------------

--DBMS
------

----Clinical Patient Visit Data Management System - Using fake data, modelled and implemented in *MongoDB*
------ Showcases my data modelling, requirements gathering, relational DB modelling, etc,.

--------------------------------------------------------------------------------------------------------------------------------------------------------


--Machine Learning (Python)
---------------------------

--Python Libraries used : Sci-Kit learn, Pandas, Numpy, Matplotlib, Seaborn, TensorFlow, Keras, etc,.

----Project01 *(Regression)*
------Utilized various regression algorithms.

----Project02 *(Classification)*
------Utilized various classification algorithms.

----Lab01 - Lab05 *(Python Proficiency practice)*
------Showcases various levels of python proficiency.

--------------------------------------------------------------------------------------------------------------------------------------------------------

--R Programming (Machine Learning)
----------------------------------

--Term Project
----Utilized R packages to predict and analyse salaries for Data related jobs from 2017-2020

--------------------------------------------------------------------------------------------------------------------------------------------------------

--SQL
-----

--Utilize DDL, DCL, DML, DQL and TCL commands.

--Create and Insert
----DDL commands.

--Views, Functions and Procedures
----Creating Views, Stored Procedures and Functions.

--AdvancedSQL_HackerRank_HARD
----Solving a level : HARD, Advanced SQL problem in Hacker Rank.

--------------------------------------------------------------------------------------------------------------------------------------------------------

Thank you for your time.
