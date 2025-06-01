--Outer join
SELECT m.id_produs,p.pret as pret_baza,m.tip_merch,m.marime_merch,s.id_stoc,f.nume_furnizor
FROM MERCHANDISE m
JOIN PRODUS p ON m.id_produs = p.id_produs
LEFT OUTER JOIN STOC s ON m.id_produs = s.id_produs
LEFT OUTER JOIN FURNIZOR f ON s.id_furnizor = f.id_furnizor;
--Divison
SELECT a.id_artist, a.prenume, a.nume_familie
FROM ARTIST a 
WHERE NOT EXISTS (  SELECT al.id_produs 
                    FROM ALBUM al 
                    JOIN CASA_DE_DISCURI c ON al.id_casa_discuri = c.id_casa_discuri 
                    WHERE c.nume_casa = 'Universal Music' 
                    AND NOT EXISTS ( SELECT m.id_melodie 
                                     FROM MELODIE m 
                                     WHERE m.id_artist = a.id_artist AND m.id_produs = al.id_produs ) );
--Analiza Top-n
SELECT nume_functie, salariu 
FROM (  SELECT a.prenume , a.nume_familie, f.nume_functie, a.salariu 
        FROM ANGAJAT a 
        JOIN FUNCTIE f ON a.id _functie = f.id_functie 
        ORDER BY a.salariu DESC ) 
WHERE ROWNUM <= 5; 