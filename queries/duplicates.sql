-- Задача: найти дубли операций (одна и та же операция проведена дважды)
-- Показывает: GROUP BY + HAVING + самоприсоединение таблицы к самой себе

WITH dup_keys AS (
    SELECT txn_date, employee_id, type_code, amount, COUNT(*) AS cnt
    FROM transactions
    GROUP BY txn_date, employee_id, type_code, amount
    HAVING COUNT(*) > 1
)
SELECT
    t.id,
    t.txn_date,
    e.name      AS employee_name,
    t.type_code,
    t.amount,
    dk.cnt      AS copies,
    t.comment
FROM transactions t
JOIN dup_keys dk
     ON dk.txn_date    = t.txn_date
    AND dk.employee_id = t.employee_id
    AND dk.type_code   = t.type_code
    AND dk.amount      = t.amount
JOIN employees e ON e.id = t.employee_id
ORDER BY t.txn_date;
