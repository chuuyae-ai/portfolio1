-- Задача: контроль качества данных (три проверки)
-- 1) доля пропусков в comment
-- 2) нарушение бизнес-правила «расход не может быть отрицательным»
-- 3) пороговая проверка: всё крупнее 500 000 — на ручную проверку

-- Проверка 1: пропуски
SELECT
    COUNT(*)                                              AS total_rows,
    SUM(CASE WHEN comment IS NULL THEN 1 ELSE 0 END)      AS null_comments,
    ROUND(100.0 * SUM(CASE WHEN comment IS NULL THEN 1 ELSE 0 END) / COUNT(*), 1) AS null_pct
FROM transactions;

-- Проверка 2: отрицательные расходы (бизнес-правило)
SELECT
    t.id, t.txn_date, e.name AS employee_name, t.type_code, t.amount, t.comment
FROM transactions t
JOIN operation_types ot ON ot.code = t.type_code
JOIN employees e ON e.id = t.employee_id
WHERE ot.category = 'expense' AND t.amount < 0;

-- Проверка 3: пороговая проверка крупных операций
SELECT
    t.id, t.txn_date, e.name AS employee_name, t.type_code, t.amount, t.comment
FROM transactions t
JOIN employees e ON e.id = t.employee_id
WHERE ABS(t.amount) > 500000;
