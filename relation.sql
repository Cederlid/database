USE everyloop

--1. Företagets totala produktkatalog består av 77 unika produkter. Om vi kollar bland våra ordrar, hur stor andel av dessa produkter har vi någon gång leverarat till London? 

SELECT
    CAST(COUNT(DISTINCT cp.Id) AS FLOAT) / 77 AS [Andel levererade produkter till London]
FROM
    company.orders AS co 
    JOIN company.order_details AS cod ON co.Id = cod.OrderId
    JOIN company.products AS cp ON cod.ProductId = cp.Id
WHERE
    ShipCity LIKE 'London'

--2. Till vilken stad har vi levererat flest unika produkter? 
SELECT
    CAST(COUNT(DISTINCT cp.Id) AS FLOAT) AS [Antal unika produkter], co.ShipCity
FROM
    company.orders AS co 
    JOIN company.order_details AS cod ON co.Id = cod.OrderId
    JOIN company.products AS cp ON cod.ProductId = cp.Id
GROUP BY 
    co.ShipCity
ORDER BY 
    [Antal unika produkter] DESC

--3. Av de produkter som inte längre finns I vårat sortiment, hur mycket har vi sålt för totalt till Tyskland? 

SELECT
    SUM(cod.Quantity * cod.UnitPrice) AS [Totalt sålt till Tyskland för produkter som utgått]
FROM
    company.orders AS co 
JOIN 
    company.order_details AS cod ON co.Id = cod.OrderId
JOIN 
    company.products AS cp ON cod.ProductId = cp.Id
WHERE 
    Discontinued = 1 AND ShipCountry LIKE 'Germany'

--4. För vilken produktkategori har vi högst lagervärde? 
SELECT TOP 1
    cc.CategoryName AS [Kategori],
    SUM(UnitPrice * UnitsInStock) AS [Totalt lagervärde]
FROM
    company.products AS cp 
JOIN 
    company.categories AS cc ON cp.CategoryId = cc.Id
GROUP BY
    CategoryName
ORDER BY 
    [Totalt lagervärde] DESC

--5. Från vilken leverantör har vi sålt flest produkter totalt under sommaren 2013?

SELECT TOP 1
    CompanyName AS Levarantör,
    SUM(Quantity) AS [Totalt antal sålda]
FROM
    company.orders AS co 
JOIN 
    company.order_details AS cod ON co.Id = cod.OrderId
JOIN
    company.products AS cp ON cod.ProductId = cp.Id
JOIN
    company.suppliers AS cs ON cp.SupplierId = cs.Id
WHERE 
    OrderDate BETWEEN '2013-06-01' AND '2013-08-31'
GROUP BY 
    CompanyName
ORDER BY
    [Totalt antal sålda] DESC
------------------------------------------------------------------
DECLARE @playlist VARCHAR(MAX) = 'Heavy Metal Classic'

SELECT
    mg.Name AS Genre,
    mar.Name AS Artist,
    ma.Title AS Album,
    mt.Name AS Track,
    RIGHT('0' + CAST(Milliseconds / 60000 AS VARCHAR), 2) + ':' + 
    RIGHT('0' + CAST((Milliseconds / 1000) % 60 AS VARCHAR), 2) AS Length,
    CAST(Bytes / 1048576.0 AS DECIMAL(10,1)) AS MiB,
    mt.Composer
FROM
   music.tracks mt
JOIN 
    music.playlist_track plt ON mt.TrackId = plt.TrackId
JOIN 
    music.playlists pl ON plt.PlaylistId = pl.PlaylistId
JOIN
     music.genres mg ON mt.GenreId = mg.GenreId
JOIN 
    music.albums ma ON mt.AlbumId = ma.AlbumId
JOIN 
    music.artists mar ON ma.ArtistId = mar.ArtistId
WHERE
    pl.Name = @playlist
AND 
    (mg.Name = 'Heavy Metal' OR
    mg.Name = 'Metal')
--1. Av alla audiospår, vilken artist har längst total speltid? 
SELECT TOP 1
    mar.Name AS Artist,
    SUM(mt.Milliseconds) AS TotalMilliseconds,
    RIGHT('0' + CAST(SUM(mt.Milliseconds) / 3600000 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((SUM(mt.Milliseconds) / 60000) % 60 AS VARCHAR), 2) AS TotalLength
FROM
    music.tracks mt
JOIN music.albums ma ON mt.AlbumId = ma.AlbumId
JOIN music.artists mar ON ma.ArtistId = mar.ArtistId
WHERE
    mt.MediaTypeId IN (
        SELECT MediaTypeId FROM music.media_types WHERE Name LIKE '%audio%'
    )
GROUP BY
    mar.Name
ORDER BY
    SUM(mt.Milliseconds) DESC


--2. Vad är den genomsnittliga speltiden på den artistens låtar?
SELECT
    mar.Name AS Artist,
    RIGHT('0' + CAST(AVG(mt.Milliseconds) / 60000 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((AVG(mt.Milliseconds) / 1000) % 60 AS VARCHAR), 2) AS [Genomsnittlig speltid (MM:SS)],
    CAST(SUM(mt.Milliseconds) / 3600000 AS VARCHAR) + ':' +
    RIGHT('0' + CAST((SUM(mt.Milliseconds) / 60000) % 60 AS VARCHAR), 2) + ':' +
    RIGHT('0' + CAST((SUM(mt.Milliseconds) / 1000) % 60 AS VARCHAR), 2) AS [Total speltid (HH:MM:SS)]
FROM
    music.tracks mt
JOIN music.albums ma ON mt.AlbumId = ma.AlbumId
JOIN music.artists mar ON ma.ArtistId = mar.ArtistId
WHERE
    mar.Name = 'Iron Maiden'
GROUP BY
    mar.Name

--3. Vad är den sammanlagda filstorleken för all video? 

SELECT 
    CAST(SUM(mt.Bytes / 1048576.0) AS DECIMAL(18,2)) AS [Total storlek (MiB)]
FROM 
    music.tracks mt
JOIN 
    music.media_types mm ON mt.MediaTypeId = mm.MediaTypeId
WHERE 
    mm.Name LIKE '%video%'
AND 
    mt.Bytes IS NOT NULL;

--4. Vilket är det högsta antal artister som finns på en enskild spellista? 

SELECT TOP 1
    mp.Name AS Playlist,
    COUNT(DISTINCT mar.ArtistId) AS [Antal artister]
FROM
    music.tracks mt 
JOIN 
    music.playlist_track mpt ON mt.TrackId = mpt.TrackId
JOIN
    music.playlists mp ON mpt.PlaylistId = mp.PlaylistId
JOIN 
    music.albums ma ON mt.AlbumId = ma.AlbumId
JOIN 
    music.artists mar ON ma.ArtistId = mar.ArtistId
GROUP BY 
    mp.Name
ORDER BY 
    COUNT(DISTINCT mar.ArtistId) DESC

--5. Vilket är det genomsnittliga antalet artister per spellista?

SELECT 
    CAST(AVG(NumberOfArtists * 1.0) AS DECIMAL(5,1)) AS [Genomsnittliga antal artister per spellista]
FROM (
    SELECT 
        mp.PlaylistId,
        COUNT(DISTINCT mar.ArtistId) AS NumberOfArtists
    FROM
        music.tracks mt 
    JOIN 
        music.playlist_track mpt ON mt.TrackId = mpt.TrackId
    JOIN
        music.playlists mp ON mpt.PlaylistId = mp.PlaylistId
    JOIN 
        music.albums ma ON mt.AlbumId = ma.AlbumId
    JOIN 
        music.artists mar ON ma.ArtistId = mar.ArtistId
    GROUP BY 
        mp.PlaylistId
) AS ArtistCountPerPlaylist;

