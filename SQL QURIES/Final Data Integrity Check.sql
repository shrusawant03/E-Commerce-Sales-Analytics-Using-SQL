USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   13A - ORDERS WITH INVALID CUSTOMER
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS OrdersWithInvalidCustomer
FROM Orders o
LEFT JOIN Customerss c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


/* ============================================================
   13B - ORDER ITEMS WITH INVALID ORDER
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS OrderItemsWithInvalidOrder
FROM Order_Items oi
LEFT JOIN Orders o
    ON oi.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   13C - ORDER ITEMS WITH INVALID PRODUCT
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS OrderItemsWithInvalidProduct
FROM Order_Items oi
LEFT JOIN Products p
    ON oi.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


/* ============================================================
   13D - PAYMENTS WITH INVALID ORDER
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS PaymentsWithInvalidOrder
FROM Payments p
LEFT JOIN Orders o
    ON p.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   13E - RETURNS WITH INVALID ORDER
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS ReturnsWithInvalidOrder
FROM Returns r
LEFT JOIN Orders o
    ON r.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   13F - RETURNS WITH INVALID PRODUCT
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS ReturnsWithInvalidProduct
FROM Returns r
LEFT JOIN Products p
    ON r.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


/* ============================================================
   13G - REVIEWS WITH INVALID CUSTOMER
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS ReviewsWithInvalidCustomer
FROM Reviews r
LEFT JOIN Customerss c
    ON r.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;


/* ============================================================
   13H - REVIEWS WITH INVALID PRODUCT
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS ReviewsWithInvalidProduct
FROM Reviews r
LEFT JOIN Products p
    ON r.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


/* ============================================================
   13I - SHIPMENTS WITH INVALID ORDER
   Expected result: 0
   ============================================================ */

SELECT
    COUNT(*) AS ShipmentsWithInvalidOrder
FROM Shipments s
LEFT JOIN Orders o
    ON s.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   13J - COMPLETE RELATIONSHIP SUMMARY
   ============================================================ */

SELECT
    (SELECT COUNT(*) FROM Customerss) AS Customers,
    (SELECT COUNT(*) FROM Orders) AS Orders,
    (SELECT COUNT(*) FROM Order_Items) AS OrderItems,
    (SELECT COUNT(*) FROM Products) AS Products,
    (SELECT COUNT(*) FROM Payments) AS Payments,
    (SELECT COUNT(*) FROM Returns) AS Returns,
    (SELECT COUNT(*) FROM Reviews) AS Reviews,
    (SELECT COUNT(*) FROM Shipments) AS Shipments;