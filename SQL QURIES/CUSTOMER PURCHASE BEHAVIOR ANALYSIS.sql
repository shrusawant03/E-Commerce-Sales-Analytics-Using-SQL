USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 8 — CUSTOMER PURCHASE BEHAVIOR ANALYSIS
   ============================================================ */


/* ============================================================
   30A - CUSTOMER ORDER FREQUENCY
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
    TotalOrders DESC;


/* ============================================================
   30B - ONE-TIME VS REPEAT CUSTOMERS
   ============================================================ */

WITH CustomerOrders AS
(
    SELECT
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS TotalOrders

    FROM Orders

    GROUP BY
        Customer_ID
)

SELECT

    CASE
        WHEN TotalOrders = 1
            THEN 'One-Time Customer'

        ELSE
            'Repeat Customer'
    END AS CustomerType,

    COUNT(*) AS CustomerCount,

    CAST(
        COUNT(*) * 100.0
        /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS CustomerPercentage

FROM CustomerOrders

GROUP BY

    CASE
        WHEN TotalOrders = 1
            THEN 'One-Time Customer'

        ELSE
            'Repeat Customer'
    END

ORDER BY
    CustomerCount DESC;


/* ============================================================
   30C - CUSTOMER PURCHASE FREQUENCY SEGMENTS
   ============================================================ */

WITH CustomerOrders AS
(
    SELECT
        Customer_ID,

        COUNT(DISTINCT Order_ID) AS TotalOrders

    FROM Orders

    GROUP BY
        Customer_ID
)

SELECT

    CASE

        WHEN TotalOrders = 1
            THEN '1 Order'

        WHEN TotalOrders BETWEEN 2 AND 5
            THEN '2-5 Orders'

        WHEN TotalOrders BETWEEN 6 AND 10
            THEN '6-10 Orders'

        ELSE
            '10+ Orders'

    END AS PurchaseFrequencySegment,

    COUNT(*) AS CustomerCount

FROM CustomerOrders

GROUP BY

    CASE

        WHEN TotalOrders = 1
            THEN '1 Order'

        WHEN TotalOrders BETWEEN 2 AND 5
            THEN '2-5 Orders'

        WHEN TotalOrders BETWEEN 6 AND 10
            THEN '6-10 Orders'

        ELSE
            '10+ Orders'

    END

ORDER BY
    CustomerCount DESC;


/* ============================================================
   30D - CUSTOMER PREFERRED CATEGORY
   ============================================================ */

WITH CustomerCategory AS
(
    SELECT
        o.Customer_ID,
        p.Category,

        SUM(oi.Quantity) AS UnitsPurchased

    FROM Orders o

    INNER JOIN Order_Items oi
        ON o.Order_ID = oi.Order_ID

    INNER JOIN Products p
        ON oi.Product_ID = p.Product_ID

    GROUP BY
        o.Customer_ID,
        p.Category
),

RankedCategories AS
(
    SELECT
        Customer_ID,
        Category,
        UnitsPurchased,

        ROW_NUMBER() OVER
        (
            PARTITION BY Customer_ID
            ORDER BY UnitsPurchased DESC
        ) AS CategoryRank

    FROM CustomerCategory
)

SELECT
    Customer_ID,
    Category AS PreferredCategory,
    UnitsPurchased

FROM RankedCategories

WHERE CategoryRank = 1

ORDER BY
    Customer_ID;


/* ============================================================
   30E - AVERAGE ORDER VALUE BY CUSTOMER
   ============================================================ */

WITH CustomerOrderValue AS
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

FROM CustomerOrderValue

GROUP BY
    Customer_ID

ORDER BY
    AverageOrderValue DESC;


/* ============================================================
   30F - TOP CUSTOMERS BY PURCHASE FREQUENCY
   ============================================================ */

SELECT TOP 20

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
    TotalOrders DESC,
    TotalRevenue DESC;