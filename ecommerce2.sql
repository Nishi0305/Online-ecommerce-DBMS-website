-- =====================================================
-- PROJECT: ONLINE SHOPPING AND E-COMMERCE MANAGEMENT
-- DBMS: MYSQL 8.0+
-- (Reviews table removed)
-- =====================================================

-- 1. DATABASE CREATION
DROP DATABASE IF EXISTS EcommerceDB;
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- =====================================================
-- 2. TABLE CREATION (DDL)
-- =====================================================

-- TABLE 1: CUSTOMERS
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(15) UNIQUE,
    Gender VARCHAR(10),
    RegistrationDate DATE NOT NULL,
    CHECK (Gender IN ('Male','Female','Other'))
);

-- TABLE 2: ADDRESSES
CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    HouseNo VARCHAR(50),
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    AddressType VARCHAR(20) DEFAULT 'Home',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CHECK (AddressType IN ('Home','Office','Other'))
);

-- TABLE 3: CATEGORIES
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(200)
);

-- TABLE 4: SUPPLIERS
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    City VARCHAR(50)
);

-- TABLE 5: PRODUCTS
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Description VARCHAR(250),
    ProductStatus VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CHECK (Price > 0),
    CHECK (ProductStatus IN ('Active','Inactive'))
);

-- TABLE 6: INVENTORY
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL UNIQUE,
    Quantity INT NOT NULL DEFAULT 0,
    ReorderLevel INT DEFAULT 10,
    LastUpdated DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CHECK (Quantity >= 0),
    CHECK (ReorderLevel >= 0)
);

-- TABLE 7: COUPONS
CREATE TABLE Coupons (
    CouponID INT PRIMARY KEY AUTO_INCREMENT,
    CouponCode VARCHAR(30) NOT NULL UNIQUE,
    DiscountPercent DECIMAL(5,2) NOT NULL,
    ExpiryDate DATE,
    MinimumOrder DECIMAL(10,2) DEFAULT 0,
    CHECK (DiscountPercent > 0 AND DiscountPercent <= 100),
    CHECK (MinimumOrder >= 0)
);

-- TABLE 8: ORDERS
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    AddressID INT NOT NULL,
    CouponID INT,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(30) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY (CouponID) REFERENCES Coupons(CouponID),
    CHECK (TotalAmount >= 0),
    CHECK (OrderStatus IN ('Pending','Confirmed','Shipped','Delivered','Cancelled'))
);

-- TABLE 9: ORDER ITEMS
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CHECK (Quantity > 0),
    CHECK (UnitPrice > 0),
    UNIQUE (OrderID, ProductID)
);

-- TABLE 10: PAYMENTS
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    PaymentDate DATE,
    PaymentMethod VARCHAR(30),
    Amount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(20) DEFAULT 'Pending',
    TransactionID VARCHAR(100) UNIQUE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CHECK (Amount >= 0),
    CHECK (PaymentMethod IN ('UPI','Card','Net Banking','COD')),
    CHECK (PaymentStatus IN ('Pending','Success','Failed','Refunded'))
);

-- TABLE 11: SHIPMENTS
CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT NOT NULL,
    TrackingNumber VARCHAR(100) UNIQUE,
    CourierName VARCHAR(100),
    ShipmentDate DATE,
    DeliveryDate DATE,
    ShipmentStatus VARCHAR(30) DEFAULT 'Processing',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CHECK (ShipmentStatus IN ('Processing','Dispatched','In Transit','Delivered','Returned'))
);

-- TABLE 12: RETURNS
CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY AUTO_INCREMENT,
    OrderItemID INT NOT NULL,
    ReturnDate DATE,
    ReturnReason VARCHAR(200),
    ReturnStatus VARCHAR(30) DEFAULT 'Requested',
    RefundAmount DECIMAL(10,2),
    FOREIGN KEY (OrderItemID) REFERENCES OrderItems(OrderItemID),
    CHECK (RefundAmount IS NULL OR RefundAmount >= 0),
    CHECK (ReturnStatus IN ('Requested','Approved','Rejected','Refunded'))
);

-- =====================================================
-- 3. INSERT SAMPLE RECORDS (DML)
-- =====================================================

-- CUSTOMERS
INSERT INTO Customers VALUES
(1,'Rahul Sharma','rahul@gmail.com','9876500001','Male','2026-01-10'),
(2,'Priya Verma','priya@gmail.com','9876500002','Female','2026-01-15'),
(3,'Amit Patil','amit@gmail.com','9876500003','Male','2026-02-01'),
(4,'Sneha Joshi','sneha@gmail.com','9876500004','Female','2026-02-10'),
(5,'Rohan Mehta','rohan@gmail.com','9876500005','Male','2026-03-05'),
(6,'Neha Gupta','neha@gmail.com','9876500006','Female','2026-03-12'),
(7,'Karan Shah','karan@gmail.com','9876500007','Male','2026-04-01'),
(8,'Pooja Singh','pooja@gmail.com','9876500008','Female','2026-04-15'),
(9,'Ananya Rao','ananya@gmail.com','9876500009','Female','2026-05-01');

-- ADDRESSES
INSERT INTO Addresses VALUES
(1,1,'House 101','Nagpur','Maharashtra','440001','Home'),
(2,2,'Flat 202','Pune','Maharashtra','411001','Home'),
(3,3,'House 303','Mumbai','Maharashtra','400001','Home'),
(4,4,'Flat 404','Nagpur','Maharashtra','440010','Office'),
(5,5,'House 505','Nashik','Maharashtra','422001','Home'),
(6,6,'Flat 606','Delhi','Delhi','110001','Home'),
(7,7,'House 707','Pune','Maharashtra','411002','Office'),
(8,8,'Flat 808','Nagpur','Maharashtra','440015','Home'),
(9,1,'Flat 109','Pune','Maharashtra','411003','Office'),
(10,9,'House 909','Mumbai','Maharashtra','400002','Home');

-- CATEGORIES
INSERT INTO Categories VALUES
(1,'Electronics','Electronic gadgets and devices'),
(2,'Clothing','Men and women clothing'),
(3,'Books','Educational and general books'),
(4,'Home Appliances','Household appliances'),
(5,'Accessories','Fashion and mobile accessories'),
(6,'Sports','Sports and fitness products');

-- SUPPLIERS
INSERT INTO Suppliers VALUES
(1,'Tech World','tech@gmail.com','9123450001','Mumbai'),
(2,'Fashion Hub','fashion@gmail.com','9123450002','Pune'),
(3,'Book House','books@gmail.com','9123450003','Nagpur'),
(4,'Home Solutions','home@gmail.com','9123450004','Delhi'),
(5,'Sports Zone','sports@gmail.com','9123450005','Mumbai');

-- PRODUCTS
INSERT INTO Products VALUES
(101,'Laptop',1,1,55000,'HP Laptop','Active'),
(102,'Smartphone',1,1,25000,'Android Phone','Active'),
(103,'Headphones',1,1,2000,'Wireless Headphones','Active'),
(104,'T-Shirt',2,2,800,'Cotton T-Shirt','Active'),
(105,'Jeans',2,2,1500,'Denim Jeans','Active'),
(106,'DBMS Book',3,3,600,'Database textbook','Active'),
(107,'Python Book',3,3,750,'Programming textbook','Active'),
(108,'Mixer Grinder',4,4,3500,'Kitchen appliance','Active'),
(109,'Refrigerator',4,4,22000,'Double door fridge','Active'),
(110,'Smart Watch',5,1,4000,'Fitness smart watch','Active'),
(111,'Mobile Cover',5,2,300,'Protective phone cover','Active'),
(112,'Bluetooth Speaker',1,1,1800,'Portable speaker','Inactive'),
(113,'Football',6,5,1200,'Standard football','Active');

-- INVENTORY
INSERT INTO Inventory VALUES
(1,101,15,5,'2026-10-20'),
(2,102,25,10,'2026-10-20'),
(3,103,50,10,'2026-10-20'),
(4,104,100,20,'2026-10-20'),
(5,105,60,15,'2026-10-20'),
(6,106,40,10,'2026-10-20'),
(7,107,35,10,'2026-10-20'),
(8,108,12,5,'2026-10-20'),
(9,109,8,10,'2026-10-20'),
(10,110,20,5,'2026-10-20'),
(11,111,150,30,'2026-10-20'),
(12,112,4,5,'2026-10-20');

-- COUPONS
INSERT INTO Coupons VALUES
(1,'WELCOME10',10,'2026-12-31',500),
(2,'FESTIVE20',20,'2026-12-31',2000),
(3,'NEWUSER15',15,'2026-11-30',1000),
(4,'BOOKS5',5,'2026-12-15',300);

-- ORDERS
INSERT INTO Orders VALUES
(201,1,1,1,'2026-10-01',55000,'Delivered'),
(202,2,2,2,'2026-10-02',25000,'Delivered'),
(203,3,3,NULL,'2026-10-03',2600,'Shipped'),
(204,4,4,3,'2026-10-04',2300,'Pending'),
(205,5,5,NULL,'2026-10-05',600,'Delivered'),
(206,6,6,4,'2026-10-06',4000,'Confirmed'),
(207,7,7,NULL,'2026-10-07',3500,'Delivered'),
(208,8,8,1,'2026-10-08',22000,'Shipped'),
(209,1,9,NULL,'2026-10-09',1800,'Cancelled'),
(210,2,2,NULL,'2026-10-10',1500,'Pending');

-- ORDER ITEMS
INSERT INTO OrderItems VALUES
(1,201,101,1,55000),
(2,202,102,1,25000),
(3,203,103,1,2000),
(4,203,111,2,300),
(5,204,104,1,800),
(6,204,105,1,1500),
(7,205,106,1,600),
(8,206,110,1,4000),
(9,207,108,1,3500),
(10,208,109,1,22000),
(11,209,112,1,1800),
(12,210,105,1,1500);

-- PAYMENTS
INSERT INTO Payments VALUES
(1,201,'2026-10-01','UPI',55000,'Success','TXN1001'),
(2,202,'2026-10-02','Card',25000,'Success','TXN1002'),
(3,203,'2026-10-03','UPI',2600,'Success','TXN1003'),
(4,204,'2026-10-04','COD',2300,'Pending','TXN1004'),
(5,205,'2026-10-05','Net Banking',600,'Success','TXN1005'),
(6,206,'2026-10-06','Card',4000,'Success','TXN1006'),
(7,207,'2026-10-07','UPI',3500,'Success','TXN1007'),
(8,208,'2026-10-08','Card',22000,'Success','TXN1008'),
(9,209,'2026-10-09','UPI',1800,'Refunded','TXN1009'),
(10,210,'2026-10-10','COD',1500,'Pending','TXN1010');

-- SHIPMENTS
INSERT INTO Shipments VALUES
(1,201,'TRK1001','BlueDart','2026-10-02','2026-10-05','Delivered'),
(2,202,'TRK1002','Delhivery','2026-10-03','2026-10-06','Delivered'),
(3,203,'TRK1003','DTDC','2026-10-04',NULL,'In Transit'),
(4,205,'TRK1005','BlueDart','2026-10-06','2026-10-08','Delivered'),
(5,207,'TRK1007','Delhivery','2026-10-08','2026-10-10','Delivered'),
(6,208,'TRK1008','DTDC','2026-10-09',NULL,'In Transit');

-- RETURNS
INSERT INTO Returns VALUES
(1,11,'2026-10-12','Product not working','Approved',1800),
(2,4,'2026-10-13','Wrong product received','Requested',600);

-- =====================================================
-- 4. BASIC SELECT AND WHERE QUERIES
-- =====================================================

-- Q1 Display all customers
SELECT * FROM Customers;

-- Q2 Display all products
SELECT * FROM Products;

-- Q3 Products costing more than 5000
SELECT * FROM Products WHERE Price > 5000;

-- Q4 Products in Electronics category
SELECT * FROM Products WHERE CategoryID = 1;

-- Q5 Customers from Nagpur
SELECT DISTINCT C.*
FROM Customers C
JOIN Addresses A ON C.CustomerID = A.CustomerID
WHERE A.City = 'Nagpur';

-- Q6 Products priced between 1000 and 10000
SELECT * FROM Products WHERE Price BETWEEN 1000 AND 10000;

-- Q7 Product names starting with S
SELECT * FROM Products WHERE ProductName LIKE 'S%';

-- Q8 Orders in descending amount
SELECT * FROM Orders ORDER BY TotalAmount DESC;

-- Q9 First five products
SELECT * FROM Products LIMIT 5;

-- =====================================================
-- 5. ALTER, UPDATE AND DELETE
-- =====================================================

-- Q10 Add a column
ALTER TABLE Customers ADD LoyaltyPoints INT DEFAULT 0;

-- Q11 Modify a column
ALTER TABLE Customers MODIFY CustomerName VARCHAR(120) NOT NULL;

-- Q12 Update loyalty points
UPDATE Customers SET LoyaltyPoints = 100 WHERE CustomerID = 1;

-- Q13 Update product price
UPDATE Products SET Price = 26000 WHERE ProductID = 102;

-- Q14 Demonstrate DELETE safely using a transaction
START TRANSACTION;
DELETE FROM Returns WHERE ReturnID = 2;
ROLLBACK;

-- =====================================================
-- 6. AGGREGATE FUNCTIONS
-- =====================================================

-- Q15 Total customers
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- Q16 Total products
SELECT COUNT(*) AS TotalProducts FROM Products;

-- Q17 Average product price
SELECT AVG(Price) AS AveragePrice FROM Products;

-- Q18 Maximum and minimum product price
SELECT MAX(Price) AS MaximumPrice, MIN(Price) AS MinimumPrice FROM Products;

-- Q19 Total non-cancelled order value
SELECT SUM(TotalAmount) AS TotalOrderValue FROM Orders WHERE OrderStatus <> 'Cancelled';

-- Q20 Total inventory quantity
SELECT SUM(Quantity) AS TotalStock FROM Inventory;

-- =====================================================
-- 7. GROUP BY AND HAVING
-- =====================================================

-- Q21 Count products in each category
SELECT CategoryID, COUNT(*) AS TotalProducts
FROM Products GROUP BY CategoryID;

-- Q22 Average price in each category
SELECT CategoryID, AVG(Price) AS AveragePrice
FROM Products GROUP BY CategoryID;

-- Q23 Categories having more than two products
SELECT CategoryID, COUNT(*) AS TotalProducts
FROM Products GROUP BY CategoryID HAVING COUNT(*) > 2;

-- Q24 Number of orders by each customer
SELECT CustomerID, COUNT(*) AS TotalOrders
FROM Orders GROUP BY CustomerID;

-- Q25 Customers with more than one order
SELECT CustomerID, COUNT(*) AS TotalOrders
FROM Orders GROUP BY CustomerID HAVING COUNT(*) > 1;

-- Q26 Payment method-wise collection
SELECT PaymentMethod, SUM(Amount) AS TotalAmount
FROM Payments WHERE PaymentStatus = 'Success'
GROUP BY PaymentMethod;

-- =====================================================
-- 8. JOIN OPERATIONS
-- =====================================================

-- Q27 INNER JOIN: Customers and orders
SELECT C.CustomerName, O.OrderID, O.OrderDate, O.TotalAmount
FROM Customers C
INNER JOIN Orders O ON C.CustomerID = O.CustomerID;

-- Q28 LEFT JOIN: All customers and their orders
SELECT C.CustomerName, O.OrderID, O.TotalAmount
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID;

-- Q29 RIGHT JOIN: All categories and their products
SELECT CAT.CategoryName, P.ProductName
FROM Products P
RIGHT JOIN Categories CAT ON P.CategoryID = CAT.CategoryID;

-- Q30 Multiple JOIN: Order details
SELECT C.CustomerName, O.OrderID, P.ProductName, OI.Quantity,
       OI.UnitPrice, PAY.PaymentMethod, PAY.PaymentStatus
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
JOIN OrderItems OI ON O.OrderID = OI.OrderID
JOIN Products P ON OI.ProductID = P.ProductID
LEFT JOIN Payments PAY ON O.OrderID = PAY.OrderID;

-- Q31 Products and their categories
SELECT P.ProductName, CAT.CategoryName, P.Price
FROM Products P
JOIN Categories CAT ON P.CategoryID = CAT.CategoryID;

-- Q32 Suppliers and their products
SELECT S.SupplierName, P.ProductName, P.Price
FROM Suppliers S
JOIN Products P ON S.SupplierID = P.SupplierID;

-- Q33 SELF JOIN: Customers sharing the same city
SELECT A1.City, C1.CustomerName AS Customer1, C2.CustomerName AS Customer2
FROM Addresses A1
JOIN Addresses A2 ON A1.City = A2.City AND A1.AddressID < A2.AddressID
JOIN Customers C1 ON A1.CustomerID = C1.CustomerID
JOIN Customers C2 ON A2.CustomerID = C2.CustomerID;

-- =====================================================
-- 9. SUBQUERIES
-- =====================================================

-- Q34 Products above average price
SELECT * FROM Products WHERE Price > (SELECT AVG(Price) FROM Products);

-- Q35 Customers who placed orders
SELECT * FROM Customers WHERE CustomerID IN (SELECT CustomerID FROM Orders);

-- Q36 Customers who never placed orders
SELECT * FROM Customers C
WHERE NOT EXISTS (SELECT 1 FROM Orders O WHERE O.CustomerID = C.CustomerID);

-- Q37 Most expensive product
SELECT * FROM Products WHERE Price = (SELECT MAX(Price) FROM Products);

-- Q38 Products costlier than all Books products
SELECT * FROM Products
WHERE Price > ALL (SELECT Price FROM Products WHERE CategoryID = 3);

-- Q39 Customers with orders above 10000
SELECT CustomerName FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE TotalAmount > 10000);

-- Q40 Correlated subquery: Products above their own category's average price
SELECT P.ProductName, P.Price, P.CategoryID
FROM Products P
WHERE P.Price > (SELECT AVG(P2.Price) FROM Products P2 WHERE P2.CategoryID = P.CategoryID);

-- =====================================================
-- 10. NULL VALUE HANDLING
-- =====================================================

-- Q41 Orders without coupons
SELECT * FROM Orders WHERE CouponID IS NULL;

-- Q42 Orders with coupons
SELECT * FROM Orders WHERE CouponID IS NOT NULL;

-- Q43 Display products with stock, replacing missing stock with zero
SELECT P.ProductName, IFNULL(I.Quantity, 0) AS AvailableStock
FROM Products P
LEFT JOIN Inventory I ON P.ProductID = I.ProductID;

-- Q44 Count products without inventory records
SELECT COUNT(*) AS ProductsWithoutInventory
FROM Products P
LEFT JOIN Inventory I ON P.ProductID = I.ProductID
WHERE I.InventoryID IS NULL;

-- =====================================================
-- 11. SET OPERATIONS
-- =====================================================

-- Q45 UNION: Cities without duplicates
SELECT City FROM Addresses
UNION
SELECT City FROM Suppliers;

-- UNION ALL: Cities including duplicates
SELECT City FROM Addresses
UNION ALL
SELECT City FROM Suppliers;

-- INTERSECT equivalent: Common cities
SELECT DISTINCT A.City
FROM Addresses A
INNER JOIN Suppliers S ON A.City = S.City;

-- EXCEPT equivalent: Customer cities not found in supplier cities
SELECT DISTINCT A.City
FROM Addresses A
WHERE NOT EXISTS (SELECT 1 FROM Suppliers S WHERE S.City = A.City);

-- =====================================================
-- 12. VIEWS
-- =====================================================

-- View 1: Customer order details
CREATE VIEW CustomerOrderView AS
SELECT C.CustomerID, C.CustomerName, O.OrderID, O.OrderDate,
       O.TotalAmount, O.OrderStatus
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID;

-- View 2: Products with low stock
CREATE VIEW LowStockView AS
SELECT P.ProductID, P.ProductName, I.Quantity, I.ReorderLevel
FROM Products P
JOIN Inventory I ON P.ProductID = I.ProductID
WHERE I.Quantity < I.ReorderLevel;

-- View 3: Successful payments
CREATE VIEW SuccessfulPaymentView AS
SELECT PaymentID, OrderID, PaymentMethod, Amount, PaymentStatus
FROM Payments
WHERE PaymentStatus = 'Success';

-- Display views
SELECT * FROM CustomerOrderView;
SELECT * FROM LowStockView;
SELECT * FROM SuccessfulPaymentView;

-- =====================================================
-- 13. ADVANCED QUERIES
-- =====================================================

-- Find the customer who placed the maximum orders
SELECT C.CustomerName, COUNT(O.OrderID) AS TotalOrders
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY TotalOrders DESC
LIMIT 1;

-- Find categories with no products
SELECT CAT.CategoryName
FROM Categories CAT
LEFT JOIN Products P ON CAT.CategoryID = P.CategoryID
WHERE P.ProductID IS NULL;

-- Find orders without a shipment
SELECT O.OrderID, O.OrderStatus
FROM Orders O
LEFT JOIN Shipments S ON O.OrderID = S.OrderID
WHERE S.ShipmentID IS NULL;

-- Find total quantity sold for each product
SELECT P.ProductName, SUM(OI.Quantity) AS TotalSold
FROM Products P
JOIN OrderItems OI ON P.ProductID = OI.ProductID
JOIN Orders O ON OI.OrderID = O.OrderID
WHERE O.OrderStatus <> 'Cancelled'
GROUP BY P.ProductID, P.ProductName;

-- Find pending payments
SELECT * FROM Payments WHERE PaymentStatus = 'Pending';

-- Find orders with their shipment tracking details
SELECT O.OrderID, C.CustomerName, S.TrackingNumber, S.CourierName, S.ShipmentStatus
FROM Orders O
JOIN Customers C ON O.CustomerID = C.CustomerID
LEFT JOIN Shipments S ON O.OrderID = S.OrderID;

-- Find total refund amount
SELECT SUM(RefundAmount) AS TotalRefund
FROM Returns
WHERE ReturnStatus = 'Refunded';

-- Find products that have never been ordered
SELECT P.ProductName
FROM Products P
WHERE NOT EXISTS (SELECT 1 FROM OrderItems OI WHERE OI.ProductID = P.ProductID);

-- =====================================================
-- 14. INDEXES
-- =====================================================

CREATE INDEX idx_product_name ON Products(ProductName);
CREATE INDEX idx_order_date ON Orders(OrderDate);
CREATE INDEX idx_order_status ON Orders(OrderStatus);

-- =====================================================
-- 15. TRANSACTION DEMONSTRATION
-- =====================================================

START TRANSACTION;

UPDATE Inventory
SET Quantity = Quantity - 1
WHERE ProductID = 101 AND Quantity > 0;

SELECT * FROM Inventory WHERE ProductID = 101;

ROLLBACK;

-- =====================================================
-- 16. FINAL DATABASE VERIFICATION
-- =====================================================

SHOW TABLES;

SELECT COUNT(*) AS TotalCustomers FROM Customers;
SELECT COUNT(*) AS TotalProducts FROM Products;
SELECT COUNT(*) AS TotalOrders FROM Orders;
SELECT COUNT(*) AS TotalOrderItems FROM OrderItems;
SELECT COUNT(*) AS TotalPayments FROM Payments;
SELECT COUNT(*) AS TotalShipments FROM Shipments;
SELECT COUNT(*) AS TotalReturns FROM Returns;

-- END OF PROJECT