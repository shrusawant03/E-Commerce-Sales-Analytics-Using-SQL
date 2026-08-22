USE Ecommerce_Business_Intelligence;
GO

SELECT 'Customerss' AS TableName, COUNT(*) AS TotalRows
FROM Customerss

UNION ALL

SELECT 'Orders', COUNT(*)
FROM Orders

UNION ALL

SELECT 'Order_Items', COUNT(*)
FROM Order_Items

UNION ALL

SELECT 'Products', COUNT(*)
FROM Products

UNION ALL

SELECT 'Payments', COUNT(*)
FROM Payments

UNION ALL

SELECT 'Returns', COUNT(*)
FROM Returns

UNION ALL

SELECT 'Reviews', COUNT(*)
FROM Reviews

UNION ALL

SELECT 'Shipments', COUNT(*)
FROM Shipments;