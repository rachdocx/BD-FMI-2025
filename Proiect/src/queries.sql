--1 Care sunt albumele care se pot achizitona 
--in cel putin doua formate diferite,
--si care sunt aduse de cel putin doi furnizori.

SELECT a.id_product, a.album_name
FROM ALBUM a
WHERE a.id_product IN (
    SELECT m.id_product
    FROM MEDIA_FORMAT m
    GROUP BY m.id_product
    HAVING COUNT(DISTINCT m.id_media_format) >= 2
)
AND a.id_product IN (
    SELECT s.id_product
    FROM STOCK s
    GROUP BY s.id_product
    HAVING COUNT(DISTINCT s.id_provider) >= 2
);

--2 Afisati numele albumului, pretul si casa de discuri a artistilor al caror prenume incepe cu "K" sau al caror nume de familie
--incepe cu "M" si au  un pret mai mare decat pretul mediu al tuturor albumelor din baza de date
-- cereri sincornizate cu 3 tabele
SELECT DISTINCT a.album_name, p.price, r.label_name
FROM ALBUM a
JOIN PRODUCT p ON a.id_product = p.id_product
JOIN RECORD_LABEL r ON a.id_record_label = r.id_record_label
JOIN SONG s ON s.id_product = a.id_product
JOIN ARTIST ar ON s.id_artist = ar.id_artist
WHERE (ar.first_name LIKE 'K%' OR ar.last_name LIKE 'M%')
  AND p.price > (
      SELECT AVG(price) 
      FROM PRODUCT 
      WHERE id_product IN (SELECT id_product FROM ALBUM)
  );
  
--3
-- Afisati numele formatului media, numarul de albume care se gasesc in respectivul format media, si media
-- pretului tuturor albumelor din respectivul format media dupa adaugarea procentului la pretul de baza.
SELECT fm.media_format_name, 
       COUNT(a.id_product) AS album_count,
       ROUND(AVG(p.price * (1 + fm.procent_added/100)), 2) AS pret_cu_adaos
FROM ALBUM a
JOIN PRODUCT p ON a.id_product = p.id_product
JOIN (
    SELECT id_product, media_format_name, procent_added
    FROM MEDIA_FORMAT
    WHERE procent_added > 0
) fm ON fm.id_product = a.id_product
GROUP BY fm.media_format_name
ORDER BY pret_cu_adaos DESC;

--4
-- Pentru fiecare gen, afișează numărul de albume, numărul total de cântece și prețul mediu al albumelor din acel gen.
-- Grupari cu subcereri in HAVING
SELECT g.genre_name, 
       COUNT(DISTINCT a.id_product) AS numar_albume,
       COUNT(s.id_song) AS numar_melodii,
       ROUND(AVG(p.price), 2) AS pret_mediu
FROM GENRE g
JOIN ALBUM a ON g.id_album = a.id_product
JOIN SONG s ON s.id_product = a.id_product
JOIN PRODUCT p ON a.id_product = p.id_product
GROUP BY g.genre_name
HAVING COUNT(s.id_song) > (
    SELECT AVG(numar_melodii) 
    FROM (SELECT COUNT(*) AS numar_melodii FROM SONG GROUP BY id_product)
)
ORDER BY numar_melodii DESC;

--5
-- Cererea 4: NVL, DECODE, ordonări
SELECT 
    c.last_name || ', ' || c.first_name AS customer_name,
    c.city,
    COUNT(p.id_purchase) AS purchase_count,
    SUM(p.quantity) AS total_items,
    NVL(SUM(p.quantity * pur.price), 0) AS total_spent,
    NVL(MAX(TO_CHAR(p.purchase_date, 'YYYY-MM-DD')), 'Never purchased') AS last_purchase,
    DECODE(COUNT(DISTINCT a.id_product), 0, 'New Here', 
           CASE WHEN COUNT(DISTINCT a.id_product) > 2 THEN 'Music lLover'
                ELSE 'Casual istener' END) AS customer_type
FROM CUSTOMER c
LEFT JOIN PURCHASE p ON c.id_customer = p.id_customer
LEFT JOIN PRODUCT pur ON p.id_product = pur.id_product
LEFT JOIN ALBUM a ON p.id_product = a.id_product
GROUP BY c.last_name, c.first_name, c.city
ORDER BY purchase_count DESC, total_spent ASC;


--6
-- Cererea 5: Funcții șiruri, date, expresia CASE, WITH
WITH artist_metrics AS (
    SELECT 
        ar.id_artist,
        ar.first_name || ' ' || NVL(ar.last_name, '') AS artist_name,
        COUNT(DISTINCT s.id_product) AS album_count,
        COUNT(s.id_song) AS song_count
    FROM ARTIST ar
    JOIN SONG s ON ar.id_artist = s.id_artist
    GROUP BY ar.id_artist, ar.first_name, ar.last_name
)
SELECT 
    am.artist_name,
    UPPER(SUBSTR(am.artist_name, 1, 1)) || LOWER(SUBSTR(am.artist_name, 2)) AS formatted_name,
    am.album_count,
    am.song_count,
    CASE 
        WHEN am.song_count > 10 THEN 'Prolific Artist'
        WHEN am.song_count > 5 THEN 'Active Artist'
        ELSE 'Emerging Artist'
    END AS artist_status,
    ADD_MONTHS(SYSDATE, ROUND(am.song_count/2)) AS next_album_prediction,
    MONTHS_BETWEEN(SYSDATE, MIN(p.release_date)) AS months_active
FROM artist_metrics am
JOIN SONG s ON s.id_artist = am.id_artist
JOIN PRODUCT p ON s.id_product = p.id_product
GROUP BY am.artist_name, am.album_count, am.song_count
ORDER BY am.song_count DESC;


