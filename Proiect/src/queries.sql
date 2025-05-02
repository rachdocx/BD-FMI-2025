--1 
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

--2
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
SELECT 
    c.last_name || ', ' || c.first_name AS customer_name,
    c.city,
    COUNT(p.id_purchase) AS purchase_count,
    SUM(p.quantity) AS total_items,
    NVL(SUM(p.quantity * pur.price), 0) AS total_spent,
    NVL(MAX(TO_CHAR(p.purchase_date, 'YYYY-MM-DD')), 'Never purchased') AS last_purchase,
    DECODE(COUNT(DISTINCT a.id_product), 0, 'New Here', 
           CASE WHEN COUNT(DISTINCT a.id_product) > 2 THEN 'Music Lover'
                ELSE 'Casual Listener' END) AS customer_type
FROM CUSTOMER c
LEFT JOIN PURCHASE p ON c.id_customer = p.id_customer
LEFT JOIN PRODUCT pur ON p.id_product = pur.id_product
LEFT JOIN ALBUM a ON p.id_product = a.id_product
GROUP BY c.last_name, c.first_name, c.city
ORDER BY purchase_count DESC, total_spent ASC;

--6
WITH total_per_employee AS (
    SELECT 
        p.id_employee, 
        SUM(pr.price * p.quantity) AS total_value
    FROM PURCHASE p
    JOIN PRODUCT pr ON p.id_product = pr.id_product
    GROUP BY p.id_employee
)
SELECT *
FROM (
    SELECT 
        e.first_name || ' ' || NVL(e.last_name, 'anonim') AS full_name,
        f.function_name,
        ROUND(t.total_value, 2) AS valoare_totala_vanzari,
        CASE 
            WHEN t.total_value > 1000 THEN 'Performant'
            WHEN t.total_value > 500 THEN 'Activ'
            ELSE 'Slab activ'
        END AS categorie_angajat,
        TO_CHAR(e.hire_date, 'Mon YYYY') AS angajat_din,
        ROUND(e.salary * MONTHS_BETWEEN(SYSDATE, e.hire_date), 2) AS salariu_estimat_total
    FROM EMPLOYEE e
    JOIN FUNCTION f ON e.id_function = f.id_function
    JOIN total_per_employee t ON e.id_employee = t.id_employee
    WHERE EXISTS (
        SELECT 1 
        FROM PURCHASE p 
        WHERE p.id_employee = e.id_employee
    )
    ORDER BY t.total_value DESC
)
WHERE ROWNUM <= 15;
