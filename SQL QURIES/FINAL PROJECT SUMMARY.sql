USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   41A - FINAL DATABASE KPI SUMMARY
   ============================================================ */

SELECT

    (SELECT COUNT(*) FROM Customerss) AS TotalCustomers,

    (SELECT COUNT(*) FROM Orders) AS TotalOrders,

    (SELECT COUNT(*) FROM Order_Items) AS TotalOrderItems,

    (SELECT COUNT(*) FROM Products) AS TotalProducts,

    (SELECT COUNT(*) FROM Payments) AS TotalPayments,

    (SELECT COUNT(*) FROM Returns) AS TotalReturns,

    (SELECT COUNT(*) FROM Reviews) AS TotalReviews,

    (SELECT COUNT(*) FROM Shipments) AS TotalShipments;


/* ============================================================
   41B - ORDER STATUS SUMMARY
   ============================================================ */

SELECT

    Order_Status,

    COUNT(*) AS OrderCount,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Percentage

FROM Orders

GROUP BY
    Order_Status

ORDER BY
    OrderCount DESC;


/* ============================================================
   41C - PAYMENT STATUS SUMMARY
   ============================================================ */

SELECT

    Payment_Status,

    COUNT(*) AS PaymentCount,

    SUM(Amount) AS TotalAmount

FROM Payments

GROUP BY
    Payment_Status

ORDER BY
    PaymentCount DESC;


/* ============================================================
   41D - RETURN REASON SUMMARY
   ============================================================ */

SELECT

    Return_Reason,

    COUNT(*) AS ReturnCount

FROM Returns

GROUP BY
    Return_Reason

ORDER BY
    ReturnCount DESC;


/* ============================================================
   41E - CUSTOMER GENDER SUMMARY
   ============================================================ */

SELECT

    Gender,

    COUNT(*) AS CustomerCount,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS Percentage

FROM Customerss

GROUP BY
    Gender

ORDER BY
    CustomerCount DESC;


/* ============================================================
   41F - PRODUCT CATEGORY SUMMARY
   ============================================================ */

SELECT

    Category,

    COUNT(*) AS ProductCount,

    MIN(Selling_Price) AS MinimumSellingPrice,

    MAX(Selling_Price) AS MaximumSellingPrice,

    AVG(Selling_Price) AS AverageSellingPrice

FROM Products

GROUP BY
    Category

ORDER BY
    ProductCount DESC;