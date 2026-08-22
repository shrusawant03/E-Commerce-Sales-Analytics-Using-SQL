USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 3 — CUSTOMER REVENUE ANALYSIS
   ============================================================ */


/* ============================================================
   17A - TOP 10 CUSTOMERS BY NET REVENUE
   ============================================================ */

SELECT TOP 10
    c.Customer_ID,
    c.Customer_Name,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(oi.Quantity) AS UnitsPurchased,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    NetRevenue DESC;


/* ============================================================
   17B - TOP 10 CUSTOMERS WITH PROFIT
   ============================================================ */

SELECT TOP 10
    c.Customer_ID,
    c.Customer_Name,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(oi.Quantity) AS UnitsPurchased,

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

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    NetRevenue DESC;


/* ============================================================
   17C - TOP 10 CUSTOMERS BY NUMBER OF ORDERS
   ============================================================ */

SELECT TOP 10
    c.Customer_ID,
    c.Customer_Name,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS NetRevenue

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    TotalOrders DESC;


/* ============================================================
   17D - TOP 10 CUSTOMERS BY CUSTOMER LIFETIME VALUE
   ============================================================ */

SELECT TOP 10
    c.Customer_ID,
    c.Customer_Name,

    MIN(o.Order_Date) AS FirstOrderDate,

    MAX(o.Order_Date) AS LastOrderDate,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(
        oi.Quantity * oi.Unit_Price * (1 - oi.Discount)
    ) AS CustomerLifetimeValue

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    CustomerLifetimeValue DESC;


/* ============================================================
   17E - CUSTOMER REVENUE RANKING
   ============================================================ */

WITH CustomerRevenue AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS NetRevenue

    FROM Customerss c

    INNER JOIN Orders o
        ON c.Customer_ID = o.Customer_ID

    INNER JOIN Order_Items oi
        ON o.Order_ID = oi.Order_ID

    GROUP BY
        c.Customer_ID,
        c.Customer_Name
)

SELECT
    Customer_ID,
    Customer_Name,
    NetRevenue,

    RANK() OVER (
        ORDER BY NetRevenue DESC
    ) AS RevenueRank

FROM CustomerRevenue

ORDER BY
    RevenueRank;