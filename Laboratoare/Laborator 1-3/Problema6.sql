SELECT
    FIRST_NAME AS "Nume",
    ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) AS "Luni lucrate"
FROM EMPLOYEES
ORDER BY  "Luni lucrate" DESC;
