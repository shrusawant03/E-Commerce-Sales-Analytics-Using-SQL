USE Ecommerce_Business_Intelligence;
GO

/* ============================================================
   PHASE 2 - DATA QUALITY
   STEP 8 - PRODUCT & CATEGORY DATA QUALITY
   ============================================================ */


/* ============================================================
   8A - BLANK PRODUCT NAMES
   Check for empty or whitespace-only product names.
   Expected result: 0.
   ============================================================ */

SELECT
    COUNT(*) AS BlankProductNames
FROM Products
WHERE Product_Name IS NULL
   OR LTRIM(RTRIM(Product_Name)) = '';


/* ============================================================
   8B - BLANK CATEGORIES
   Check for empty or whitespace-only categories.
   Expected result: 0.
   ============================================================ */

SELECT
    COUNT(*) AS BlankCategories
FROM Products
WHERE Category IS NULL
   OR LTRIM(RTRIM(Category)) = '';


/* ============================================================
   8C - BLANK BRANDS
   Check for empty or whitespace-only brands.
   Expected result: 0.
   ============================================================ */

SELECT
    COUNT(*) AS BlankBrands
FROM Products
WHERE Brand IS NULL
   OR LTRIM(RTRIM(Brand)) = '';


/* ============================================================
   8D - DUPLICATE PRODUCT NAMES
   Check whether multiple products have the same name.
   ============================================================ */

SELECT
    Product_Name,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY Product_Name
HAVING COUNT(*) > 1
ORDER BY ProductCount DESC;


/* ============================================================
   8E - PRODUCT COUNT BY CATEGORY
   Understand the number of products in each category.
   ============================================================ */

SELECT
    Category,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY Category
ORDER BY ProductCount DESC;


/* ============================================================
   8F - PRODUCT COUNT BY BRAND
   Understand the number of products per brand.
   ============================================================ */

SELECT
    Brand,
    COUNT(*) AS ProductCount
FROM Products
GROUP BY Brand
ORDER BY ProductCount DESC;


/* ============================================================
   8G - PRODUCT MARGIN
   Calculate gross margin per product.
   ============================================================ */

SELECT
    Product_ID,
    Product_Name,
    Category,
    Cost_Price,
    Selling_Price,
    Selling_Price - Cost_Price AS GrossMargin,
    ((Selling_Price - Cost_Price) / NULLIF(Selling_Price, 0)) * 100
        AS GrossMarginPercentage
FROM Products
ORDER BY GrossMarginPercentage DESC;


/* ============================================================
   8H - PRODUCTS WITH VERY LOW MARGIN
   Find products with less than 10% gross margin.
   ============================================================ */

SELECT
    Product_ID,
    Product_Name,
    Category,
    Cost_Price,
    Selling_Price,
    ((Selling_Price - Cost_Price) / NULLIF(Selling_Price, 0)) * 100
        AS GrossMarginPercentage
FROM Products
WHERE ((Selling_Price - Cost_Price) / NULLIF(Selling_Price, 0)) * 100 < 10
ORDER BY GrossMarginPercentage;


/* ============================================================
   8I - CATEGORY DISTRIBUTION
   Check how many products exist in each category.
   ============================================================ */

SELECT
    Category,
    COUNT(*) AS ProductCount,
    MIN(Selling_Price) AS MinimumSellingPrice,
    MAX(Selling_Price) AS MaximumSellingPrice,
    AVG(Selling_Price) AS AverageSellingPrice
FROM Products
GROUP BY Category
ORDER BY ProductCount DESC;