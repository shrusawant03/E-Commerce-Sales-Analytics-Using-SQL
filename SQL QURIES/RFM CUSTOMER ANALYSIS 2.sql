USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 5 — RFM CUSTOMER ANALYTICS
   ============================================================ */


/* ============================================================
   25A - RAW RFM METRICS
   ============================================================ */

WITH CustomerRFM AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        DATEDIFF(
            DAY,
            MAX(o.Order_Date),
            '2025-12-31'
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
    Monetary

FROM CustomerRFM

ORDER BY
    Monetary DESC;


/* ============================================================
   25B - RFM SCORES USING NTILE
   ============================================================ */

WITH CustomerRFM AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        DATEDIFF(
            DAY,
            MAX(o.Order_Date),
            '2025-12-31'
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

RFMScores AS
(
    SELECT
        Customer_ID,
        Customer_Name,
        Recency,
        Frequency,
        Monetary,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS RecencyScore,

        NTILE(5) OVER (
            ORDER BY Frequency
        ) AS FrequencyScore,

        NTILE(5) OVER (
            ORDER BY Monetary
        ) AS MonetaryScore

    FROM CustomerRFM
)

SELECT
    Customer_ID,
    Customer_Name,
    Recency,
    Frequency,
    Monetary,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,

    RecencyScore
    + FrequencyScore
    + MonetaryScore AS RFMScore

FROM RFMScores

ORDER BY
    RFMScore DESC;


/* ============================================================
   25C - RFM CUSTOMER SEGMENTS
   ============================================================ */

WITH CustomerRFM AS
(
    SELECT
        c.Customer_ID,
        c.Customer_Name,

        DATEDIFF(
            DAY,
            MAX(o.Order_Date),
            '2025-12-31'
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

RFMScores AS
(
    SELECT
        Customer_ID,
        Customer_Name,
        Recency,
        Frequency,
        Monetary,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS RecencyScore,

        NTILE(5) OVER (
            ORDER BY Frequency
        ) AS FrequencyScore,

        NTILE(5) OVER (
            ORDER BY Monetary
        ) AS MonetaryScore

    FROM CustomerRFM
),

FinalRFM AS
(
    SELECT
        *,

        RecencyScore
        + FrequencyScore
        + MonetaryScore AS RFMScore

    FROM RFMScores
)

SELECT
    Customer_ID,
    Customer_Name,
    Recency,
    Frequency,
    Monetary,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    RFMScore,

    CASE

        WHEN RFMScore >= 13
            THEN 'Champions'

        WHEN RFMScore >= 10
            THEN 'Loyal Customers'

        WHEN RFMScore >= 7
            THEN 'Potential Loyalists'

        WHEN RFMScore >= 5
            THEN 'At Risk'

        ELSE
            'Lost Customers'

    END AS CustomerSegment

FROM FinalRFM

ORDER BY
    RFMScore DESC;


/* ============================================================
   25D - RFM SEGMENT DISTRIBUTION
   ============================================================ */

WITH CustomerRFM AS
(
    SELECT
        c.Customer_ID,

        DATEDIFF(
            DAY,
            MAX(o.Order_Date),
            '2025-12-31'
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

RFMScores AS
(
    SELECT
        Customer_ID,
        Recency,
        Frequency,
        Monetary,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS RecencyScore,

        NTILE(5) OVER (
            ORDER BY Frequency
        ) AS FrequencyScore,

        NTILE(5) OVER (
            ORDER BY Monetary
        ) AS MonetaryScore

    FROM CustomerRFM
),

FinalRFM AS
(
    SELECT
        *,

        RecencyScore
        + FrequencyScore
        + MonetaryScore AS RFMScore

    FROM RFMScores
),

Segments AS
(
    SELECT
        Customer_ID,

        CASE

            WHEN RFMScore >= 13
                THEN 'Champions'

            WHEN RFMScore >= 10
                THEN 'Loyal Customers'

            WHEN RFMScore >= 7
                THEN 'Potential Loyalists'

            WHEN RFMScore >= 5
                THEN 'At Risk'

            ELSE
                'Lost Customers'

        END AS CustomerSegment

    FROM FinalRFM
)

SELECT
    CustomerSegment,

    COUNT(*) AS CustomerCount,

    CAST(
        COUNT(*) * 100.0
        /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS CustomerPercentage

FROM Segments

GROUP BY
    CustomerSegment

ORDER BY
    CustomerCount DESC;


/* ============================================================
   25E - RFM SEGMENT REVENUE
   ============================================================ */

WITH CustomerRFM AS
(
    SELECT
        c.Customer_ID,

        DATEDIFF(
            DAY,
            MAX(o.Order_Date),
            '2025-12-31'
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

RFMScores AS
(
    SELECT
        Customer_ID,
        Recency,
        Frequency,
        Monetary,

        NTILE(5) OVER (
            ORDER BY Recency DESC
        ) AS RecencyScore,

        NTILE(5) OVER (
            ORDER BY Frequency
        ) AS FrequencyScore,

        NTILE(5) OVER (
            ORDER BY Monetary
        ) AS MonetaryScore

    FROM CustomerRFM
),

FinalRFM AS
(
    SELECT
        *,

        RecencyScore
        + FrequencyScore
        + MonetaryScore AS RFMScore

    FROM RFMScores
)

SELECT

    CASE

        WHEN RFMScore >= 13
            THEN 'Champions'

        WHEN RFMScore >= 10
            THEN 'Loyal Customers'

        WHEN RFMScore >= 7
            THEN 'Potential Loyalists'

        WHEN RFMScore >= 5
            THEN 'At Risk'

        ELSE
            'Lost Customers'

    END AS CustomerSegment,

    COUNT(*) AS CustomerCount,

    SUM(Monetary) AS SegmentRevenue,

    AVG(Monetary) AS AverageCustomerValue

FROM FinalRFM

GROUP BY

    CASE

        WHEN RFMScore >= 13
            THEN 'Champions'

        WHEN RFMScore >= 10
            THEN 'Loyal Customers'

        WHEN RFMScore >= 7
            THEN 'Potential Loyalists'

        WHEN RFMScore >= 5
            THEN 'At Risk'

        ELSE
            'Lost Customers'

    END

ORDER BY
    SegmentRevenue DESC;