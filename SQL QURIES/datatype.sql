SELECT 'Orders.Customer_ID' AS ColumnName,
       MIN(Customer_ID) AS MinValue,
       MAX(Customer_ID) AS MaxValue
FROM Orders

UNION ALL

SELECT 'Customerss.Customer_ID',
       MIN(Customer_ID),
       MAX(Customer_ID)
FROM Customerss

UNION ALL

SELECT 'Order_Items.Product_ID',
       MIN(Product_ID),
       MAX(Product_ID)
FROM Order_Items

UNION ALL

SELECT 'Products.Product_ID',
       MIN(Product_ID),
       MAX(Product_ID)
FROM Products

UNION ALL

SELECT 'Payments.Order_ID',
       MIN(Order_ID),
       MAX(Order_ID)
FROM Payments

UNION ALL

SELECT 'Orders.Order_ID',
       MIN(Order_ID),
       MAX(Order_ID)
FROM Orders

UNION ALL

SELECT 'Returns.Order_ID',
       MIN(Order_ID),
       MAX(Order_ID)
FROM Returns

UNION ALL

SELECT 'Reviews.Customer_ID',
       MIN(Customer_ID),
       MAX(Customer_ID)
FROM Reviews

UNION ALL

SELECT 'Reviews.Product_ID',
       MIN(Product_ID),
       MAX(Product_ID)
FROM Reviews;