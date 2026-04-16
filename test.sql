CREATE DATABASE ShopDB;
GO

USE ShopDB;
GO


-- TABLES

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplyName NVARCHAR(100),
    ContactPerson NVARCHAR(100),
    Address NVARCHAR(200),
    ContactPhone NVARCHAR(15),
    ContactEmail NVARCHAR(100)
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(200)
);

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100),
    ContactPhone NVARCHAR(15),
    Address NVARCHAR(200),
    Sex NVARCHAR(10),
    DateWork DATE
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    ContactPhone NVARCHAR(15),
    Address NVARCHAR(200),
    Sex NVARCHAR(10)
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    PaymentName NVARCHAR(100)
);

CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Description NVARCHAR(200),
    Quantity INT,
    PricePerProduct FLOAT,
    PriceImport FLOAT,
    CategoryID INT,
    SupplierID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE Import (
    ImportID INT PRIMARY KEY,
    DateImport DATE,
    EmployeeID INT,
    SupplierID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE ImportDetails (
    ImportID INT,
    ProductID INT,
    QuantityProducts INT,
    PRIMARY KEY (ImportID, ProductID),
    FOREIGN KEY (ImportID) REFERENCES Import(ImportID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Bill (
    BillID INT PRIMARY KEY,
    Date DATE,
    EmployeeID INT,
    CustomerID INT,
    PaymentID INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);

CREATE TABLE BillDetails (
    BillID INT,
    ProductID INT,
    QuantityProducts INT,
    PRIMARY KEY (BillID, ProductID),
    FOREIGN KEY (BillID) REFERENCES Bill(BillID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
-- Data

-- Suppliers
INSERT INTO Suppliers VALUES
(1,N'NCC A',N'A','HN','0901','a@gmail.com'),
(2,N'NCC B',N'B','HCM','0902','b@gmail.com'),
(3,N'NCC C',N'C','DN','0903','c@gmail.com');

-- Categories
INSERT INTO Categories VALUES
(1,N'Đồ uống',N'Uống'),
(2,N'Đồ ăn',N'Ăn'),
(3,N'VPP',N'Học tập');

-- Employee
INSERT INTO Employee VALUES
(1,N'NV1','0909',N'HN',N'Nam','2023-01-01'),
(2,N'NV2','0910',N'HCM',N'Nữ','2023-02-01'),
(3,N'NV3','0911',N'DN',N'Nam','2023-03-01');

-- Customer
INSERT INTO Customer VALUES
(1,N'KH1','0991',N'HN',N'Nam'),
(2,N'KH2','0992',N'HCM',N'Nữ'),
(3,N'KH3','0993',N'DN',N'Nam');

-- Payment
INSERT INTO Payment VALUES
(1,N'Tiền mặt'),
(2,N'Chuyển khoản'),
(3,N'Ví');

-- Product
INSERT INTO Product VALUES
(1,N'Coca',N'Nuoc',100,10000,7000,1,1),
(2,N'Pepsi',N'Nuoc',200,9000,6000,1,1),
(3,N'Burger',N'An',50,30000,20000,2,2),
(4,N'Bút',N'VPP',500,5000,2000,3,3),
(5,N'Vở',N'VPP',300,10000,7000,3,3);

-- Import
INSERT INTO Import VALUES
(1,'2025-01-01',1,1),
(2,'2025-01-02',2,2);

-- ImportDetails
INSERT INTO ImportDetails VALUES
(1,1,50),
(1,2,70),
(2,3,20),
(2,4,100);

-- Bill
INSERT INTO Bill VALUES
(1,'2025-01-05',1,1,1),
(2,'2025-01-06',2,2,2),
(3,'2025-01-07',3,3,3);

-- BillDetails
INSERT INTO BillDetails VALUES
(1,1,2),
(1,2,1),
(2,3,2),
(2,4,5),
(3,5,3);


-- Xem tất cả sản phẩm
SELECT * FROM Product;

-- Join full hóa đơn
SELECT 
    b.BillID,
    c.CustomerName,
    e.EmployeeName,
    p.PaymentName,
    b.Date
FROM Bill b
JOIN Customer c ON b.CustomerID = c.CustomerID
JOIN Employee e ON b.EmployeeID = e.EmployeeID
JOIN Payment p ON b.PaymentID = p.PaymentID;

-- Chi tiết hóa đơn + tiền
SELECT 
    pr.ProductName,
    bd.QuantityProducts,
    pr.PricePerProduct,
    bd.QuantityProducts * pr.PricePerProduct AS Total
FROM BillDetails bd
JOIN Product pr ON bd.ProductID = pr.ProductID;

-- Tổng doanh thu
SELECT SUM(bd.QuantityProducts * pr.PricePerProduct) AS Revenue
FROM BillDetails bd
JOIN Product pr ON bd.ProductID = pr.ProductID;