USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   40A - VERIFY TABLE ROW COUNTS
   ============================================================ */

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



USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   40B - CHECK PRIMARY KEYS
   ============================================================ */

SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc
WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY tc.TABLE_NAME;


/* ============================================================
   40C - CHECK FOREIGN KEYS
   ============================================================ */

SELECT
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS ChildTable,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ChildColumn,
    OBJECT_NAME(fk.referenced_object_id) AS ParentTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ParentColumn
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc
    ON fk.object_id = fkc.constraint_object_id
ORDER BY ChildTable, ForeignKeyName;


/* ============================================================
   40D - CHECK NULL VALUES IN ORDERS
   ============================================================ */

SELECT
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS NullCustomerIDs,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS NullOrderDates,
    SUM(CASE WHEN Order_Status IS NULL THEN 1 ELSE 0 END) AS NullOrderStatuses
FROM Orders;


/* ============================================================
   40E - CHECK INVALID ORDER REFERENCES
   ============================================================ */

SELECT
    COUNT(*) AS InvalidOrderItems
FROM Order_Items oi
LEFT JOIN Orders o
    ON oi.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   40F - CHECK INVALID PRODUCT REFERENCES
   ============================================================ */

SELECT
    COUNT(*) AS InvalidProductReferences
FROM Order_Items oi
LEFT JOIN Products p
    ON oi.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


/* ============================================================
   40G - CHECK INVALID CUSTOMER REFERENCES
   ============================================================ */

SELECT
    COUNT(*) AS InvalidCustomerReferences
FROM Orders o
LEFT JOIN Customerss c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


/* ============================================================
   40H - DATABASE OBJECT SUMMARY
   ============================================================ */

SELECT
    type_desc AS ObjectType,
    COUNT(*) AS ObjectCount
FROM sys.objects
WHERE type IN ('U', 'V', 'P')
GROUP BY type_desc
ORDER BY ObjectType;