USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 3 — CATEGORY PROFITABILITY ANALYSIS
   ============================================================ */


/* ============================================================
   20A - REVENUE, COST & PROFIT BY CATEGORY
   ============================================================ */

SELECT
    p.Category,

    SUM(oi.Quantity) AS UnitsSold,

    COUNT(DISTINCT oi.Order_ID) AS TotalOrders,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS NetRevenue,

    SUM(
        oi.Quantity * p.Cost_Price
    ) AS TotalCost,

    SUM(
        (
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        )
        -
        (
            oi.Quantity * p.Cost_Price
        )
    ) AS TotalProfit

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Category

ORDER BY
    TotalProfit DESC;


/* ============================================================
   20B - PROFIT MARGIN BY CATEGORY
   ============================================================ */

SELECT
    p.Category,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS NetRevenue,

    SUM(
        (
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        )
        -
        (
            oi.Quantity * p.Cost_Price
        )
    ) AS TotalProfit,

    CAST(
        SUM(
            (
                oi.Quantity
                * oi.Unit_Price
                * (1 - oi.Discount)
            )
            -
            (
                oi.Quantity * p.Cost_Price
            )
        )
        /
        NULLIF(
            SUM(
                oi.Quantity
                * oi.Unit_Price
                * (1 - oi.Discount)
            ),
            0
        )
        * 100
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercentage

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Category

ORDER BY
    ProfitMarginPercentage DESC;


/* ============================================================
   20C - CATEGORY REVENUE CONTRIBUTION
   ============================================================ */

WITH CategoryRevenue AS
(
    SELECT
        p.Category,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS NetRevenue

    FROM Products p

    INNER JOIN Order_Items oi
        ON p.Product_ID = oi.Product_ID

    GROUP BY
        p.Category
)

SELECT
    Category,
    NetRevenue,

    CAST(
        NetRevenue * 100.0
        /
        SUM(NetRevenue) OVER ()
        AS DECIMAL(10,2)
    ) AS RevenueContributionPercentage

FROM CategoryRevenue

ORDER BY
    NetRevenue DESC;


/* ============================================================
   20D - CATEGORY PRODUCT PERFORMANCE
   ============================================================ */

SELECT
    p.Category,

    COUNT(DISTINCT p.Product_ID) AS ProductCount,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS NetRevenue,

    SUM(
        (
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        )
        -
        (
            oi.Quantity * p.Cost_Price
        )
    ) AS TotalProfit

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Category

ORDER BY
    TotalProfit DESC;