USE AI24

DROP TABLE Products;

CREATE TABLE SalesPeople (
    SalesPersonID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Region NVARCHAR(50)
);


CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(50),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    SalesPersonID INT,        -- FOREIGN KEY referencing SalesPeople table
    ProductID INT,            -- FOREIGN KEY referencing Products table
    SaleDate DATE,
    Quantity INT
);

INSERT INTO SalesPeople VALUES
(1, 'Rafael', 'Schmidl', 'North'),
(2, 'Astrid', 'Rodin', 'South'),
(3, 'Wijdan', 'Cederlid', 'East'),
(4, 'Isak', 'Forsberg', 'West'),
(5, 'Fabio', 'Rubino', 'North');


INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 1000),
(2, 'Tablet', 'Electronics', 600),
(3, 'Office Chair', 'Furniture', 150),
(4, 'Desk', 'Furniture', 250),
(5, 'Whiteboard', 'Supplies', 80);


-- Simulated sales over 2 months
INSERT INTO Sales VALUES
(1, 1, 1, '2024-03-01', 2),
(2, 1, 2, '2024-03-02', 1),
(3, 2, 3, '2024-03-05', 4),
(4, 2, 4, '2024-03-06', 2),
(5, 3, 5, '2024-03-07', 5),
(6, 4, 1, '2024-03-08', 1),
(7, 5, 2, '2024-03-09', 3),
(8, 1, 3, '2024-03-10', 2),
(9, 3, 1, '2024-03-11', 1),
(10, 4, 5, '2024-03-12', 4),
(11, 5, 4, '2024-03-13', 2),
(12, 2, 2, '2024-03-14', 1),
(13, 3, 4, '2024-03-15', 3),
(14, 1, 1, '2024-03-16', 1),
(15, 5, 5, '2024-03-17', 6);


SELECT * FROM SalesPeople;
SELECT * FROM Products;
SELECT * FROM Sales;


/* 

ROLLUP is a GROUP BY extension that generates subtotals and grand totals for a hierarchy of grouped columns.

It adds summary rows at each level of aggregation:

    - Individual groups

    - Subtotals (per group)

    - Grand total
*/



-- Warmup. Just count total number (quantity) of products sold, per region


SELECT
	sp.Region,
	SUM(s.Quantity) AS TotalQuantityPerRegion
FROM 
	SalesPeople sp 
	JOIN Sales s ON sp.SalesPersonID = s.SalesPersonID
GROUP BY 
	sp.Region;



-- Example: Total Quantity Sold by Region and Product Category

SELECT
	sp.Region,
	p.Category,
	SUM(s.Quantity) AS TotalQuantity
FROM
	Sales s
	JOIN SalesPeople sp ON s.SalesPersonID = sp.SalesPersonID
	JOIN Products p ON s.ProductID = p.ProductID
GROUP BY ROLLUP(sp.Region, p.Category)
ORDER BY sp.Region, p.Category                    -- optional, gör det kanske lite snyggare

SELECT
	p.Category,
	sp.Region,
	SUM(s.Quantity) AS TotalQuantity
FROM
	Sales s
	JOIN SalesPeople sp ON s.SalesPersonID = sp.SalesPersonID
	JOIN Products p ON s.ProductID = p.ProductID
GROUP BY ROLLUP(p.Category, sp.Region)                    -- obs, ordning spelar roll


/*
A window function allows you to look at a row and also look at other rows around it—kind of 
like looking out a window in a train car, where you can see what’s around you while still sitting in your seat.

You use a window function when you want to perform a calculation across a set of rows, but without 
collapsing the result into one row like GROUP BY does.
*/


/*
The syntax for using a window function is as follows

<window_function>() OVER (
    PARTITION BY <column(s)> 
    ORDER BY <column(s)>
)
*/


CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DepartmentID INT,              -- FOREIGN KEY referencing Departments
    HireDate DATE
);

-- Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

-- Salaries Table
CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY,
    EmployeeID INT,                -- FOREIGN KEY referencing Employees
    SalaryDate DATE,
    BaseSalary DECIMAL(10,2),
    Bonus DECIMAL(10,2),
);

INSERT INTO Departments VALUES
(1, 'Engineering'),
(2, 'Sales'),
(3, 'HR'),
(4, 'Marketing');

INSERT INTO Employees VALUES
(1, 'Rafael', 'Schmidl', 1, '2021-01-15'),
(2, 'Astrid', 'Rodin', 2, '2020-07-10'),
(3, 'Wijdan', 'Cederlid', 1, '2022-03-01'),
(4, 'Isak', 'Forsberg', 3, '2019-11-25'),
(5, 'Fabio', 'Rubino', 2, '2021-09-30'),
(6, 'Lotta', 'Holmström', 4, '2020-01-10');

INSERT INTO Salaries VALUES
(1, 1, '2024-01-01', 6000, 500),
(2, 1, '2024-02-01', 6000, 600),
(3, 1, '2024-03-01', 6000, 400),
(4, 2, '2024-01-01', 5000, 1000),
(5, 2, '2024-02-01', 5000, 800),
(6, 3, '2024-02-01', 5500, 300),
(7, 3, '2024-03-01', 5500, 350),
(8, 4, '2024-01-01', 4500, 200),
(9, 4, '2024-02-01', 4500, 150),
(10, 5, '2024-01-01', 4800, 700),
(11, 5, '2024-02-01', 4800, 600),
(12, 6, '2024-03-01', 4700, 300);

SELECT * FROM Departments;
SELECT * FROM Employees;
SELECT * FROM Salaries;

SELECT 
    EmployeeID,
    SalaryDate,
    Bonus
FROM 
	Salaries;


SELECT
	EmployeeID,
	SUM(Bonus) AS TotalBonus
FROM
	Salaries
GROUP BY
	EmployeeID


SELECT 
    EmployeeID,
    SalaryDate,
    Bonus,
	SUM(Bonus) OVER (PARTITION BY EmployeeID) AS TotalBonus
FROM 
	Salaries;


SELECT 
    EmployeeID,
    SalaryDate,
    Bonus,
	SUM(Bonus) OVER (PARTITION BY EmployeeID ORDER BY Bonus) AS TotalBonus
FROM 
	Salaries;



-- Let’s now say you want to see how many units each salesperson has sold in total.
-- the window function we will use here is, again, SUM()

SELECT * FROM SalesPeople;
SELECT * FROM Products;
SELECT * FROM Sales;


SELECT 
    sp.FirstName,
    s.SaleDate,
    s.Quantity
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID;



SELECT 
    sp.FirstName,
    s.SaleDate,
    s.Quantity,
	SUM(s.Quantity) OVER (PARTITION BY sp.FirstName) AS TotalSoldQuantity
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID
ORDER BY TotalSoldQuantity                                     -- optional


-- Let’s now say you want to highlight the maximum quantity a person has sold.
-- the window function we will use here is MAX()


SELECT 
    sp.FirstName,
    s.SaleDate,
    s.Quantity
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID;



SELECT 
    sp.FirstName,
    s.SaleDate,
    s.Quantity,
	MAX(s.Quantity) OVER (PARTITION BY sp.FirstName) AS MaxSoldQuantity
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID;


-- Let’s now say you want to see the order in which each sale has been made, per person.
-- the window function we will use here is ROW_NUMBER()


SELECT 
    sp.FirstName,
    s.SaleDate,
    s.Quantity
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID;


SELECT 
    sp.FirstName,
    s.SaleDate,
    s.Quantity,
	ROW_NUMBER() OVER (PARTITION BY sp.FirstName ORDER BY s.SaleDate) AS SaleOrder
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID;


-- Let’s now say want to rank each sale, per region, in terms of purchase quantity.
-- the window function we will use here is RANK()

SELECT 
    sp.FirstName,
    sp.Region,
    s.Quantity
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID;


SELECT 
    sp.FirstName,
    sp.Region,
    s.Quantity,
	RANK() OVER (PARTITION BY sp.Region ORDER BY s.Quantity DESC) AS QuantityRank
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID;


-- Let’s now say you want to highlight the date for the first sale each salesperson has made.
-- the window function we will use here is FIRST_VALUE()


SELECT 
    s.SaleID,
    sp.FirstName,
    sp.Region,
    p.ProductName,
    s.Quantity,
    s.SaleDate
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID
JOIN Products p ON p.ProductID = s.ProductID
ORDER BY sp.FirstName, s.SaleDate;


SELECT 
    s.SaleID,
    sp.FirstName,
    sp.Region,
    p.ProductName,
    s.Quantity,
    s.SaleDate,
	FIRST_VALUE(s.SaleDate) OVER (PARTITION BY sp.FirstName ORDER BY s.SaleDate) AS FirstSaleDate
FROM Sales s
JOIN SalesPeople sp ON sp.SalesPersonID = s.SalesPersonID
JOIN Products p ON p.ProductID = s.ProductID;


-- EXCERCISES

-- We will be using the following tables

SELECT * FROM Departments;
SELECT * FROM Employees;
SELECT * FROM Salaries;


/*

Excercise 1. Department Salary Summary

Show the total base salary paid per department with subtotals and grand total.

Hint: GROUP BY ROLLUP

*/

SELECT  
    d.DepartmentName,
    SUM(s.BaseSalary) AS TotalSalaryPerDepartment
FROM
    Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Salaries s ON e.EmployeeID = s.EmployeeID
GROUP BY ROLLUP(d.DepartmentName);

/*

Excercise 2: Total Compensation Per Month

Use a window function to compute each employee’s total compensation per month, and show the total per employee over all months.

Hint: SUM() OVER (...)

*/

SELECT
    s.SalaryDate,
    e.FirstName,
    SUM(s.BaseSalary + s.Bonus) OVER (PARTITION BY s.SalaryDate, e.FirstName) AS TotalCompensationPerMonth,
    SUM(s.BaseSalary + s.Bonus) OVER (PARTITION BY e.EmployeeID) AS TotalCompensation 
FROM
    Salaries s
JOIN Employees e ON e.EmployeeID = s.EmployeeID;

/*

Exercise 3: Salary order

Create a column highlighting at which order, per employee, the pay slip has arrived. Their first salary should have number 1, the second 2 etc. 

Hint: ROW_NUMBER()

*/

SELECT
    e.FirstName,
    s.SalaryDate,
    ROW_NUMBER() OVER (PARTITION BY e.FirstName ORDER BY s.SalaryDate) AS OrderOfSalary
FROM
    Salaries s 
JOIN Employees e ON s.EmployeeID = e.EmployeeID;



/*

Exercise 4: Rank Employees by Bonus

For each month, rank employees by their bonus amount.

*/

SELECT
    e.FirstName,
    s.Bonus,
    s.SalaryDate,
    RANK()OVER (PARTITION BY s.SalaryDate ORDER BY s.Bonus DESC) AS QuantityRank
FROM
    Employees e
JOIN Salaries s ON e.EmployeeID = s.EmployeeID;