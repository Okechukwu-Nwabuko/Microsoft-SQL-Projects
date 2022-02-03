--DATA VILDATION IN T-SQL:

--CREATING TEMPORARY TABLES:
--SELECT APPROACH:
SELECT BusinessEntityID, PersonType, FirstName, LastName
INTO #Name
FROM [Person].[Person]
ORDER BY BusinessEntityID;

SELECT ProductID, Name AS ProductName, Color, StandardCost, ListPrice, ModifiedDate
INTO #ProducValues
FROM [Production].[Product]
WHERE Color = 'Yellow' 

SELECT PH.PurchaseOrderID, VendorID, OrderDate, ShipDate, SubTotal, TaxAmt, PH.Freight, Orderqty, ProductID, LineTotal, StockedQty
INTO #PurchasingOrder
FROM [Purchasing].[PurchaseOrderHeader] AS PH LEFT JOIN  [Purchasing].[PurchaseOrderDetail] AS PD
ON PH.PurchaseOrderID = PD.PurchaseOrderDetailID
WHERE LineTotal > 20000
ORDER BY LineTotal DESC

--RETRIEVE VALUES FROM #TEMP TABLES:
SELECT *
FROM [dbo].[#ProducValues];

SELECT *
FROM [dbo].[#Name]
ORDER BY PersonType ASC;

SELECT *
FROM [dbo].[#PurchasingOrder];

--DELETE TEMPORARY TABLE:
DROP TABLE IF EXISTS #Name;

DROP TABLE IF EXISTS #PurchasingOrder;


--CREATING VIEWS:
CREATE VIEW EmployeeNames AS
SELECT *
FROM [Person].[Person];

CREATE VIEW ProductDetails AS
SELECT ProductID, Name, ProductNumber, Color
FROM [Production].[Product]
WHERE Color = 'Red'

CREATE VIEW ProductionFullDetails AS 
SELECT PP.ProductID, Name, ProductNumber, Color, Style, PWR.WorkOrderID, OrderQty, StockedQty, ScrappedQty, ScrapReasonID, LocationID, PlannedCost, ActualCost, ActualResourceHrs
FROM[Production].[Product]  AS PP INNER JOIN [Production].[WorkOrder] AS PW
ON PP.ProductID = PW.ProductID
INNER JOIN [Production].[WorkOrderRouting] AS PWR
ON PWR.WorkOrderID = PW.WorkOrderID;
 
--RETRIEVE VIEW VALUES:
SELECT *
FROM EmployeeNames
ORDER BY BusinessEntityID;

SELECT *
FROM ProductDetails;

SELECT *
FROM ProductionFullDetails;

--DELETE VIEW:
DROP VIEW EmployeeNames;

DROP VIEW ProductDetails;

--SUBSTRING:
SELECT SalesOrderID, CarrierTrackingNumber, ProductID, UnitPrice, LineTotal, ModifiedDate,
SUBSTRING(CarrierTrackingNumber, 1, 4) AS CarrierTrackCode
FROM [Sales].[SalesOrderDetail]
ORDER BY CarrierTrackCode ASC; 
 
SELECT BusinessEntityID, AccountNumber, Name, ModifiedDate,
SUBSTRING(AccountNumber, 9, 4) AS AccountCode
FROM [Purchasing].[Vendor]
ORDER BY BusinessEntityID DESC;

SELECT BusinessEntityID, NationalIDNumber, JobTitle, MaritalStatus, OrganizationNode,
SUBSTRING(NationalIDNumber, 5,5) AS NatioanlIDCode
FROM [HumanResources].[Employee];

--SUBQUERIES:
SELECT CustomerID, PersonID, StoreID, AccountNumber, ModifiedDate
FROM [Sales].[Customer]
WHERE TerritoryID IN (SELECT TerritoryID 
FROM [Sales].[SalesTerritory]
WHERE CountryRegionCode = 'US');

SELECT ProductID, Name, ProductNumber, Color, ProductSubcategoryID, ProductModelID
FROM [Production].[Product]
WHERE ProductID IN (SELECT ProductID
FROM [Sales].[SalesOrderDetail]
WHERE UnitPrice > 2000)
ORDER BY ProductModelID ASC;

SELECT PurchaseOrderID, ProductID, DueDate, OrderQty, UnitPrice, LineTotal, ReceivedQty, StockedQty, ModifiedDate
FROM [Purchasing].[PurchaseOrderDetail]
WHERE PurchaseOrderID IN (SELECT PurchaseOrderID 
FROM [Purchasing].[PurchaseOrderHeader]
WHERE  OrderDate = '2013-12-30 00:00:00.000')
ORDER BY  OrderQty DESC;

--JOINS [FULL OUTER, INNER, RIGHT & LEFT]:
--FULL OUTER JOIN:
SELECT PH.PurchaseOrderID, EmployeeID, VendorID, ProductID, OrderDate, ShipDate, DueDate, OrderQty, UnitPrice, TaxAmt, Freight, TotalDue
FROM [Purchasing].[PurchaseOrderHeader] AS PH FULL OUTER JOIN [Purchasing].[PurchaseOrderDetail] AS PD
ON PH.PurchaseOrderID = PD.PurchaseOrderID
ORDER BY TotalDue DESC;

SELECT CustomerID, StoreID, C.TerritoryID, AccountNumber, SalesQuota, Bonus, SalesYTD, SalesLastYear, SP.ModifiedDate
FROM [Sales].[Customer] AS C JOIN [Sales].[SalesPerson] AS SP
ON C.TerritoryID = SP.TerritoryID
WHERE SalesQuota >= 250000;

--FULL OUTER JOIN [MULTIPLE TABLES]:
SELECT P.ProductID,  P.Name, ProductNumber, Color, DaysToManufacture, FinishedGoodsFlag, PP.LocationID, Shelf, Bin, Quantity, L.CostRate, L.Availability, L.ModifiedDate
FROM [Production].[Product] AS P FULL JOIN [Production].[ProductInventory] AS PP
ON P.ProductID = PP.ProductID
FULL JOIN [Production].[Location] AS L 
ON L.LocationID = PP.LocationID;

--INNER JOIN:
SELECT BusinessEntityID, AddressTypeID, A.AddressID, AddressLine1, StateProvinceID, PostalCode, A.ModifiedDate
FROM [Person].[Address] AS A INNER JOIN [Person].[BusinessEntityAddress] AS BA
ON A.AddressID = BA.AddressID
ORDER BY BusinessEntityID ASC;

--INNER JOIN [MULTIPLE TABLES]:
SELECT PP.ProductID, Name, ProductNumber, Color, Style, PWR.WorkOrderID, OrderQty, StockedQty, ScrappedQty, ScrapReasonID, LocationID, PlannedCost, ActualCost, ActualResourceHrs
FROM[Production].[Product]  AS PP INNER JOIN [Production].[WorkOrder] AS PW
ON PP.ProductID = PW.ProductID
INNER JOIN [Production].[WorkOrderRouting] AS PWR
ON PWR.WorkOrderID = PW.WorkOrderID;

--RIGHT JOIN:
SELECT V.BusinessEntityID, AccountNumber, Name,  ProductID, StandardPrice, LastReceiptDate, MaxOrderQty, OnOrderQty
FROM [Purchasing].[ProductVendor] AS V RIGHT JOIN [Purchasing].[Vendor] AS PV
ON V.BusinessEntityID = PV.BusinessEntityID
WHERE OnOrderQty= 3;

--RIGHT JOIN [MULTIPLE TABLES]:
SELECT P.ProductID, PM.NAME, ProductNumber, SafetyStockLevel, ProductSubcategoryID, CatalogDescription, Instructions, P.ProductModelID, StartDate, EndDate, PC.StandardCost
FROM [Production].[Product] AS P RIGHT JOIN  [Production].[ProductModel] AS PM
ON P.ProductModelID = PM .ProductModelID
RIGHT JOIN [Production].[ProductCostHistory] AS PC
ON PC.ProductID = P.ProductID;

--LEFT JOIN:
SELECT P.BusinessEntityID, NationalIDNumber, LoginID, Title, FirstName, MiddleName, LastName,  JobTitle, BirthDate, HireDate, Gender, MaritalStatus
FROM [Person].[Person] AS P LEFT JOIN [HumanResources].[Employee] AS E
ON P.BusinessEntityID = E.BusinessEntityID
ORDER BY BusinessEntityID ASC;

SELECT P.BusinessEntityID, FirstName, MiddleName, LastName, PhoneNumber, PhoneNumberTypeID, PP.ModifiedDate
FROM [Person].[Person] AS P LEFT JOIN [Person].[PersonPhone] AS PP
ON P.BusinessEntityID = PP.BusinessEntityID
ORDER BY PhoneNumberTypeID ASC;

--LEFT JOIN [MULTIPLE TABLES]:
SELECT E.BusinessEntityID,NAME, GroupName, Rate, RateChangeDate, PayFrequency, D.DepartmentID, ShiftID, StartDate, EndDate
FROM [HumanResources].[EmployeePayHistory] AS E LEFT JOIN [HumanResources].[EmployeeDepartmentHistory] AS EH
ON E.BusinessEntityID = EH.BusinessEntityID
LEFT JOIN [HumanResources].[Department] AS D 
ON D. DepartmentID = EH.DepartmentID
WHERE PayFrequency = 2 OR D.DepartmentID = 1;

--JOIN USING GROUP BY FUNCTION:
SELECT SD.SalesOrderID, SUM(UnitPrice) AS UnitPrice , SUM(LineTotal) AS LineTotal, COUNT(SD.SalesOrderID) AS CountSalesOrderID , COUNT(RevisionNumber) AS RevisionNumber, COUNT(PurchaseOrderNumber) AS PurchaseOrderNumber
FROM [Sales].[SalesOrderDetail] AS SD INNER JOIN [Sales].[SalesOrderHeader] AS SH
ON SD.SalesOrderID = SH.SalesOrderID
GROUP BY SD.SalesOrderID;

--GROUP BY FUNCTION:
SELECT SalesOrderID, SUM(UnitPrice) AS UnitPrice, SUM(LineTotal) AS LineTotal
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID;

SELECT SalesOrderID, COUNT(CarrierTrackingNumber) AS CarrierTrackingNumber, SUM(UnitPrice)AS UnitPrice, SUM(LineTotal) AS LineTotal
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID, CarrierTrackingNumber
ORDER BY SalesOrderID;

SELECT PurchaseOrderID, SUM(OrderQty) AS OrderQuantity, SUM(ReceivedQty) AS ReceivedQty, SUM(RejectedQty) AS RejectedQty, SUM(StockedQty) AS StockedQty, SUM(UnitPrice) AS UnitPrice, SUM(LineTotal)AS Total
FROM [Purchasing].[PurchaseOrderDetail]
GROUP BY PurchaseOrderID
ORDER BY Total ASC;

SELECT Color, COUNT(ProductID) AS ProductID, COUNT(Name) AS ProductName, COUNT(ProductNumber) AS ProductNumber, COUNT(SafetyStockLevel) AS SafetyStockLevel
FROM [Production].[Product]
GROUP BY Color;

--HAVING FUNCTION:
SELECT Color, COUNT(ProductID) AS ProductID, COUNT(Name) AS ProductName, COUNT(ProductNumber) AS ProductNumber, COUNT(SafetyStockLevel) AS SafetyStockLevel
FROM [Production].[Product]
GROUP BY Color
HAVING Color IN ('Black', 'Red', 'Silver', 'White', 'Grey');

SELECT SalesOrderID, COUNT(CarrierTrackingNumber) AS CarrierTrackingNumber, COUNT(OrderQty) AS OrderQuantity, SUM(UnitPrice) AS UnitPrice , SUM(LineTotal) AS LineTotal
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID
HAVING SUM(LineTotal) > 1000;

SELECT SalesOrderID, COUNT(CarrierTrackingNumber) AS CarrierTrackingNumber, COUNT(OrderQty) AS OrderQuantity, SUM(UnitPrice) AS UnitPrice , SUM(LineTotal) AS LineTotal
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID
HAVING SUM(LineTotal) BETWEEN 5000 AND 10000
ORDER BY LineTotal DESC;

SELECT JobTitle, MaritalStatus,  COUNT(MaritalStatus) AS CountMaritalStatus, Gender, COUNT(Gender) AS CountGender
FROM[HumanResources].[Employee]
GROUP BY JobTitle, MaritalStatus, Gender
HAVING MaritalStatus IN ('M') AND Gender IN ('F');

--BETWEEN FUNCTION:
SELECT SalesOrderID, SalesOrderNumber, PurchaseOrderNumber, AccountNumber,  OrderDate, DueDate, TotalDue, ModifiedDate
FROM [Sales].[SalesOrderHeader]
WHERE TotalDue BETWEEN 2500 AND 5000;

SELECT SalesOrderID, SalesOrderNumber, PurchaseOrderNumber, AccountNumber, CustomerID, SalesPersonID, OrderDate, DueDate, ShipDate
FROM [Sales].[SalesOrderHeader]
WHERE OrderDate  BETWEEN  '2011-05-31 00:00:00:000' AND '2013-12-27 00:00:00:000' 
ORDER BY SalesOrderID ASC;

--NOT FUNCTION [NOT BETWEEN, NOT IN]:

--NOT BETWEEN FUNCTION:
SELECT BusinessEntityID, TerritoryID, SalesQuota, Bonus, SalesYTD, SalesLastYear, ModifiedDate
FROM [Sales].[SalesPerson]
WHERE SalesYTD NOT BETWEEN 1000000 AND 2000000
ORDER BY SalesYTD DESC;

SELECT CustomerID, StoreID, TerritoryID, AccountNumber, Rowguid, ModifiedDate
FROM [Sales].[Customer]
WHERE TerritoryID NOT BETWEEN 1 AND 4
ORDER BY CustomerID ASC;

--NOT IN FUNCTION:
SELECT CountryRegionCode, Name, ModifiedDate
FROM [Person].[CountryRegion]
WHERE Name NOT IN ('Afghanistan', 'Albania', 'Greece', 'Guam', 'Samoa', 'Yemen')
order by ModifiedDate asc;

SELECT BusinessEntityID, AccountNumber, Name, PurchasingWebServiceURL, CreditRating, ActiveFlag
FROM [Purchasing].[Vendor]
WHERE BusinessEntityID NOT IN (1492, 1504, 1502, 1608, 1614) AND CreditRating NOT IN (1)
ORDER BY BusinessEntityID ASC;

--UPPER CASE FUNCTION:
SELECT BusinessEntityID, AccountNumber, UPPER(Name) AS ProductName
FROM [Purchasing].[Vendor];

SELECT BusinessEntityID, UPPER(Title) AS Title, UPPER(FirstName) AS FirstName, UPPER(MiddleName) AS MiddleName, UPPER(LastName) AS LastName
FROM [Person].[Person]
ORDER BY BusinessEntityID ASC;

--LOWER CASE FUNCTION:
SELECT TerritoryID, LOWER(Name) AS Name, LOWER(CountryRegionCode) AS CountryRegionCode, ModifiedDate
FROM [Sales].[SalesTerritory]
ORDER BY TerritoryID ASC;

SELECT TerritoryID, LOWER(Name) AS Name, LOWER(CountryRegionCode) AS CountryRegionCode, SalesYTD, SalesLastYear, ModifiedDate
FROM [Sales].[SalesTerritory]
ORDER BY CountryRegionCode;

--USING BOTH UPPER & LOWER FUNCTION:
SELECT TerritoryID, UPPER(Name) AS Name, LOWER(CountryRegionCode) AS CountryRegionCode, SalesYTD, SalesLastYear, ModifiedDate
FROM [Sales].[SalesTerritory]
ORDER BY CountryRegionCode ASC;

--CONCATENATE FUNCTION:
SELECT BusinessEntityID, FirstName +' '+ LastName AS FullName
FROM [Person].[Person]
ORDER BY BusinessEntityID ASC;

SELECT AddressID, AddressLine1, City, AddressLine1 +' - '+ City AS FullAddress
FROM [Person].[Address]
ORDER BY AddressID ASC;

--REPLACE FUNCTION:
SELECT BusinessEntityID, NationalIDNumber, JobTitle, REPLACE(MaritalStatus, 'M', 'Married')  AS MaritalStatus, REPLACE(Gender, 'M', 'Male') AS Gender
FROM [HumanResources].[Employee];

SELECT DepartmentID, Name, REPLACE(Name, 'Engineering', 'Eng') AS NewName, GroupName, REPLACE(GroupName, 'Research and Development', 'R&D') AS NewGroupName, ModifiedDate
FROM [HumanResources].[Department]
ORDER BY DepartmentID ASC;

--CASE STATEMENT:
SELECT BusinessEntityID, NationalIDNumber, JobTitle, 
CASE
   WHEN MaritalStatus = 'S' THEN 'Single'
   WHEN MaritalStatus = 'M' THEN 'Married'
   END AS MaritalStatus
FROM [HumanResources].[Employee];

SELECT BusinessEntityID, NationalIDNumber, JobTitle,
CASE
   WHEN Gender = 'F' THEN 'Female'
   WHEN Gender = 'M' THEN 'Male'
   END AS Gender
FROM [HumanResources].[Employee];

SELECT AddressID, AddressLine1, City, 
CASE 
    WHEN AddressLine1 LIKE '%H%' THEN 'Bothel'
	END AS CItyLocation
FROM [Person].[Address]
ORDER BY CItyLocation DESC;








