USE everyloop
SELECT 
    *
FROM
    dbo.Users

SELECT
    ID, UserName, Password 
FROM
    dbo.Users

SELECT TOP 10
    ID, UserName, Password 
FROM
    dbo.Users

SELECT 
    *
FROM
    dbo.Users
WHERE
    FirstName = 'Johanna'

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    Season = 1 AND [Directed by]='Brian Kirk'

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    [Directed by] IN ('Brian Kirk', 'Tim Van Patten', 'Alan Taylor')

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    Season BETWEEN 2 AND 4

SELECT
    *
FROM
    dbo.Airports
WHERE
    IATA BETWEEN 'AAF' AND 'AAJ'

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    [Directed by] LIKE 'D%'

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    [Directed by] LIKE '%R'

SELECT
    *
FROM
    dbo.Airports
WHERE
    IATA LIKE '[acf]_q'

SELECT
    *
FROM
    dbo.Airports
WHERE
    IATA LIKE '[acf]_[q-z]'

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    [Directed by] LIKE '[ABC]%[A-P]'

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    [Directed by] LIKE '%Ali%'

SELECT 
    *
FROM
    dbo.GameOfThrones
ORDER BY
    [Directed by] 

SELECT 
    *
FROM
    dbo.GameOfThrones
ORDER BY
    [Directed by] ASC

SELECT 
    *
FROM
    dbo.GameOfThrones
ORDER BY
    [Directed by] DESC

SELECT 
    *
FROM
    dbo.GameOfThrones
ORDER BY
    [U.S. viewers(millions)] DESC

SELECT 
    *
FROM
    dbo.GameOfThrones
WHERE
    [Directed by] LIKE 'D%'
ORDER BY
    [U.S. viewers(millions)] DESC

SELECT
    Title As [Episode Name], [Directed by]  As Director
FROM
    dbo.GameOfThrones

SELECT DISTINCT
    [Directed by]
FROM
    dbo.GameOfThrones

SELECT
    FirstName, Lastname
FROM   
    dbo.Users
UNION ALL
SELECT
    Title, [Directed by] 
FROM
    dbo.GameOfThrones

SELECT
    FirstName, CASE 
                    WHEN LEN(FirstName) <= 4 THEN 'Kort'
                    WHEN LEN(FirstName) >= 8 THEN 'Långt'
                    ELSE 'Mellan'
                END
                AS 'NamnLängd'
FROM
    dbo.Users

SELECT
	ID,
	FirstName,
	LastName,
	FirstName + ' ' + LastName AS FullName,
	FirstName + ' ' + LastName + '' + LastName AS Email
INTO
	Users3
FROM
	Users

SELECT * FROM Users3

-- MINIUPPGIFT 1
-- updatera Email till att anta formatet [förnamn]@gmail.com för alla rader där förnamnets längd är kortare än 6 bokstäver 
-- exempelvis ali@gmail.com

UPDATE Users3 SET Email = LOWER(FirstName) + '@gmail.com' 
WHERE LEN(FirstName) < 6

SELECT * FROM Users3