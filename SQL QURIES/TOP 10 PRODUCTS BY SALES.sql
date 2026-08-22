USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 3 — PRODUCT SALES & PERFORMANCE ANALYSIS
   ============================================================ */


/* ============================================================
   18A - TOP 10 PRODUCTS BY UNITS SOLD
   ============================================================ */

SELECT TOP 10
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Brand,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Brand

ORDER BY
    UnitsSold DESC;


/* ============================================================
   18B - TOP 10 PRODUCTS BY NET REVENUE
   ============================================================ */

SELECT TOP 10
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Brand,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Brand

ORDER BY
    NetRevenue DESC;


/* ============================================================
   18C - TOP 10 PRODUCTS BY PROFIT
   ============================================================ */

SELECT TOP 10
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Brand,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue,

    SUM(
        oi.Quantity * p.Cost_Price
    ) AS TotalCost,

    SUM(
        (
            oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
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
    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Brand

ORDER BY
    TotalProfit DESC;


/* ============================================================
   18D - PRODUCT PROFIT MARGIN
   ============================================================ */

SELECT
    p.Product_ID,
    p.Product_Name,
    p.Category,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue,

    SUM(
        (
            oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
        )
        -
        (
            oi.Quantity * p.Cost_Price
        )
    ) AS TotalProfit,

    CAST(
        (
            SUM(
                (
                    oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
                )
                -
                (
                    oi.Quantity * p.Cost_Price
                )
            )
            /
            NULLIF(
                SUM(
                    oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
                ),
                0
            )
        ) * 100
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
    ProfitMarginPercentage DESC;


/* ============================================================
   18E - PRODUCT SALES RANKING
   ============================================================ */

WITH ProductSales AS
(
    SELECT
        p.Product_ID,
        p.Product_Name,
        p.Category,

        SUM(oi.Quantity) AS UnitsSold,

        SUM(
            oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
        ) AS NetRevenue

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
    NetRevenue,

    RANK() OVER (
        ORDER BY UnitsSold DESC
    ) AS SalesVolumeRank,

    RANK() OVER (
        ORDER BY NetRevenue DESC
    ) AS RevenueRank

FROM ProductSales

ORDER BY
    SalesVolumeRank;