-- Задача: статистический поиск аномалий по правилу «3 сигм» (PostgreSQL)
-- ВАЖНО: экстремальные выбросы раздувают среднее и STDDEV своей группы
-- (эффект маскировки), поэтому часть аномалий ловит только пороговая
-- проверка из data_quality.sql — это нормально и о нём стоит рассказать.

WITH stats AS (
    SELECT
        employee_id,
        type_code,
        AVG(amount)      AS avg_amount,
        STDDEV_POP(amount) AS std_amount
    FROM transactions
    GROUP BY employee_id, type_code
    HAVING COUNT(*) > 3
)
SELECT
    t.id,
    t.txn_date,
    e.name  AS employee_name,
    t.type_code,
    t.amount,
    ROUND((t.amount - s.avg_amount) / NULLIF(s.std_amount, 0), 1) AS sigma_deviation,
    t.comment
FROM transactions t
JOIN stats s ON s.employee_id = t.employee_id AND s.type_code = t.type_code
JOIN employees e ON e.id = t.employee_id
WHERE ABS(t.amount - s.avg_amount) > 3 * s.std_amount
ORDER BY ABS(t.amount) DESC;
