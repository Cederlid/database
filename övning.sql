CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name NVARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderAmount INT
);
INSERT INTO Customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES
(101, 1, 2000),
(102, 1, 1500),
(103, 2, 3000),
(104, 2, 2500),
(105, 3, 1000);

SELECT *
 FROM Customers

 SELECT *
 FROM Orders

 SELECT name FROM Customers WHERE CustomerID IN (
    SELECT CustomerID FROM Orders GROUP BY CustomerID HAVING SUM(OrderAmount) > 5000
 ) 