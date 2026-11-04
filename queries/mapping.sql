-- Задача: маппинг кодов операций в бизнес-категории + помесячный итог
-- Показывает: JOIN со справочником — как в интеграциях (маппинг полей)

SELECT
    strftime('%Y-%m', t.txn_date)          AS month,
    ot.category                            AS business_category,
    SUM(CASE WHEN t.amount > 0 THEN t.amount ELSE 0 END) AS inflow,
    SUM(CASE WHEN t.amount < 0 THEN -t.amount ELSE 0 END) AS outflow,
    SUM(t.amount)                          AS net
FROM transactions t
JOIN operation_types ot ON ot.code = t.type_code
GROUP BY month, business_category
ORDER BY month, business_category;
