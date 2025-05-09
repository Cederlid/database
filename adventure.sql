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
    *
FROM
    Sales.SalesOrderHeader