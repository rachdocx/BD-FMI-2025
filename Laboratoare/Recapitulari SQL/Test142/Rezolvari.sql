--1
SELECT c.nume, c.prenume, NVL(SUM(ca.pret), 0) AS suma_platita_2025
FROM CITITORI c
LEFT JOIN CUMPARAT cu ON c.id_cititor = cu.id_cititor AND TO_CHAR(cu.data, 'YYYY') = '2025'
LEFT JOIN CARTI ca ON cu.id_carte = ca.id_carte
GROUP BY c.id_cititor, c.nume, c.prenume
ORDER BY c.nume, c.prenume;
--2
select c.NUME, c.PRENUME, count(distinct NUME_AUTOR)
from (
    select *
    from CITITORI c
    where to_char(data_nastere, 'YYYY') between '1990' and '1999'
     ) c
left join CUMPARAT cu on c.ID_CITITOR = cu.ID_CITITOR
left join carti ca on cu.ID_CARTE = ca.ID_CARTE
group by c.NUME, c.PRENUME
having count(distinct NUME_AUTOR) > =2;

--3
select *
from(
select *
from CARTI
join OPINIE o on CARTI.ID_CARTE = o.ID_CARTE
order by  o.RATING desc)
where rownum<= (
    select count(l.ID_LIBRARIE)
    from CARTI c1
    join CUMPARAT cu on c1.ID_CARTE = cu.ID_CARTE
    join LIBRARIE l on cu.ID_LIBRARIE = l.ID_LIBRARIE
    group by l.NUME
    having lower(l.NUME) = 'humanitas'
    )
