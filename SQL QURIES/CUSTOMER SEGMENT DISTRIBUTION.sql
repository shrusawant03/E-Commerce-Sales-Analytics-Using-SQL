USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 3 — CUSTOMER SEGMENTATION ANALYSIS
   ============================================================ */


/* ============================================================
   19A - CUSTOMER REVENUE SEGMENT
   ============================================================ */

WITH CustomerMetrics AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        COUNT(DISTINCT o.Order_ID) AS TotalOrders,

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
    TotalOrders,
    NetRevenue,

    CASE
        WHEN NetRevenue >= 100000 THEN 'VIP'
        WHEN NetRevenue >= 50000 THEN 'High Value'
        WHEN NetRevenue >= 20000 THEN 'Regular'
        ELSE 'Low Value'
    END AS CustomerSegment

FROM CustomerMetrics

ORDER BY
    NetRevenue DESC;


/* ============================================================
   19B - CUSTOMER SEGMENT DISTRIBUTION
   ============================================================ */

WITH CustomerMetrics AS
(
    SELECT
        c.Customer_ID,

        COUNT(DISTINCT o.Order_ID) AS TotalOrders,

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
        c.Customer_ID
),

SegmentedCustomers AS
(
    SELECT
        Customer_ID,
        TotalOrders,
        NetRevenue,

        CASE
            WHEN NetRevenue >= 100000 THEN 'VIP'
            WHEN NetRevenue >= 50000 THEN 'High Value'
            WHEN NetRevenue >= 20000 THEN 'Regular'
            ELSE 'Low Value'
        END AS CustomerSegment

    FROM CustomerMetrics
)

SELECT
    CustomerSegment,
    COUNT(*) AS CustomerCount,

    CAST(
        COUNT(*) * 100.0
        /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS SegmentPercentage

FROM SegmentedCustomers

GROUP BY
    CustomerSegment

ORDER BY
    CustomerCount DESC;


/* ============================================================
   19C - REVENUE BY CUSTOMER SEGMENT
   ============================================================ */

WITH CustomerMetrics AS
(
    SELECT
        c.Customer_ID,

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
        c.Customer_ID
),

SegmentedCustomers AS
(
    SELECT
        Customer_ID,
        NetRevenue,

        CASE
            WHEN NetRevenue >= 100000 THEN 'VIP'
            WHEN NetRevenue >= 50000 THEN 'High Value'
            WHEN NetRevenue >= 20000 THEN 'Regular'
            ELSE 'Low Value'
        END AS CustomerSegment

    FROM CustomerMetrics
)

SELECT
    CustomerSegment,

    COUNT(*) AS CustomerCount,

    SUM(NetRevenue) AS SegmentRevenue,

    AVG(NetRevenue) AS AverageCustomerRevenue

FROM SegmentedCustomers

GROUP BY
    CustomerSegment

ORDER BY
    SegmentRevenue DESC;


/* ============================================================
   19D - CUSTOMER SEGMENT BY ORDER FREQUENCY
   ============================================================ */

WITH CustomerMetrics AS
(
    SELECT
        c.Customer_ID,

        COUNT(DISTINCT o.Order_ID) AS TotalOrders,

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
        c.Customer_ID
),

SegmentedCustomers AS
(
    SELECT
        Customer_ID,
        TotalOrders,
        NetRevenue,

        CASE
            WHEN NetRevenue >= 100000 THEN 'VIP'
            WHEN NetRevenue >= 50000 THEN 'High Value'
            WHEN NetRevenue >= 20000 THEN 'Regular'
            ELSE 'Low Value'
        END AS CustomerSegment

    FROM CustomerMetrics
)

SELECT
    CustomerSegment,

    COUNT(*) AS CustomerCount,

    SUM(TotalOrders) AS TotalOrders,

    AVG(
        CAST(TotalOrders AS DECIMAL(10,2))
    ) AS AverageOrdersPerCustomer

FROM SegmentedCustomers

GROUP BY
    CustomerSegment

ORDER BY
    AverageOrdersPerCustomer DESC;