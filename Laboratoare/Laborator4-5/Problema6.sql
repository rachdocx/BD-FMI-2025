SELECT e.employee_id AS ang,
       e.first_name || ' ' || e.last_name AS angajat,
       m.employee_id AS mgr,
       m.first_name || ' ' || m.last_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
