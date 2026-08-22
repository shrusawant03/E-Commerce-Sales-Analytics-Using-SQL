USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   12A - ORDERS WITHOUT SHIPMENT
   Check whether every order has a shipment record.
   ============================================================ */

SELECT
    COUNT(*) AS OrdersWithoutShipment
FROM Orders o
LEFT JOIN Shipments s
    ON o.Order_ID = s.Order_ID
WHERE s.Order_ID IS NULL;


/* ============================================================
   12B - SHIPMENTS WITHOUT ORDER
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS ShipmentsWithoutOrder
FROM Shipments s
LEFT JOIN Orders o
    ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   12C - MISSING SHIP DATES
   ============================================================ */

SELECT
    COUNT(*) AS MissingShipDates
FROM Shipments
WHERE Ship_Date IS NULL;


/* ============================================================
   12D - MISSING DELIVERY DATES
   ============================================================ */

SELECT
    COUNT(*) AS MissingDeliveryDates
FROM Shipments
WHERE Delivery_Date IS NULL;


/* ============================================================
   12E - DELIVERY BEFORE SHIPMENT
   Delivery date should not be earlier than ship date.
   Expected result: 0
   ============================================================ */

SELECT
    Shipment_ID,
    Order_ID,
    Ship_Date,
    Delivery_Date
FROM Shipments
WHERE Ship_Date IS NOT NULL
  AND Delivery_Date IS NOT NULL
  AND Delivery_Date < Ship_Date;


/* ============================================================
   12F - SHIPMENT STATUS DISTRIBUTION
   ============================================================ */

SELECT
    Shipment_Status,
    COUNT(*) AS ShipmentCount
FROM Shipments
GROUP BY Shipment_Status
ORDER BY ShipmentCount DESC;


/* ============================================================
   12G - DELIVERY DAYS
   Calculate delivery time for completed deliveries.
   ============================================================ */

SELECT
    Shipment_Status,
    COUNT(*) AS ShipmentCount,
    MIN(DATEDIFF(DAY, Ship_Date, Delivery_Date)) AS MinimumDeliveryDays,
    MAX(DATEDIFF(DAY, Ship_Date, Delivery_Date)) AS MaximumDeliveryDays,
    AVG(
        CAST(
            DATEDIFF(DAY, Ship_Date, Delivery_Date)
            AS DECIMAL(10,2)
        )
    ) AS AverageDeliveryDays
FROM Shipments
WHERE Ship_Date IS NOT NULL
  AND Delivery_Date IS NOT NULL
GROUP BY Shipment_Status
ORDER BY Shipment_Status;


/* ============================================================
   12H - UNUSUAL DELIVERY TIMES
   Find deliveries taking more than 30 days.
   ============================================================ */

SELECT
    Shipment_ID,
    Order_ID,
    Ship_Date,
    Delivery_Date,
    DATEDIFF(DAY, Ship_Date, Delivery_Date) AS DeliveryDays
FROM Shipments
WHERE Ship_Date IS NOT NULL
  AND Delivery_Date IS NOT NULL
  AND DATEDIFF(DAY, Ship_Date, Delivery_Date) > 30
ORDER BY DeliveryDays DESC;


/* ============================================================
   12I - FUTURE SHIP OR DELIVERY DATES
   Check whether shipment dates are after today.
   ============================================================ */

SELECT
    COUNT(*) AS FutureShipmentDates
FROM Shipments
WHERE Ship_Date > CAST(GETDATE() AS DATE)
   OR Delivery_Date > CAST(GETDATE() AS DATE);


/* ============================================================
   12J - SHIPMENT STATUS VALIDATION
   Show all distinct shipment statuses.
   ============================================================ */

SELECT DISTINCT
    Shipment_Status
FROM Shipments
ORDER BY Shipment_Status;