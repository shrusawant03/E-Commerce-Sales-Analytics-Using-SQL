USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 4 — DELIVERY & LOGISTICS PERFORMANCE
   ============================================================ */


/* ============================================================
   22A - DELIVERY TIME FOR EACH SHIPMENT
   ============================================================ */

SELECT
    Shipment_ID,
    Order_ID,
    Ship_Date,
    Delivery_Date,
    Shipment_Status,

    CASE
        WHEN Ship_Date IS NOT NULL
         AND Delivery_Date IS NOT NULL
        THEN DATEDIFF(DAY, Ship_Date, Delivery_Date)
        ELSE NULL
    END AS DeliveryDays

FROM Shipments

ORDER BY
    Shipment_ID;


/* ============================================================
   22B - AVERAGE DELIVERY TIME
   ============================================================ */

SELECT
    AVG(
        CAST(
            DATEDIFF(
                DAY,
                Ship_Date,
                Delivery_Date
            ) AS DECIMAL(10,2)
        )
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
   22C - DELIVERY PERFORMANCE BY SHIPMENT STATUS
   ============================================================ */

SELECT
    Shipment_Status,

    COUNT(*) AS ShipmentCount,

    AVG(
        CAST(
            DATEDIFF(
                DAY,
                Ship_Date,
                Delivery_Date
            ) AS DECIMAL(10,2)
        )
    ) AS AverageDeliveryDays

FROM Shipments

WHERE
    Ship_Date IS NOT NULL
    AND Delivery_Date IS NOT NULL

GROUP BY
    Shipment_Status

ORDER BY
    ShipmentCount DESC;


/* ============================================================
   22D - FAST / NORMAL / SLOW DELIVERY CLASSIFICATION
   ============================================================ */

SELECT
    Shipment_ID,
    Order_ID,
    Ship_Date,
    Delivery_Date,

    DATEDIFF(
        DAY,
        Ship_Date,
        Delivery_Date
    ) AS DeliveryDays,

    CASE
        WHEN DATEDIFF(
                DAY,
                Ship_Date,
                Delivery_Date
             ) <= 3
            THEN 'Fast Delivery'

        WHEN DATEDIFF(
                DAY,
                Ship_Date,
                Delivery_Date
             ) <= 7
            THEN 'Normal Delivery'

        ELSE 'Slow Delivery'
    END AS DeliveryCategory

FROM Shipments

WHERE
    Ship_Date IS NOT NULL
    AND Delivery_Date IS NOT NULL

ORDER BY
    DeliveryDays;


/* ============================================================
   22E - DELIVERY CATEGORY DISTRIBUTION
   ============================================================ */

WITH DeliveryClassification AS
(
    SELECT
        CASE
            WHEN DATEDIFF(
                    DAY,
                    Ship_Date,
                    Delivery_Date
                 ) <= 3
                THEN 'Fast Delivery'

            WHEN DATEDIFF(
                    DAY,
                    Ship_Date,
                    Delivery_Date
                 ) <= 7
                THEN 'Normal Delivery'

            ELSE 'Slow Delivery'
        END AS DeliveryCategory

    FROM Shipments

    WHERE
        Ship_Date IS NOT NULL
        AND Delivery_Date IS NOT NULL
)

SELECT
    DeliveryCategory,

    COUNT(*) AS ShipmentCount,

    CAST(
        COUNT(*) * 100.0
        /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS PercentageOfShipments

FROM DeliveryClassification

GROUP BY
    DeliveryCategory

ORDER BY
    ShipmentCount DESC;


/* ============================================================
   22F - MONTHLY DELIVERY PERFORMANCE
   ============================================================ */

SELECT
    DATEFROMPARTS(
        YEAR(Delivery_Date),
        MONTH(Delivery_Date),
        1
    ) AS DeliveryMonth,

    COUNT(*) AS DeliveredShipments,

    AVG(
        CAST(
            DATEDIFF(
                DAY,
                Ship_Date,
                Delivery_Date
            ) AS DECIMAL(10,2)
        )
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
    DeliveryMonth; d