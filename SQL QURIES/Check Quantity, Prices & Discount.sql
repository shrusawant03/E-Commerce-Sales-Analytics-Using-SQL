USE Ecommerce_Business_Intelligence;
GO

-- 1. Quantity
SELECT
    MIN(Quantity) AS MinimumQuantity,
    MAX(Quantity) AS MaximumQuantity,
    AVG(CAST(Quantity AS DECIMAL(10,2))) AS AverageQuantity
FROM Order_Items;


-- 2. Unit Price
SELECT
    MIN(Unit_Price) AS MinimumUnitPrice,
    MAX(Unit_Price) AS MaximumUnitPrice,
    AVG(Unit_Price) AS AverageUnitPrice
FROM Order_Items;


-- 3. Discount
SELECT
    MIN(Discount) AS MinimumDiscount,
    MAX(Discount) AS MaximumDiscount,
    AVG(Discount) AS AverageDiscount
FROM Order_Items;


-- 4. Product Cost Price
SELECT
    MIN(Cost_Price) AS MinimumCostPrice,
    MAX(Cost_Price) AS MaximumCostPrice,
    AVG(Cost_Price) AS AverageCostPrice
FROM Products;


-- 5. Product Selling Price
SELECT
    MIN(Selling_Price) AS MinimumSellingPrice,
    MAX(Selling_Price) AS MaximumSellingPrice,
    AVG(Selling_Price) AS AverageSellingPrice
FROM Products;


-- Check Customer Age
SELECT
    MIN(Age) AS MinimumAge,
    MAX(Age) AS MaximumAge,
    AVG(CAST(Age AS DECIMAL(10,2))) AS AverageAge
FROM Customerss;

-- Check Ratings
SELECT
    MIN(Rating) AS MinimumRating,
    MAX(Rating) AS MaximumRating,
    AVG(CAST(Rating AS DECIMAL(10,2))) AS AverageRating
FROM Reviews;