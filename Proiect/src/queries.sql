--1
SELECT a.id_produs, a.nume_album
FROM ALBUM a
WHERE a.id_produs IN (
    SELECT m.id_produs
    FROM FORMAT_MEDIA m
    GROUP BY m.id_produs
    HAVING COUNT(DISTINCT m.id_format_media) >= 2
)
AND a.id_produs IN (
    SELECT s.id_produs
    FROM STOC s
    GROUP BY s.id_produs
    HAVING COUNT(DISTINCT s.id_furnizor) >= 2
);

--2
SELECT a.nume_album, p.pret, g.nume_gen
FROM ALBUM a
JOIN PRODUS p ON a.id_produs = p.id_produs
JOIN GEN g ON a.id_gen = g.id_gen
WHERE p.pret >= NVL((
        SELECT AVG(p2.pret)
        FROM ALBUM a2
        JOIN PRODUS p2 ON a2.id_produs = p2.id_produs
        JOIN MELODIE m2 ON a2.id_produs = m2.id_produs
        JOIN ARTIST ar2 ON m2.id_artist = ar2.id_artist
        WHERE a2.id_gen = g.id_gen AND ar2.trupa IS NOT NULL ), 0);
  
--3
SELECT fm.nume_format_media,
       COUNT(a.id_produs) AS numar_albume,
       ROUND(AVG(p.pret * (1 + fm.procent_adaugat/100)), 2) AS pret_cu_adaos
FROM ALBUM a
JOIN PRODUS p ON a.id_produs = p.id_produs
JOIN (
    SELECT id_produs, nume_format_media, procent_adaugat
    FROM FORMAT_MEDIA
    WHERE procent_adaugat > 0
) fm ON fm.id_produs = a.id_produs
GROUP BY fm.nume_format_media
ORDER BY pret_cu_adaos DESC;

--4
SELECT g.nume_gen,
       COUNT(DISTINCT a.id_produs) AS numar_albume,
       COUNT(mel.id_melodie) AS numar_melodii, 
       ROUND(AVG(p.pret), 2) AS pret_mediu
FROM GEN g
JOIN ALBUM a ON g.id_gen = a.id_gen 
JOIN MELODIE mel ON mel.id_produs = a.id_produs 
JOIN PRODUS p ON a.id_produs = p.id_produs
GROUP BY g.nume_gen
HAVING COUNT(mel.id_melodie) > (
    SELECT AVG(numar_melodii_per_album)
    FROM (
        SELECT COUNT(id_melodie) AS numar_melodii_per_album
        FROM MELODIE
        GROUP BY id_produs 
    )
)
ORDER BY numar_melodii DESC;

--5
SELECT
    c.nume_familie || ', ' || c.prenume AS nume_client,
    c.oras,
    COUNT(ach.id_achizitie) AS numar_achizitii,
    SUM(ach.cantitate) AS total_articole,
    NVL(SUM(ach.cantitate * prod.pret), 0) AS total_cheltuit,
    NVL(MAX(TO_CHAR(ach.data_achizitie, 'YYYY-MM-DD')), 'Nicio achizitie') AS ultima_achizitie,
    DECODE(COUNT(DISTINCT alb.id_produs), 0, 'Client nou',
           CASE WHEN COUNT(DISTINCT alb.id_produs) > 1 THEN 'Ascultator frecvent'
                ELSE 'Ascultator ocazional' END) AS tip_client,
    COUNT(DISTINCT alb.id_produs)
FROM CUMPARATOR c
LEFT JOIN ACHIZITIE ach ON c.id_cumparator = ach.id_cumparator
LEFT JOIN PRODUS prod ON ach.id_produs = prod.id_produs
LEFT JOIN ALBUM alb ON prod.id_produs = alb.id_produs 
GROUP BY c.nume_familie, c.prenume, c.oras
ORDER BY numar_achizitii DESC, total_cheltuit ASC;
--6
WITH total_vanzari_per_angajat AS (
    SELECT
        ach.id_angajat,
        SUM(prod.pret * ach.cantitate) AS valoare_totala
    FROM ACHIZITIE ach
    JOIN PRODUS prod ON ach.id_produs = prod.id_produs
    GROUP BY ach.id_angajat
)
SELECT *
FROM (
    SELECT
        ang.prenume || ' ' || NVL(ang.nume_familie, 'anonim') AS nume_complet,
        f.nume_functie,
        ROUND(tva.valoare_totala, 2) AS valoare_totala_vanzari,
        CASE
            WHEN tva.valoare_totala > 1000 THEN 'Performant'
            WHEN tva.valoare_totala > 500 THEN 'Activ'
            ELSE 'Slab activ'
        END AS categorie_angajat,
        TO_CHAR(ang.data_angajare, 'Mon YYYY', 'NLS_DATE_LANGUAGE=Romanian') AS angajat_din_luna,
        ROUND(ang.salariu * MONTHS_BETWEEN(SYSDATE, ang.data_angajare), 2) AS salariu_estimat_total
    FROM ANGAJAT ang
    JOIN FUNCTIE f ON ang.id_functie = f.id_functie
    JOIN total_vanzari_per_angajat tva ON ang.id_angajat = tva.id_angajat
    WHERE EXISTS (
        SELECT 1
        FROM ACHIZITIE ach_check
        WHERE ach_check.id_angajat = ang.id_angajat
    )
    ORDER BY tva.valoare_totala DESC
)
WHERE ROWNUM <= 15;