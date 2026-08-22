USE Ecommerce_Business_Intelligence;
GO

SELECT
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN Selling_Price > Cost_Price THEN 1 ELSE 0 END) AS SellingAboveCost,
    SUM(CASE WHEN Selling_Price = Cost_Price THEN 1 ELSE 0 END) AS SellingEqualsCost,
    SUM(CASE WHEN Selling_Price < Cost_Price THEN 1 ELSE 0 END) AS SellingBelowCost
FROM Products;