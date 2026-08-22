USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 12 — DELIVERY PERFORMANCE ANALYSIS
   ============================================================ */


/* ============================================================
   35A - OVERALL DELIVERY PERFORMANCE
   ============================================================ */

SELECT

    COUNT(*) AS TotalShipments,

    COUNT(Delivery_Date) AS DeliveredShipments,

    AVG(
        DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) * 1.0
    ) AS AverageDeliveryDays,

    MIN(
        DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        )
    ) AS MinimumDeliveryDays,

    MAX(
        DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        )
    ) AS MaximumDeliveryDays

FROM Shipments

WHERE
    Ship_Date IS NOT NULL
    AND Delivery_Date IS NOT NULL;


/* ============================================================
   35B - DELIVERY PERFORMANCE BY STATUS
   ============================================================ */

SELECT

    Shipment_Status,

    COUNT(*) AS ShipmentCount,

    COUNT(Delivery_Date) AS DeliveredCount,

    AVG(
        CASE
            WHEN Ship_Date IS NOT NULL
                 AND Delivery_Date IS NOT NULL
            THEN DATEDIFF(
                DAY,
                Ship_Date,
                Delivery_Date
            ) * 1.0
        END
    ) AS AverageDeliveryDays

FROM Shipments

GROUP BY
    Shipment_Status

ORDER BY
    ShipmentCount DESC;


/* ============================================================
   35C - MONTHLY DELIVERY PERFORMANCE
   ============================================================ */

SELECT

    DATEFROMPARTS(
        YEAR(Delivery_Date),
        MONTH(Delivery_Date),
        1
    ) AS DeliveryMonth,

    COUNT(*) AS DeliveredShipments,

    AVG(
        DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) * 1.0
    ) AS AverageDeliveryDays

FROM Shipments

WHERE
    Ship_Date IS NOT NULL
    AND Delivery_Date IS NOT NULL

GROUP BY

    DATEFROMPARTS(
        YEAR(Delivery_Date),
        MONTH(Delivery_Date),
        1
    )

ORDER BY
    DeliveryMonth;


/* ============================================================
   35D - DELIVERY PERFORMANCE CATEGORY
   ============================================================ */

SELECT

    CASE

        WHEN DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) <= 3
            THEN 'Fast Delivery (0-3 Days)'

        WHEN DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) BETWEEN 4 AND 7
            THEN 'Normal Delivery (4-7 Days)'

        ELSE
            'Slow Delivery (8+ Days)'

    END AS DeliveryCategory,

    COUNT(*) AS ShipmentCount,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS ShipmentPercentage

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
            THEN 'Fast Delivery (0-3 Days)'

        WHEN DATEDIFF(
            DAY,
            Ship_Date,
            Delivery_Date
        ) BETWEEN 4 AND 7
            THEN 'Normal Delivery (4-7 Days)'

        ELSE
            'Slow Delivery (8+ Days)'

    END

ORDER BY
    ShipmentCount DESC;