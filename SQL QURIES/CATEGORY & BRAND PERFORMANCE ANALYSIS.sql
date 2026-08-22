USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 7 — CATEGORY & BRAND PERFORMANCE ANALYSIS
   ============================================================ */


/* ============================================================
   29A - CATEGORY REVENUE & PROFIT
   ============================================================ */

SELECT
    p.Category,

    COUNT(DISTINCT p.Product_ID) AS ProductCount,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

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
    ) AS Profit,

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
        ) * 100.0
        /
        NULLIF(
            SUM(
                oi.Quantity
                * oi.Unit_Price
                * (1 - oi.Discount)
            ),
            0
        )
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercentage

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Category

ORDER BY
    Revenue DESC;


/* ============================================================
   29B - CATEGORY REVENUE CONTRIBUTION
   ============================================================ */

WITH CategoryRevenue AS
(
    SELECT
        p.Category,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS Revenue

    FROM Products p

    INNER JOIN Order_Items oi
        ON p.Product_ID = oi.Product_ID

    GROUP BY
        p.Category
)

SELECT
    Category,
    Revenue,

    CAST(
        Revenue * 100.0
        /
        SUM(Revenue) OVER ()
        AS DECIMAL(10,2)
    ) AS RevenueContributionPercentage

FROM CategoryRevenue

ORDER BY
    Revenue DESC;


/* ============================================================
   29C - BRAND PERFORMANCE
   ============================================================ */

SELECT
    p.Brand,

    COUNT(DISTINCT p.Product_ID) AS ProductCount,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

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
    ) AS Profit

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Brand

ORDER BY
    Revenue DESC;


/* ============================================================
   29D - TOP 10 BRANDS BY PROFIT
   ============================================================ */

SELECT TOP 10

    p.Brand,

    COUNT(DISTINCT p.Product_ID) AS ProductCount,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

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
    ) AS Profit

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Brand

ORDER BY
    Profit DESC;


/* ============================================================
   29E - CATEGORY RANKING
   ============================================================ */

WITH CategoryPerformance AS
(
    SELECT
        p.Category,

        SUM(oi.Quantity) AS UnitsSold,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS Revenue,

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
        ) AS Profit

    FROM Products p

    INNER JOIN Order_Items oi
        ON p.Product_ID = oi.Product_ID

    GROUP BY
        p.Category
)

SELECT
    Category,
    UnitsSold,
    Revenue,
    Profit,

    RANK() OVER (
        ORDER BY Revenue DESC
    ) AS RevenueRank,

    RANK() OVER (
        ORDER BY Profit DESC
    ) AS ProfitRank,

    RANK() OVER (
        ORDER BY UnitsSold DESC
    ) AS UnitsSoldRank

FROM CategoryPerformance

ORDER BY
    RevenueRank;