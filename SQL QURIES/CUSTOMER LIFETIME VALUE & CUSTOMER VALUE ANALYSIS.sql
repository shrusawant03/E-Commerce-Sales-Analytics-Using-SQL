USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 6 — CUSTOMER LIFETIME VALUE & VALUE ANALYSIS
   ============================================================ */


/* ============================================================
   27A - CUSTOMER REVENUE SUMMARY
   ============================================================ */

SELECT
    c.Customer_ID,
    c.Customer_Name,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS TotalRevenue

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    TotalRevenue DESC;


/* ============================================================
   27B - CUSTOMER AVERAGE ORDER VALUE
   ============================================================ */

WITH CustomerOrders AS
(
    SELECT
        o.Customer_ID,
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
        o.Customer_ID,
        o.Order_ID
)

SELECT
    Customer_ID,

    COUNT(Order_ID) AS TotalOrders,

    SUM(OrderValue) AS TotalRevenue,

    AVG(OrderValue) AS AverageOrderValue

FROM CustomerOrders

GROUP BY
    Customer_ID

ORDER BY
    TotalRevenue DESC;


/* ============================================================
   27C - CUSTOMER LIFETIME VALUE
   ============================================================ */

WITH CustomerRevenue AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        COUNT(DISTINCT o.Order_ID) AS TotalOrders,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS TotalRevenue

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
    TotalOrders,
    TotalRevenue,

    CAST(
        TotalRevenue
        / NULLIF(TotalOrders, 0)
        AS DECIMAL(12,2)
    ) AS AverageOrderValue,

    CAST(
        TotalRevenue
        AS DECIMAL(12,2)
    ) AS CustomerLifetimeValue

FROM CustomerRevenue

ORDER BY
    CustomerLifetimeValue DESC;


/* ============================================================
   27D - CUSTOMER VALUE RANKING
   ============================================================ */

WITH CustomerRevenue AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        COUNT(DISTINCT o.Order_ID) AS TotalOrders,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS TotalRevenue

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
    TotalOrders,
    TotalRevenue,

    RANK() OVER (
        ORDER BY TotalRevenue DESC
    ) AS CustomerRevenueRank

FROM CustomerRevenue

ORDER BY
    CustomerRevenueRank;


/* ============================================================
   27E - CUSTOMER VALUE SEGMENTS
   ============================================================ */

WITH CustomerRevenue AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        COUNT(DISTINCT o.Order_ID) AS TotalOrders,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS TotalRevenue

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

    CASE

        WHEN TotalRevenue >= 50000
            THEN 'High Value'

        WHEN TotalRevenue >= 25000
            THEN 'Medium Value'

        ELSE
            'Low Value'

    END AS CustomerValueSegment,

    COUNT(*) AS CustomerCount,

    SUM(TotalRevenue) AS SegmentRevenue,

    AVG(TotalRevenue) AS AverageCustomerRevenue

FROM CustomerRevenue

GROUP BY

    CASE

        WHEN TotalRevenue >= 50000
            THEN 'High Value'

        WHEN TotalRevenue >= 25000
            THEN 'Medium Value'

        ELSE
            'Low Value'

    END

ORDER BY
    SegmentRevenue DESC;