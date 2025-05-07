USE everyloop

--a)Ta ut (select) en rad för varje (unik) period i tabellen ”Elements” med följande kolumner: ”period”, ”from” med lägsta atomnumret i perioden, ”to” med högsta atomnumret i perioden, ”average isotopes” med genomsnittligt antal isotoper visat med 2 decimaler, ”symbols” med en kommaseparerad lista av alla ämnen i perioden. 
SELECT
    Period,
    MIN(Number) AS [From],
    MAX(Number) AS [To],
    ROUND(AVG(CAST(Stableisotopes AS FLOAT)), 2) AS [Average isotops],
    STRING_AGG(Symbol, ', ') AS [All symbols]
FROM
    Elements
GROUP BY 
    Period
ORDER BY Period

--b) För varje stad som har 2 eller fler kunder i tabellen Customers, ta ut (select) följande kolumner: ”Region”, ”Country”, ”City”, samt ”Customers” som anger hur många kunder som finns i staden.
SELECT
    COUNT(*) AS Customers,
    Region, 
    Country, 
    City
FROM
    company.customers
GROUP BY
    City, Region, Country
HAVING
    COUNT(*) >= 2

--c)Skapa en varchar-variabel och skriv en select-sats som sätter värdet: ”Säsong 1 sändes från april till juni 2011. Totalt sändes 10 avsnitt, som i genomsnitt sågs av 2.5 miljoner människor i USA.”, följt av radbyte/char(13), följt av ”Säsong 2 sändes …” osv. När du sedan skriver (print) variabeln till messages ska du alltså få en rad för varje säsong enligt ovan, med data sammanställt från tabellen GameOfThrones. Tips: Ange ’sv’ som tredje parameter i format() för svenska månader.  

DECLARE @variabel AS VARCHAR(MAX) = ''


SELECT
    @variabel += 'Säsong ' + CAST(Season AS varchar) + ' sändes från ' + LOWER(FORMAT(MIN([Original air date]), 'MMMM', 'sv')) + ' till ' + LOWER(FORMAT(MAX([Original air date]), 'MMMM yyyy', 'sv')) + '. ' + 'Total sänder ' + CAST(COUNT(*) AS varchar) + ' avsnitt, som i genomsnitt sågs av ' + FORMAT(AVG([U.S. viewers(millions)]), 'N1', 'en') + ' miljoner människor i USA.' + CHAR(13)
FROM
    GameOfThrones
GROUP BY 
    Season
PRINT @variabel

--d) Ta ut (select) alla användare i tabellen ”Users” så du får tre kolumner: ”Namn” som har fulla namnet; ”Ålder” som visar hur många år personen är idag (ex. ’45 år’); ”Kön” som visar om det är en man eller kvinna. Sortera raderna efter för- och efternamn. 
SELECT 
    FirstName + ' ' + Lastname AS 'Namn',
    CAST(DATEDIFF(YEAR, 
        CASE 
            WHEN LEFT(ID, 2) > RIGHT(CAST(YEAR(GETDATE()) AS CHAR(4)), 2)
                THEN CAST('19' + LEFT(ID, 6) AS DATE)
            ELSE CAST('20' + LEFT(ID, 6) AS DATE)
        END, 
    GETDATE()) AS VARCHAR) + ' år' AS Ålder,
    CASE 
        WHEN CAST(SUBSTRING(ID, 10, 1) AS INT) % 2 = 0 THEN 'Kvinna'
        ELSE 'Man'
    END AS Kön
FROM
    Users
ORDER BY
    FirstName, LastName;

--e) Ta ut en lista över regioner i tabellen ”Countries” där det för varje region framgår regionens namn, antal länder i regionen, totalt antal invånare, total area, befolkningstätheten med 2 decimaler, samt spädbarnsdödligheten per 100.000 födslar avrundat till heltal. 

SELECT
    Region,
    COUNT(CAST(Country AS varchar)) AS [Antal länder i regionen],
    SUM(CAST(Population AS bigint)) AS [Totalt antal invånare],
    SUM(CAST([Area (sq# mi#)] AS bigint)) AS [Total area],
    ROUND(
        CAST(SUM(CAST(Population AS FLOAT)) / NULLIF(SUM(CAST([Area (sq# mi#)] AS FLOAT)), 0) AS DECIMAL(10,2)),
        2
    ) AS [Befolkningstäthet],
    ROUND(
        SUM(TRY_CAST(REPLACE([Infant mortality (per 1000 births)], ',', '.') AS FLOAT) * 100),
        0
    ) AS [Spädbarnsdödlighet per 100000 födslar]
FROM 
    Countries
GROUP BY
    Region

--f) Från tabellen ”Airports”, gruppera per land och ta ut kolumner som visar: land, antal flygplatser (IATA-koder), antal som saknar ICAO-kod, samt hur många procent av flygplatserna i varje land som saknar ICAO-kod. 

SELECT
    COUNT(CAST(IATA AS varchar)) AS [Antal flygplatser],
    LTRIM(RIGHT([Location served], CHARINDEX(',', REVERSE([Location served])) -1)) AS Land,
    COUNT(CASE WHEN ICAO IS NULL OR ICAO = '' THEN 1 END) AS [Saknar ICAO],
    CAST(
    ROUND(
        100.0 * COUNT(CASE WHEN ICAO IS NULL OR ICAO = '' THEN 1 END) / COUNT(IATA),
        1
    ) AS DECIMAL(5,2)
) AS [% utan ICAO]
FROM
    Airports
WHERE
    [Location served] LIKE '%,%' 
GROUP BY
    LTRIM(RIGHT([Location served], CHARINDEX(',', REVERSE([Location served])) - 1))
ORDER BY
    [% utan ICAO] DESC


