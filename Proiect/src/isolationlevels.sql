SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE STOC
SET cantitate = cantitate - 1
WHERE id_produs = 1;
INSERT INTO ACHIZITIE (
    id_achizitie, id_cumparator, id_angajat, id_produs, cantitate
)
VALUES (
    SEQ_ACHIZITIE.NEXTVAL, 2, 1, 1, 1
);
COMMIT;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE STOC
SET cantitate = cantitate - 2
WHERE id_produs = 1;
INSERT INTO ACHIZITIE (
    id_achizitie, id_cumparator, id_angajat, id_produs, cantitate
)
VALUES (
    SEQ_ACHIZITIE.NEXTVAL, 3, 2, 1, 2
);
COMMIT;


SET TRANSACTION READ ONLY;
SELECT id_produs, pret
FROM PRODUS
WHERE pret > 50;
COMMIT;

