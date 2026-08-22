USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 7 — PRODUCT PERFORMANCE & PRODUCT ANALYTICS
   ============================================================ */


/* ============================================================
   28A - PRODUCT SALES SUMMARY
   ============================================================ */

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category

ORDER BY
    Revenue DESC;


/* ============================================================
   28B - PRODUCT PROFIT ANALYSIS
   ============================================================ */

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,

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
    p.Product_ID,
    p.Product_Name,
    p.Category

ORDER BY
    Profit DESC;


/* ============================================================
   28C - TOP 10 PRODUCTS BY REVENUE
   ============================================================ */

SELECT TOP 10

    p.Product_ID,
    p.Product_Name,
    p.Category,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category

ORDER BY
    Revenue DESC;


/* ============================================================
   28D - TOP 10 PRODUCTS BY PROFIT
   ============================================================ */

SELECT TOP 10

    p.Product_ID,
    p.Product_Name,
    p.Category,

    SUM(oi.Quantity) AS UnitsSold,

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
    p.Product_ID,
    p.Product_Name,
    p.Category

ORDER BY
    Profit DESC;


/* ============================================================
   28E - PRODUCT PERFORMANCE RANKING
   ============================================================ */

WITH ProductPerformance AS
(
    SELECT
        p.Product_ID,
        p.Product_Name,
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
        p.Product_ID,
        p.Product_Name,
        p.Category
)

SELECT
    Product_ID,
    Product_Name,
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

FROM ProductPerformance

ORDER BY
    RevenueRank;


/* ============================================================
   28F - CATEGORY PRODUCT PERFORMANCE
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
    ) AS Profit

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Category

ORDER BY
    Revenue DESC;