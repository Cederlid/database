USE everyloop

-- UPPGIFT 1. Använd ”SELECT INTO” för att ta ut kolumnerna ’Spacecraft’, ’Launch date’,
--’Carrier rocket’, ’Operator’, samt ’Mission type’ för alla lyckade uppdrag
--(Successful outcome) och sätt in i en ny tabell med namn ”SuccessfulMissions”.

SELECT 
   Spacecraft,
   [Launch date],
   [Carrier rocket],
   Operator,
   [Mission type]
INTO
    SuccessfulMissions
FROM
    MoonMissions
WHERE
    Outcome LIKE '%Success%';

--UPPGIFT 2. I kolumnen ’Operator’ har det smugit sig in ett eller flera mellanslag före
--operatörens namn skriv en query som uppdaterar ”SuccessfulMissions” och tar
--bort mellanslagen kring operatör.

UPDATE
    SuccessfulMissions
SET 
    Operator = LTRIM(Operator);

--3. Skriv en select query som tar ut, grupperar, samt sorterar på kolumnerna
-- ’Operator’ och ’Mission type’ från ”SuccessfulMissions”. Som en tredje kolumn
-- ’Mission count’ i resultatet vill vi ha antal uppdrag av varje operatör och typ. Ta
-- bara med de grupper som har fler än ett (>1) uppdrag av samma typ och
-- operatör.
SELECT
    Operator,
    [Mission type],
    COUNT([Mission type]) AS [Mission count]
FROM
    SuccessfulMissions
GROUP BY 
    Operator, [Mission type]
HAVING
    COUNT([Mission type]) > 1
ORDER BY
    Operator, [Mission type];


--5. Ta ut samtliga rader och kolumner från tabellen ”Users”, men slå ihop
-- ’Firstname’ och ’Lastname’ till en ny kolumn ’Name’, samt lägg till en extra
-- kolumn ’Gender’ som du ger värdet ’Female’ för alla användare vars näst sista
-- siffra i personnumret är jämn, och värdet ’Male’ för de användare där siffran är
-- udda. Sätt in resultatet i en ny tabell ”NewUsers”.

SELECT  
    *,
    CONCAT(FirstName, ' ', LastName) AS Name,
    CASE 
        WHEN CAST(SUBSTRING(ID, 10, 1) AS INT) % 2 = 0 THEN 'Female'
        ELSE 'Male'
    END AS Gender
INTO 
    NewUsers
FROM
    Users;

-- 6. Skriv en query som returnerar en tabell med alla användarnamn i ”NewUsers”
-- som inte är unika i den första kolumnen, och antalet gånger de är duplicerade i
-- den andra kolumnen.

SELECT
    UserName, 
    COUNT(*) AS UserNameOccurence
FROM
    NewUsers
GROUP BY
    UserName
HAVING 
    COUNT(*) > 1;

-- 7. Skriv en följd av queries som uppdaterar de användare med dubblerade
-- användarnamn som du fann ovan, så att alla användare får ett unikt
-- användarnamn. D.v.s du kan hitta på nya användarnamn för de användarna, så
-- länge du ser till att alla i ”NewUsers” har unika värden på ’Username’.


UPDATE 
    NewUsers 
SET 
    UserName = LOWER(LEFT(FirstName, 2)) + LOWER(LEFT(LastName, 4));

SELECT
    UserName, 
    COUNT(*) AS UserNameOccurence
FROM
    NewUsers
GROUP BY
    UserName
HAVING 
    COUNT(*) > 1;

--8. Skapa en query som tar bort alla kvinnor födda före 1970 från ”NewUsers”.

SELECT
    *
FROM
    NewUsers
WHERE
   NOT (Gender = 'Female' AND SUBSTRING(ID, 1, 2) < 70);

--9. Lägg till en ny användare (hitta på en) i tabellen ”NewUsers”.

INSERT INTO NewUsers VALUES
('930613-6324', 'elekma', 'A33e67928d12r6c20t1e452h13d974e6', 'Ellinor','Ekmark','ellinor.ekmark@gmail.com', '0723365348', 'Ellinor Ekmark', 'Female');

-- 11. Skriv en query som selectar ut alla (77) produkter i company.products
-- Dessa ska visas i 4 kolumner:
-- Id – produktens id
-- Product – produktens namn
-- Supplier – namnet på företaget som leverar produkten
-- Category – namnet på kategorin som produkten tillhör
SELECT
    cp.Id,
    cp.ProductName AS Product,
    cs.CompanyName AS Supplier,
    cc.CategoryName AS Category
FROM
    company.products cp
JOIN company.suppliers cs ON cp.SupplierId = cs.Id
JOIN company.categories cc ON cp.CategoryId = cc.Id;

-- 12. Skriv en query som listar antal anställda i var och en av de fyra regionerna i
-- tabellen company.regions
SELECT 
    *
FROM
    company.regions
    
SELECT 
    *
FROM
    company.employees

SELECT 
    *
FROM
    company.employee_territory

SELECT
    *
FROM
    company.territories