--1
select c.id_client, c.name,
    case
        when count(distinct mv.id_movie) =0 then '---'
        else to_char(count(distinct mv.id_movie))
    END AS nr_filme
from CLIENTS c
left join BOOKINGS b on c.ID_CLIENT = b.id_client
left join MOVIE_SCREENING_ROOM m on b.ID_SCREENING = m.ID_SCREENING
left join MOVIES mv on m.ID_MOVIE = mv.ID_MOVIE and lower( mv.GENRE) = 'action'
GROUP BY c.id_client, c.name;

--2

select count(distinct c.id_client) as nr_clienti_vip
from CLIENTS c
join BOOKINGS b on c.ID_CLIENT = b.ID_CLIENT
join MOVIE_SCREENING_ROOM ms on b.ID_SCREENING = ms.ID_SCREENING
join SCREENING_ROOMS sr on ms.ID_ROOM = sr.ID_ROOM
where lower(sr.TYPE) = 'vip';

--3

select m.ID_MOVIE,  m.name,  sum(ms.ticket_price * b.number_tickets)
from MOVIES m
join MOVIE_SCREENING_ROOM ms on m.ID_MOVIE = ms.ID_MOVIE
join BOOKINGS b on b.ID_SCREENING = ms.ID_SCREENING
where trunc(ms.SCREENING_DATE) >=to_date('2024-04-01','YYYY-MM-DD') and trunc(ms.SCREENING_DATE) <=to_date('2024-04-21', 'YYYY-MM-DD')
group by m.ID_MOVIE, m.name




