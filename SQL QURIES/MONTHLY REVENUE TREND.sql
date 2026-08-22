USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 3 — MONTHLY REVENUE TREND ANALYSIS
   ============================================================ */


/* ============================================================
   15A - MONTHLY SALES & REVENUE TREND
   ============================================================ */

SELECT
    YEAR(o.Order_Date) AS OrderYear,
    MONTH(o.Order_Date) AS OrderMonth,

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

GROUP BY
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)

ORDER BY
    OrderYear,
    OrderMonth;


/* ============================================================
   15B - MONTHLY PROFIT TREND
   ============================================================ */

SELECT
    YEAR(o.Order_Date) AS OrderYear,
    MONTH(o.Order_Date) AS OrderMonth,

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
    YEAR(o.Order_Date),
    MONTH(o.Order_Date)

ORDER BY
    OrderYear,
    OrderMonth;


/* ============================================================
   15C - YEARLY REVENUE SUMMARY
   ============================================================ */

SELECT
    YEAR(o.Order_Date) AS OrderYear,

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

GROUP BY
    YEAR(o.Order_Date)

ORDER BY
    OrderYear;


/* ============================================================
   15D - MONTH-OVER-MONTH REVENUE CHANGE
   ============================================================ */

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.Order_Date) AS OrderYear,
        MONTH(o.Order_Date) AS OrderMonth,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS NetRevenue

    FROM Orders o

    INNER JOIN Order_Items oi
        ON o.Order_ID = oi.Order_ID

    GROUP BY
        YEAR(o.Order_Date),
        MONTH(o.Order_Date)
)

SELECT
    OrderYear,
    OrderMonth,
    NetRevenue,

    LAG(NetRevenue) OVER
    (
        ORDER BY OrderYear, OrderMonth
    ) AS PreviousMonthRevenue,

    NetRevenue
    -
    LAG(NetRevenue) OVER
    (
        ORDER BY OrderYear, OrderMonth
    ) AS RevenueChange,

    CAST(
        (
            (
                NetRevenue
                -
                LAG(NetRevenue) OVER
                (
                    ORDER BY OrderYear, OrderMonth
                )
            )
            /
            NULLIF(
                LAG(NetRevenue) OVER
                (
                    ORDER BY OrderYear, OrderMonth
                ),
                0
            )
        ) * 100
        AS DECIMAL(10,2)
    ) AS RevenueGrowthPercentage

FROM MonthlyRevenue

ORDER BY
    OrderYear,
    OrderMonth;