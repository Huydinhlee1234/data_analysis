USE game_analysis;  

-- Payer Analysis — Phân tích người nạp tiền
-- Tìm hiểu hành vi và đặc điểm của 75 người chơi có giao dịch nạp tiền — nhóm tạo ra toàn bộ doanh thu.

-- 1. Tỷ lệ chuyển đổi từ : User -> Payer 
SELECT
  total_users,
  paying_users,
  ROUND(paying_users * 100.0 / total_users, 2) AS conversion_rate_pct
FROM
  (SELECT COUNT(DISTINCT user_id) AS total_users
   FROM game_logins) a,
  (SELECT COUNT(DISTINCT user_id) AS paying_users
   FROM game_transactions) b;
   
-- Result: 
-- Tỷ lệ chuyển đổi người chơi trả phí rất thấp (chỉ đạt 2,24%), 
-- cho thấy phần lớn người dùng (hơn 3.200 người) đang chơi hoàn toàn miễn phí 

-- 2. Phân khúc payer theo giá trị nạp 
WITH user_revenue AS (
  SELECT
    user_id,
    SUM(transaction_amount) AS total_spent,
    COUNT(*)                AS tx_count
  FROM game_transactions
  GROUP BY user_id
)
SELECT
  CASE
    WHEN total_spent >= 2000000 THEN ' Whale (≥2M)'
    WHEN total_spent >= 500000  THEN ' Dolphin (500K-2M)'
    ELSE                              ' Minnow (<500K)'
  END AS segment,
  COUNT(*)                          AS user_count,
  ROUND(SUM(total_spent), 0)        AS segment_revenue,
  ROUND(AVG(total_spent), 0)        AS avg_spend
FROM user_revenue
GROUP BY segment
ORDER BY avg_spend DESC;

-- Result:
-- Chỉ với 11 người chơi hệ (Whales) nhưng đã tạo ra tới gần 84% tổng doanh thu của toàn game 

-- 3. Tenure của Payer (thâm niên chơi)
SELECT
  CASE
    WHEN DATEDIFF('2023-06-30', first_login_date) <= 7   THEN 'New (0-7 ngày)'
    WHEN DATEDIFF('2023-06-30', first_login_date) <= 30  THEN 'Recent (8-30 ngày)'
    WHEN DATEDIFF('2023-06-30', first_login_date) <= 180 THEN 'Mid (1-6 tháng)'
    ELSE                                                      'Veteran (>6 tháng)'
  END AS tenure_segment,
  COUNT(DISTINCT user_id)                AS payers,
  ROUND(SUM(transaction_amount), 0)      AS revenue,
  ROUND(AVG(transaction_amount), 0)      AS avg_tx_value
FROM game_transactions
GROUP BY tenure_segment
ORDER BY avg_tx_value DESC; 

-- Result: 
-- Nhóm người chơi ở giai đoạn 'Mid (1-6 tháng)' là lực lượng đóng góp doanh thu chủ lực nhất 
-- (hơn 56 triệu VNĐ), vượt xa tệp người chơi lâu năm, trong khi nhóm người dùng mới (dưới 1 tháng) 
-- lại chi tiêu cực kỳ nhỏ giọt. 