USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 6 — COHORT & CUSTOMER RETENTION ANALYSIS
   ============================================================ */


/* ============================================================
   26A - CUSTOMER COHORT MONTH
   ============================================================ */

WITH CustomerFirstOrder AS
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
)

SELECT
    Customer_ID,
    CohortMonth
FROM CustomerFirstOrder
ORDER BY
    CohortMonth,
    Customer_ID;


/* ============================================================
   26B - CUSTOMER COHORT + PURCHASE MONTH
   ============================================================ */

WITH CustomerFirstOrder AS
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
        o.Customer_ID,

        DATEFROMPARTS(
            YEAR(o.Order_Date),
            MONTH(o.Order_Date),
            1
        ) AS PurchaseMonth

    FROM Orders o
)

SELECT
    ca.Customer_ID,
    cfo.CohortMonth,
    ca.PurchaseMonth,

    DATEDIFF(
        MONTH,
        cfo.CohortMonth,
        ca.PurchaseMonth
    ) AS MonthsSinceFirstPurchase

FROM CustomerActivity ca

INNER JOIN CustomerFirstOrder cfo
    ON ca.Customer_ID = cfo.Customer_ID

ORDER BY
    cfo.CohortMonth,
    MonthsSinceFirstPurchase;


/* ============================================================
   26C - COHORT RETENTION COUNTS
   ============================================================ */

WITH CustomerFirstOrder AS
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
        ) AS PurchaseMonth

    FROM Orders
),

CohortActivity AS
(
    SELECT
        cfo.CohortMonth,

        DATEDIFF(
            MONTH,
            cfo.CohortMonth,
            ca.PurchaseMonth
        ) AS MonthNumber,

        COUNT(DISTINCT ca.Customer_ID) AS ActiveCustomers

    FROM CustomerFirstOrder cfo

    INNER JOIN CustomerActivity ca
        ON cfo.Customer_ID = ca.Customer_ID

    GROUP BY
        cfo.CohortMonth,

        DATEDIFF(
            MONTH,
            cfo.CohortMonth,
            ca.PurchaseMonth
        )
)

SELECT
    CohortMonth,
    MonthNumber,
    ActiveCustomers

FROM CohortActivity

ORDER BY
    CohortMonth,
    MonthNumber;


/* ============================================================
   26D - COHORT RETENTION PERCENTAGE
   ============================================================ */

WITH CustomerFirstOrder AS
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
        ) AS PurchaseMonth

    FROM Orders
),

CohortActivity AS
(
    SELECT
        cfo.CohortMonth,

        DATEDIFF(
            MONTH,
            cfo.CohortMonth,
            ca.PurchaseMonth
        ) AS MonthNumber,

        COUNT(DISTINCT ca.Customer_ID) AS ActiveCustomers

    FROM CustomerFirstOrder cfo

    INNER JOIN CustomerActivity ca
        ON cfo.Customer_ID = ca.Customer_ID

    GROUP BY
        cfo.CohortMonth,

        DATEDIFF(
            MONTH,
            cfo.CohortMonth,
            ca.PurchaseMonth
        )
),

CohortSize AS
(
    SELECT
        CohortMonth,
        COUNT(*) AS TotalCohortCustomers

    FROM CustomerFirstOrder

    GROUP BY
        CohortMonth
)

SELECT

    ca.CohortMonth,

    ca.MonthNumber,

    ca.ActiveCustomers,

    cs.TotalCohortCustomers,

    CAST(
        ca.ActiveCustomers * 100.0
        / NULLIF(cs.TotalCohortCustomers, 0)
        AS DECIMAL(10,2)
    ) AS RetentionPercentage

FROM CohortActivity ca

INNER JOIN CohortSize cs
    ON ca.CohortMonth = cs.CohortMonth

ORDER BY
    ca.CohortMonth,
    ca.MonthNumber;