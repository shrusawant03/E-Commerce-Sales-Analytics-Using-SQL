USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   PHASE 2 - DATA QUALITY
   STEP 7 - RETURN & ORDER CONSISTENCY
   ============================================================ */


/* ============================================================
   7A - RETURNS WITH INVALID ORDER ITEMS
   Check whether each returned product actually exists
   in the corresponding order.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    r.Return_ID,
    r.Order_ID,
    r.Product_ID
FROM Returns r
LEFT JOIN Order_Items oi
    ON r.Order_ID = oi.Order_ID
   AND r.Product_ID = oi.Product_ID
WHERE oi.Order_Item_ID IS NULL;


/* ============================================================
   7B - COUNT INVALID RETURNS
   Expected result: 0.
   ============================================================ */

SELECT
    COUNT(*) AS InvalidReturns
FROM Returns r
LEFT JOIN Order_Items oi
    ON r.Order_ID = oi.Order_ID
   AND r.Product_ID = oi.Product_ID
WHERE oi.Order_Item_ID IS NULL;


/* ============================================================
   7C - RETURN REASON DISTRIBUTION
   Check the distribution of return reasons.
   ============================================================ */

SELECT
    Return_Reason,
    COUNT(*) AS TotalReturns
FROM Returns
GROUP BY Return_Reason
ORDER BY TotalReturns DESC;


/* ============================================================
   7D - RETURN STATUS BY ORDER STATUS
   Check whether returned records are associated with
   the expected order statuses.
   ============================================================ */

SELECT
    o.Order_Status,
    COUNT(r.Return_ID) AS TotalReturns
FROM Orders o
LEFT JOIN Returns r
    ON o.Order_ID = r.Order_ID
GROUP BY o.Order_Status
ORDER BY TotalReturns DESC;