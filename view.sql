/*

CREATE VIEW statement

In SQL, a view is a virtual table based on the result-set of a SQL-statement.

A view contains rows and columns, just like a real table.
The fields in a view are fields from on or several proper tables in the database.

*/

/*

Views act as a layer of insulation between users and the underlying tables.
You can define a view that presents a specific subset of columns or joins data from multiple tables,
hiding the complexity from users who only need to see that specific data.

*/


/*

NOTE: Views are updated AUTOMATICALLY, as the underlying tables are updated.

Example below.

*/


USE AI24

CREATE SCHEMA Literature;       -- not really needed, but we use it anyway just to connect with previous lecture

CREATE TABLE Literature.Authors (
		AuthorID INT IDENTITY PRIMARY KEY,
		FirstName NVARCHAR(100) NOT NULL,
		LastName NVARCHAR(100) NOT NULL
);

CREATE TABLE Literature.Books (
		BookID INT IDENTITY PRIMARY KEY,
		Title NVARCHAR(100),
		Genre NVARCHAR(100),
		AuthorID INT FOREIGN KEY REFERENCES Literature.Authors(AuthorID) ON DELETE SET NULL    -- notera ON DELETE SET NULL
);


INSERT INTO Literature.Authors (FirstName, LastName)
VALUES ('Jane', 'Austen'),
       ('J.R.R.', 'Tolkien'),
       ('Harper', 'Lee');


INSERT INTO Literature.Books (Title, Genre, AuthorID)
VALUES ('Pride and Prejudice', 'Classic', 1),
       ('The Lord of the Rings', 'Fantasy', 2),
       ('To Kill a Mockingbird', 'Fiction', 3);


SELECT * FROM Literature.Authors;
SELECT * FROM Literature.Books;


-- Create a proper, dynamic VIEW

CREATE VIEW Literature.BookAuthorDetails AS

SELECT
	b.Title,
	a.FirstName,
	a.LastName
FROM
	Literature.Books b
	JOIN Literature.Authors a ON b.AuthorID = a.AuthorID; 


-- Check out our new VIEW

SELECT * FROM Literature.BookAuthorDetails;

-- Add another book to the books table

INSERT INTO Literature.Books (Title, Genre, AuthorID)
VALUES ('The Return of The King', 'Fantasy', 2);

-- Ok, now check out or view again

SELECT * FROM Literature.BookAuthorDetails;


/*

Here are some specific scenarios where views might be a good choice:

	
	Customer Dashboards:
	A view could present a customer's order history,
	combining data from order and product tables.

	Sales Report:
	A view could pre-calculate sales figures for specific product categories

	User Roles:
	Views can restrict access to sensitive data by only showing specific columns or rows to users with different roles.

*/


-- Okey, sidenote: let's try out our ON DELETE SET NULL

SELECT * FROM Literature.Authors;
SELECT * FROM Literature.Books;

DELETE FROM Literature.Authors WHERE AuthorID = 2; 

-- As promised, none of the rows from the Books table are deleted - their AuthorID is instead SET NULL.

SELECT * FROM Literature.Authors;
SELECT * FROM Literature.Books;


-- ALTER VIEW

ALTER VIEW Literature.BookAuthorDetails AS 

SELECT
	
	b.Title,
	a.FirstName,
	a.LastName,
	a.FirstName + ' ' + a.LastName AS 'FullName'
FROM
	Literature.Books b
	JOIN Literature.Authors a ON b.AuthorID = a.AuthorID; 


SELECT * FROM Literature.BookAuthorDetails;

