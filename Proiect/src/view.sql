CREATE VIEW ALBUMEDETALIATE AS
SELECT
    a.id_produs,
    a.nume_album,
    g.nume_gen,
    f.nume_format_media,
    p.pret AS pret_baza,
    f.procent_adaugat,
    (p.pret * (1 + f.procent_adaugat / 100)) AS pret_final_calculat
FROM ALBUM a
JOIN PRODUS p ON a.id_produs = p.id_produs
JOIN GEN g ON a.id_gen = g.id_gen
JOIN FORMAT_MEDIA f ON a.id_produs = f.id_produs
WHERE p.data_lansare >= TO_DATE ('2015-01-01', 'YYYY-MM-DD');
--Nepermisa
UPDATE ALBUMEDETALIATE
SET pret_final_calculat = 75.00
WHERE id_produs = 12;
--sau
UPDATE ALBUMEDETALIATE
SET nume_album = 'blonde - special edition'
WHERE id_produs = 12;

--Permisa
UPDATE ALBUM
SET nume_album = 'blonde - special edition'
WHERE id_produs = 12;