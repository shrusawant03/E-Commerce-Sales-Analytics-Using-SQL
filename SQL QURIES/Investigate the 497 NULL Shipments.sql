USE Ecommerce_Business_Intelligence;
GO

SELECT
    Shipment_Status,
    COUNT(*) AS TotalShipments,
    SUM(CASE WHEN Ship_Date IS NULL THEN 1 ELSE 0 END) AS MissingShipDate,
    SUM(CASE WHEN Delivery_Date IS NULL THEN 1 ELSE 0 END) AS MissingDeliveryDate
FROM Shipments
GROUP BY Shipment_Status
ORDER BY TotalShipments DESC;

SELECT
    COUNT(*) AS TotalNullShipmentRecords,
    SUM(CASE
        WHEN Ship_Date IS NULL AND Delivery_Date IS NULL
        THEN 1 ELSE 0
    END) AS BothDatesMissing,
    SUM(CASE
        WHEN Ship_Date IS NULL AND Delivery_Date IS NOT NULL
        THEN 1 ELSE 0
    END) AS ShipDateMissingOnly,
    SUM(CASE
        WHEN Ship_Date IS NOT NULL AND Delivery_Date IS NULL
        THEN 1 ELSE 0
    END) AS DeliveryDateMissingOnly
FROM Shipments
WHERE Ship_Date IS NULL
   OR Delivery_Date IS NULL;