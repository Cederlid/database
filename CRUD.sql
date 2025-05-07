USE everyloop

SELECT 
    * 
INTO 
    GoT
FROM 
    GameOfThrones;
--a)
SELECT 
    Title, 'S' +
    FORMAT(Season, '00') + 'E'+ FORMAT(EpisodeInSeason, '00') AS Episode
    FROM
    GoT;

--b)
SELECT
    *
INTO
    User2
FROM
    Users;

SELECT
    *
FROM
    User2;

UPDATE 
    User2 
SET UserName = LOWER(LEFT(FirstName, 2)) + LOWER(LEFT(LastName, 2))

--c)  

SELECT 
    *
INTO
    Airports2
FROM
    Airports;

SELECT
    *
FROM
    Airports2;

UPDATE
    Airports2
SET
    DST = '-' , Time = '-'
WHERE DST IS NULL OR Time is Null;

UPDATE 
    Airports2
SET
    Time = ISNULL(Time, '-'),
    DST = ISNULL(DST, '-')

--d) 

SELECT
    *
INTO
    Elements2
FROM
    Elements

SELECT
    *
FROM
    Elements2


DELETE FROM
    Elements2
WHERE Name IN ('Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium')
    OR LOWER(LEFT(Name, 1)) IN ('d', 'k', 'm', 'o', 'u')

--e) 

SELECT 
    Symbol, Name,
    CASE
        WHEN LEFT(Name, LEN(Symbol)) = Symbol THEN 'Yes'
        ELSE 'No'
    END AS Match
INTO
    Elements3
FROM
    Elements

SELECT 
    * 
FROM
    Elements3
