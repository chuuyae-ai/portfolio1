-- ============================================================
-- Витрина для бизнес-пользователей
-- Скрывает сложность схемы: имена вместо ID, категории вместо кодов
-- ============================================================
CREATE VIEW IF NOT EXISTS v_transactions_wide AS
SELECT
    t.id,
    t.txn_date,
    e.name          AS employee_name,
    t.type_code,
    ot.category,
    ABS(t.amount)   AS amount_abs,
    t.amount,
    t.comment
FROM transactions t
JOIN employees e         ON e.id = t.employee_id
JOIN operation_types ot  ON ot.code = t.type_code;
