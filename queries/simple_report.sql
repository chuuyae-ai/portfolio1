-- Задача: простой отчёт из витрины (что видит бизнес-пользователь)
SELECT
    txn_date,
    employee_name,
    type_code,
    category AS business_category,
    amount,
    comment
FROM v_transactions_wide
WHERE txn_date BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY txn_date;
