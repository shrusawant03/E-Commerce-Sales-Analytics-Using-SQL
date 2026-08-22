USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   PHASE 2 - DATA QUALITY
   STEP 9 - CUSTOMER DATA QUALITY
   ============================================================ */


/* ============================================================
   9A - DUPLICATE CUSTOMER NAMES
   Check whether the same customer name appears multiple times.
   ============================================================ */

SELECT
    Customer_Name,
    COUNT(*) AS CustomerCount
FROM Customerss
GROUP BY Customer_Name
HAVING COUNT(*) > 1
ORDER BY CustomerCount DESC;


/* ============================================================
   9B - INVALID AGE
   Check for unrealistic customer ages.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    Customer_ID,
    Customer_Name,
    Age
FROM Customerss
WHERE Age < 18
   OR Age > 100
ORDER BY Age;


/* ============================================================
   9C - CUSTOMER COUNT BY GENDER
   Understand gender distribution.
   ============================================================ */

SELECT
    Gender,
    COUNT(*) AS CustomerCount
FROM Customerss
GROUP BY Gender
ORDER BY CustomerCount DESC;


/* ============================================================
   9D - CUSTOMER COUNT BY STATE
   Understand geographic distribution.
   ============================================================ */

SELECT
    State,
    COUNT(*) AS CustomerCount
FROM Customerss
GROUP BY State
ORDER BY CustomerCount DESC;


/* ============================================================
   9E - CUSTOMER COUNT BY CITY
   Find the cities with the most customers.
   ============================================================ */

SELECT
    City,
    State,
    COUNT(*) AS CustomerCount
FROM Customerss
GROUP BY City, State
ORDER BY CustomerCount DESC;


/* ============================================================
   9F - CUSTOMER AGE STATISTICS
   Check minimum, maximum and average age.
   ============================================================ */

SELECT
    MIN(Age) AS MinimumAge,
    MAX(Age) AS MaximumAge,
    AVG(CAST(Age AS DECIMAL(10,2))) AS AverageAge
FROM Customerss;


/* ============================================================
   9G - FUTURE SIGNUP DATES
   Check whether any signup date is after today.
   ============================================================ */

SELECT
    COUNT(*) AS FutureSignupDates
FROM Customerss
WHERE Signup_Date > CAST(GETDATE() AS DATE);


/* ============================================================
   9H - CUSTOMER SIGNUP DATE RANGE
   Find earliest and latest signup dates.
   ============================================================ */

SELECT
    MIN(Signup_Date) AS EarliestSignupDate,
    MAX(Signup_Date) AS LatestSignupDate
FROM Customerss;


/* ============================================================
   9I - CUSTOMER GENDER VALIDATION
   Find unexpected gender values.
   ============================================================ */

SELECT DISTINCT
    Gender
FROM Customerss
ORDER BY Gender;