--Maths Operation in T-SQL:

--CALCULATE QUANTITY ORDERED:
SELECT SalesOrderID, ProductID, UnitPrice, (LineTotal), (LineTotal/UnitPrice) AS QuantityOrdered, ModifiedDate
FROM [Sales].[SalesOrderDetail]
WHERE LineTotal > 1500
ORDER BY QuantityOrdered DESC;

--GROUP QUANTITY ORDERED INTO SEGMENTS [LOW VALUE, MEDIUM VALUE, HIGH VALUE]
SELECT SalesOrderID, ProductID, UnitPrice, (LineTotal), (LineTotal/UnitPrice) AS QuantityOrdered, ModifiedDate,
CASE 
    WHEN (LineTotal/UnitPrice) BETWEEN 1 AND 10 THEN 'Low Value'
	WHEN (LineTotal/UnitPrice) BETWEEN 10 AND 20 THEN 'Medium Value'
	ELSE 'High Value'
	END AS QuantitySegment
FROM [Sales].[SalesOrderDetail]
--WHERE LineTotal > 1500
ORDER BY QuantityOrdered DESC;

--CALCULATE DAYS TO SHIP PRODUCT ORDERED:
SELECT SalesOrderID, SalesPersonID,CustomerID,  SalesOrderNumber, PurchaseOrderNumber, AccountNumber,OrderDate, ShipDate,
DAY(ShipDate - OrderDate) AS DaysToShip
FROM [Sales].[SalesOrderHeader];

--COUNT OF  DISTINCT SALES:
SELECT COUNT (DISTINCT SalesOrderID) AS CountOfSales
FROM [Sales].[SalesOrderDetail];

--COUNT OF  TOTAL SALES:
SELECT COUNT(SalesOrderID) AS CountOfSales
FROM [Sales].[SalesOrderDetail];

--COUNT OF  DISTINCT PAYMENTS:
SELECT COUNT(DISTINCT LineTotal) AS Payments
FROM [Sales].[SalesOrderDetail];

--COUNT OF PAYMENTS:
SELECT COUNT(LineTotal) AS Payments
FROM [Sales].[SalesOrderDetail];

--LIST OF PAYMENT AMOUNTS:
SELECT DISTINCT (LineTotal) AS Payments
FROM [Sales].[SalesOrderDetail]
ORDER BY Payments DESC;

--CALCULATE TOTAL PAYMENT:
SELECT SUM(LineTotal) AS TotalPayment
FROM [Sales].[SalesOrderDetail];

--COUNT OF PRODUCTS PRODUCED:
SELECT COUNT(Name) AS CountOfProducts
FROM Production.Product;

--CALCULATE PROFIT FOR ALL PRODUCTS:
SELECT P.ProductID, ProductNumber, Name, Color, SUM(StandardCost) AS StandardCost, 
SUM(UnitPrice) AS UnitPrice, SUM(UnitPrice-StandardCost) AS Profit
FROM [Production].[Product] AS P FULL JOIN [Sales].[SalesOrderDetail] AS S
ON P.ProductID = S.ProductID
GROUP BY P.ProductID, Color, ProductNumber, Name
ORDER BY Profit DESC;

--CALCULATE TOTAL COST OF PRODUCTION, BASED ON QUANTITY PRODUCED:
SELECT PI.ProductID, ProductNumber,Name,  Color, SUM(Quantity) AS Quantity 
,SUM(StandardCost) AS StandardCost, SUM(Quantity*StandardCost) AS ProductionCost
FROM [Production].[ProductInventory] AS PI INNER JOIN [Production].[Product] AS PP
ON PI.ProductID = PP.ProductID
GROUP BY PI.ProductID, Color, ProductNumber, Name
ORDER BY ProductionCost DESC;

--COUNT OF PRODUCTS BASED ON PRODUCT MODEL:
SELECT PS.Name AS ProductModelName, COUNT(PP.NAME) AS CountOfProducts
FROM [Production].[ProductSubcategory] AS PS INNER JOIN [Production].[Product] AS PP
ON PS.ProductSubcategoryID = PP.ProductSubcategoryID
GROUP BY PS.Name
ORDER BY ProductModelName ASC;

--CALCULATE AVERAGE AMOUNT FOR [SubTotal, TaxAmt, Freight, TotalDue]:
SELECT SalesOrderID, SalesOrderNumber, AccountNumber, CustomerID, AVG(SubTotal) AS AvgSubTotal, 
AVG(TaxAmt) AS AvgTaxAmt, AVG(Freight) AS AvgFreight, AVG(TotalDue) AS AvgTotalDue, ModifiedDate
FROM [Sales].[SalesOrderHeader]
GROUP BY SalesOrderID, SalesOrderNumber, AccountNumber, CustomerID, ModifiedDate
ORDER BY SalesOrderID ASC;

--CALCULATE SALES DIFFERENCE BASED ON TERRITORY TO DETECT INCREASE OR DECREASE:
SELECT TerritoryID, Name, CountryRegionCode, SalesYTD, SalesLastYear, (SalesYTD-SalesLastYear) AS SalesDifference
FROM [Sales].[SalesTerritory]
ORDER BY SalesDifference DESC;

--CALCULATE SALES PERCENTAGE DIFFERENCE(%) BASED ON TERRITORY:
SELECT TerritoryID, Name, CountryRegionCode, SalesYTD, SalesLastYear, (SalesYTD-SalesLastYear) AS SalesDifference, ((SalesYTD - SalesLastYear)/SalesLastYear)*100 AS SalesPercentage
FROM [Sales].[SalesTerritory]
ORDER BY SalesPercentage DESC;

--CALCULATE SALES TARGET ACHIEVEMENT BY REGION:
SELECT ST.TerritoryID, Name, CountryRegionCode, BusinessEntityID, SP.SalesYTD, SalesQuota, (SP.SalesYTD - SalesQuota) AS TargetAchievement
FROM [Sales].[SalesTerritory] AS ST INNER JOIN [Sales].[SalesPerson] AS SP
ON ST.TerritoryID = SP.TerritoryID
ORDER BY TargetAchievement DESC;

--CALCULATE SALES TARGET ACHIEVEMENT % BY REGION:
SELECT ST.TerritoryID, Name, CountryRegionCode, BusinessEntityID, SP.SalesYTD, SalesQuota, ((SP.SalesYTD - SalesQuota)/SalesQuota)*100 AS TargetAchievement
FROM [Sales].[SalesTerritory] AS ST INNER JOIN [Sales].[SalesPerson] AS SP
ON ST.TerritoryID = SP.TerritoryID
ORDER BY TargetAchievement DESC;

--COUNT OF EMPLOYEES:
SELECT 
CASE  
    WHEN Gender = 'F' THEN 'Female'
	 Else 'Male'
	 END
	 Gender, COUNT(Gender) AS CountOfEmployees
FROM [HumanResources].[Employee]
GROUP BY Gender
ORDER BY CountOfEmployees ASC;

--COUNT OF EMPLOYEES BY JOB TITLE:
SELECT JobTitle, COUNT(JobTitle) AS CountOfJobTitle
FROM [HumanResources].[Employee]
GROUP BY JobTitle
ORDER BY JobTitle ASC;

--COUNT OF TOTAL EMPLOYEES:
SELECT COUNT(JobTitle) AS TotalEmployees
FROM [HumanResources].[Employee];

-- GROUP JOB TITLE BASED ON COUNT OF GENDER & MARITAL STATUS:
SELECT JobTitle, Gender, COUNT(Gender) AS CountOfEmployees, MaritalStatus,
CASE 
    WHEN Gender = 'F' THEN 'Female'
	WHEN Gender  = 'M' THEN 'Male'
	WHEN MaritalStatus = 'S' THEN 'Single'
	WHEN MaritalStatus = 'M' THEN 'Married'
	 END  AS Gender
FROM [HumanResources].[Employee]
GROUP BY JobTitle, Gender, MaritalStatus;

-- GROUP JOB TITLE BASED ON COUNT OF GENDER & MARITAL STATUS:
SELECT JobTitle,  MaritalStatus, COUNT(Gender) AS CountOfEmployees,
CASE 
    WHEN Gender = 'F' THEN 'Female'
	ELSE 'Male'
	 END  AS Gender
FROM [HumanResources].[Employee]
GROUP BY JobTitle, Gender, MaritalStatus;

--CONCATENATE FUNCTION
SELECT BusinessEntityID, FirstName + ' ' + LastName AS FullName
FROM [Person].[Person];

SELECT (Name+' - ' + ProductNumber) AS ProductDetails
FROM [Production].[Product]
 
--RETRIEVE INFORMATION ABOUT PRODUCTS WITH COLOR VALUES EXCEPT NULL, RED, SILVER, BLACK & LIST PRICE BETWEEN $75 & $750.
--RENAME THE COLUMN STANDARD COST TO PRICE. ASLO SORT THE RESULTS IN DESCENDING ORDER BY LIST PRICE
SELECT ProductID, Name, ProductNumber, Color, ROUND(StandardCost,2) AS Price, ListPrice, Size, ProductLine, ProductSubcategoryID, ProductModelID
FROM [Production].[Product]
WHERE Color NOT IN ('NULL', 'RED', 'SILVER/BLACK') AND  ListPrice BETWEEN 75 AND 750
ORDER BY ListPrice DESC;
 
--FIND ALL THE MALE EMPLOYEES BORN BETWEEN 1962 - 1970 & WITH HIRE DATE GREATER THAN 2001 & 
--FEMALE EMPLOYEES BORN BETWEEN 1972 & 1975 & HIRE DATE BETWEEN 2001 & 2002
SELECT HE.BusinessEntityID, NationalIDNumber, FirstName, LastName, JobTitle, MaritalStatus, Gender,  BirthDate, HireDate
FROM [HumanResources].[Employee] AS HE INNER JOIN [Person].[Person] AS PP
ON HE.BusinessEntityID = PP.BusinessEntityID
WHERE Gender = 'M' OR BirthDate BETWEEN '1962-01-01' AND '1970-12-31' AND HireDate > '2001-12-31'
OR Gender = 'F' AND BirthDate BETWEEN '1972-01-01' AND '1975-12-31' AND HireDate BETWEEN '2001-01-01' AND '2002-12-31'

--CREATE A LIST OF 10 MOST EXPENSICE PRODUCTS THAT HAVE PRODUCT NUMBER BEGINING WITH 'BK' 
--INCLUDE ONLY THE PRODUCTID, NAME & COLOR
SELECT DISTINCT TOP 10 ProductID, ProductNumber, Name, Color, ListPrice
FROM [Production].[Product]
WHERE ProductNumber LIKE 'BK%'
ORDER BY ListPrice DESC;

--CREATE A LIST OF ALL CONTACT PERSONS, WHERE THE FIRST FOUR CHARACTERS OF THE LASTNAME ARE THE SAME AS THE FIRST FOUR 
--CHARACTERS OF THE EMAL ADDRESS. ALSO FOR ALL CONTACTS WHOSE FIRSTNAME & LASTNAME BEGINS WITH THE SAME CHARACTERS
--CREATE A NEW COLUMN CALLED FULLNAME, COMBINING FIRSTNAME & LASTNAME ONLY, ALSO PROVIDE THE LENGTH OF THE NEW COLUMN
SELECT PP.BusinessEntityID, FirstName, LastName, EmailAddress, SUBSTRING(LastName, 1, 4) NewLastName,
SUBSTRING(EmailAddress, 1, 4) AS NewEmail, (FirstName+' '+LastName) AS FullName, LEN(FirstName+''+LastName) AS NameLength
FROM [Person].[Person] AS PP FULL JOIN [Person].[EmailAddress] AS PE
ON PP.BusinessEntityID = PE.BusinessEntityID
WHERE SUBSTRING(LastName, 1, 4) = SUBSTRING(EmailAddress,1, 4) AND  SUBSTRING(FirstName,1,1) = SUBSTRING(LastName, 1,1);

--RETURN ALL PRODUCT SUB-CATEGORIES THAT TAKE AN AVERAGE OF 3DAYS TO MANUFACTURE:
SELECT PS.ProductSubcategoryID, ProductCategoryID, PS.Name, DaysToManufacture
FROM [Production].[ProductSubcategory] AS PS INNER JOIN [Production].[Product] AS PP
ON PS.ProductSubcategoryID = PP.ProductSubcategoryID
WHERE DaysToManufacture >= 3
ORDER BY ProductSubcategoryID ASC;

--CREATE A LIST OF PRODUCT SEGMENTATION BY DEFINING CRITERIA THAT PLACES EACH ITEM IN A PRIDEFINED SEGMENT AS FOLLOWS
--IF PRICE IS LESS THAN $200 THEN THE VALUE IS LOW, IF PRICE IS BETWEEN $201 & $750 THEN THE VALUE IS MID VALUE,
--IF  BETWEEN $750 & $1250 THEN MID TO HIGH VALUE. FILTER THE RESULT FOR ONLY BLACK, SILVER & RED COLOR PROODUCTS:
SELECT ProductID, Name, ProductNumber, Color, StandardCost, ListPrice,
CASE  
    WHEN ListPrice < 200 THEN 'Low Value'
	WHEN ListPrice  BETWEEN  201 AND 750 THEN 'Mid Value'
	WHEN ListPrice BETWEEN 750 AND 1250 THEN 'Mid-High Value'
	ELSE 'High Value'
	END  AS PriceSegment
FROM [Production].[Product]
WHERE Color IN ('Black', 'Silver', 'Red');

--HOW MANY DISTINCT JOB TITLE IS PRESENT IN EMPLOYEE TABLE:
SELECT COUNT (DISTINCT JobTitle) AS CountOfJobTitle
FROM [HumanResources].[Employee];

--USE EMPLOYEE TABLE & CALULATE THE AGES OF EMPLOYEES WHEN HIRED:
SELECT BusinessEntityID, NationalIDNumber, JobTitle, BirthDate, HireDate, YEAR(HireDate) - YEAR(BirthDate) AS AgeEmployed
FROM [HumanResources].[Employee]
ORDER BY BusinessEntityID ASC;

--HOW MANY EMPLOYEES WILL BE DUE FOR A LONG SERVICE AWARD IN THE NEXT 5YEARS, IF LONG SERVICE IS 20YEARS:
SELECT COUNT(BusinessEntityID) AS  CountofEmployees
FROM [HumanResources].[Employee]
WHERE YEAR(CURRENT_TIMESTAMP) - YEAR(HireDate) + 5 = 20;

--HOW MANY YEARS DOES EACH EMPLOYEE HAVE TO WORK BEFORE REACHING SETIMENT? 
--IF SENTIMENT AGE IS 65YEARS:
SELECT BusinessEntityID, NationalIDNumber, JobTitle, Gender, BirthDate, HireDate, YEAR(CURRENT_TIMESTAMP) - YEAR(BirthDate) AS Age,
65 - (YEAR(CURRENT_TIMESTAMP) - YEAR(BirthDate)) AS SentimentDuration
FROM [HumanResources].[Employee]
ORDER BY BusinessEntityID;

--IMPLEMENT NEW PRICE POLICY ON THE PRODUCT TABLE BASED ON COLOR OF THE ITEM
--IF WHITE THEN INCREASE PRICE BY 8%, IF YELLOW THEN REDUCE BY 7.5%,TF BLACK INCREASE PRICE BY 17.2%
--IF MULTI, SILVER, SILVER/BLACK, BLUE TAKE THE SQUARE ROOT OF THE PRICE & DOUBLE THE VALUE
--COLUMN SHOULD BE CALLED NEWPRICE. FOR EACH ITEM ALSO CACULATE COMMISSION AS 37.5%OF NEWLY COMPUTED LISTPRICE:
SELECT ProductID, Name, ProductNumber, Color, ListPrice,
CASE
    WHEN Color = 'White' THEN ListPrice + (ListPrice * 8/100)
	WHEN Color = 'Yellow' THEN ListPrice +(ListPrice * -7.5/100)
	WHEN Color = 'Black' THEN ListPrice +(ListPrice * 17.2/100)
	ELSE SQRT(ListPrice) * 2
	END AS NewPrice, 
	(CASE
    WHEN Color = 'White' THEN ListPrice + (ListPrice * 8/100)
	WHEN Color = 'Yellow' THEN ListPrice +(ListPrice * -7.5/100)
	WHEN Color = 'Black' THEN ListPrice +(ListPrice * 17.2/100)
	ELSE SQRT(ListPrice) * 2
	END * 37.5/100) AS Commission
FROM Production.Product;

--PRINT THE INFORMATION ABOUT ALL THE SALES PERSON & THEIR SALES QUOTA. FOR EVERY SALES PERSON YOU SHOULD PROVIDE
--FIRSTNAME, LASTNAME, HIREDATE, SICKLEAVEHOURS & REGION WHERE THEY WORK:
SELECT SH.SalesPersonID, FirstName, LastName, HireDate, ST.TerritoryID, 
CASE
    WHEN CountryRegionCode = 'CA' THEN 'Canada'
	WHEN CountryRegionCode = 'US' THEN 'United States'
	WHEN CountryRegionCode = 'AU' THEN 'Australia'
	WHEN CountryRegionCode = 'FR' THEN 'France'
	WHEN CountryRegionCode = 'GB' THEN 'United Kingdom'
	WHEN CountryRegionCode = 'DE' THEN 'Germany'
	END AS CountryRegionCode,
	SalesQuota, Bonus, CommissionPct, SP.SalesYTD, SP.SalesLastYear, SickLeaveHours 
FROM [Sales].[SalesPerson] AS SP INNER JOIN  [Person].[Person] AS PP
ON SP.BusinessEntityID = PP.BusinessEntityID
INNER JOIN[HumanResources].[Employee] AS HE 
ON  HE.BusinessEntityID = PP.BusinessEntityID
INNER JOIN  [Sales].[SalesTerritory] AS ST
ON ST.TerritoryID =SP.TerritoryID
INNER JOIN [Sales].[SalesOrderHeader] AS SH 
ON SH.TerritoryID = ST.TerritoryID;

--USING ADVENTURE WORKS, WRITE A QUERY TO EXTRACT THE FOLLOWING INFORMATION: SalesPersonID, PRODUCTID, PRODUCT NAME, PRODUCT CATEGORY NAME, 
--PRODUCT SUB-CATEGORY NAME, SALES PERSON, REVENUE, MONTH OF TRANSACTION, QUARTER OF TRANSACTION:
SELECT SH.SalesPersonID, PP.ProductID, (PP.Name) AS ProductName, (PC.Name) AS ProductCategoryName, (PS.Name) AS ProductSubCategoryName, 
(LineTotal) AS Revenue, (MONTH(TransactionDate)) AS Month,
CASE
    WHEN MONTH(TransactionDate) BETWEEN 1 AND 3 THEN 'Quarter 1'
	WHEN MONTH(TransactionDate) BETWEEN 4 AND 6 THEN 'Quarter 2'
	WHEN MONTH(TransactionDate) BETWEEN 7 AND 9 THEN 'Quarter 3'
	WHEN MONTH(TransactionDate) BETWEEN 7 AND 9 THEN 'Quarter 4'
	END AS OrderQuarter
FROM [Production].[Product]  AS PP INNER JOIN [Production].[ProductSubcategory] AS PS
ON PP.ProductSubcategoryID = PS.ProductSubcategoryID
INNER JOIN [Production].[ProductCategory] AS PC 
ON PC.ProductCategoryID = PS.ProductCategoryID
INNER JOIN Production.TransactionHistory AS PT 
ON PT.ProductID = PP.ProductID
INNER JOIN [Sales].[SalesOrderDetail] AS SD 
ON SD. ProductID = PP.ProductID
INNER JOIN [Sales].[SalesOrderHeader] AS SH
ON SH.SalesOrderID = SD.SalesOrderID;

--DISPLAY THE INFORMATION ABOUT  THE DETAILS  OF AN ORDER i.e.ORDER NUMBER, ORDER DATE, AMOUNT OF ORDER
--WHICH CUSTOMER GIVES THE ORDER & WHICH SALESMAN WORKS FOR THAT CUSTOMER & HOW MUCH COMMISION HE GOT FOR AN ORDER:
SELECT SalesPersonID, SC.CustomerID, SalesOrderNumber, OrderDate, OrderQty, TotalDue,
CommissionPct, (TotalDue * CommissionPct) AS CommissionMade
FROM [Sales].[SalesOrderHeader] AS SH INNER JOIN [Sales].[Customer] AS SC
ON SH.TerritoryID = SC.TerritoryID
INNER JOIN [Sales].[SalesOrderDetail] AS SD 
ON SD.SalesOrderID = SH.SalesOrderID
INNER JOIN [Sales].[SalesPerson] AS SP 
ON SP.TerritoryID = SH.TerritoryID;

--FOR ALL THE PRODUCTS CALCULATE:
--COMMISSION AS 14.79% OF STANDARD COST, MARGIN IF STANDARD COST IS INCREASED OR DECREASED AS FOLLOWS:
--BLACK +22%, RED -12%, SILVER +15%, MULTI +5%, WHITE(TWO TIMES ORIGINAL COST DIVIDED BY THE SQUARE ROOT OF COST)
--FOR OTHER COLORS, STANDARD COST REMAINS THE SAME
SELECT ProductID, Name, ProductNumber, Color, StandardCost, ListPrice,
(14.79/100 * StandardCost) AS Commission,
CASE
    WHEN Color ='Black' THEN StandardCost + (StandardCost * 22/100)
	WHEN Color = 'Red' THEN StandardCost + (StandardCost * -12/100)
	WHEN Color = 'Silver' THEN StandardCost + (StandardCost * 15/100)
	WHEN Color = 'Multi' THEN StandardCost + (StandardCost * 5/100)
	WHEN Color = 'White' THEN (StandardCost * 2)/SQRT(StandardCost)
	ELSE StandardCost
	END AS NewCost	
FROM [Production].[Product];

--CREATE A VIEW TO FIND OUT THE TOP 5 MOST EXPENSIVE PRODUCTS FOR EACH COLOR:
CREATE VIEW 
MostExpensiveProducts AS 
WITH RESULT AS(
SELECT ProductID, NAME, ProductNumber, Color, ListPrice,
ROW_NUMBER() OVER (PARTITION BY Color ORDER BY ListPrice DESC) AS ROWNO
FROM [Production].[Product])

SELECT *
FROM RESULT 
WHERE ROWNO <=5

--RETRIVE VALUES FROM VIEW:
SELECT *
FROM MostExpensiveProducts



