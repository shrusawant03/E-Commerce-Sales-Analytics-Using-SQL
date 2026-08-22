-- ============================================
-- STEP 5: CHECK RELATIONSHIP DATA
-- ============================================

-- 1. Check Orders without a Customer
SELECT COUNT(*) AS Orders_Without_Customer
FROM Orders o
LEFT JOIN Customerss c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


-- 2. Check Order_Items without an Order
SELECT COUNT(*) AS Order_Items_Without_Order
FROM Order_Items oi
LEFT JOIN Orders o
    ON oi.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


-- 3. Check Order_Items without a Product
SELECT COUNT(*) AS Order_Items_Without_Product
FROM Order_Items oi
LEFT JOIN Products p
    ON oi.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


-- 4. Check Payments without an Order
SELECT COUNT(*) AS Payments_Without_Order
FROM Payments p
LEFT JOIN Orders o
    ON p.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


-- 5. Check Returns without an Order
SELECT COUNT(*) AS Returns_Without_Order
FROM Returns r
LEFT JOIN Orders o
    ON r.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


-- 6. Check Returns without a Product
SELECT COUNT(*) AS Returns_Without_Product
FROM Returns r
LEFT JOIN Products p
    ON r.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


-- 7. Check Reviews without an Order
SELECT COUNT(*) AS Reviews_Without_Order
FROM Reviews r
LEFT JOIN Orders o
    ON r.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


-- 8. Check Reviews without a Customer
SELECT COUNT(*) AS Reviews_Without_Customer
FROM Reviews r
LEFT JOIN Customerss c
    ON r.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


-- 9. Check Reviews without a Product
SELECT COUNT(*) AS Reviews_Without_Product
FROM Reviews r
LEFT JOIN Products p
    ON r.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


-- 10. Check Shipments without an Order
SELECT COUNT(*) AS Shipments_Without_Order
FROM Shipments s
LEFT JOIN Orders o
    ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;