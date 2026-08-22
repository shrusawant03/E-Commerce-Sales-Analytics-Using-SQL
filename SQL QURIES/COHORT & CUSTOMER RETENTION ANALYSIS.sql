USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 11 — COHORT & CUSTOMER RETENTION ANALYSIS
   ============================================================ */


/* ============================================================
   34A - CUSTOMER COHORT MONTH
   ============================================================ */

SELECT
    Customer_ID,
    MIN(Order_Date) AS FirstOrderDate,
    DATEFROMPARTS(
        YEAR(MIN(Order_Date)),
        MONTH(MIN(Order_Date)),
        1
    ) AS CohortMonth

FROM Orders

GROUP BY
    Customer_ID

ORDER BY
    CohortMonth,
    Customer_ID;


/* ============================================================
   34B - MONTHLY ACTIVE CUSTOMERS
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
   34C - REPEAT CUSTOMER RETENTION
   ============================================================ */

WITH CustomerMonthlyOrders AS
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

FirstPurchase AS
(
    SELECT

        Customer_ID,

        MIN(OrderMonth) AS CohortMonth

    FROM CustomerMonthlyOrders

    GROUP BY
        Customer_ID
)

SELECT

    f.CohortMonth,

    c.OrderMonth,

    COUNT(DISTINCT c.Customer_ID) AS RetainedCustomers

FROM FirstPurchase f

INNER JOIN CustomerMonthlyOrders c
    ON f.Customer_ID = c.Customer_ID

WHERE
    c.OrderMonth > f.CohortMonth

GROUP BY

    f.CohortMonth,
    c.OrderMonth

ORDER BY

    f.CohortMonth,
    c.OrderMonth;


/* ============================================================
   34D - MONTHLY CUSTOMER RETENTION RATE
   ============================================================ */

WITH CustomerMonthlyOrders AS
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

FirstPurchase AS
(
    SELECT

        Customer_ID,

        MIN(OrderMonth) AS CohortMonth

    FROM CustomerMonthlyOrders

    GROUP BY
        Customer_ID
),

CohortSize AS
(
    SELECT

        CohortMonth,

        COUNT(DISTINCT Customer_ID) AS CohortCustomers

    FROM FirstPurchase

    GROUP BY
        CohortMonth
),

Retention AS
(
    SELECT

        f.CohortMonth,

        c.OrderMonth,

        COUNT(DISTINCT c.Customer_ID) AS RetainedCustomers

    FROM FirstPurchase f

    INNER JOIN CustomerMonthlyOrders c
        ON f.Customer_ID = c.Customer_ID

    WHERE
        c.OrderMonth > f.CohortMonth

    GROUP BY

        f.CohortMonth,
        c.OrderMonth
)

SELECT

    r.CohortMonth,

    r.OrderMonth,

    r.RetainedCustomers,

    cs.CohortCustomers,

    CAST(
        r.RetainedCustomers * 100.0
        / NULLIF(cs.CohortCustomers, 0)
        AS DECIMAL(10,2)
    ) AS RetentionRatePercentage

FROM Retention r

INNER JOIN CohortSize cs
    ON r.CohortMonth = cs.CohortMonth

ORDER BY

    r.CohortMonth,
    r.OrderMonth;