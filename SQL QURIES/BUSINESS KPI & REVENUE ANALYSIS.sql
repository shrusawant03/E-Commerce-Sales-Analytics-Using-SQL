USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   PHASE 3 — BUSINESS KPI & REVENUE ANALYSIS
   ============================================================ */


/* ============================================================
   14A - OVERALL BUSINESS KPIs
   ============================================================ */

SELECT
    COUNT(DISTINCT o.Order_ID) AS TotalOrders,
    COUNT(DISTINCT o.Customer_ID) AS CustomersWithOrders,
    COUNT(DISTINCT oi.Product_ID) AS ProductsSold,
    SUM(oi.Quantity) AS TotalUnitsSold,

    SUM(oi.Quantity * oi.Unit_Price) AS GrossSales,

    SUM(
        oi.Quantity * oi.Unit_Price * oi.Discount
    ) AS TotalDiscount,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue

FROM Orders o
INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID;


/* ============================================================
   14B - TOTAL PROFIT & PROFIT MARGIN
   ============================================================ */

SELECT
    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue,

    SUM(
        oi.Quantity * p.Cost_Price
    ) AS TotalCost,

    SUM(
        (oi.Quantity * oi.Unit_Price * (1 - oi.Discount))
        - (oi.Quantity * p.Cost_Price)
    ) AS TotalProfit,

    CAST(
        (
            SUM(
                (oi.Quantity * oi.Unit_Price * (1 - oi.Discount))
                - (oi.Quantity * p.Cost_Price)
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

FROM Order_Items oi
INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID;


/* ============================================================
   14C - ORDER STATUS SUMMARY
   ============================================================ */

SELECT
    Order_Status,
    COUNT(*) AS OrderCount,
    COUNT(DISTINCT Customer_ID) AS CustomerCount

FROM Orders

GROUP BY
    Order_Status

ORDER BY
    OrderCount DESC;


/* ============================================================
   14D - REVENUE BY ORDER STATUS
   ============================================================ */

SELECT
    o.Order_Status,

    COUNT(DISTINCT o.Order_ID) AS OrderCount,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue

FROM Orders o

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

GROUP BY
    o.Order_Status

ORDER BY
    NetRevenue DESC;