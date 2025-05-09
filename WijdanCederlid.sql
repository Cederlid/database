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
    Outcome LIKE 'Success%';

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

