-- 1
SELECT a.nume, count(a.nume)
FROM ARTISTI A
JOIN TURNEE T ON A.ID_ARTIST = T.ID_ARTIST
JOIN CONCERTE C ON C.ID_TURNEU = T.ID_TURNEU
JOIN ARTISTI D ON C.ID_ARTIST_DESCHIDERE = D.ID_ARTIST
where lower(d.tip) = 'formatie'
group by A.nume;

--2
SELECT
    a.nume,
    count(al.nume_album)
FROM ALBUME al
JOIN ARTISTI a ON al.id_artist = a.id_artist
JOIN (
    select ID_ARTIST, max(AN_DECERNARE) as ultimul
    from premii_castigate
    group by ID_ARTIST
     ) ceva on al.id_artist = ceva.id_artist
where al.an_lansare < ceva.ultimul and al.ID_ARTIST in (
    SELECT a.ID_ARTIST
    from ARTISTI a
    join turnee t on a.ID_ARTIST = t.ID_ARTIST
    join CONCERTE c on c.ID_TURNEU = t.ID_TURNEU
    where to_char(c.data, 'YYYY') = '2024'
    group by a.ID_ARTIST
    having count(ID_CONCERT) > = 3
    )
group by a.nume ;

--3
select
    a.NUME as "artist principal",
    sum(c.venit)
from ARTISTI a
join TURNEE t on a.ID_ARTIST = t.ID_ARTIST
join CONCERTE c on c.ID_TURNEU = t.id_turneu
join ARTISTI deschidere ON c.id_artist_deschidere = deschidere.id_artist
where deschidere.ID_ARTIST in(
select
    a.id_artist
from PREMII_CASTIGATE p
join artisti a on a.ID_ARTIST = p.id_artist
group by a.id_artist
having count(a.ID_ARTIST)>=3
    ) and to_char(c.data, 'YYYY') = '2025'
group by a.nume;



/*
 scraps
select
    a.id_artist,
    count(p.ID_ARTIST)
from PREMII_CASTIGATE p
join artisti a on a.ID_ARTIST = p.id_artist
group by a.id_artist;

select ultimul
from ARTISTI a
join(
select ID_ARTIST, max(AN_DECERNARE) as ultimul
from premii_castigate
group by ID_ARTIST) ceva on a.id_artist = ceva.id_artist;

SELECT a.ID_ARTIST, count(ID_CONCERT)
from ARTISTI a
join turnee t on a.ID_ARTIST = t.ID_ARTIST
join CONCERTE c on c.ID_TURNEU = t.ID_TURNEU
where to_char(c.data, 'YYYY') = '2024'
group by a.ID_ARTIST
having count(ID_CONCERT) > = 3;

 */