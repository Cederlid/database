USE AdventureWorks2022
--1
SELECT
    *
FROM 
    HumanResources.Employee
ORDER BY
    JobTitle;

--2
SELECT
    e.*
FROM
    Person.Person AS e
ORDER BY
    e.LastName;

--3
SELECT
    FirstName, 
    LastName,
    BusinessEntityID AS Employee_id
FROM
    Person.Person
ORDER BY
    LastName;

--4
SELECT
    ProductID,
    ProductNumber,
    name AS productName
FROM
    Production.Product
WHERE 
    SellStartDate IS NOT NULL AND ProductLine = 'T'
ORDER BY
    Name;

--5

SELECT
    SalesOrderID,
    CustomerID,
    OrderDate,
    SubTotal,
    TaxAmt/SubTotal * 100 AS [percentage of tax column]
FROM
    Sales.SalesOrderHeader
ORDER BY 
    SubTotal DESC;

--6

SELECT 
    DISTINCT JobTitle
FROM
    HumanResources.Employee;

--7
SELECT
    CustomerID,
    SUM(Freight) AS TotalFreight
FROM
    Sales.SalesOrderHeader
GROUP BY 
    CustomerID
ORDER BY
    CustomerID;

--8
SELECT 
    CustomerID,
    SalesPersonID,
    AVG(SubTotal) AS Average,
    Sum(SubTotal) AS Total
FROM    
    Sales.SalesOrderHeader
GROUP BY
    CustomerID, SalesPersonID
ORDER BY
    CustomerID DESC;

--9
SELECT
    ProductID,
    SUM(Quantity) AS TotalQuantity
FROM
    Production.ProductInventory
WHERE
    Shelf IN ('A', 'C', 'H')
GROUP BY
    ProductID
HAVING 
    SUM(Quantity) > 500
ORDER BY
    ProductID ASC;