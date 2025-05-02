--1
UPDATE PRODUCT
SET price = price * 1.2
WHERE id_product IN (
    SELECT id_album
    FROM GENRE
    WHERE UPPER(genre_name) = 'POP'
);
--2
UPDATE EMPLOYEE
SET salary = salary * 0.75
WHERE id_function IN (
    SELECT id_function
    FROM FUNCTION
    WHERE function_name = 'IT Support'
);
--3
--a)
UPDATE STOCK s
SET s.quantity = s.quantity - (
    SELECT SUM(p.quantity)
    FROM PURCHASE p
    WHERE p.status = 'Pending'
    AND p.id_product = s.id_product
)
WHERE EXISTS (
    SELECT 1
    FROM PURCHASE p
    WHERE p.status = 'Pending'
    AND p.id_product = s.id_product
)
AND s.id_stock = (
    SELECT MIN(s2.id_stock)
    FROM STOCK s2
    WHERE s2.id_product = s.id_product
);

UPDATE PURCHASE
SET status = 'Completed'
WHERE status = 'Pending';
--b)
DELETE FROM STOCK
WHERE quantity <= 0;