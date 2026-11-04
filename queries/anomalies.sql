-- Задача: найти операции, сильно выбивающиеся из среднего для своей группы
-- Вариант для SQLite (упрощённый): отклонение больше 3x от среднего по группе
-- Полная статистическая версия с STDDEV_POP для PostgreSQL — в anomalies_postgres.sql

WITH stats AS (
    SELECT
        type_code,
        AVG(ABS(amount)) AS avg_amount,
        COUNT(*)         AS cnt
    FROM transactions
    GROUP BY type_code
)
SELECT
    t.id,
    t.txn_date,
    e.name  AS employee_name,
    t.type_code,
    t.amount,
    ROUND(ABS(t.amount) / s.avg_amount, 1) AS deviation_x_avg,
    t.comment
FROM transactions t
JOIN stats s    ON s.type_code = t.type_code
JOIN employees e ON e.id = t.employee_id
WHERE ABS(t.amount) > 3 * s.avg_amount
ORDER BY ABS(t.amount) DESC;
