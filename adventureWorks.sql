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

--10

SELECT
    SUM(Quantity) AS Totalquantity
FROM
    Production.ProductInventory
GROUP BY
    (LocationID * 10);

--11

SELECT
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    pp.PhoneNumber
FROM
    Person.PersonPhone pp
JOIN
    Person.Person p ON pp.BusinessEntityID = p.BusinessEntityID
WHERE
    p.LastName LIKE 'L%'
ORDER BY 
    p.LastName, p.FirstName;

--12

SELECT
    SalesPersonID,
    CustomerID,
    SUM(SubTotal) AS sum_subtotal
FROM
    Sales.SalesOrderHeader
GROUP BY ROLLUP (SalesPersonID, CustomerID)
HAVING SalesPersonID IS NOT NULL;

--13
SELECT
    LocationID,
    Shelf,
    SUM(Quantity) AS TotalQuantity
FROM
    Production.ProductInventory
GROUP BY CUBE(LocationID, Shelf);

--14
SELECT
    LocationID,
    Shelf,
    SUM(Quantity) AS TotalQuantity
FROM    
    Production.ProductInventory
GROUP BY GROUPING SETS (ROLLUP(LocationID, Shelf), CUBE(LocationID, Shelf));

--15

SELECT
    LocationID,
    SUM(Quantity) AS TotalQuantity
FROM
    Production.ProductInventory
GROUP BY
    GROUPING SETS(LocationID, ());

--16
SELECT
    a.City, 
    COUNT(*) AS employeeCount
FROM
    Person.BusinessEntityAddress ba 
JOIN Person.Address a ON ba.AddressID = a.AddressID
GROUP BY 
    a.City
ORDER BY    
    a.City;

--17 

SELECT  
    YEAR(OrderDate) AS Year,
    SUM(TotalDue) AS TotalDueAmount
FROM Sales.SalesOrderHeader
GROUP BY 
    YEAR(OrderDate)
ORDER BY 
    YEAR(OrderDate);

--18

SELECT  
    YEAR(OrderDate) AS Year,
    SUM(TotalDue) AS TotalDueAmount
FROM Sales.SalesOrderHeader
GROUP BY 
    YEAR(OrderDate)
HAVING
    YEAR(OrderDate) < 2016
ORDER BY 
    YEAR(OrderDate);

--19

SELECT
    ContactTypeID, 
    Name
FROM
    Person.ContactType
WHERE 
    Name LIKE '%Manager%'
ORDER BY 
    ContactTypeID DESC;

--20

SELECT
    pp.BusinessEntityID, pp.LastName, pp.FirstName
FROM
    Person.BusinessEntityContact b
JOIN Person.ContactType p ON b.ContactTypeID = p.ContactTypeID
JOIN Person.Person pp ON b.PersonID = pp.BusinessEntityID
WHERE p.Name LIKE 'Purchasing Manager'
ORDER BY LastName, FirstName;

--21

SELECT 
    ROW_NUMBER() OVER (PARTITION BY pa.PostalCode ORDER BY sp.SalesYTD DESC) AS RowNumer,
    pp.LastName,
    sp.SalesYTD,
    pa.PostalCode
FROM 
    Sales.SalesPerson sp 
JOIN Person.Person pp ON sp.BusinessEntityID = pp.BusinessEntityID
JOIN Person.BusinessEntityAddress pba ON sp.BusinessEntityID = pba.BusinessEntityID
JOIN Person.Address pa ON pba.AddressID = pa.AddressID
WHERE 
    sp.TerritoryID IS NOT NULL AND sp.SalesYTD <> 0
ORDER BY
    pa.PostalCode

--22

SELECT 
    *
FROM
    Person.BusinessEntityContact