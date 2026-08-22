USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 3 — PRODUCT CATEGORY REVENUE & PROFIT ANALYSIS
   ============================================================ */


/* ============================================================
   16A - REVENUE BY PRODUCT CATEGORY
   ============================================================ */

SELECT
    p.Category,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity * oi.Unit_Price
    ) AS GrossSales,

    SUM(
        oi.Quantity * oi.Unit_Price * oi.Discount
    ) AS TotalDiscount,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue

FROM Orders o

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID

GROUP BY
    p.Category

ORDER BY
    NetRevenue DESC;


/* ============================================================
   16B - PROFIT BY PRODUCT CATEGORY
   ============================================================ */

SELECT
    p.Category,

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
    ) AS TotalProfit,

    CAST(
        (
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
        ) * 100
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercentage

FROM Orders o

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID

GROUP BY
    p.Category

ORDER BY
    TotalProfit DESC;


/* ============================================================
   16C - CATEGORY SHARE OF TOTAL REVENUE
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

    FROM Orders o

    INNER JOIN Order_Items oi
        ON o.Order_ID = oi.Order_ID

    INNER JOIN Products p
        ON oi.Product_ID = p.Product_ID

    GROUP BY
        p.Category
)

SELECT
    Category,
    NetRevenue,

    CAST(
        (
            NetRevenue
            /
            NULLIF(
                SUM(NetRevenue) OVER (),
                0
            )
        ) * 100
        AS DECIMAL(10,2)
    ) AS RevenueSharePercentage

FROM CategoryRevenue

ORDER BY
    NetRevenue DESC;


/* ============================================================
   16D - CATEGORY PERFORMANCE SUMMARY
   ============================================================ */

SELECT
    p.Category,

    COUNT(DISTINCT p.Product_ID) AS ProductCount,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(oi.Quantity) AS UnitsSold,

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
    ) AS TotalProfit

FROM Products p

LEFT JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

LEFT JOIN Orders o
    ON oi.Order_ID = o.Order_ID

GROUP BY
    p.Category

ORDER BY
    NetRevenue DESC;