USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 13 — FINAL BUSINESS INTELLIGENCE ANALYSIS
   ============================================================ */


/* ============================================================
   36A - MONTHLY REVENUE TREND
   Chart: Line Chart
   ============================================================ */

SELECT

    DATEFROMPARTS(
        YEAR(o.Order_Date),
        MONTH(o.Order_Date),
        1
    ) AS Month,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue

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
    )

ORDER BY
    Month;


/* ============================================================
   36B - REVENUE BY PRODUCT CATEGORY
   Chart: Bar Chart
   ============================================================ */

SELECT

    p.Category,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue

FROM Order_Items oi

INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID

INNER JOIN Orders o
    ON oi.Order_ID = o.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY
    p.Category

ORDER BY
    Revenue DESC;


/* ============================================================
   36C - TOP 10 CUSTOMERS BY REVENUE
   Chart: Bar Chart
   ============================================================ */

SELECT TOP 10

    c.Customer_ID,
    c.Customer_Name,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY

    c.Customer_ID,
    c.Customer_Name

ORDER BY
    Revenue DESC;


/* ============================================================
   36D - TOP 10 PRODUCTS BY SALES
   Chart: Bar Chart
   ============================================================ */

SELECT TOP 10

    p.Product_ID,
    p.Product_Name,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

INNER JOIN Orders o
    ON oi.Order_ID = o.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY

    p.Product_ID,
    p.Product_Name

ORDER BY
    UnitsSold DESC;


/* ============================================================
   36E - CUSTOMER SEGMENT DISTRIBUTION
   Chart: Pie / Bar Chart
   ============================================================ */

WITH CustomerRFM AS
(
    SELECT

        c.Customer_ID,

        DATEDIFF(
            DAY,
            MAX(o.Order_Date),
            (SELECT MAX(Order_Date) FROM Orders)
        ) AS Recency,

        COUNT(DISTINCT o.Order_ID) AS Frequency,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS Monetary

    FROM Customerss c

    INNER JOIN Orders o
        ON c.Customer_ID = o.Customer_ID

    INNER JOIN Order_Items oi
        ON o.Order_ID = oi.Order_ID

    GROUP BY
        c.Customer_ID
),

Scored AS
(
    SELECT

        *,

        NTILE(5) OVER
        (
            ORDER BY Recency DESC
        ) AS RScore,

        NTILE(5) OVER
        (
            ORDER BY Frequency
        ) AS FScore,

        NTILE(5) OVER
        (
            ORDER BY Monetary
        ) AS MScore

    FROM CustomerRFM
)

SELECT

    CASE

        WHEN RScore >= 4
             AND FScore >= 4
             AND MScore >= 4
            THEN 'Champions'

        WHEN RScore >= 4
             AND FScore >= 3
            THEN 'Loyal Customers'

        WHEN RScore >= 4
             AND FScore <= 2
            THEN 'New Customers'

        WHEN RScore <= 2
             AND FScore >= 3
            THEN 'At Risk'

        WHEN RScore <= 2
             AND FScore <= 2
            THEN 'Lost Customers'

        ELSE
            'Potential Loyalists'

    END AS CustomerSegment,

    COUNT(*) AS CustomerCount

FROM Scored

GROUP BY

    CASE

        WHEN RScore >= 4
             AND FScore >= 4
             AND MScore >= 4
            THEN 'Champions'

        WHEN RScore >= 4
             AND FScore >= 3
            THEN 'Loyal Customers'

        WHEN RScore >= 4
             AND FScore <= 2
            THEN 'New Customers'

        WHEN RScore <= 2
             AND FScore >= 3
            THEN 'At Risk'

        WHEN RScore <= 2
             AND FScore <= 2
            THEN 'Lost Customers'

        ELSE
            'Potential Loyalists'

    END

ORDER BY
    CustomerCount DESC;


/* ============================================================
   36F - PROFIT BY CATEGORY
   Chart: Bar Chart
   ============================================================ */

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
    ) AS Profit

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

INNER JOIN Orders o
    ON oi.Order_ID = o.Order_ID

WHERE
    o.Order_Status NOT IN ('Cancelled', 'Returned')

GROUP BY
    p.Category

ORDER BY
    Profit DESC;


/* ============================================================
   36G - MONTHLY CUSTOMER RETENTION
   Chart: Line Chart
   ============================================================ */

WITH CustomerMonths AS
(
    SELECT DISTINCT

        Customer_ID,

        DATEFROMPARTS(
            YEAR(Order_Date),
            MONTH(Order_Date),
            1
        ) AS OrderMonth

    FROM Orders
),

FirstPurchase AS
(
    SELECT

        Customer_ID,

        MIN(OrderMonth) AS FirstMonth

    FROM CustomerMonths

    GROUP BY
        Customer_ID
)

SELECT

    cm.OrderMonth,

    COUNT(DISTINCT cm.Customer_ID) AS ActiveCustomers,

    COUNT(
        DISTINCT
        CASE
            WHEN cm.OrderMonth > fp.FirstMonth
            THEN cm.Customer_ID
        END
    ) AS RetainedCustomers

FROM CustomerMonths cm

INNER JOIN FirstPurchase fp
    ON cm.Customer_ID = fp.Customer_ID

GROUP BY
    cm.OrderMonth

ORDER BY
    cm.OrderMonth;


/* ============================================================
   36H - DELIVERY PERFORMANCE
   Chart: Bar Chart
   ============================================================ */

SELECT

    CASE

        WHEN DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) <= 3
            THEN 'Fast (0-3 Days)'

        WHEN DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) BETWEEN 4 AND 7
            THEN 'Normal (4-7 Days)'

        ELSE
            'Slow (8+ Days)'

    END AS DeliveryPerformance,

    COUNT(*) AS ShipmentCount

FROM Shipments

WHERE
    Ship_Date IS NOT NULL
    AND Delivery_Date IS NOT NULL

GROUP BY

    CASE

        WHEN DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) <= 3
            THEN 'Fast (0-3 Days)'

        WHEN DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) BETWEEN 4 AND 7
            THEN 'Normal (4-7 Days)'

        ELSE
            'Slow (8+ Days)'

    END

ORDER BY
    ShipmentCount DESC;


/* ============================================================
   36I - RETURN RATE BY CATEGORY
   Chart: Bar Chart
   ============================================================ */

WITH CategorySales AS
(
    SELECT

        p.Category,

        COUNT(DISTINCT oi.Order_Item_ID) AS TotalItems

    FROM Products p

    INNER JOIN Order_Items oi
        ON p.Product_ID = oi.Product_ID

    INNER JOIN Orders o
        ON oi.Order_ID = o.Order_ID

    WHERE
        o.Order_Status NOT IN ('Cancelled')

    GROUP BY
        p.Category
),

CategoryReturns AS
(
    SELECT

        p.Category,

        COUNT(DISTINCT r.Return_ID) AS ReturnedItems

    FROM Returns r

    INNER JOIN Products p
        ON r.Product_ID = p.Product_ID

    GROUP BY
        p.Category
)

SELECT

    cs.Category,

    cs.TotalItems,

    ISNULL(cr.ReturnedItems, 0) AS ReturnedItems,

    CAST(
        ISNULL(cr.ReturnedItems, 0) * 100.0
        / NULLIF(cs.TotalItems, 0)
        AS DECIMAL(10,2)
    ) AS ReturnRatePercentage

FROM CategorySales cs

LEFT JOIN CategoryReturns cr
    ON cs.Category = cr.Category

ORDER BY
    ReturnRatePercentage DESC;