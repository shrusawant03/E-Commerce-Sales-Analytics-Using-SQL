USE Ecommerce_Business_Intelligence;
GO

-- 1. Customerss
SELECT Customer_ID, COUNT(*) AS Duplicate_Count
FROM Customerss
GROUP BY Customer_ID
HAVING COUNT(*) > 1;


-- 2. Order_Items
SELECT Order_Item_ID, COUNT(*) AS Duplicate_Count
FROM Order_Items
GROUP BY Order_Item_ID
HAVING COUNT(*) > 1;


-- 3. Orders
SELECT Order_ID, COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- 4. Payments
SELECT Payment_ID, COUNT(*) AS Duplicate_Count
FROM Payments
GROUP BY Payment_ID
HAVING COUNT(*) > 1;


-- 5. Products
SELECT Product_ID, COUNT(*) AS Duplicate_Count
FROM Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;


-- 6. Returns
SELECT Return_ID, COUNT(*) AS Duplicate_Count
FROM Returns
GROUP BY Return_ID
HAVING COUNT(*) > 1;


-- 7. Reviews
SELECT Review_ID, COUNT(*) AS Duplicate_Count
FROM Reviews
GROUP BY Review_ID
HAVING COUNT(*) > 1;


-- 8. Shipments
SELECT Shipment_ID, COUNT(*) AS Duplicate_Count
FROM Shipments
GROUP BY Shipment_ID
HAVING COUNT(*) > 1;