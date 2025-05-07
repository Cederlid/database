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
	aas.Score > aas.AvgScore



-- Excercises can be solved using either SUBQUERIES OR CTE, up to you



-- Exercise 1: Find Students Enrolled in More Than two Courses

-- SUBQUERY
SELECT s.FirstName, s.LastName
FROM Students s
WHERE s.StudentID IN (
    SELECT StudentID
    FROM Enrollments
    GROUP BY StudentID
    HAVING COUNT(*) > 2
);


-- CTE version		    
WITH StudentEnrollmentsMoreThan2Courses AS (
    SELECT StudentID, COUNT(CourseID) AS NumCourses
    FROM Enrollments
    GROUP BY StudentID
    HAVING COUNT(CourseID) > 2
)
 
SELECT se.NumCourses, s.Firstname, s.LastName
FROM
    StudentEnrollmentsMoreThan2Courses se 
	JOIN Students s ON se.StudentID = s.StudentID

-- Excercise 2: Show average score per course, along with teacher name

-- SUBQUERY
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


-- CTE
WITH CourseAverages AS (
	SELECT CourseID, ROUND(AVG(CAST(Score AS float)),1) AS AvgScore
	FROM Enrollments
	GROUP BY CourseID
	                   )
SELECT 
	c.CourseName, c.Teacher, ca.AvgScore
FROM 
	CourseAverages ca 
	JOIN Courses c ON ca.CourseID = c.CourseID;



-- Excercise 3: Find students whose score is below the course average

-- SUBQUERY
SELECT s.FirstName, s.LastName, c.CourseName, e.Score, e.CourseID
FROM Enrollments e
JOIN Students s ON e.StudentID = s.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE e.Score < (
    SELECT AVG(e2.Score)
    FROM Enrollments e2
    WHERE e2.CourseID = e.CourseID
);

-- SUBQUERY 2

SELECT
    s.FirstName, s.LastName, e.CourseID, e.Score, ca.AvgCourseScore
FROM
    Enrollments e
JOIN
    Students s ON e.StudentID = s.StudentID
JOIN
    (SELECT CourseID, AVG(CAST(Score AS FLOAT)) AS AvgCourseScore
     FROM Enrollments
     GROUP BY CourseID) AS ca ON e.CourseID = ca.CourseID
WHERE
    e.Score < ca.AvgCourseScore;


-- CTE
WITH AverageScore AS (
    SELECT
        e.CourseID,
        ROUND(AVG(CAST(Score AS REAL)), 2) [AverageScore]
        
    FROM
        Students s JOIN Enrollments e ON s.StudentID = e.StudentID
        JOIN Courses c ON e.CourseID = c.CourseID
    GROUP BY
        e.CourseID
)
SELECT
    c.CourseName,
    s.FirstName + ' ' + LastName AS [Name],
    e.Score,
    a.AverageScore
FROM
    Students s JOIN Enrollments e ON s.StudentID = e.StudentID
    JOIN Courses c ON e.CourseID = c.CourseID
    JOIN AverageScore a ON a.CourseID = c.CourseID
WHERE e.Score < a.AverageScore


-- Excercise 4: List students who took 'Physics' and scored above 85.

-- SUBQUERY
SELECT  
	Firstname, LastName, CourseName, Score
FROM 
	Enrollments as e 
	JOIN Courses c ON c.CourseID = e.CourseID
	JOIN Students s ON s.StudentID = e.StudentID
WHERE e.CourseID = (
					SELECT CourseID
					FROM Courses
					WHERE Courses.CourseName  = 'Physics'
					)
	 AND e.Score > 85

-- CTE
WITH PhysicsEnrollments AS (
    SELECT 
		e.StudentID, e.Score
    FROM 
		Enrollments e
		JOIN Courses c ON e.CourseID = c.CourseID
    WHERE 
		c.CourseName = 'Physics' AND e.Score > 85
)
SELECT s.FirstName, s.LastName, p.Score
FROM PhysicsEnrollments p
JOIN Students s ON s.StudentID = p.StudentID;

-- Excercise 5: Find the top-performing student(s) per course

WITH MaxScores AS (
		SELECT CourseID, MAX(Score) AS MaxScore
		FROM Enrollments
		GROUP BY CourseID
), TopStudents AS (
		SELECT e.StudentID, e.CourseID, e.Score
		FROM Enrollments e
		JOIN MaxScores ms ON e.CourseID = ms.CourseID AND e.Score = ms.MaxScore
)
-- SELECT * FROM TopStudents
SELECT s.FirstName, s.LastName, c.CourseName, ts.Score
FROM TopStudents ts
JOIN Students s ON ts.StudentID = s.StudentID
JOIN Courses c ON ts.CourseID = c.CourseID;








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


SELECT * FROM Products
SELECT * FROM Customers
SELECT * FROM Orders
SELECT * FROM OrderItems


-- Excercise 1 Find the total number of orders placed by each customer [Easy]


-- Excercise 2 List products that have been ordered more than once across all orders [Easy-Medium]


-- Excercise 3 Find the average order value for each customer (based on price × quantity) [Medium]

-- Hint: just use CTE version for this one




