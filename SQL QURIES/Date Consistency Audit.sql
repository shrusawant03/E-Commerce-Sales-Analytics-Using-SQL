USE Ecommerce_Business_Intelligence;
GO

/* 6A - Order Date Range */
SELECT
    MIN(Order_Date) AS EarliestOrderDate,
    MAX(Order_Date) AS LatestOrderDate
FROM Orders;


/* 6B - Orders Before Customer Signup */
SELECT
    o.Order_ID,
    o.Customer_ID,
    o.Order_Date,
    c.Signup_Date
FROM Orders o
JOIN Customerss c
    ON o.Customer_ID = c.Customer_ID
WHERE CAST(o.Order_Date AS DATE) < c.Signup_Date;


/* 6C - Return Before Order */
SELECT
    r.Return_ID,
    r.Order_ID,
    r.Return_Date,
    o.Order_Date
FROM Returns r
JOIN Orders o
    ON r.Order_ID = o.Order_ID
WHERE r.Return_Date < CAST(o.Order_Date AS DATE);


/* 6D - Review Before Order */
SELECT
    rv.Review_ID,
    rv.Order_ID,
    rv.Review_Date,
    o.Order_Date
FROM Reviews rv
JOIN Orders o
    ON rv.Order_ID = o.Order_ID
WHERE rv.Review_Date < CAST(o.Order_Date AS DATE);


/* 6E - Shipment Before Order */
SELECT
    s.Shipment_ID,
    s.Order_ID,
    s.Ship_Date,
    o.Order_Date
FROM Shipments s
JOIN Orders o
    ON s.Order_ID = o.Order_ID
WHERE s.Ship_Date < CAST(o.Order_Date AS DATE);


/* 6F - Delivery Before Shipment */
SELECT
    Shipment_ID,
    Order_ID,
    Ship_Date,
    Delivery_Date
FROM Shipments
WHERE Ship_Date IS NOT NULL
  AND Delivery_Date IS NOT NULL
  AND Delivery_Date < Ship_Date;


/* 6G - Return Date Range */
SELECT
    COUNT(*) AS TotalReturns,
    MIN(Return_Date) AS EarliestReturnDate,
    MAX(Return_Date) AS LatestReturnDate
FROM Returns;