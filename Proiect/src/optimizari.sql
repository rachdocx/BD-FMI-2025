--Neoptimizat
SELECT DISTINCT a.nume_album, p.pret 
FROM ARTIST ar, MELODIE m, ALBUM a, PRODUS p, CASA_DE_DISCURI c 
WHERE ar.id_artist = m.id_artist 
    AND m.id_produs = a.id_produs 
    AND a.id_produs = p.id_produs 
    AND a.id_casa_discuri = c.id_casa_discuri 
    AND ar.prenume = 'Kendrick' AND ar.nume_familie = 'Lamar' AND c.nume_casa = 'Atlantic Records'; 
    
--Optimizat
SELECT DISTINCT a.nume_album, p.pret 
FROM ARTIST ar 
JOIN MELODIE m ON ar.id_artist = m.id_artist 
JOIN ALBUM a ON m.id_produs = a.id_produs 
JOIN PRODUS p ON a.id_produs = p.id_produs 
JOIN CASA_DE_DISCURI cd ON a.id_casa_discuri = cd.id_casa_discuri 
WHERE ar.prenume = 'Kendrick' AND ar.nume_familie = 'Lamar' AND cd.nume_casa = 'Atlantic Records';