USE game_analysis;

-- View tổng hợp cho Power BI
-- Tạo các MySQL Views để kết nối trực tiếp vào Power BI. Mỗi view là một dataset hoàn chỉnh cho từng visual.

-- 1. View: Daily KPI Summary
CREATE VIEW v_daily_kpi AS
SELECT
  l.created_date,
  COUNT(DISTINCT l.user_id)             AS dau,
  COALESCE(SUM(t.transaction_amount), 0) AS daily_revenue,
  COUNT(DISTINCT t.user_id)             AS daily_payers,
  SUM(CASE WHEN l.created_date = l.first_login_date
             THEN 1 ELSE 0 END)         AS new_installs
FROM game_logins l
LEFT JOIN game_transactions t
  ON l.user_id = t.user_id
 AND l.created_date = t.created_date
GROUP BY l.created_date
ORDER BY l.created_date; 


-- 2. View: User Segments 
CREATE OR REPLACE VIEW v_user_segments AS
SELECT
  u.user_id,
  u.first_login_date,
  DATEDIFF('2023-06-30', u.first_login_date) AS tenure_days,
  COALESCE(p.total_spent, 0)                  AS total_spent,
  COALESCE(p.tx_count, 0)                     AS tx_count,
  CASE WHEN p.user_id IS NOT NULL THEN 'Payer'
       ELSE 'Non-payer' END                 AS payer_status,
  l.session_count,
  l.last_login_date  -- CỘT MỚI ĐƯỢC THÊM VÀO
FROM
  (SELECT DISTINCT user_id, first_login_date
   FROM game_logins) u
LEFT JOIN
  (SELECT user_id,
          SUM(transaction_amount) AS total_spent,
          COUNT(*)                AS tx_count
   FROM game_transactions
   GROUP BY user_id) p ON u.user_id = p.user_id
LEFT JOIN
  (SELECT user_id, 
          COUNT(*) AS session_count,
          MAX(created_date) AS last_login_date -- TÌM NGÀY ĐĂNG NHẬP CUỐI CÙNG
   FROM game_logins 
   GROUP BY user_id) l ON u.user_id = l.user_id;
   

-- 3. View: Cohort Retention Matrix 
CREATE VIEW v_cohort_retention AS
WITH base AS (
  SELECT
    user_id,
    DATE_FORMAT(first_login_date, '%Y-%m')  AS cohort,
    DATEDIFF(created_date, first_login_date) AS day_n
  FROM game_logins
),
sizes AS (
  SELECT cohort, COUNT(DISTINCT user_id) AS cohort_size
  FROM base WHERE day_n = 0 GROUP BY cohort
)
SELECT
  b.cohort,
  s.cohort_size,
  b.day_n,
  COUNT(DISTINCT b.user_id)                              AS retained,
  ROUND(COUNT(DISTINCT b.user_id)*100.0/s.cohort_size,1) AS retention_pct
FROM base b JOIN sizes s ON b.cohort = s.cohort
GROUP BY b.cohort, s.cohort_size, b.day_n;

-- 4. View: Fact Transactions (Dữ liệu giao dịch chi tiết)
CREATE OR REPLACE VIEW v_fact_transactions AS
SELECT 
    transaction_id, 
    user_id, 
    transaction_type, 
    transaction_amount, 
    created_date
FROM game_transactions;

