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
    WHERE p.id_product = s.id_product
)
WHERE s.id_stock IN (
    SELECT id_stock
    FROM (
        SELECT id_stock
        FROM STOCK s1
        WHERE EXISTS (
            SELECT 1 FROM PURCHASE p
            WHERE p.id_product = s1.id_product
        )
        ORDER BY id_product, id_stock
    )
    WHERE ROWNUM = 1
);
--b)
DELETE FROM STOCK
WHERE quantity <= (
    SELECT NVL(SUM(p.quantity), 0)
    FROM PURCHASE p
    WHERE p.id_product = STOCK.id_product
);


