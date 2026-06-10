/*
==========================================================
Project: Finance Investment Analysis
Database: finance
Tool: SQL Server Management Studio

Objective:
Analyse investor behaviour and investment preferences
using SQL Server.

Author: Shahper Ali Khan

==========================================================
*/

/*
==========================================================
DATABASE CREATION
==========================================================
*/

create database finance;
use finance;

/*
==========================================================
TABLE CREATION
==========================================================
*/

CREATE TABLE investordata(
    gender VARCHAR(20),
    age INT,
    Investment_Avenues VARCHAR(20),
    Mutual_Funds INT,
    Equity_Market INT,
    Debentures INT,
    Government_Bonds INT,
    Fixed_Deposits INT,
    PPF INT,
    Gold INT,
    Stock_Marktet INT,
    Factor VARCHAR(50),
    Objective VARCHAR(50),
    Purpose VARCHAR(100),
    Duration VARCHAR(50),
    Invest_Monitor VARCHAR(50),
    Expect VARCHAR(50),
    Avenue VARCHAR(50),
    saving_objective VARCHAR(100),
    Reason_Equity VARCHAR(100),
    Reason_Mutual VARCHAR(100),
    Reason_Bonds VARCHAR(100),
    Reason_FD VARCHAR(100),
    Source VARCHAR(100)
);
/*
==========================================================
DATA EXPLORATION
==========================================================
*/

/* validating the data quality and schema before performing any analysis

========================================================================*/
select * from investordata;
select top 5 * from investordata;
select distinct Objective from investordata;


/*
==========================================================
BASIC ANALYSIS
==========================================================
*/

----------------------------------------------------------
-- Question 1: Count total records in the dataset
----------------------------------------------------------

SELECT COUNT(*) AS Total_Records
FROM investordata;

----------------------------------------------------------
-- Question 2: Find distinct investment avenues
----------------------------------------------------------

SELECT DISTINCT Avenue
FROM investordata;

----------------------------------------------------------
-- Question 3: Calculate average age by gender
----------------------------------------------------------

SELECT
    gender,
    AVG(age) AS Average_Age
FROM investordata
GROUP BY gender;


----------------------------------------------------------
-- Question 4: Count number of investors for each avenue
----------------------------------------------------------

SELECT
    Avenue,
    COUNT(*) AS Total_Investors
FROM investordata
GROUP BY Avenue;

----------------------------------------------------------
-- Question 5: Find the most preferred investment option
----------------------------------------------------------

SELECT TOP 1 Avenue,COUNT(*) AS Total
From investordata 
group by Avenue Order BY Total Desc;

----------------------------------------------------------
-- Question 6: Retrieve records where age is less than 30
----------------------------------------------------------

Select * From Investordata 
Where age<30;

----------------------------------------------------------
-- Question 7: Count investors whose objective is Safety
----------------------------------------------------------
Select Count(*) As Safety_Investors
from Investordata Where
Objective='Safety';

----------------------------------------------------------
-- Question 8: Display top 5 most common savings objectives
----------------------------------------------------------
Select TOP 5 Savings_objectives,
Count(*) As Total From Investordata
Group by Savings_objectives
order by Total Desc;

----------------------------------------------------------
-- Question 9: Find number of investors choosing Fixed Deposits
----------------------------------------------------------
Select COUNT(*) AS Fixed_Deposit_Investors
From investordata 
Where Avenue='Fixed Deposits';

----------------------------------------------------------
-- Question 10: Group investors by source of information
----------------------------------------------------------
Select Source,Count(*) As Total From Investordata 
group by Source ;

SELECT TOP 1 *
FROM investordata;


/*
==========================================================
INTERMEDIATE ANALYSIS
==========================================================
*/

----------------------------------------------------------
-- Q1. Group investors by age range and investment avenue
----------------------------------------------------------

SELECT 
CASE
WHEN age< 30 THEN 'Below 30'
ELSE '30 and Above'
END AS Age_Group,
Avenue,Count(*) AS Total_Investors
FROM investordata
GROUP BY 
CASE 
WHEN AGE<30 THEN 'Below 30'
ELSE '30 and Above'
END,
Avenue;

----------------------------------------------------------
-- Q2. Calculate percentage contribution of each avenue
----------------------------------------------------------

SELECT Avenue,
COUNT(*) * 100.0/(SELECT COUNT(*) FROM investordata) as Percentage
FROM investordata
Group by Avenue;

----------------------------------------------------------
-- Q3. Compare average age for Equity vs Fixed Deposit investors
----------------------------------------------------------

Select Avenue,AVG(age) as Average_age
From investordata
Where Avenue='Equity' 
OR Avenue='Fixed Deposit'
GROUP BY Avenue;

----------------------------------------------------------
-- Q4. Identify dominant factor influencing investment
----------------------------------------------------------

SELECT TOP 1
Factor,count(*) as Total
from investordata
group by Factor
Order by Total Desc;

----------------------------------------------------------
-- Q5. Analyse purpose vs duration
----------------------------------------------------------
Select Purpose, Duration,
COUNT (*) As Total
From Investordata
Group by Purpose, Duration;

----------------------------------------------------------
-- Q6. Rank investment avenues by popularity
----------------------------------------------------------
SELECT
Avenue,
COUNT(*) AS Total
FROM investordata
GROUP BY Avenue
ORDER BY Total DESC;

----------------------------------------------------------
-- Q7. Count investors monitoring frequently
----------------------------------------------------------

SELECT
Invest_Monitor,
COUNT(*) AS Total
FROM investordata
GROUP BY Invest_Monitor;

----------------------------------------------------------
-- Q8. Correlation between objective and avenue
----------------------------------------------------------

SELECT
Objective,
Avenue,
COUNT(*) AS Total
FROM investordata
GROUP BY Objective,Avenue;


----------------------------------------------------------
-- Q9. Top reason for Mutual Fund investment
----------------------------------------------------------

SELECT TOP 1
Reason_Mutual,
COUNT(*) AS Total
FROM investordata
GROUP BY Reason_Mutual
ORDER BY Total DESC;


----------------------------------------------------------
-- Q10. Create a view for long-term investors
----------------------------------------------------------
CREATE VIEW Long_Term_Investors AS

Select *
From investordata
WHERE Duration = 'More than 5 Years';

Select * from Long_Term_Investors;


/*
==========================================================
ADVANCED ANALYSIS
==========================================================
*/

----------------------------------------------------------
-- Q1. Create CTE for investor segmentation
----------------------------------------------------------

WITH Investor_Segment AS
(
SELECT
gender,
age,
Avenue,
CASE
WHEN age < 30 THEN 'Young'
ELSE 'Experienced'
END AS Investor_Type
FROM investordata
)

SELECT *
FROM Investor_Segment;

----------------------------------------------------------
-- Q2. Rank investment factors
----------------------------------------------------------

SELECT
Factor,
COUNT(*) AS Total,
RANK() OVER(ORDER BY COUNT(*) DESC) AS Ranking
FROM investordata
GROUP BY Factor;

----------------------------------------------------------
-- Q3. Hidden trends using Window Function
----------------------------------------------------------

SELECT
Avenue,
COUNT(*) AS Total,
SUM(COUNT(*)) OVER() AS Overall_Total
FROM investordata
GROUP BY Avenue;

----------------------------------------------------------
-- Q4. Build reporting view
----------------------------------------------------------

CREATE VIEW Investment_Report AS

SELECT
Avenue,
COUNT(*) AS Total_Investors,
AVG(age) AS Average_Age

FROM investordata

GROUP BY Avenue;

Select * from Investment_Report;

----------------------------------------------------------
-- Q5. Detect inconsistencies
----------------------------------------------------------

SELECT *
FROM investordata

WHERE Objective='Safety'

AND Avenue='Equity';

---------------------------------

----------------------------------------------------------
-- Q5. Relationship between investment objective and avenue
----------------------------------------------------------

SELECT
Objective,
Avenue,
COUNT(*) AS Total_Investors
FROM investordata
GROUP BY Objective, Avenue
ORDER BY Objective;

----------------------------------------------------------
-- Q6. Cohort analysis based on age
----------------------------------------------------------

SELECT

CASE

WHEN age <30 THEN 'Below 30'

ELSE '30 and Above'

END AS Age_Group,

COUNT(*) AS Total

FROM investordata

GROUP BY

CASE

WHEN age <30 THEN 'Below 30'

ELSE '30 and Above'

END;