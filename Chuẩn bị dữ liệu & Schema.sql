CREATE DATABASE game_analysis;
USE game_analysis;

-- Bảng giao dịch nạp tiền
CREATE TABLE game_transactions (
  created_date      DATE,
  transaction_id    VARCHAR(30) PRIMARY KEY,
  transaction_type  VARCHAR(20),
  transaction_amount DECIMAL(15,6),
  user_id           BIGINT,
  first_login_date  DATE
);
-- ALTER TABLE game_transactions MODIFY transaction_amount VARCHAR(50);
-- TRUNCATE TABLE game_transactions;

-- SET SQL_SAFE_UPDATES = 0;
-- UPDATE game_transactions 
-- SET transaction_amount = REPLACE(transaction_amount, ',', '.');

-- ALTER TABLE game_transactions MODIFY transaction_amount DECIMAL(15,6);

SELECT count(*) FROM game_transactions;
-- Bảng đăng nhập
CREATE TABLE game_logins (
  created_date      DATE,
  user_id           BIGINT,
  first_login_date  DATE
);

SELECT count(*) FROM game_logins;
-- 1. Kiểm tra duplicate transaction_id
SELECT transaction_id, COUNT(*) AS cnt
FROM game_transactions
GROUP BY transaction_id
HAVING cnt > 1;
-- Kết quả: 0 bản ghi trùng 

-- 2. Kiểm tra null values
SELECT
  SUM(CASE WHEN transaction_amount IS NULL THEN 1 ELSE 0 END) AS null_amount,
  SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END)   AS null_user,
  SUM(CASE WHEN created_date IS NULL THEN 1 ELSE 0 END) AS null_date
FROM game_transactions;

-- 3. Kiểm tra giá trị âm bất thường
SELECT * FROM game_transactions
WHERE transaction_amount <= 0;

-- 4. Kiểm tra date range hợp lệ
SELECT MIN(created_date), MAX(created_date) FROM game_transactions;
SELECT MIN(created_date), MAX(created_date) FROM game_logins;

-- Tạo bảng sạch (deduplicated) để phân tích

-- Cách 1: 
-- CREATE TABLE game_transactions_clean AS
-- SELECT *
-- FROM game_transactions
-- WHERE transaction_id IN (
--   SELECT MIN(transaction_id)
--   FROM game_transactions
--   GROUP BY transaction_id
-- );


-- Cách 2: 
-- Bước 1: Xác định chi tiết các duplicate 
-- SELECT
--   transaction_id,
--   COUNT(*) AS dup_count,
--   MIN(created_date)         AS date,
--   MIN(user_id)              AS user_id,
--   MIN(transaction_type)    AS type,
--   MIN(transaction_amount)  AS amount
-- FROM game_transactions
-- GROUP BY transaction_id
-- HAVING dup_count > 1;

-- Bước 2: Tạo bảng clean dùng ROW_NUMBER()
-- CREATE TABLE game_transactions_clean AS
-- WITH ranked AS (
--   SELECT *,
--     ROW_NUMBER() OVER (
--       PARTITION BY transaction_id
--       ORDER BY created_date
--     ) AS rn
--   FROM game_transactions
-- )
-- SELECT created_date, transaction_id, transaction_type,
--        transaction_amount, user_id, first_login_date
-- FROM ranked WHERE rn = 1;




