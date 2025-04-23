--1
select
    p.oras, count(distinct r.ID_CLIENT)
from PROPRIETATI p
join REZERVARI r on p.ID_PROPRIETATE = r.ID_PROPRIETATE
join CLIENTI c on r.id_client = c.ID_CLIENT
where lower(r.STATUS) = 'confirmata'
group by p.oras;

--2
select
    c.ID_CLIENT,
    c.NUME
from CLIENTI c
join (
select
    ID_CLIENT,
    nr_reviews
from(
select
    c.ID_CLIENT,
    count( c.id_client) as nr_reviews
from reviews r
join clienti c on r.ID_CLIENT = c.id_client
where r.rating >= 2
group by c.ID_CLIENT)
where nr_reviews >= 3) ceva on c.id_client = ceva.id_client
WHERE c.id_client NOT IN (
    SELECT rez.id_client
    FROM PLATI p
    JOIN REZERVARI rez ON p.id_rezervare = rez.id_rezervare
    WHERE LOWER(p.metoda) <> 'cash'
);

--3
select *
from(
select
    c.NUME,
    sum((r.DATA_CHECK_OUT-r.DATA_CHECK_IN)*p.PRET_PER_NOAPTE) as bani
from CLIENTI c
join REZERVARI r on c.ID_CLIENT = r.ID_CLIENT
join PROPRIETATI p on r.ID_PROPRIETATE = p.ID_PROPRIETATE
group by c.NUME
order by bani desc)
where rownum<=(
    select count(distinct r.ID_PROPRIETATE)
    from PROPRIETATI p
    join REZERVARI r on p.ID_PROPRIETATE = r.ID_PROPRIETATE
    where to_char(r.DATA_CHECK_IN, 'YYYY') = '2025'
);
