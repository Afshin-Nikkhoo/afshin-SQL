SELECT * 
FROM tested;

DESCRIBE titanic_copy;

SELECT COUNT(*) AS total_row
FROM tested;

CREATE TABLE titanic_copy
LIKE tested;

SELECT *
FROM titanic_copy;

INSERT titanic_copy
SELECT *
FROM tested;

SELECT *
FROM titanic_copy;

SELECT Pclass,Sex, Ticket, COUNT(*) as duplicate_records  # Best for finding duplicate groups
From titanic_copy
GROUP BY Pclass,Sex, Ticket  # to tell all three values are exactly the same.
HAVING COUNT(*) > 1;

SELECT *,                                                         # See the actual duplicate rows and Potentially delete duplicates later.
ROW_NUMBER () OVER(PARTITION BY Pclass,Sex, Ticket)AS row_num
FROM titanic_copy;

SELECT *
FROM titanic_copy
WHERE Ticket = 19950;

WITH duplicate_CTE AS   # creating a temporary result table form duplicate data
(SELECT *,
ROW_NUMBER () OVER(PARTITION BY Pclass,Sex, Ticket)AS row_num
FROM titanic_copy)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;


SELECT PassengerId, COUNT(*) AS duplicate_records
FROM titanic_copy
GROUP BY PassengerId
HAVING COUNT(*) > 1;  # I look for duplicates in Pclass,Sex, Ticket and found duplicates, however, PassengerIds were unique and there no duplicate data

SELECT PassengerId, Survived,Pclass,Name,Sex, Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked, COUNT(*) as duplicate_records  # Best for finding duplicate groups
From titanic_copy
GROUP BY PassengerId, Survived,Pclass,Name,Sex, Age,SibSp,Parch,Ticket,Fare,Cabin,Embarked # to tell all four values are exactly the same.
HAVING COUNT(*) > 1;


# ___________________________________________________________________________________________________________________________

-- 2. Standerdize the data

SELECT *
FROM titanic_copy;

SELECT Name, TRIM(Name)
FROM titanic_copy;

UPDATE titanic_copy
SET Name = TRIM(Name);

SELECT DISTINCT Ticket # this is done just to single out the specific column to look for issues.
FROM titanic_copy
ORDER BY 1;
# _____________________________________________________________________________________________________

-- Dealing with Null and blank values

SELECT *  # Identify null data
FROM titanic_copy
WHERE Fare IS NULL;

#################  Exploratory Data Analyses  #############

SELECT *
FROM titanic_copy;

SELECT MAX(Age)
FROM titanic_copy;

SELECT MAX(SibSp)
FROM titanic_copy;

#####################################################################################################################################################

# 1. Basic data overview

## First understand the size and structure of your data.
SELECT COUNT(*) AS total_rows # It count number of rows
FROM titanic_copy;

## Check the columns and data types
DESC titanic_copy; 

## Check whether PassengerId is unique
SELECT PassengerId, COUNT(*) AS count 
FROM titanic_copy
GROUP BY PassengerId
HAVING COUNT(*) > 1; # look for rows that are higher than 1 

#____________________________________________________________________

# 2. Check missing values

# how complete the Titanic dataset is
SELECT    # if the number of row for Age,... are equal to number of 
    COUNT(*) AS total_rows,
    COUNT(Age) AS age_not_null,
    COUNT(Cabin) AS cabin_not_null,
    COUNT(Embarked) AS embarked_not_null
FROM titanic_copy;


# calculate how many are missing
SELECT
    COUNT(*) - COUNT(Age) AS missing_age,
    COUNT(*) - COUNT(Cabin) AS missing_cabin,
    COUNT(*) - COUNT(Embarked) AS missing_embarked
FROM titanic_copy;
#_________________________________________________________________

# Univariate analysis --> examining one variable at a time

# Calculate survival percentages
SELECT Survived, COUNT(*) AS passengers
FROM titanic_copy
GROUP BY Survived;

SELECT Survived, COUNT(*) AS passengers,
ROUND((COUNT(*)*100)/ (SELECT COUNT(*) FROM titanic_copy),2) AS Percentage
FROM titanic_copy
GROUP BY Survived;

SELECT
    Survived,
    COUNT(*) AS passengers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM titanic_copy), 2) AS percentage 
FROM titanic_copy
GROUP BY Survived;

SELECT Sex, COUNT(*) AS Gender
FROM titanic_copy
GROUP BY Sex;

SELECT Sex, COUNT(*) AS Gender, ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM titanic_copy), 2) AS percentage
FROM titanic_copy
GROUP BY Sex;


SELECT Pclass, COUNT(*) AS passengers
FROM titanic_copy
GROUP BY Pclass
ORDER BY Pclass;


SELECT Pclass, COUNT(*) AS passengers, ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM titanic_copy), 2) AS percentage
FROM titanic_copy
GROUP BY Pclass
ORDER BY Pclass;

SELECT Pclass, COUNT(*) AS passengers, ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM titanic_copy), 2) AS percentage
FROM titanic_copy
GROUP BY Pclass
ORDER BY Pclass;


SELECT Embarked, COUNT(*) AS passengers
FROM titanic_copy
GROUP BY Embarked;


SELECT Age, COUNT(*)
FROM titanic_copy
GROUP BY Age;

SELECT MAX(Age) AS max_age, MIN(Age) AS Min_age, AVG(Age) 
FROM titanic_copy;

SELECT 
	CASE # creates age categories
		WHEN Age < 18 THEN 'Child'
        WHEN Age < 30 THEN '18-29'
        WHEN Age < 50 THEN '30-49' 
		ELSE '50+'
	END AS age_group,
    COUNT(*) AS passengers
FROM titanic_copy
WHERE Age IS NOT NULL
GROUP BY age_group;

#__________________________________________________________________

# 4. Bivariate analysis  ----->  How does one variable relate to another?

# Survival by sex
SELECT Survived, Sex
FROM titanic_copy;

SELECT Survived, Sex, COUNT(*) AS passengers
FROM titanic_copy
group BY Survived, Sex;

SELECT
    Sex,
    Survived,
    COUNT(*) AS passengers
FROM titanic_copy
GROUP BY Sex, Survived
ORDER BY Sex, Survived;

SELECT
    Sex,
    COUNT(*) AS passengers,
    SUM(Survived) AS survivors,
    ROUND(AVG(Survived) * 100, 2) AS survival_rate
FROM titanic_copy
GROUP BY Sex;
