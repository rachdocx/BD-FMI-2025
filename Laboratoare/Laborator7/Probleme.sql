
-- 1. Numărul de angajați care sunt șefi
SELECT COUNT(*) AS nr_sefi
FROM (
    SELECT manager_id
    FROM employees
    WHERE manager_id IS NOT NULL
    GROUP BY manager_id
);

-- 2. Angajați care câștigă mai mult decât salariul mediu
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    GROUP BY NULL
);

-- 3. Codul șefului și salariul minim al subordonaților
SELECT manager_id, MIN(salary) AS salariu_minim
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) >= 4000
ORDER BY salariu_minim DESC;

-- 4. Maximul salariilor medii pe departamente
SELECT MAX(sal_mediu) AS salariu_mediu_maxim
FROM (
    SELECT AVG(salary) AS sal_mediu
    FROM employees
    GROUP BY department_id
)

SELECT MAX(sal_mediu)
FROM(
SELECT AVG(salary) as sal_mediu
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID)

-- 5. Suma salariilor pentru fiecare job în departamente cu cod > 80
SELECT d.department_name AS "Departament",
       e.job_id AS "Job",
       SUM(e.salary) AS "Total Salarii"
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id > 80
GROUP BY d.department_name, e.job_id;


-- 6. Comisionul mediu din firmă (cu GROUP BY)
SELECT 'Comision mediu' AS descriere, AVG(NVL(commission_pct, 0)) AS comision_mediu
FROM employees
GROUP BY 'Comision mediu';

-- 7. Departamente cu mai puțin de 4 angajați
SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS nr_angajati
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) < 4;

-- 8. Job-ul cu salariul mediu minim
SELECT job_id, AVG(salary) AS salariu_mediu
FROM employees
GROUP BY job_id
HAVING AVG(salary) = (
    SELECT MIN(avg_sal)
    FROM (
        SELECT job_id, AVG(salary) AS avg_sal
        FROM employees
        GROUP BY job_id
    )
);

-- 9. Cel mai mic salariu din departamentul cu cel mai mare salariu mediu
SELECT department_id, MIN(salary) AS salariu_minim
FROM employees
GROUP BY department_id
HAVING AVG(salary) = (
    SELECT MAX(avg_sal)
    FROM (
        SELECT department_id, AVG(salary) AS avg_sal
        FROM employees
        GROUP BY department_id
    )
);

-- 10. Info despre departamente și angajați (inclusiv fără angajați)
SELECT d.department_id, d.department_name,
       COUNT(e.employee_id) AS nr_angajati,
       AVG(e.salary) AS salariu_mediu,
       e.first_name, e.last_name, e.salary, e.job_id
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name,
         e.first_name, e.last_name, e.salary, e.job_id;


SELECT j.job_id, j.job_title, AVG(e.salary)
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
GROUP BY j.job_id, j.job_title
HAVING AVG(e.salary) = (
    SELECT MIN(avg_sal)
    FROM (
        SELECT AVG(salary) AS avg_sal
        FROM employees
        GROUP BY job_id
    )
);

SELECT d.department_name , MIN(e.salary)
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.department_id = (
    SELECT department_id
    FROM (
        SELECT department_id
        FROM employees
        GROUP BY department_id
        ORDER BY AVG(salary) DESC
    )
    WHERE ROWNUM = 1
)
GROUP BY d.department_name;
select e.department_name, min(e.salary)
from EMPLOYEES e
join DEPARTMENTS d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
where e.DEPARTMENT_ID = (
    select d.DEPARTMENT_ID
    from EMPLOYEES
    group by d.DEPARTMENT_ID
    order by avg(salary) desc
    )
    where