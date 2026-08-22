ALTER TABLE Order_Items
ADD CONSTRAINT FK_Order_Items_Orders
FOREIGN KEY (Order_ID)
REFERENCES Orders(Order_ID);

ALTER TABLE Returns
ADD CONSTRAINT FK_Returns_Products
FOREIGN KEY (Product_ID)
REFERENCES Products(Product_ID);

ALTER TABLE Reviews
ADD CONSTRAINT FK_Reviews_Orders
FOREIGN KEY (Order_ID)
REFERENCES Orders(Order_ID);

ALTER TABLE Shipments
ADD CONSTRAINT FK_Shipments_Orders
FOREIGN KEY (Order_ID)
REFERENCES Orders(Order_ID);