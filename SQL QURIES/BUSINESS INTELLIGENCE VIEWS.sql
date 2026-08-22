USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   37A - MONTHLY REVENUE VIEW
   ============================================================ */

CREATE OR ALTER VIEW vw_MonthlyRevenue
AS

SELECT

    DATEFROMPARTS(
        YEAR(o.Order_Date),
        MONTH(o.Order_Date),
        1
    ) AS RevenueMonth,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders

FROM Orders o

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY

    DATEFROMPARTS(
        YEAR(o.Order_Date),
        MONTH(o.Order_Date),
        1
    );
GO


/* ============================================================
   37B - CATEGORY PERFORMANCE VIEW
   ============================================================ */

CREATE OR ALTER VIEW vw_CategoryPerformance
AS

SELECT

    p.Category,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

    SUM(
        oi.Quantity * p.Cost_Price
    ) AS Cost,

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

    SUM(oi.Quantity) AS UnitsSold

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

INNER JOIN Orders o
    ON oi.Order_ID = o.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY
    p.Category;
GO


/* ============================================================
   37C - CUSTOMER REVENUE VIEW
   ============================================================ */

CREATE OR ALTER VIEW vw_CustomerRevenue
AS

SELECT

    c.Customer_ID,

    c.Customer_Name,

    c.Gender,

    c.City,

    c.State,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS TotalRevenue,

    AVG(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS AverageOrderItemValue

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY

    c.Customer_ID,
    c.Customer_Name,
    c.Gender,
    c.City,
    c.State;
GO


/* ============================================================
   37D - PRODUCT PERFORMANCE VIEW
   ============================================================ */

CREATE OR ALTER VIEW vw_ProductPerformance
AS

SELECT

    p.Product_ID,

    p.Product_Name,

    p.Category,

    p.Brand,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

    SUM(
        oi.Quantity * p.Cost_Price
    ) AS Cost,

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

INNER JOIN Orders o
    ON oi.Order_ID = o.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY

    p.Product_ID,
    p.Product_Name,
    p.Category,
    p.Brand;
GO

/* ============================================================
   37E - VERIFY BUSINESS INTELLIGENCE VIEWS
   ============================================================ */

SELECT * FROM vw_MonthlyRevenue
ORDER BY RevenueMonth;

SELECT * FROM vw_CategoryPerformance
ORDER BY Revenue DESC;

SELECT * FROM vw_CustomerRevenue
ORDER BY TotalRevenue DESC;

SELECT * FROM vw_ProductPerformance
ORDER BY Revenue DESC;