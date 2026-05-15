USE game_analysis;

-- Cohort Analysis & Retention
-- Phân tích khả năng giữ chân người chơi theo nhóm ngày đăng ký đầu tiên

-- 1. Xây dựng Cohort theo tháng đăng ký 
-- Bước 1: Tính số ngày từ first_login đến mỗi lần login
WITH cohort_base AS (
  SELECT
    user_id,
    DATE_FORMAT(first_login_date, '%Y-%m') AS cohort_month,
    DATEDIFF(created_date, first_login_date)  AS day_number
  FROM game_logins
),
-- Bước 2: Đếm user theo cohort và day_number
cohort_size AS (
  SELECT cohort_month,
         COUNT(DISTINCT user_id) AS cohort_users
  FROM cohort_base WHERE day_number = 0
  GROUP BY cohort_month
)
SELECT
  b.cohort_month,
  s.cohort_users,
  b.day_number,
  COUNT(DISTINCT b.user_id) AS active_users,
  ROUND(COUNT(DISTINCT b.user_id) * 100.0
        / s.cohort_users, 1)    AS retention_rate
FROM cohort_base b
JOIN cohort_size s ON b.cohort_month = s.cohort_month
GROUP BY b.cohort_month, s.cohort_users, b.day_number
ORDER BY b.cohort_month, b.day_number;


-- Result: 
-- Day 0 luôn = 100%.
-- Tỷ lệ giữ chân người chơi (Retention Rate) sụt giảm rất nghiêm trọng ngay từ giai đoạn đầu: 
-- chỉ có 30,4% người chơi quay lại vào Ngày 1 (D1) và tụt xuống vỏn vẹn 10,5% vào Ngày 7 (D7) 

-- 2. D1/D7/D30 Retention Rate
WITH user_days AS (
  SELECT
    user_id,
    first_login_date,
    DATEDIFF(created_date, first_login_date) AS day_n
  FROM game_logins
)
SELECT
  COUNT(DISTINCT user_id) AS new_users,
  ROUND(SUM(CASE WHEN day_n = 1  THEN 1 ELSE 0 END)
        * 100.0 / COUNT(DISTINCT user_id), 1) AS d1_retention,
  ROUND(SUM(CASE WHEN day_n = 7  THEN 1 ELSE 0 END)
        * 100.0 / COUNT(DISTINCT user_id), 1) AS d7_retention,
  ROUND(SUM(CASE WHEN day_n = 30 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(DISTINCT user_id), 1) AS d30_retention
FROM user_days
WHERE day_n = 0 OR day_n IN (1, 7, 30); 

-- Result:
-- Tỷ lệ giữ chân người chơi (Retention) rớt thảm hại theo thời gian: chỉ 29,4% quay lại ở Ngày 1, 
-- giảm xuống 12% ở Ngày 7 và gần như rời bỏ hoàn toàn (chỉ còn 2,7%) vào Ngày 30 


-- 3. Phân tích User Cohort theo tháng đăng ký 
-- Phân bổ user trong login data theo tháng first_login
SELECT
  DATE_FORMAT(first_login_date, '%Y-%m') AS cohort_month,
  COUNT(DISTINCT user_id)                 AS cohort_size,
  COUNT(*)                                AS total_sessions,
  ROUND(COUNT(*) * 1.0
        / COUNT(DISTINCT user_id), 1)     AS avg_sessions_per_user
FROM game_logins
GROUP BY cohort_month
ORDER BY cohort_month; 

-- Result:
-- Mặc dù nhóm người dùng mới tạo tài khoản trong tháng 6 chiếm số lượng đông đảo nhất, 
-- nhưng nhóm người chơi cũ từ tháng 4 lại có mức độ gắn kết (engagement) cao nhất với trung bình hơn 
-- 16 lần đăng nhập/người, cho thấy game đang sống dựa vào sự trung thành của tệp user lâu năm. 
