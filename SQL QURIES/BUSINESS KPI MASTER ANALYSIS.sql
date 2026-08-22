USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 5 — BUSINESS KPI & EXECUTIVE ANALYSIS
   ============================================================ */


/* ============================================================
   24A - TOTAL CUSTOMERS
   ============================================================ */

SELECT
    COUNT(*) AS TotalCustomers
FROM Customerss;


/* ============================================================
   24B - TOTAL ORDERS & ORDER STATUS
   ============================================================ */

SELECT
    COUNT(*) AS TotalOrders,

    SUM(
        CASE
            WHEN Order_Status = 'Delivered'
            THEN 1
            ELSE 0
        END
    ) AS DeliveredOrders,

    SUM(
        CASE
            WHEN Order_Status = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS CancelledOrders,

    SUM(
        CASE
            WHEN Order_Status = 'Returned'
            THEN 1
            ELSE 0
        END
    ) AS ReturnedOrders

FROM Orders;


/* ============================================================
   24C - TOTAL REVENUE
   ============================================================ */

SELECT
    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS TotalRevenue

FROM Order_Items oi;


/* ============================================================
   24D - TOTAL COST & PROFIT
   ============================================================ */

SELECT

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS TotalRevenue,

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

FROM Order_Items oi

INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID;


/* ============================================================
   24E - AVERAGE ORDER VALUE
   ============================================================ */

WITH OrderRevenue AS
(
    SELECT
        o.Order_ID,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS OrderValue

    FROM Orders o

    INNER JOIN Order_Items oi
        ON o.Order_ID = oi.Order_ID

    GROUP BY
        o.Order_ID
)

SELECT
    AVG(OrderValue) AS AverageOrderValue,

    MIN(OrderValue) AS MinimumOrderValue,

    MAX(OrderValue) AS MaximumOrderValue

FROM OrderRevenue;


/* ============================================================
   24F - OVERALL BUSINESS KPI SUMMARY
   ============================================================ */

WITH RevenueData AS
(
    SELECT
        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS TotalRevenue,

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

    FROM Order_Items oi

    INNER JOIN Products p
        ON oi.Product_ID = p.Product_ID
),

OrderData AS
(
    SELECT
        COUNT(*) AS TotalOrders,

        SUM(
            CASE
                WHEN Order_Status = 'Delivered'
                THEN 1
                ELSE 0
            END
        ) AS DeliveredOrders,

        SUM(
            CASE
                WHEN Order_Status = 'Cancelled'
                THEN 1
                ELSE 0
            END
        ) AS CancelledOrders,

        SUM(
            CASE
                WHEN Order_Status = 'Returned'
                THEN 1
                ELSE 0
            END
        ) AS ReturnedOrders

    FROM Orders
),

CustomerData AS
(
    SELECT
        COUNT(*) AS TotalCustomers
    FROM Customerss
)

SELECT

    cd.TotalCustomers,

    od.TotalOrders,

    od.DeliveredOrders,

    od.CancelledOrders,

    od.ReturnedOrders,

    rd.TotalRevenue,

    rd.TotalCost,

    rd.TotalProfit,

    CAST(
        rd.TotalProfit * 100.0
        /
        NULLIF(rd.TotalRevenue, 0)
        AS DECIMAL(10,2)
    ) AS ProfitMarginPercentage

FROM CustomerData cd

CROSS JOIN OrderData od

CROSS JOIN RevenueData rd;