SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_NAME IN
(
    'Customers',
    'Order_Items',
    'Orders',
    'Payments',
    'Products',
    'Returns',
    'Reviews',
    'Shipments'
)
ORDER BY TABLE_NAME;