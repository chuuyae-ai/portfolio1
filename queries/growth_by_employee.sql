-- Задача: динамика выручки по сотрудникам месяц к месяцу
-- Показывает: группировку + оконную функцию LAG + защиту от деления на ноль

WITH monthly AS (
    SELECT
        e.name                        AS employee_name,
        strftime('%Y-%m', t.txn_date) AS month,
        SUM(t.amount)                 AS month_total
    FROM transactions t
    JOIN employees e ON e.id = t.employee_id
    WHERE t.type_code = 'SALE'
    GROUP BY e.name, month
)
SELECT
    employee_name,
    month,
    month_total,
    LAG(month_total) OVER (
        PARTITION BY employee_name
        ORDER BY month
    )                                AS prev_month_total,
    ROUND(
        100.0 * (month_total - LAG(month_total) OVER (
                    PARTITION BY employee_name ORDER BY month))
        / NULLIF(LAG(month_total) OVER (
                    PARTITION BY employee_name ORDER BY month), 0),
        1
    )                                AS growth_pct
FROM monthly
ORDER BY employee_name, month;
