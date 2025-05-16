--1
UPDATE PRODUS
SET pret = pret * 1.2
WHERE id_produs IN (
    SELECT alb.id_produs
    FROM ALBUM alb
    JOIN GEN g ON alb.id_gen = g.id_gen
    WHERE UPPER(g.nume_gen) = 'POP'
);
--2
UPDATE ANGAJAT
SET salariu = salariu * 0.75
WHERE id_functie IN (
    SELECT id_functie
    FROM FUNCTIE
    WHERE nume_functie = 'IT Support'
);
--3
--a)
UPDATE STOC s
SET s.cantitate = s.cantitate - (
    SELECT SUM(ach.cantitate)
    FROM ACHIZITIE ach
    WHERE ach.status = 'Pending'
    AND ach.id_produs = s.id_produs
)
WHERE EXISTS (
    SELECT 1
    FROM ACHIZITIE ach
    WHERE ach.status = 'Pending'
    AND ach.id_produs = s.id_produs
)
AND s.id_stoc = (
    SELECT MIN(s2.id_stoc)
    FROM STOC s2
    WHERE s2.id_produs = s.id_produs
);
UPDATE ACHIZITIE
SET status = 'Completed'
WHERE status = 'Pending';
--b)
DELETE FROM STOC
WHERE cantitate <= 0;