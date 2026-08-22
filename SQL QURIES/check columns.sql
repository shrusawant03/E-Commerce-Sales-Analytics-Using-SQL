-- ============================================
-- CHECK COLUMNS OF ALL 8 TABLES
-- ============================================

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
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
ORDER BY 
    TABLE_NAME,
    ORDINAL_POSITION;