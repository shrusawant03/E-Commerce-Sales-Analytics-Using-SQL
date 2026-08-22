USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 10 — RFM CUSTOMER ANALYSIS
   ============================================================ */


/* ============================================================
   33A - CUSTOMER RECENCY
   ============================================================ */

SELECT

    c.Customer_ID,
    c.Customer_Name,

    MAX(o.Order_Date) AS LastPurchaseDate,

    DATEDIFF(
        DAY,
        MAX(o.Order_Date),
        (SELECT MAX(Order_Date) FROM Orders)
    ) AS RecencyDays

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    RecencyDays;


/* ============================================================
   33B - CUSTOMER FREQUENCY
   ============================================================ */

SELECT

    c.Customer_ID,
    c.Customer_Name,

    COUNT(DISTINCT o.Order_ID) AS Frequency

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    Frequency DESC;


/* ============================================================
   33C - CUSTOMER MONETARY VALUE
   ============================================================ */

SELECT

    c.Customer_ID,
    c.Customer_Name,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS MonetaryValue

FROM Customerss c

INNER JOIN Orders o
    ON c.Customer_ID = o.Customer_ID

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

GROUP BY
    c.Customer_ID,
    c.Customer_Name

ORDER BY
    MonetaryValue DESC;


/* ============================================================
   33D - COMPLETE RFM VALUES
   ============================================================ */

SELECT

    c.Customer_ID,
    c.Customer_Name,

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
    c.Customer_ID,
    c.Customer_Name;


/* ============================================================
   33E - RFM SCORING
   ============================================================ */

WITH RFM AS
(
    SELECT

        c.Customer_ID,
        c.Customer_Name,

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
        c.Customer_ID,
        c.Customer_Name
)

SELECT

    Customer_ID,
    Customer_Name,
    Recency,
    Frequency,
    Monetary,

    NTILE(5) OVER
    (
        ORDER BY Recency DESC
    ) AS RecencyScore,

    NTILE(5) OVER
    (
        ORDER BY Frequency
    ) AS FrequencyScore,

    NTILE(5) OVER
    (
        ORDER BY Monetary
    ) AS MonetaryScore

FROM RFM

ORDER BY
    Monetary DESC;


/* ============================================================
   33F - CUSTOMER RFM SEGMENTATION
   ============================================================ */

WITH RFM AS
(
    SELECT

        c.Customer_ID,
        c.Customer_Name,

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
        c.Customer_ID,
        c.Customer_Name
),

ScoredRFM AS
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

    FROM RFM
)

SELECT

    Customer_ID,
    Customer_Name,

    Recency,
    Frequency,
    Monetary,

    RScore,
    FScore,
    MScore,

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

    END AS CustomerSegment

FROM ScoredRFM

ORDER BY
    Monetary DESC;