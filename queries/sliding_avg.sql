-- Задача: дневная выручка и скользящее среднее за 7 дней
-- Показывает: вложенную агрегацию AVG(SUM(...)) и оконный фрейм ROWS BETWEEN

WITH daily AS (
    SELECT txn_date, SUM(amount) AS day_total
    FROM transactions
    WHERE type_code = 'SALE'
    GROUP BY txn_date
)
SELECT
    txn_date,
    day_total,
    ROUND(AVG(day_total) OVER (
        ORDER BY txn_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 0) AS sliding_avg_7d
FROM daily
ORDER BY txn_date;
