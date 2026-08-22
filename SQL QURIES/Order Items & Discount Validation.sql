USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   PHASE 2 - DATA QUALITY
   STEP 10 - ORDER ITEMS & DISCOUNT VALIDATION
   ============================================================ */


/* ============================================================
   10A - INVALID QUANTITY
   Quantity should be greater than zero.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    Order_Item_ID,
    Order_ID,
    Product_ID,
    Quantity
FROM Order_Items
WHERE Quantity <= 0
ORDER BY Quantity;


/* ============================================================
   10B - INVALID UNIT PRICE
   Unit price should be greater than zero.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    Order_Item_ID,
    Order_ID,
    Product_ID,
    Unit_Price
FROM Order_Items
WHERE Unit_Price <= 0
ORDER BY Unit_Price;


/* ============================================================
   10C - INVALID DISCOUNT
   Discount should normally be between 0 and 1
   because the dataset uses decimal discount rates.
   ============================================================ */

SELECT
    Order_Item_ID,
    Order_ID,
    Product_ID,
    Discount
FROM Order_Items
WHERE Discount < 0
   OR Discount > 1
ORDER BY Discount;


/* ============================================================
   10D - DISCOUNT DISTRIBUTION
   Understand the discounts used in the dataset.
   ============================================================ */

SELECT
    Discount,
    COUNT(*) AS ItemCount
FROM Order_Items
GROUP BY Discount
ORDER BY Discount;


/* ============================================================
   10E - ORDER ITEM PRODUCT VALIDATION
   Check whether every Order_Item references a valid product.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    oi.Order_Item_ID,
    oi.Order_ID,
    oi.Product_ID
FROM Order_Items oi
LEFT JOIN Products p
    ON oi.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


/* ============================================================
   10F - ORDER ITEM ORDER VALIDATION
   Check whether every Order_Item references a valid order.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    oi.Order_Item_ID,
    oi.Order_ID
FROM Order_Items oi
LEFT JOIN Orders o
    ON oi.Order_ID = o.Order_ID
WHERE o.Order_ID IS NULL;


/* ============================================================
   10G - ORDER ITEM PRICE VS PRODUCT PRICE
   Compare transaction Unit_Price with the current
   Product Selling_Price.
   This is informational because discounts/promotions
   may explain differences.
   ============================================================ */

SELECT
    COUNT(*) AS DifferentPrices
FROM Order_Items oi
JOIN Products p
    ON oi.Product_ID = p.Product_ID
WHERE ABS(oi.Unit_Price - p.Selling_Price) > 0.01;


/* ============================================================
   10H - ORDER ITEM FINANCIAL CALCULATION
   Calculate gross amount, discount amount and net amount.
   ============================================================ */

SELECT TOP 20
    Order_Item_ID,
    Order_ID,
    Product_ID,
    Quantity,
    Unit_Price,
    Discount,
    Quantity * Unit_Price AS GrossAmount,
    Quantity * Unit_Price * Discount AS DiscountAmount,
    Quantity * Unit_Price * (1 - Discount) AS NetAmount
FROM Order_Items
ORDER BY Order_Item_ID;


/* ============================================================
   10I - NEGATIVE NET SALES
   Check whether discounts produce negative amounts.
   Expected result: 0 rows.
   ============================================================ */

SELECT
    Order_Item_ID,
    Order_ID,
    Product_ID,
    Quantity,
    Unit_Price,
    Discount,
    Quantity * Unit_Price * (1 - Discount) AS NetAmount
FROM Order_Items
WHERE Quantity * Unit_Price * (1 - Discount) < 0;