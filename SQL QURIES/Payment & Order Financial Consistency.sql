USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   PHASE 2 - DATA QUALITY
   STEP 11 - PAYMENT & ORDER FINANCIAL CONSISTENCY
   ============================================================ */


/* ============================================================
   11A - PAYMENT COUNT VS ORDER COUNT
   Check whether each order has a payment.
   ============================================================ */

SELECT
    (SELECT COUNT(*) FROM Orders) AS TotalOrders,
    (SELECT COUNT(*) FROM Payments) AS TotalPayments;


/* ============================================================
   11B - ORDERS WITHOUT PAYMENT
   Expected result: 0 rows.
   ============================================================ */

SELECT
    o.Order_ID
FROM Orders o
LEFT JOIN Payments p
    ON o.Order_ID = p.Order_ID
WHERE p.Order_ID IS NULL;


/* ============================================================
   11C - PAYMENTS WITHOUT ORDER
   Expected result: 0 rows.
   ============================================================ */

SELECT
    p.Payment_ID,
    p.Order_ID
FROM Payments p
LEFT JOIN Orders o
    ON p.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   11D - PAYMENT STATUS DISTRIBUTION
   ============================================================ */

SELECT
    Payment_Status,
    COUNT(*) AS PaymentCount,
    SUM(Amount) AS TotalPaymentAmount,
    AVG(Amount) AS AveragePaymentAmount
FROM Payments
GROUP BY Payment_Status
ORDER BY PaymentCount DESC;


/* ============================================================
   11E - ORDER NET VALUE
   Calculate the actual net order amount from Order_Items.
   ============================================================ */

SELECT
    o.Order_ID,
    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS CalculatedOrderAmount
FROM Orders o
JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID
GROUP BY o.Order_ID;


/* ============================================================
   11F - PAYMENT AMOUNT VS CALCULATED ORDER AMOUNT
   Show orders where payment amount differs from calculated
   order value by more than 1 rupee.
   ============================================================ */

SELECT
    o.Order_ID,
    p.Amount AS PaymentAmount,
    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS CalculatedOrderAmount,
    p.Amount
    -
    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Difference
FROM Orders o
JOIN Payments p
    ON o.Order_ID = p.Order_ID
JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID
GROUP BY
    o.Order_ID,
    p.Amount
HAVING ABS(
    p.Amount
    -
    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    )
) > 1
ORDER BY ABS(
    p.Amount
    -
    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    )
) DESC;


/* ============================================================
   11G - PAYMENT AMOUNT SUMMARY
   Compare successful payment amounts with calculated
   order values.
   ============================================================ */

SELECT
    COUNT(*) AS SuccessfulPayments,
    SUM(p.Amount) AS TotalSuccessfulPayments,
    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS CalculatedOrderValue
FROM Payments p
JOIN Orders o
    ON p.Order_ID = o.Order_ID
JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID
WHERE p.Payment_Status = 'Successful';