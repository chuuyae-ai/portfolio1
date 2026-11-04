-- ============================================================
-- Проект «Аналитика операций»: схема базы данных
-- СУБД: SQLite (совместимо с PostgreSQL, кроме помеченного)
-- Порядок запуска: schema.sql -> seed.sql -> view.sql
-- ============================================================

-- Справочник: сотрудники
CREATE TABLE IF NOT EXISTS employees (
    id   INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Справочник: типы операций
CREATE TABLE IF NOT EXISTS operation_types (
    code     VARCHAR(20) PRIMARY KEY,
    category VARCHAR(20) NOT NULL  -- 'income' / 'expense'
);

-- Основная таблица операций
CREATE TABLE IF NOT EXISTS transactions (
    id          INTEGER PRIMARY KEY,
    txn_date    DATE          NOT NULL,
    employee_id INTEGER       NOT NULL REFERENCES employees(id),
    type_code   VARCHAR(20)   NOT NULL REFERENCES operation_types(code),
    amount      NUMERIC(12,2) NOT NULL,
    comment     VARCHAR(255)
);

-- Индексы: по ним чаще всего фильтруют отчёты
CREATE INDEX IF NOT EXISTS idx_txn_date     ON transactions(txn_date);
CREATE INDEX IF NOT EXISTS idx_txn_employee ON transactions(employee_id);
CREATE INDEX IF NOT EXISTS idx_txn_type     ON transactions(type_code);
