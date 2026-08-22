USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   11A - PAYMENT COUNT VS ORDER COUNT
   ============================================================ */

SELECT
    (SELECT COUNT(*) FROM Orders) AS TotalOrders,
    (SELECT COUNT(*) FROM Payments) AS TotalPayments;


/* ============================================================
   11B - ORDERS WITHOUT PAYMENT
   Expected result: 0 rows
   ============================================================ */

SELECT
    o.Order_ID
FROM Orders o
LEFT JOIN Payments p
    ON o.Order_ID = p.Order_ID
WHERE p.Order_ID IS NULL;


/* ============================================================
   11C - PAYMENTS WITHOUT ORDER
   Expected result: 0 rows
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
   11E - CALCULATED ORDER VALUE
   Calculate each order's total from Order_Items first.
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
   11F - PAYMENT AMOUNT VS ORDER AMOUNT
   Correct version.
   First calculate one total per order, then compare payment.
   ============================================================ */

WITH OrderTotals AS
(
    SELECT
        oi.Order_ID,
        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS CalculatedOrderAmount
    FROM Order_Items oi
    GROUP BY oi.Order_ID
)
SELECT
    p.Order_ID,
    p.Amount AS PaymentAmount,
    ot.CalculatedOrderAmount,
    p.Amount - ot.CalculatedOrderAmount AS Difference
FROM Payments p
JOIN OrderTotals ot
    ON p.Order_ID = ot.Order_ID
WHERE ABS(p.Amount - ot.CalculatedOrderAmount) > 1
ORDER BY ABS(p.Amount - ot.CalculatedOrderAmount) DESC;


/* ============================================================
   11G - COUNT PAYMENT/ORDER AMOUNT MISMATCHES
   Expected result depends on the dataset.
   ============================================================ */

WITH OrderTotals AS
(
    SELECT
        oi.Order_ID,
        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS CalculatedOrderAmount
    FROM Order_Items oi
    GROUP BY oi.Order_ID
)
SELECT
    COUNT(*) AS MismatchedOrders
FROM Payments p
JOIN OrderTotals ot
    ON p.Order_ID = ot.Order_ID
WHERE ABS(p.Amount - ot.CalculatedOrderAmount) > 1;


/* ============================================================
   11H - SUCCESSFUL PAYMENTS VS SUCCESSFUL ORDER VALUE
   Compare totals without duplicating payment amounts.
   ============================================================ */

WITH OrderTotals AS
(
    SELECT
        oi.Order_ID,
        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS CalculatedOrderAmount
    FROM Order_Items oi
    GROUP BY oi.Order_ID
)
SELECT
    COUNT(*) AS SuccessfulPayments,
    SUM(p.Amount) AS TotalSuccessfulPayments,
    SUM(ot.CalculatedOrderAmount) AS CalculatedValueOfSuccessfulOrders
FROM Payments p
JOIN OrderTotals ot
    ON p.Order_ID = ot.Order_ID
WHERE p.Payment_Status = 'Successful';


/* ============================================================
   11I - FAILED PAYMENT VALUE
   ============================================================ */

SELECT
    COUNT(*) AS FailedPayments,
    SUM(Amount) AS TotalFailedPaymentAmount,
    AVG(Amount) AS AverageFailedPayment
FROM Payments
WHERE Payment_Status = 'Failed';