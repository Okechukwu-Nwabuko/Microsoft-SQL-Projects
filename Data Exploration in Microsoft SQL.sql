--DATA EXPLORATION IN T-SQL:

--CREATING TABLE:
CREATE TABLE
Details(
CustomerID INT Primary key, 
StoreID INT NOT NULL,
SalesPersonID INT NOT NULL,
--AccountNumber VARCHAR (10) NOT NULL,
TerritoryID INT NOT NULL,
ProductID INT Not Null,
Quantity INT NOT NULL,
Amount Int NOT NULL,
TaxAmount INT NOT NULL,
Freight INT NOT NULL,
);

CREATE TABLE 
Description(
ProductID INT Primary Key Not Null,
Name VARCHAR (100) Not Null,
CustomerID INT Not Null,
ProductNumber Varchar (50),
Color Char (20)Not Null,
Style Char (10) Not Null,
ProductModelID INT Not NULL,
UnitPrice INT Not Null,
);

--INSERTING VALUES INTO TABLE:
--Details TABLE:
INSERT INTO Details VALUES
      (1, 1972, 43659, 4, 2064, 50000, 6545754, 3865, 5321),
      (2, 1982, 47045, 1, 4400, 15000, 141500, 1125, 1027),
	  (3, 1984, 40781, 1, 110, 5000, 85000, 1082, 465),
	  (4, 1986, 50204, 10, 655, 124000, 7918, 1525, 308),
	  (5, 1990, 50204, 7, 74, 16000, 68000, 6251, 508),
	  (6, 1992, 52936, 6, 15, 51000, 413000, 2190, 5905),
	  (7, 1934, 55325, 3, 18, 23000, 9100, 1567, 2504);
 
--DESCRIPTIONUNITS TABLE:
INSERT INTO Description VALUES
      --(879, 'Down Tuber', 1, 51098, 'Black', 'Shaped', 5381, 5)
      (783, 'Fork End', 2, 51012, 'Silver', 'Necked', 4564, 32),
	  (886, 'Flat Washer', 3, 51043, 'Black', 'Shaped', 41256, 23),
	  (587, 'Free Wheel', 4, 51098, 'Yellow', 'Shaped', 4572, 93),
	  (439, 'Lock', 5, 51033, 'Green', 'Necked',  41276, 57),
	  (216, 'Lock & Key', 6, 51760, 'Blue', 'Necked', 41237, 35),
	  (720, 'Touring', 7,  53760, 'Yellow', 'Necked', 412367, 93);

--RETRIEVE TABLES:
SELECT *
FROM [dbo].[Details];

SELECT *
FROM [dbo].[Description];

--DELETE TABLES:
DROP TABLE Details;

DROP TABLE Description;

--DELETE COLUMN:
DELETE FROM [dbo].[Details]
WHERE CustomerID = 2;

--DELETE COLUMN:
DELETE FROM [dbo].[Description]
WHERE ProductID = 439;

--SELECT STATEMENT:
SELECT *
FROM [HumanResources].[Employee];

SELECT *
FROM [HumanResources].[Department];

SELECT *
FROM [Production].[Product]
WHERE MakeFlag = 1;

--SELECTING SPECIFIC COLUMNS:
SELECT NationalIDNumber, OrganizationLevel, JobTitle, Gender
FROM [HumanResources].[Employee]
ORDER BY JobTitle;

SELECT Name, ProductNumber, Color
FROM Production.Product;

SELECT CustomerID, SalesOrderID, OrderDate, DueDate, ShipDate, SalesOrderNumber, PurchaseOrderNumber, AccountNumber, SalesPersonID, TotalDue
FROM [Sales].[SalesOrderHeader]
ORDER BY CustomerID;

--REMOVING DUPLICATES [DISTINCT FUNCTION]:
SELECT DISTINCT(Color)
FROM Production.Product;

SELECT DISTINCT(City)
FROM Person.Address
ORDER BY City ASC;

SELECT COUNT(DISTINCT(City)) AS CITY_COUNT
FROM Person.Address;

--SORTING QUERIES [ORDER BY FUNTION (ASCENDING OR DESCENDING)]:
SELECT NAME, ProductNumber, Color, ListPrice
FROM Production.Product
ORDER BY Color ASC;

SELECT CustomerID, PersonID, TerritoryID, AccountNumber, ModifiedDate
FROM [Sales].[Customer]
ORDER BY TerritoryID ASC;

SELECT SalesOrderID, OrderQty,ProductID, UnitPrice, LineTotal
FROM [Sales].[SalesOrderDetail]
ORDER BY OrderQty DESC;

SELECT *
FROM [Purchasing].[PurchaseOrderDetail]
ORDER BY StockedQty DESC;

--SORTING BY MULTIPLE COLUMNS:
SELECT NAME, ProductNumber, Color, ListPrice
FROM Production.Product
ORDER BY Color ASC, ListPrice DESC;

SELECT SalesOrderID, OrderQty,ProductID, UnitPrice, LineTotal
FROM [Sales].[SalesOrderDetail]
ORDER BY OrderQty ASC, LineTotal ASC;

--LIMITED SORTING:
SELECT TOP 100 SalesOrderID, SalesOrderDetailID, OrderQty, ProductID, UnitPrice, LineTotal
FROM [Sales].[SalesOrderDetail]
ORDER BY OrderQty DESC;

SELECT TOP 100 UnitPrice
FROM [Sales].[SalesOrderDetail]
ORDER BY UnitPrice ASC;
 
SELECT DISTINCT TOP 100 UnitPrice, UnitPriceDiscount
FROM Sales.SalesOrderDetail;

SELECT DISTINCT TOP 100 UnitPrice, UnitPriceDiscount
FROM Sales.SalesOrderDetail
ORDER BY UnitPrice DESC;

--LIKE FUNCTION:
SELECT BusinessEntityID, EmailAddressID, EmailAddress, Rowguid, ModifiedDate
FROM [Person].[EmailAddress]
WHERE EmailAddress LIKE 'd%';

SELECT BusinessEntityID, AccountNumber, Name, CreditRating, PurchasingWebServiceURL, ModifiedDate
FROM [Purchasing].[Vendor]
WHERE AccountNumber LIKE '%N%';

SELECT ProductID, Name, ProductNumber, Color, SafetyStockLevel, Rowguid
FROM [Production].[Product]
WHERE Color LIKE 'Bla__';

SELECT StateProvinceID, StateProvinceCode, CountryRegionCode, Name, TerritoryID, ModifiedDate
FROM [Person].[StateProvince]
WHERE CountryRegionCode LIKE '_S';

--USING LIKE FUNCTION INBETWEEN:
SELECT BusinessEntityID, EmailAddressID, EmailAddress, Rowguid
FROM [Person].[EmailAddress]
WHERE EmailAddress LIKE 'd%@adventure-works.com'
ORDER BY EmailAddressID ASC;

--AS FUNCTION:
SELECT BillOfMaterialsID, ISNULL(ProductAssemblyID, 0) AS ProductAssemblyID, ComponentID, UnitMeasureCode, ModifiedDate
FROM [Production].[BillOfMaterials]
ORDER BY BillOfMaterialsID;

SELECT SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber,ProductID, (OrderQty * UnitPrice) AS TotalSales
FROM [Sales].[SalesOrderDetail]
ORDER BY SalesOrderID;

--OR FUNCTION:
SELECT PurchaseOrderID, RevisionNumber, Status, EmployeeID, VendorID, SubTotal, TotalDue
FROM [Purchasing].[PurchaseOrderHeader]
WHERE RevisionNumber = 4 OR EmployeeID = 256
ORDER BY PurchaseOrderID ASC;

SELECT SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber ProductID, UnitPrice, LineTotal, ModifiedDate
FROM [Sales].[SalesOrderDetail]
WHERE SalesOrderID = 43659 OR CarrierTrackingNumber = '30BA-400A-89';

SELECT ProductID, AverageLeadTime, StandardPrice, LastReceiptCost, LastReceiptDate, MinOrderQty, MaxOrderQty, OnOrderQty
FROM [Purchasing].[ProductVendor]
WHERE AverageLeadTime = 17 OR LastReceiptCost > 40;

--OR WITH AND FUNCTION:
SELECT BusinessEntityID, PersonType, Title, FirstName, MiddleName, LastName, Demographics
FROM [Person].[Person]
WHERE PersonType = 'EM' OR PersonType = 'IN'
AND Title = 'NULL';

SELECT ProductID, AverageLeadTime, StandardPrice, LastReceiptCost, LastReceiptDate, MinOrderQty, MaxOrderQty, OnOrderQty
FROM [Purchasing].[ProductVendor]
WHERE AverageLeadTime = 17 OR MaxOrderQty = 5
AND OnOrderQty = 3;

--IN FUNCTION:
SELECT CreditCardID, CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate
FROM [Sales].[CreditCard]
WHERE ExpYear IN ( 2005, 2007, 2008);

SELECT BusinessEntityID, PersonType, Title, FirstName, LastName, Suffix, ModifiedDate
FROM [Person].[Person]
WHERE PersonType IN ('EM','IN');

--IN WITH AND FUNCTION:
SELECT CreditCardID, CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate
FROM [Sales].[CreditCard]
WHERE ExpYear IN ( 2005, 2007, 2008) AND CardType IN ('Distinguish', 'Vista', 'SuperiorCard');

SELECT BusinessEntityID, TerritoryID, SalesQuota, Bonus, SalesYTD, SalesLastYear, Rowguid
FROM [Sales].[SalesPerson]
WHERE TerritoryID IN (1) AND SalesYTD > 50000
ORDER BY BusinessEntityID ASC;

--IN WITH OR FUNCTION:
SELECT BusinessEntityID, TerritoryID, SalesQuota, Bonus, SalesYTD, SalesLastYear, Rowguid
FROM [Sales].[SalesPerson]
WHERE TerritoryID IN (1) OR SalesLastYear < 14000
ORDER BY BusinessEntityID DESC;

SELECT CreditCardID, CardType, CardNumber, ExpMonth, ExpYear, ModifiedDate
FROM [Sales].[CreditCard]
WHERE ExpYear IN ( 2005, 2007, 2008) OR CardType = 'SuperiorCard'
ORDER BY ExpYear DESC;

--NOT IN FUNCTION:
SELECT SalesOrderID, CarrierTrackingNumber, OrderQty, ProductID, UnitPrice, LineTotal
FROM [Sales].[SalesOrderDetail]
WHERE SalesOrderID NOT IN (43659); 

SELECT WorkOrderID, ProductID, OrderQty, StockedQty, ScrappedQty, ScrapReasonID
FROM [Production].[WorkOrder]
WHERE OrderQty NOT IN (1, 3) AND StockedQty NOT IN (4);

--FILTERING STATEMENT [WHERE STATEMENT]:
SELECT *
FROM [HumanResources].[Employee]
WHERE JobTitle = 'Research and Development Manager';

SELECT ProductID, BusinessEntityID, AverageLeadTime, StandardPrice, MinOrderQty, MaxOrderQty, UnitMeasureCode
FROM [Purchasing].[ProductVendor]
WHERE AverageLeadTime = 17
ORDER BY ProductID ASC;

 --USING LIKE AND WHERE STATEMENT:
SELECT *
FROM [HumanResources].[Employee]
WHERE JobTitle LIKE 'Research%';

SELECT FirstName, MiddleName, LastName
FROM [Person].[Person]
WHERE MiddleName LIKE 'J%';

SELECT FirstName, MiddleName, LastName
FROM [Person].[Person]
WHERE MiddleName LIKE 'J%' AND LastName LIKE 'Se%';

--NULL VALUES:
SELECT ProductID, ProductNumber, Color, ProductSubcategoryID,ProductModelID
FROM [Production].[Product]
WHERE Color IS NULL;

SELECT CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, Rowguid, ModifiedDate
FROM [Sales].[Customer]
WHERE PersonID IS NULL
ORDER BY TerritoryID ASC;

--REPLACING NULL VALUES:
SELECT NAME, ProductNumber, ISNULL(Color, 'Green') AS Color,  ISNULL(Size, 'None') AS Size, 
ISNULL(ProductSubcategoryID, 0) as ProductSubcategoryID, Rowguid, ModifiedDate
FROM [Production].[Product]
ORDER BY NAME ASC, Color ASC;

SELECT BusinessEntityID, ISNULL(TerritoryID, 0) AS TerritoryID, ISNULL(SalesQuota, 0) AS SalesQuota, Bonus, SalesYTD, SalesLastYear, ModifiedDate
FROM [Sales].[SalesPerson] 
ORDER BY BusinessEntityID ASC;

--NULLIF FUNCTION:
SELECT Name, ProductNumber, NULLIF(Color, 'Black') AS Color, ProductSubcategoryID, SellStartDate, SellEndDate
FROM [Production].[Product]
WHERE Color = 'Black';

SELECT SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, NULLIF(ProductID, 776) AS ProductID,
UnitPrice, UnitPriceDiscount, LineTotal, Rowguid
FROM [Sales].[SalesOrderDetail]
WHERE ProductID = 776
ORDER BY SalesOrderID DESC;

--AGGREGRATE FUNCTIONS[SUM, AVG, MIN, MAX]:

--SUM FUNCTION:
SELECT SUM(ROUND(SubTotal,0)) AS TotalSales
FROM [Sales].[SalesOrderHeader];

SELECT SUM(LineTotal) AS TotalAmount
FROM [Sales].[SalesOrderDetail];

--AVERAGE FUNCTION:
SELECT AVG(ROUND(TaxAmt,1)) AS AverageTaxAmount
FROM [Sales].[SalesOrderHeader];

--MAX FUNCTION:
SELECT MAX(SalesYTD) AS SalesYTD
FROM [Sales].[SalesPerson];

SELECT MAX(Rate) AS HighestPayRate
FROM [HumanResources].[EmployeePayHistory];

--MIN FUNCTION:
SELECT MIN(CostRate) AS CostRate
FROM [Production].[Location];

SELECT MIN(TotalDue) AS MinTotalAmount
FROM [Sales].[SalesOrderHeader];

--COUNT FUNCTION:
SELECT COUNT(Color) AS ColorCount
FROM [Production].[Product];

SELECT COUNT(NAME) AS NameCount
FROM [Production].[Product];

--COUNT DISTINCT:
SELECT COUNT(DISTINCT Color) AS ColorCount
FROM [Production].[Product];

SELECT COUNT(DISTINCT SalesOrderID) SalesCount
FROM [Sales].[SalesOrderDetail];

--TOP FUNCTION:
SELECT TOP 1000 SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber, OrderQty, UnitPrice, LineTotal, Rowguid
FROM [Sales].[SalesOrderDetail]
ORDER BY SalesOrderID ASC;

SELECT TOP 500 ProductID, NAME, ProductNumber, Color, Size,ProductSubcategoryID, ModifiedDate
FROM [Production].[Product]
ORDER BY ProductID DESC;

SELECT DISTINCT TOP 2000 SalesOrderID, OrderQty, ProductID, UnitPrice, LineTotal
FROM [Sales].[SalesOrderDetail]
ORDER BY LineTotal DESC;

  


   