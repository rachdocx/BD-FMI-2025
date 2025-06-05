--1
select p.nume, p.PRENUME
from pacient p
join CONSULTATIE c on c.ID_PACIENT = p.ID_PACIENT
join PRESCRIPTIE pr on c.ID_CONSULTATIE = pr.ID_CONSULTATIE
join MEDICAMENT m on m.ID_MEDICAMENT = pr.ID_MEDICAMENT
where lower(m.NUME) = 'ibuprofen';

--2
select d.ID_DOCTOR, d.nume, d.PRENUME, s.NUME, d.SALARIU, d.nr
from(
select d.ID_DOCTOR, d.ID_SECTIE,d.nume, d.prenume, count(d.ID_DOCTOR) as nr, d.SALARIU
from DOCTOR d
join CONSULTATIE c on d.ID_DOCTOR = c.ID_DOCTOR
group by d.ID_DOCTOR, d.ID_SECTIE, d.nume, d.prenume, d.SALARIU
having count(d.ID_DOCTOR) >=2
order by d.salariu desc, count(d.ID_DOCTOR) asc) d
join SECTIE s on s.ID_SECTIE = d.id_sectie
where ROWNUM <=2;


--3
select nvl(d.nume, '-'), nvl(d.prenume, '-'), nvl(d.salariu, '0'), d.id_doctor, s.nume
from SECTIE s
left join DOCTOR d on s.ID_SECTIE = d.ID_SECTIE
where d.SALARIU = (
    select max(d2.salariu)
    from DOCTOR d2
    where d.ID_SECTIE = d2.ID_SECTIE
    );


--4
SELECT DISTINCT p.nume
FROM SECTIE s
JOIN PACIENT p ON s.ID_SECTIE = p.ID_SECTIE
WHERE s.ID_SECTIE IN (
    SELECT ID_SECTIE
    FROM (
        SELECT s2.ID_SECTIE, COUNT(c.id_consultatie) AS nr_consultatii
        FROM SECTIE s2
        JOIN PACIENT p2 ON s2.ID_SECTIE = p2.ID_SECTIE
        JOIN CONSULTATIE c ON p2.ID_PACIENT = c.ID_PACIENT
        GROUP BY s2.ID_SECTIE
    )
    WHERE nr_consultatii = (
        SELECT MIN(nr)
        FROM (
            SELECT COUNT(c.id_consultatie) AS nr
            FROM SECTIE s3
            JOIN PACIENT p3 ON s3.ID_SECTIE = p3.ID_SECTIE
            JOIN CONSULTATIE c ON p3.ID_PACIENT = c.ID_PACIENT
            GROUP BY s3.ID_SECTIE
        )
    )
)
