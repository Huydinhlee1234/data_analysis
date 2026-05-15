USE game_analysis

-- Phân tích tổng doanh thu, cơ cấu theo phương thức thanh toán, và xu hướng theo ngày trong tháng 6/2023.

-- 1. Tổng doanh thu theo tháng
SELECT
  COUNT(*)                                    AS total_transactions,
  COUNT(DISTINCT user_id)                     AS total_payers,
  ROUND(SUM(transaction_amount), 0)           AS total_revenue,
  ROUND(AVG(transaction_amount), 0)           AS avg_transaction,
  ROUND(SUM(transaction_amount)
        / COUNT(DISTINCT user_id), 0)          AS arppu  -- Average Revenue Per Paying User
FROM game_transactions;

-- Result:  
-- +, Total Revenue (T6) = ~81M VNĐ
-- +, ARPPU (Rev/Payer) = ~1.08M VNĐ
-- +, Total Payers = 75 users
-- +, Avg_transaction = ~101K VNĐ

-- 2. Doanh thu theo phương thức thanh toán
SELECT
  transaction_type,
  COUNT(*)                                         AS tx_count,
  COUNT(DISTINCT user_id)                          AS payer_count,
  ROUND(SUM(transaction_amount), 0)                AS revenue,
  ROUND(SUM(transaction_amount) * 100.0
        / SUM(SUM(transaction_amount)) OVER(), 1) AS revenue_pct
FROM game_transactions
GROUP BY transaction_type
ORDER BY revenue DESC; 

-- Result:  
-- -> eWallet chiếm gần 47% revenue — đây là kênh quan trọng nhất. Google Pay rất thấp (0.6%), cần xem xét chi phí duy trì tích hợp. 

-- 3. Doanh thu theo ngày (Daily Revenue)
SELECT
  created_date,
  DAYOFWEEK(created_date)                  AS day_of_week,
  COUNT(*)                                 AS tx_count,
  COUNT(DISTINCT user_id)                  AS payers,
  ROUND(SUM(transaction_amount), 0)        AS daily_revenue,
  ROUND(AVG(SUM(transaction_amount)) OVER
    (ORDER BY created_date
     ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),
    0)                                     AS revenue_7d_ma  
FROM game_transactions
GROUP BY created_date
ORDER BY created_date;

-- Result:  
-- Đường trung bình 7 ngày (7d_ma) giúp làm mịn các biến động ngắn hạn (như hiệu ứng cuối tuần), 
-- cho thấy rõ xu hướng tổng thể: doanh thu tăng trưởng mạnh, đạt đỉnh vào giữa tháng 6 trước khi 
-- hạ nhiệt dần về cuối tháng. 


-- 4. Doanh thu theo tuần trong tháng 
SELECT
  CONCAT('Week ', CEIL(DAY(created_date) / 7.0)) AS week_label,
  ROUND(SUM(transaction_amount), 0)                 AS weekly_revenue,
  COUNT(DISTINCT user_id)                           AS payers,
  ROUND(SUM(transaction_amount) / COUNT(DISTINCT user_id), 0) AS avg_revenue_per_payer 
FROM game_transactions
GROUP BY week_label
ORDER BY week_label; 

-- Result:
-- Mặc dù Tuần 2 có lượng người nạp đông nhất, nhưng Tuần 3 mới là 
-- đỉnh doanh thu với mức chi tiêu trung bình trên mỗi người tăng vọt.

