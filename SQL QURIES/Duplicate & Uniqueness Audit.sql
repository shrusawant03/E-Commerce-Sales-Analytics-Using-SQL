USE Ecommerce_Business_Intelligence;
GO

-- Customers
SELECT
    'Customerss' AS TableName,
    Customer_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Customerss
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- Orders
SELECT
    'Orders' AS TableName,
    Order_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- Order Items
SELECT
    'Order_Items' AS TableName,
    Order_Item_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Order_Items
GROUP BY Order_Item_ID
HAVING COUNT(*) > 1;


-- Products
SELECT
    'Products' AS TableName,
    Product_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;


-- Payments
SELECT
    'Payments' AS TableName,
    Payment_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Payments
GROUP BY Payment_ID
HAVING COUNT(*) > 1;


-- Returns
SELECT
    'Returns' AS TableName,
    Return_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Returns
GROUP BY Return_ID
HAVING COUNT(*) > 1;


-- Reviews
SELECT
    'Reviews' AS TableName,
    Review_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Reviews
GROUP BY Review_ID
HAVING COUNT(*) > 1;


-- Shipments
SELECT
    'Shipments' AS TableName,
    Shipment_ID AS ID,
    COUNT(*) AS DuplicateCount
FROM Shipments
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;