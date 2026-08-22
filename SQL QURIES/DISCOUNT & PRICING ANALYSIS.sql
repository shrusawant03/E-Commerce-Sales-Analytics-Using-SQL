USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   PHASE 8 — DISCOUNT & PRICING ANALYSIS
   ============================================================ */


/* ============================================================
   31A - DISCOUNT DISTRIBUTION
   ============================================================ */

SELECT

    oi.Discount,

    COUNT(*) AS OrderItemCount,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue

FROM Order_Items oi

GROUP BY
    oi.Discount

ORDER BY
    oi.Discount;


/* ============================================================
   31B - REVENUE BY DISCOUNT LEVEL
   ============================================================ */

SELECT

    oi.Discount,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS NetRevenue,

    SUM(
        oi.Quantity
        * oi.Unit_Price
    ) AS GrossRevenue,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * oi.Discount
    ) AS DiscountAmount

FROM Order_Items oi

GROUP BY
    oi.Discount

ORDER BY
    oi.Discount;


/* ============================================================
   31C - PROFIT BY DISCOUNT LEVEL
   ============================================================ */

SELECT

    oi.Discount,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

    SUM(
        oi.Quantity * p.Cost_Price
    ) AS TotalCost,

    SUM(
        (
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        )
        -
        (
            oi.Quantity * p.Cost_Price
        )
    ) AS Profit

FROM Order_Items oi

INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID

GROUP BY
    oi.Discount

ORDER BY
    oi.Discount;


/* ============================================================
   31D - PRODUCT PRICE VS SELLING PRICE
   ============================================================ */

SELECT

    Product_ID,
    Product_Name,
    Category,
    Brand,
    Cost_Price,
    Selling_Price,

    Selling_Price - Cost_Price AS GrossProfitPerUnit,

    CAST(
        (Selling_Price - Cost_Price) * 100.0
        /
        NULLIF(Selling_Price, 0)
        AS DECIMAL(10,2)
    ) AS GrossMarginPercentage

FROM Products

ORDER BY
    GrossMarginPercentage DESC;


/* ============================================================
   31E - DISCOUNT IMPACT BY CATEGORY
   ============================================================ */

SELECT

    p.Category,

    oi.Discount,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * oi.Discount
    ) AS DiscountAmount,

    SUM(
        (
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        )
        -
        (
            oi.Quantity * p.Cost_Price
        )
    ) AS Profit

FROM Order_Items oi

INNER JOIN Products p
    ON oi.Product_ID = p.Product_ID

GROUP BY
    p.Category,
    oi.Discount

ORDER BY
    p.Category,
    oi.Discount;


/* ============================================================
   31F - HIGH DISCOUNT PRODUCTS
   ============================================================ */

SELECT TOP 20

    p.Product_ID,
    p.Product_Name,
    p.Category,

    AVG(oi.Discount) AS AverageDiscount,

    SUM(oi.Quantity) AS UnitsSold,

    SUM(
        oi.Quantity
        * oi.Unit_Price
        * (1 - oi.Discount)
    ) AS Revenue,

    SUM(
        (
            oi.Quantity
            * oi.Unit_Price
            * (1 - oi.Discount)
        )
        -
        (
            oi.Quantity * p.Cost_Price
        )
    ) AS Profit

FROM Products p

INNER JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID

GROUP BY
    p.Product_ID,
    p.Product_Name,
    p.Category

HAVING
    AVG(oi.Discount) >= 0.15

ORDER BY
    AverageDiscount DESC;