USE AI24

-- 1. Setting up tables

CREATE TABLE Products (
  ProductID INT IDENTITY PRIMARY KEY,
  ProductName NVARCHAR(50) NOT NULL,
  CategoryID INT,                        --- FOREIGN KEY som refererar till CategoryID i Categories tabellen
  UnitPrice FLOAT NOT NULL
);

CREATE TABLE Categories (
  CategoryID INT IDENTITY PRIMARY KEY,   
  CategoryName NVARCHAR(50) NOT NULL
);

INSERT INTO 
Products (ProductName, CategoryID, UnitPrice)
VALUES
('Laptop', 1, 899.99), ('Shirt', 2, 29.99), ('Desk', 3, 199.99), ('Phone', 1, 499.99), ('Dress', 2, 59.99), ('Chair', 3, 99.99);

INSERT INTO Categories (CategoryName)
VALUES ('Electronics'), ('Clothing'), ('Furniture');

SELECT * FROM Products
SELECT * FROM Categories


-- SUBQUERY 

-- Find the most expensive product using a subquery

SELECT
	ProductName, UnitPrice
FROM
	Products
WHERE
	UnitPrice = (
				SELECT 
					MAX(UnitPrice)
				FROM 
					Products
				)

-- Find all products in the 'Electronics' category


SELECT
	*
FROM
	Products
WHERE
	CategoryID = (
				  SELECT CategoryID
				  FROM Categories
				  WHERE CategoryName = 'Electronics'
				 );

SELECT
	*
FROM
	Products
WHERE
	CategoryID IN (
				  SELECT CategoryID
				  FROM Categories
				  WHERE CategoryName = 'Electronics' OR CategoryName = 'Clothing'
				 )

SELECT
	*
FROM
	Products
WHERE
	CategoryID IN (
				  SELECT CategoryID
				  FROM Categories
				  WHERE CategoryName IN ('Electronics', 'Clothing')
				 )


-- Correlated SUBQUERIES

--  Find all products more expensive than the average price within their category

SELECT
	p.ProductName, p.UnitPrice, c.CategoryName
FROM
	Products as p JOIN Categories as c ON p.CategoryID = c.CategoryID
WHERE
	p.UnitPrice > (
					SELECT 
						AVG(UnitPrice)
					FROM 
						Products AS p2
					WHERE p2.CategoryID = p.CategoryID
				 )
				 
-- WITH statement (CTE)

--  Find all products in the 'Electronics' category with WITH

WITH ElectronicCategory AS (
							SELECT CategoryId
							FROM Categories
							WHERE CategoryName IN ('Electronics', 'Furniture')
							)
SELECT *
FROM Products
WHERE CategoryID IN ( 
					  SELECT CategoryID
					  FROM ElectronicCategory
					)