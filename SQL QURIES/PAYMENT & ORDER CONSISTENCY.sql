USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   PHASE 2 - DATA QUALITY
   STEP 5 - PAYMENT & ORDER CONSISTENCY
   ============================================================ */


/* ============================================================
   5A - PAYMENT STATUS DISTRIBUTION
   Purpose:
   Check payment statuses, total payment amount,
   and average payment amount.
   ============================================================ */

SELECT
    Payment_Status,
    COUNT(*) AS TotalPayments,
    SUM(Amount) AS TotalAmount,
    AVG(Amount) AS AverageAmount
FROM Payments
GROUP BY Payment_Status
ORDER BY TotalPayments DESC;


/* ============================================================
   5B - ORDER STATUS DISTRIBUTION
   Purpose:
   Check how many orders exist under each order status.
   ============================================================ */

SELECT
    Order_Status,
    COUNT(*) AS TotalOrders
FROM Orders
GROUP BY Order_Status
ORDER BY TotalOrders DESC;


/* ============================================================
   5C - ORDERS WITHOUT PAYMENT
   Purpose:
   Check whether every order has a corresponding payment.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    COUNT(*) AS OrdersWithoutPayment
FROM Orders o
LEFT JOIN Payments p
    ON o.Order_ID = p.Order_ID
WHERE p.Order_ID IS NULL;


/* ============================================================
   5C - PAYMENTS WITHOUT ORDER
   Purpose:
   Check whether every payment belongs to an existing order.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    COUNT(*) AS PaymentsWithoutOrder
FROM Payments p
LEFT JOIN Orders o
    ON p.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   5D - DUPLICATE PAYMENTS PER ORDER
   Purpose:
   Check whether any order has more than one payment.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    Order_ID,
    COUNT(*) AS PaymentCount
FROM Payments
GROUP BY Order_ID
HAVING COUNT(*) > 1;