/*
================================================================================
Database Project: Shipping & Logistics Management System (ShippingDB)
Description: Multi-schema T-SQL database modeling retail and logistics operations.
================================================================================
*/

-- 1. DATABASE ENVIRONMENT SETUP

CREATE DATABASE ShippingDB;
GO

USE ShippingDB;
GO


-- 2. SCHEMA DEFINITIONS

CREATE SCHEMA Sales;
GO
CREATE SCHEMA Logistics;
GO

-- 3. TABLE STRUCTURES & RELATIONSHIPS

-- TABLE 1: Sales.Customers
CREATE TABLE Sales.Customers (
    CustomerID   INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100) NOT NULL,
    Email        VARCHAR(100) NULL,
    Phone        VARCHAR(20)  NULL,
    City         VARCHAR(50)  NULL,
    Country      VARCHAR(50)  NULL
);

-- TABLE 2: Sales.Products
CREATE TABLE Sales.Products (
    ProductID   INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category    VARCHAR(50)  NULL,
    WeightKG    DECIMAL(6,2) NULL,
    PriceUSD    DECIMAL(10,2)NULL
);

-- TABLE 3: Logistics.Warehouses
CREATE TABLE Logistics.Warehouses (
    WarehouseID   INT PRIMARY KEY IDENTITY(1,1),
    WarehouseName VARCHAR(100) NOT NULL,
    City          VARCHAR(50)  NULL,
    Country       VARCHAR(50)  NULL,
    Capacity      INT          NULL
);

-- TABLE 4: Logistics.Drivers
CREATE TABLE Logistics.Drivers (
    DriverID   INT PRIMARY KEY IDENTITY(1,1),
    DriverName VARCHAR(100) NOT NULL,
    Phone      VARCHAR(20)  NULL,
    LicenseNo  VARCHAR(50)  NULL,
    Status     VARCHAR(20)  NOT NULL DEFAULT 'Available'
);

-- TABLE 5: Logistics.Vehicles
CREATE TABLE Logistics.Vehicles (
    VehicleID      INT PRIMARY KEY IDENTITY(1,1),
    RegistrationNo VARCHAR(30)  NOT NULL,
    VehicleType    VARCHAR(30)  NULL,
    CapacityKG     DECIMAL(10,2)NULL,
    Status         VARCHAR(20)  NOT NULL DEFAULT 'Available',
    DriverID       INT          NULL FOREIGN KEY REFERENCES Logistics.Drivers(DriverID)
);

-- TABLE 6: Sales.Orders
CREATE TABLE Sales.Orders (
    OrderID       INT PRIMARY KEY IDENTITY(1,1),
    CustomerID    INT           NOT NULL FOREIGN KEY REFERENCES Sales.Customers(CustomerID),
    ProductID     INT           NOT NULL FOREIGN KEY REFERENCES Sales.Products(ProductID),
    Quantity      INT           NOT NULL,
    OrderDate     DATE          NOT NULL DEFAULT GETDATE(),
    TotalValueUSD DECIMAL(10,2) NULL,
    Status        VARCHAR(30)   NOT NULL DEFAULT 'Pending'
);

-- TABLE 7: Logistics.Shipments
CREATE TABLE Logistics.Shipments (
    ShipmentID        INT PRIMARY KEY IDENTITY(1,1),
    OrderID           INT           NOT NULL FOREIGN KEY REFERENCES Sales.Orders(OrderID),
    VehicleID         INT           NOT NULL FOREIGN KEY REFERENCES Logistics.Vehicles(VehicleID),
    WarehouseID       INT           NOT NULL FOREIGN KEY REFERENCES Logistics.Warehouses(WarehouseID),
    TrackingNumber    VARCHAR(50)   NOT NULL UNIQUE,
    ShipmentDate      DATE          NULL,
    EstimatedDelivery DATE          NULL,
    ActualDelivery    DATE          NULL,
    FreightCostUSD    DECIMAL(10,2) NULL,
    Status            VARCHAR(30)   NOT NULL DEFAULT 'Pending'
);
GO

-- 4. SEED DATA INSERTIONS

INSERT INTO Sales.Customers (CustomerName, Email, Phone, City, Country) VALUES
('Raj Traders',   'raj@traders.in',   '9876543210', 'Chennai',   'India'),
('Gulf Imports',  'info@gulf.ae',     '0501234567', 'Dubai',     'UAE'),
('FastShip USA',  'ops@fastship.us',  '3125550100', 'Chicago',   'USA'),
('Euro Goods',    'buy@eurogoods.de', '3012345678', 'Berlin',    'Germany'),
('Pacific Deals', 'pd@pacific.sg',    '6512345678', 'Singapore', 'Singapore');

INSERT INTO Sales.Products (ProductName, Category, WeightKG, PriceUSD) VALUES
('Laptop',           'Electronics',  2.0,  800.00),
('Industrial Motor', 'Machinery',   50.0, 3000.00),
('Cotton Fabric',    'Textiles',    10.0,  150.00),
('Medicine Box',     'Pharma',       1.5,  500.00),
('Car Brake Kit',    'Automotive',  12.0,  250.00);

INSERT INTO Logistics.Warehouses (WarehouseName, City, Country, Capacity) VALUES
('Chennai Hub',        'Chennai',   'India',     5000),
('Dubai Logistics',    'Dubai',     'UAE',       8000),
('Chicago Central',    'Chicago',   'USA',       6000),
('Singapore Port WH',  'Singapore', 'Singapore', 7500);

INSERT INTO Logistics.Drivers (DriverName, Phone, LicenseNo, Status) VALUES
('Murugan S',    '9876501234', 'TN-001-2023', 'Available'),
('James Carter', '3125559876', 'IL-556-2022', 'On Trip'),
('Khalid Rashid','509876543',  'UAE-334-2021','Available'),
('Priya Sharma', '9812309876', 'TN-012-2022', 'Available');

INSERT INTO Logistics.Vehicles (RegistrationNo, VehicleType, CapacityKG, Status, DriverID) VALUES
('TN-01-AB-1234', 'Truck', 10000,  'Available',  1),
('IL-5678-TRK',   'Truck', 15000,  'In Transit', 2),
('UAE-7890-VAN',  'Van',    2000,  'Available',  3),
('SG-SHIP-001',   'Ship',  500000, 'Available',  NULL);

INSERT INTO Sales.Orders (CustomerID, ProductID, Quantity, OrderDate, TotalValueUSD, Status) VALUES
(1, 1, 10, '2024-06-01', 8000.00, 'Delivered'),
(2, 2,  2, '2024-06-03', 6000.00, 'Shipped'),
(3, 4,  5, '2024-06-07', 2500.00, 'Pending'),
(4, 3, 20, '2024-06-10', 3000.00, 'Pending'),
(5, 5,  8, '2024-06-12', 2000.00, 'Delivered'),
(1, 5,  3, '2024-06-15',  750.00, 'Shipped'),
(3, 1,  4, '2024-06-18', 3200.00, 'Cancelled');

INSERT INTO Logistics.Shipments (OrderID, VehicleID, WarehouseID, TrackingNumber, ShipmentDate, EstimatedDelivery, ActualDelivery, FreightCostUSD, Status) VALUES
(1, 1, 1, 'TRK-2024-001', '2024-06-02', '2024-06-05', '2024-06-05', 120.00,  'Delivered'),
(2, 4, 2, 'TRK-2024-002', '2024-06-04', '2024-06-18',  NULL,        2500.00, 'In Transit'),
(5, 3, 4, 'TRK-2024-003', '2024-06-13', '2024-06-16', '2024-06-17', 180.00,  'Delivered'),
(6, 1, 1, 'TRK-2024-004', '2024-06-16', '2024-06-19',  NULL,         95.00,  'In Transit');
GO

-- 5. REPORTING PACK & ANALYTICAL QUERIES

-- Q1: All orders with customer and product details
SELECT
    o.OrderID,
    c.CustomerName,
    c.Country,
    p.ProductName,
    p.Category,
    o.Quantity,
    o.TotalValueUSD,
    o.OrderDate,
    o.Status
FROM Sales.Customers c
INNER JOIN Sales.Orders o   ON c.CustomerID = o.CustomerID
INNER JOIN Sales.Products p ON p.ProductID  = o.ProductID
ORDER BY o.OrderDate DESC;

-- Q2: All shipments with full details
SELECT
    s.TrackingNumber,
    c.CustomerName,
    c.Country,
    p.ProductName,
    v.VehicleType,
    d.DriverName,
    w.WarehouseName,
    s.ShipmentDate,
    s.EstimatedDelivery,
    s.ActualDelivery,
    s.FreightCostUSD,
    s.Status
FROM Logistics.Shipments s
INNER JOIN Sales.Orders o       ON s.OrderID     = o.OrderID
INNER JOIN Sales.Customers c    ON o.CustomerID  = c.CustomerID
INNER JOIN Sales.Products p     ON o.ProductID   = p.ProductID
INNER JOIN Logistics.Vehicles v     ON s.VehicleID   = v.VehicleID
INNER JOIN Logistics.Warehouses w   ON s.WarehouseID = w.WarehouseID
LEFT JOIN  Logistics.Drivers d    ON v.DriverID    = d.DriverID;

-- Q3: On Time or Delayed? (CASE + DATEDIFF)
SELECT
    s.TrackingNumber,
    c.CustomerName,
    s.ShipmentDate,
    s.EstimatedDelivery,
    s.ActualDelivery,
    CASE 
        WHEN s.ActualDelivery IS NULL THEN 'Not Yet Delivered'
        WHEN s.ActualDelivery <= s.EstimatedDelivery THEN 'On Time'
        WHEN DATEDIFF(DAY, s.EstimatedDelivery, s.ActualDelivery) <= 2 THEN 'Slightly Late'
        ELSE 'Delayed'
    END AS DeliveryPerformance
FROM Logistics.Shipments s
INNER JOIN Sales.Orders o    ON s.OrderID    = o.OrderID
INNER JOIN Sales.Customers c ON o.CustomerID = c.CustomerID;

-- Q4: Total revenue per customer
SELECT
    c.CustomerName,
    c.Country,
    COUNT(o.OrderID)     AS TotalOrders,
    SUM(o.TotalValueUSD) AS TotalRevenue
FROM Sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
WHERE o.Status != 'Cancelled'
GROUP BY c.CustomerName, c.Country
ORDER BY TotalRevenue DESC;

-- Q5: Orders count by status
SELECT 
    Status, 
    COUNT(*) AS TotalOrders
FROM Sales.Orders
GROUP BY Status;

-- Q6: Vehicles currently In Transit
SELECT 
    v.RegistrationNo,
    v.VehicleType,
    d.DriverName,
    v.Status,
    s.TrackingNumber,
    s.ShipmentDate,
    s.EstimatedDelivery
FROM Logistics.Vehicles v
LEFT JOIN Logistics.Shipments s ON v.VehicleID = s.VehicleID
LEFT JOIN Logistics.Drivers d   ON v.DriverID  = d.DriverID
WHERE v.Status = 'In Transit';

-- Q7: Best selling product category
SELECT 
    p.Category,
    COUNT(o.OrderID)     AS TotalOrders,
    SUM(o.Quantity)      AS TotalUnitsSold,
    SUM(o.TotalValueUSD) AS TotalSales
FROM Sales.Products p
INNER JOIN Sales.Orders o ON p.ProductID = o.ProductID
GROUP BY p.Category
ORDER BY TotalSales DESC;


-- Q8: Freight cost and shipments per warehouse
SELECT
    w.WarehouseName,
    w.City,
    COUNT(s.ShipmentID)   AS TotalShipments,
    SUM(s.FreightCostUSD) AS TotalFreightCost
FROM Logistics.Shipments s 
INNER JOIN Logistics.Warehouses w ON s.WarehouseID = w.WarehouseID
GROUP BY w.WarehouseName, w.City
ORDER BY TotalFreightCost DESC;
GO


-- 6. ANALYTICAL VIEWS
-- View: Complete Shipment Dashboard

CREATE VIEW Logistics.vw_ShipmentOverview AS
SELECT
    s.TrackingNumber,
    c.CustomerName,
    c.Country          AS CustomerCountry,
    p.ProductName,
    o.Quantity,
    o.TotalValueUSD,
    w.WarehouseName    AS ShippedFrom,
    v.VehicleType,
    d.DriverName,
    s.ShipmentDate,
    s.EstimatedDelivery,
    s.ActualDelivery,
    s.FreightCostUSD,
    s.Status
FROM Logistics.Shipments s
INNER JOIN Sales.Orders     o ON s.OrderID     = o.OrderID
INNER JOIN Sales.Customers  c ON o.CustomerID  = c.CustomerID
INNER JOIN Sales.Products   p ON o.ProductID   = p.ProductID
INNER JOIN Logistics.Vehicles   v ON s.VehicleID   = v.VehicleID
INNER JOIN Logistics.Warehouses w ON s.WarehouseID = w.WarehouseID
LEFT JOIN  Logistics.Drivers    d ON v.DriverID    = d.DriverID;
GO


-- 7. VIEW VALIDATION EXAMPLES
SELECT * FROM Logistics.vw_ShipmentOverview;
SELECT * FROM Logistics.vw_ShipmentOverview WHERE Status = 'In Transit';
SELECT * FROM Logistics.vw_ShipmentOverview WHERE CustomerCountry = 'India';
GO