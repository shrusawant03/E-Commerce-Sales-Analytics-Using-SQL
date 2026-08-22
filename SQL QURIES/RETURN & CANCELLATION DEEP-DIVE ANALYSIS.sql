USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 9 — RETURN & CANCELLATION ANALYSIS
   ============================================================ */


/* ============================================================
   32A - RETURN REASONS ANALYSIS
   ============================================================ */

SELECT
    Return_Reason,
    COUNT(*) AS ReturnCount,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS ReturnPercentage

FROM Returns

GROUP BY
    Return_Reason

ORDER BY
    ReturnCount DESC;


/* ============================================================
   32B - RETURN RATE BY PRODUCT CATEGORY
   ============================================================ */

SELECT
    p.Category,

    COUNT(DISTINCT r.Return_ID) AS ReturnedItems,

    COUNT(DISTINCT oi.Order_Item_ID) AS TotalOrderItems,

    CAST(
        COUNT(DISTINCT r.Return_ID) * 100.0 /
        NULLIF(COUNT(DISTINCT oi.Order_Item_ID), 0)
        AS DECIMAL(10,2)
    ) AS ReturnRatePercentage

FROM Products p

LEFT JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

LEFT JOIN Returns r
    ON p.Product_ID = r.Product_ID
    AND oi.Order_ID = r.Order_ID

GROUP BY
    p.Category

ORDER BY
    ReturnRatePercentage DESC;


/* ============================================================
   32C - TOP RETURNED PRODUCTS
   ============================================================ */

SELECT TOP 20

    p.Product_ID,
    p.Product_Name,
    p.Category,

    COUNT(r.Return_ID) AS ReturnCount,

    SUM(oi.Quantity) AS UnitsSold

FROM Products p

INNER JOIN Returns r
    ON p.Product_ID = r.Product_ID

INNER JOIN Order_Items oi
    ON r.Order_ID = oi.Order_ID
    AND r.Product_ID = oi.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category

ORDER BY
    ReturnCount DESC;


/* ============================================================
   32D - RETURNED REVENUE BY CATEGORY
   ============================================================ */

SELECT

    p.Category,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS ReturnedRevenue

FROM Returns r

INNER JOIN Products p
    ON r.Product_ID = p.Product_ID

INNER JOIN Order_Items oi
    ON r.Order_ID = oi.Order_ID
    AND r.Product_ID = oi.Product_ID

GROUP BY
    p.Category

ORDER BY
    ReturnedRevenue DESC;


/* ============================================================
   32E - ORDER CANCELLATION ANALYSIS
   ============================================================ */

SELECT

    Order_Status,

    COUNT(*) AS OrderCount,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS OrderPercentage

FROM Orders

GROUP BY
    Order_Status

ORDER BY
    OrderCount DESC;


/* ============================================================
   32F - CANCELLATION FINANCIAL IMPACT
   ============================================================ */

SELECT

    o.Order_Status,

    COUNT(DISTINCT o.Order_ID) AS TotalOrders,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS RevenueValue

FROM Orders o

INNER JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID

WHERE
    o.Order_Status IN ('Cancelled', 'Returned')

GROUP BY
    o.Order_Status

ORDER BY
    RevenueValue DESC;