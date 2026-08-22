USE Ecommerce_Business_Intelligence;
GO


/* ============================================================
   38A - MONTHLY SALES REPORT
   ============================================================ */

CREATE OR ALTER PROCEDURE sp_MonthlySalesReport
AS
BEGIN

    SET NOCOUNT ON;

    SELECT

        RevenueMonth,

        Revenue,

        TotalOrders

    FROM vw_MonthlyRevenue

    ORDER BY
        RevenueMonth;

END;
GO


/* ============================================================
   38B - TOP PRODUCTS REPORT
   ============================================================ */

CREATE OR ALTER PROCEDURE sp_TopProducts
    @TopN INT = 10
AS
BEGIN

    SET NOCOUNT ON;

    SELECT TOP (@TopN)

        Product_ID,

        Product_Name,

        Category,

        Brand,

        UnitsSold,

        Revenue,

        Cost,

        Profit

    FROM vw_ProductPerformance

    ORDER BY
        Revenue DESC;

END;
GO


/* ============================================================
   38C - TOP CUSTOMERS REPORT
   ============================================================ */

CREATE OR ALTER PROCEDURE sp_TopCustomers
    @TopN INT = 10
AS
BEGIN

    SET NOCOUNT ON;

    SELECT TOP (@TopN)

        Customer_ID,

        Customer_Name,

        Gender,

        City,

        State,

        TotalOrders,

        TotalRevenue,

        AverageOrderItemValue

    FROM vw_CustomerRevenue

    ORDER BY
        TotalRevenue DESC;

END;
GO


/* ============================================================
   38D - CATEGORY PROFIT REPORT
   ============================================================ */

CREATE OR ALTER PROCEDURE sp_CategoryProfit
AS
BEGIN

    SET NOCOUNT ON;

    SELECT

        Category,

        Revenue,

        Cost,

        Profit,

        UnitsSold

    FROM vw_CategoryPerformance

    ORDER BY
        Profit DESC;

END;
GO