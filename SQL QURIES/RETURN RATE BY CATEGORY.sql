USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 4 — RETURN & PRODUCT QUALITY ANALYSIS
   ============================================================ */


/* ============================================================
   23A - TOTAL RETURNS
   ============================================================ */

SELECT
    COUNT(*) AS TotalReturns
FROM Returns;


/* ============================================================
   23B - RETURNS BY CATEGORY
   ============================================================ */

SELECT
    p.Category,

    COUNT(r.Return_ID) AS TotalReturns

FROM Returns r

INNER JOIN Products p
    ON r.Product_ID = p.Product_ID

GROUP BY
    p.Category

ORDER BY
    TotalReturns DESC;


/* ============================================================
   23C - RETURN RATE BY CATEGORY
   ============================================================ */

WITH CategoryOrders AS
(
    SELECT
        p.Category,

        COUNT(DISTINCT oi.Order_Item_ID) AS TotalOrderItems

    FROM Products p

    INNER JOIN Order_Items oi
        ON p.Product_ID = oi.Product_ID

    GROUP BY
        p.Category
),

CategoryReturns AS
(
    SELECT
        p.Category,

        COUNT(r.Return_ID) AS TotalReturns

    FROM Returns r

    INNER JOIN Products p
        ON r.Product_ID = p.Product_ID

    GROUP BY
        p.Category
)

SELECT
    co.Category,

    co.TotalOrderItems,

    ISNULL(cr.TotalReturns, 0) AS TotalReturns,

    CAST(
        ISNULL(cr.TotalReturns, 0) * 100.0
        /
        NULLIF(co.TotalOrderItems, 0)
        AS DECIMAL(10,2)
    ) AS ReturnRatePercentage

FROM CategoryOrders co

LEFT JOIN CategoryReturns cr
    ON co.Category = cr.Category

ORDER BY
    ReturnRatePercentage DESC;


/* ============================================================
   23D - RETURN REASON ANALYSIS
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
   23E - RETURN RATE BY PRODUCT
   ============================================================ */

WITH ProductSales AS
(
    SELECT
        Product_ID,

        COUNT(DISTINCT Order_Item_ID) AS TotalOrderItems

    FROM Order_Items

    GROUP BY
        Product_ID
),

ProductReturns AS
(
    SELECT
        Product_ID,

        COUNT(Return_ID) AS TotalReturns

    FROM Returns

    GROUP BY
        Product_ID
)

SELECT TOP 10
    p.Product_ID,
    p.Product_Name,
    p.Category,

    ps.TotalOrderItems,

    ISNULL(pr.TotalReturns, 0) AS TotalReturns,

    CAST(
        ISNULL(pr.TotalReturns, 0) * 100.0
        /
        NULLIF(ps.TotalOrderItems, 0)
        AS DECIMAL(10,2)
    ) AS ReturnRatePercentage

FROM Products p

INNER JOIN ProductSales ps
    ON p.Product_ID = ps.Product_ID

LEFT JOIN ProductReturns pr
    ON p.Product_ID = pr.Product_ID

ORDER BY
    ReturnRatePercentage DESC;


/* ============================================================
   23F - RETURN RATE BY CATEGORY WITH REVENUE
   ============================================================ */

WITH CategorySales AS
(
    SELECT
        p.Category,

        SUM(
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        ) AS NetRevenue

    FROM Products p

    INNER JOIN Order_Items oi
        ON p.Product_ID = oi.Product_ID

    GROUP BY
        p.Category
),

CategoryReturns AS
(
    SELECT
        p.Category,

        COUNT(r.Return_ID) AS TotalReturns

    FROM Returns r

    INNER JOIN Products p
        ON r.Product_ID = p.Product_ID

    GROUP BY
        p.Category
)

SELECT
    cs.Category,

    cs.NetRevenue,

    ISNULL(cr.TotalReturns, 0) AS TotalReturns,

    CAST(
        ISNULL(cr.TotalReturns, 0) * 100.0
        /
        NULLIF(
            SUM(ISNULL(cr.TotalReturns, 0)) OVER (),
            0
        )
        AS DECIMAL(10,2)
    ) AS ReturnContributionPercentage

FROM CategorySales cs

LEFT JOIN CategoryReturns cr
    ON cs.Category = cr.Category

ORDER BY
    TotalReturns DESC;