USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 4 — CUSTOMER RETENTION & COHORT ANALYSIS
   ============================================================ */


/* ============================================================
   21A - FIRST ORDER MONTH FOR EACH CUSTOMER
   ============================================================ */

SELECT
    Customer_ID,
    DATEFROMPARTS(
        YEAR(MIN(Order_Date)),
        MONTH(MIN(Order_Date)),
        1
    ) AS FirstOrderMonth

FROM Orders

GROUP BY
    Customer_ID

ORDER BY
    Customer_ID;


/* ============================================================
   21B - MONTHLY ACTIVE CUSTOMERS
   ============================================================ */

SELECT
    DATEFROMPARTS(
        YEAR(Order_Date),
        MONTH(Order_Date),
        1
    ) AS OrderMonth,

    COUNT(DISTINCT Customer_ID) AS ActiveCustomers

FROM Orders

GROUP BY
    DATEFROMPARTS(
        YEAR(Order_Date),
        MONTH(Order_Date),
        1
    )

ORDER BY
    OrderMonth;


/* ============================================================
   21C - NEW CUSTOMERS ACQUIRED EACH MONTH
   ============================================================ */

WITH FirstOrders AS
(
    SELECT
        Customer_ID,

        DATEFROMPARTS(
            YEAR(MIN(Order_Date)),
            MONTH(MIN(Order_Date)),
            1
        ) AS FirstOrderMonth

    FROM Orders

    GROUP BY
        Customer_ID
)

SELECT
    FirstOrderMonth AS OrderMonth,

    COUNT(*) AS NewCustomers

FROM FirstOrders

GROUP BY
    FirstOrderMonth

ORDER BY
    FirstOrderMonth;


/* ============================================================
   21D - RETURNING CUSTOMERS BY MONTH
   ============================================================ */

WITH FirstOrders AS
(
    SELECT
        Customer_ID,

        DATEFROMPARTS(
            YEAR(MIN(Order_Date)),
            MONTH(MIN(Order_Date)),
            1
        ) AS FirstOrderMonth

    FROM Orders

    GROUP BY
        Customer_ID
),

MonthlyCustomers AS
(
    SELECT DISTINCT
        Customer_ID,

        DATEFROMPARTS(
            YEAR(Order_Date),
            MONTH(Order_Date),
            1
        ) AS OrderMonth

    FROM Orders
)

SELECT
    mc.OrderMonth,

    COUNT(*) AS ReturningCustomers

FROM MonthlyCustomers mc

INNER JOIN FirstOrders fo
    ON mc.Customer_ID = fo.Customer_ID

WHERE
    mc.OrderMonth > fo.FirstOrderMonth

GROUP BY
    mc.OrderMonth

ORDER BY
    mc.OrderMonth;


/* ============================================================
   21E - MONTHLY RETENTION RATE
   ============================================================ */

WITH FirstOrders AS
(
    SELECT
        Customer_ID,

        DATEFROMPARTS(
            YEAR(MIN(Order_Date)),
            MONTH(MIN(Order_Date)),
            1
        ) AS FirstOrderMonth

    FROM Orders

    GROUP BY
        Customer_ID
),

MonthlyCustomers AS
(
    SELECT DISTINCT
        Customer_ID,

        DATEFROMPARTS(
            YEAR(Order_Date),
            MONTH(Order_Date),
            1
        ) AS OrderMonth

    FROM Orders
),

MonthlyStats AS
(
    SELECT
        mc.OrderMonth,

        COUNT(*) AS TotalActiveCustomers,

        SUM(
            CASE
                WHEN mc.OrderMonth > fo.FirstOrderMonth
                THEN 1
                ELSE 0
            END
        ) AS ReturningCustomers

    FROM MonthlyCustomers mc

    INNER JOIN FirstOrders fo
        ON mc.Customer_ID = fo.Customer_ID

    GROUP BY
        mc.OrderMonth
)

SELECT
    OrderMonth,

    TotalActiveCustomers,

    ReturningCustomers,

    CAST(
        ReturningCustomers * 100.0
        /
        NULLIF(TotalActiveCustomers, 0)
        AS DECIMAL(10,2)
    ) AS RetentionRatePercentage

FROM MonthlyStats

ORDER BY
    OrderMonth;


/* ============================================================
   21F - CUSTOMER COHORT ANALYSIS
   ============================================================ */

WITH FirstOrders AS
(
    SELECT
        Customer_ID,

        DATEFROMPARTS(
            YEAR(MIN(Order_Date)),
            MONTH(MIN(Order_Date)),
            1
        ) AS CohortMonth

    FROM Orders

    GROUP BY
        Customer_ID
),

CustomerActivity AS
(
    SELECT DISTINCT
        Customer_ID,

        DATEFROMPARTS(
            YEAR(Order_Date),
            MONTH(Order_Date),
            1
        ) AS OrderMonth

    FROM Orders
)

SELECT
    fo.CohortMonth,

    ca.OrderMonth,

    DATEDIFF(
        MONTH,
        fo.CohortMonth,
        ca.OrderMonth
    ) AS MonthsSinceFirstOrder,

    COUNT(DISTINCT ca.Customer_ID) AS ActiveCustomers

FROM FirstOrders fo

INNER JOIN CustomerActivity ca
    ON fo.Customer_ID = ca.Customer_ID

GROUP BY
    fo.CohortMonth,
    ca.OrderMonth

ORDER BY
    fo.CohortMonth,
    ca.OrderMonth;