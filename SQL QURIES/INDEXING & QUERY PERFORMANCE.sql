USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   39A - INDEX ORDERS BY CUSTOMER
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Orders_Customer_ID
ON Orders(Customer_ID);
GO


/* ============================================================
   39B - INDEX ORDERS BY DATE
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Orders_Order_Date
ON Orders(Order_Date);
GO


/* ============================================================
   39C - INDEX ORDERS BY STATUS
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Orders_Order_Status
ON Orders(Order_Status);
GO


/* ============================================================
   39D - INDEX ORDER ITEMS BY ORDER
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Order_Items_Order_ID
ON Order_Items(Order_ID);
GO


/* ============================================================
   39E - INDEX ORDER ITEMS BY PRODUCT
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Order_Items_Product_ID
ON Order_Items(Product_ID);
GO


/* ============================================================
   39F - INDEX PAYMENTS BY ORDER
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Payments_Order_ID
ON Payments(Order_ID);
GO


/* ============================================================
   39G - INDEX PAYMENTS BY STATUS
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Payments_Status
ON Payments(Payment_Status);
GO


/* ============================================================
   39H - INDEX RETURNS BY PRODUCT
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Returns_Product_ID
ON Returns(Product_ID);
GO


/* ============================================================
   39I - INDEX RETURNS BY ORDER
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Returns_Order_ID
ON Returns(Order_ID);
GO


/* ============================================================
   39J - INDEX REVIEWS BY PRODUCT
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Reviews_Product_ID
ON Reviews(Product_ID);
GO


/* ============================================================
   39K - INDEX REVIEWS BY CUSTOMER
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Reviews_Customer_ID
ON Reviews(Customer_ID);
GO


/* ============================================================
   39L - INDEX SHIPMENTS BY ORDER
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Shipments_Order_ID
ON Shipments(Order_ID);
GO


/* ============================================================
   39M - INDEX SHIPMENTS BY STATUS
   ============================================================ */

CREATE NONCLUSTERED INDEX IX_Shipments_Status
ON Shipments(Shipment_Status);
GO