SELECT
    EMPLOYEE_ID, LAST_NAME
FROM EMPLOYEES
WHERE lower(LAST_NAME) LIKE '%e'