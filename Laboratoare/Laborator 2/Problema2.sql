SELECT
    employee_id AS Cod_Angajat,
    FIRST_NAME AS Nume,
    department_id AS Cod_Departament
FROM EMPLOYEES
WHERE 'steven' in LOWER(FIRST_NAME);