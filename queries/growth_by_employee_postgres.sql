-- PostgreSQL-версия: то же самое, но с to_char вместо strftime
WITH monthly AS (
    SELECT
        e.name                        AS employee_name,
        to_char(t.txn_date, 'YYYY-MM') AS month,
        SUM(t.amount)                 AS month_total
    FROM transactions t
    JOIN employees e ON e.id = t.employee_id
    WHERE t.type_code = 'SALE'
    GROUP BY e.name, month
)
SELECT
    employee_name, month, month_total,
    LAG(month_total) OVER (PARTITION BY employee_name ORDER BY month) AS prev_month_total,
    ROUND(100.0 * (month_total - LAG(month_total) OVER (
        PARTITION BY employee_name ORDER BY month))
        / NULLIF(LAG(month_total) OVER (
        PARTITION BY employee_name ORDER BY month), 0), 1) AS growth_pct
FROM monthly
ORDER BY employee_name, month;
