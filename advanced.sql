USE AI24

-- Tables

CREATE TABLE Students (
				StudentID INT PRIMARY KEY,
				Firstname NVARCHAR(50),
				LastName NVARCHAR(50),
				GradeLevel INT
				      )

CREATE TABLE Courses (
	            CourseID INT PRIMARY KEY,
				CourseName NVARCHAR(100),
				Teacher NVARCHAR(100)
				     )

CREATE TABLE Enrollments (
                EnrollmentID INT PRIMARY KEY,
				StudentID INT,
				CourseID INT,
				Score INT
				         )


-- Insert Students
INSERT INTO Students VALUES
(1, 'Alice', 'Johnson', 10),
(2, 'Bob', 'Smith', 10),
(3, 'Charlie', 'Lee', 11),
(4, 'Diana', 'Garcia', 11),
(5, 'Ethan', 'White', 12),
(6, 'Fiona', 'Brown', 12);

-- Insert Courses
INSERT INTO Courses VALUES
(101, 'Mathematics', 'Mr. Adams'),
(102, 'History', 'Ms. Brooks'),
(103, 'Biology', 'Dr. Clark'),
(104, 'English', 'Mrs. Davis'),
(105, 'Physics', 'Dr. Evans');

-- Insert Enrollments
INSERT INTO Enrollments VALUES
(1, 1, 101, 85),
(2, 1, 102, 90),
(3, 1, 103, 75),
(4, 2, 101, 78),
(5, 2, 104, 82),
(6, 3, 103, 88),
(7, 3, 105, 91),
(8, 4, 102, 85),
(9, 4, 101, 89),
(10, 5, 104, 95),
(11, 5, 105, 87),
(12, 6, 102, 90),
(13, 6, 103, 92);

SELECT * FROM Students
SELECT * FROM Courses
SELECT * FROM Enrollments


-- Find students who have scored more than the average score

SELECT 
	FirstName, LastName
FROM
	Students
WHERE 
	StudentID IN (
				  SELECT StudentID
				  FROM Enrollments
				  WHERE Score > (
				                 SELECT AVG(Score) FROM Enrollments
								 )
				 )

-- Get average scores per student using subquery as a table

SELECT
	s.FirstName,
	s.LastName,
	avgScores.AverageScore
FROM
	Students s JOIN (
					 SELECT StudentID, 
	                 AVG(Score) AS AverageScore
					 FROM Enrollments
					 GROUP BY StudentID
					 ) avgScores ON s.StudentID = avgScores.StudentID


-- CTE

-- A CTE is a temporary result defined with WITH, used to simplify complex queries and improve readability.

/*

WITH CTE_Name AS (
    SELECT ...
)
SELECT * FROM CTE_Name;

*/


-- Use CTE to calculate average scores per student

WITH StudentAverages AS (
	SELECT StudentID, AVG(Score) AS AvgScore
	FROM Enrollments
	GROUP BY StudentID
	                    )

SELECT s.FirstName, s.LastName, sa.AvgScore
FROM Students s JOIN StudentAverages sa ON s.StudentID = sa.StudentID


-- Find students with average score > 85

WITH HighAchievers AS (
	SELECT StudentID, AVG(Score) AS AvgScore
	FROM Enrollments
	GROUP BY StudentID
	HAVING AVG(Score) > 85
	                   )
SELECT s.FirstName, s.LastName, h.AvgScore
FROM Students s JOIN HighAchievers h ON s.StudentID = h.StudentID


-- List students with the courses they took and their scores

WITH StudentCourses AS (
		SELECT
			s.FirstName,
			s.LastName,
			c.Coursename,
			e.Score
		FROM Students s  
		JOIN Enrollments e ON s.StudentID = e.StudentID
		JOIN Courses c ON e.CourseID = c.CourseID
		               )

SELECT * FROM StudentCourses
ORDER BY LastName

-- First, calculate per-course average, then find students who beat it

WITH CourseAverages AS (
	SELECT CourseID, AVG(Score) AS AvgScore
	FROM Enrollments
	GROUP BY CourseID
	                   ),
    AboveAverageScores AS (
	SELECT e.StudentID, e.courseID, e.Score, ca.AvgScore
	FROM Enrollments e JOIN CourseAverages ca on e.CourseID = ca.CourseID
	                      )

SELECT 
	s.Firstname, s.LastName, c.CourseName, aas.StudentID, aas.CourseID, aas.Score, aas.AvgScore
FROM 
	AboveAverageScores aas 
	JOIN Students s ON aas.StudentID = s.StudentID
	JOIN Courses c ON aas.CourseID = c.CourseID
WHERE
	aas.Score > aas.AvgScore;

-- Excercises can be solved using either SUBQUERIES OR CTE, up to you



--  Exercise 1: Find Students Enrolled in More Than two Courses
WITH StudentEnrolled AS(
    SELECT
        s.Firstname, s.LastName, e.CourseID, e.StudentID
    FROM
        Enrollments e 
        JOIN Students s ON e.StudentID = s.StudentID
)

SELECT
    StudentID, FirstName, LastName, COUNT(CourseID) AS [Number of courses]
FROM
    StudentEnrolled  
GROUP BY 
    StudentID, Firstname, LastName
HAVING
    COUNT(CourseID) > 2;


-- Excercise 2: Show average score per course, along with teacher name
SELECT
    c.CourseName, c.Teacher, avgscores.Averagescore
FROM
    Courses c 
JOIN(
    SELECT 
        CourseID, AVG(Score) AS Averagescore
    FROM
        Enrollments
    GROUP BY
        CourseID
) AS avgscores ON c.CourseID = avgscores.CourseID;

-- Excercise 3: Find students whose score is below the course average

WITH CourseAverage AS(
    SELECT
        CourseID, ROUND(AVG(CAST(Score AS FLOAT)),1) AS AverageScore
    FROM
        Enrollments  
    GROUP BY
        CourseID
)

SELECT
    s.FirstName, s.LastName, e.CourseID, e.Score, ca.AverageScore
FROM
    Enrollments e
JOIN  
    Students s ON e.StudentID = s.StudentID
JOIN
    CourseAverage ca ON e.CourseID = ca.CourseID
WHERE
    e.Score < ca.AverageScore

-- Excercise 4: List students who took 'Physics' and scored above 85.

WITH PhysicsEnrollments AS(
    SELECT
        e.StudentID, e.CourseID, e.Score, c.CourseName
    FROM
        Enrollments e 
    JOIN 
        Courses c ON e.CourseID = c.CourseID
    WHERE 
        c.CourseName = 'Physics' AND e.Score > 85
)

SELECT
    s.Firstname, s.LastName, pe.CourseName, pe.Score
FROM
    Students s 
JOIN PhysicsEnrollments pe ON s.StudentID = pe.StudentID

-- Excercise 5: Find the top-performing student(s) per course
WITH MaxScores AS(
    SELECT
        CourseID, MAX(Score) AS MaxScore 
    FROM
        Enrollments
    GROUP BY
        CourseID
)
SELECT
    s.Firstname, s.LastName, c.CourseName, e.Score AS MaxScore
FROM 
    Enrollments e 
JOIN MaxScores ms ON e.CourseID = ms.CourseID AND e.Score = ms.MaxScore
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
ORDER BY
    e.CourseID;

-- FLER TABELLER & UPPGIFTER


CREATE TABLE Products (
    ProductID INT IDENTITY PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    Price DECIMAL(10,2)                      -- Decimaltal med totalt 10 siffror, varav 2 st efter decimaltecknet
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    City NVARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderItems (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT
);

INSERT INTO Products VALUES
('Wireless Mouse', 'Electronics', 25.99),
('Laptop', 'Electronics', 999.99),
('Notebook', 'Stationery', 3.50),
('Pen Pack', 'Stationery', 4.99),
('Desk Lamp', 'Home', 29.99);


INSERT INTO Customers VALUES
('John', 'Doe', 'New York'),
('Jane', 'Smith', 'Chicago'),
('Mike', 'Brown', 'New York'),
('Lisa', 'Taylor', 'Seattle');


INSERT INTO Orders VALUES
(1, '2024-01-10'),
(1, '2024-02-15'),
(2, '2024-03-01'),
(3, '2024-03-22'),
(4, '2024-04-05');

INSERT INTO OrderItems VALUES
(1, 2, 1),
(1, 1, 2),
(2, 5, 1),
(3, 3, 5),
(3, 4, 3),
(4, 1, 1),
(5, 2, 1);


SELECT * FROM Products;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderItems;


-- Excercise 1 Find the total number of orders placed by each customer [Easy]
SELECT
    c.FirstName, c.LastName, (
                                SELECT COUNT(*)
                                FROM Orders o
                                WHERE o.CustomerID = c.CustomerID
                            ) AS NumberOfOrders
FROM 
    Customers c;

WITH NumberOfOrders AS(
    SELECT
        CustomerID, COUNT(*) AS Totalorders
    FROM
        Orders
    GROUP BY
        CustomerID
)

SELECT
    c.FirstName, c.LastName, noo.Totalorders
FROM 
    Customers c 
JOIN NumberOfOrders noo ON c.CustomerID = noo.CustomerID;

-- Excercise 2 List products that have been ordered more than once across all orders [Easy-Medium]
WITH orderCount AS (
    SELECT
        ProductID, SUM(Quantity) AS [Total orders]
    FROM
        OrderItems
    GROUP BY
        ProductID
    HAVING
        SUM(Quantity) > 1
)
SELECT
    p.ProductName, oc.[Total orders]
FROM
    Products p 
JOIN orderCount oc ON p.ProductID = oc.ProductID;

SELECT ProductName
FROM Products
WHERE ProductID IN (
    SELECT ProductID
    FROM OrderItems
    GROUP BY ProductID
    HAVING SUM(Quantity) > 1
);

-- Excercise 3 Find the average order value for each customer (based on price × quantity) [Medium]
-- Hint: just use CTE version for this one

WITH orderValue AS(
    SELECT
        o.CustomerID, o.OrderID, SUM(p.Price * oi.Quantity) AS ItemValue
    FROM
        Orders o 
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    JOIN Products p ON oi.ProductID = p.ProductID
    GROUP BY 
        o.CustomerID, o.OrderID
), 
    AverageValue AS (
        SELECT
            ov.CustomerID, AVG(ItemValue) AS AverageOrder
        FROM
            orderValue ov 
        GROUP BY
            ov.CustomerID
    )

SELECT 
    c.FirstName, c.LastName, CAST(av.AverageOrder AS decimal(5,2))
FROM 
    Customers c 
JOIN AverageValue av ON c.CustomerID = av.CustomerID




