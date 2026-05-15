USE game_analysis

-- User Activity — DAU / WAU / MAU
-- Đo lường mức độ hoạt động của người chơi qua các chỉ số DAU, WAU, MAU và tỷ lệ Stickiness.

-- 1. DAU - Daily Active Users
SELECT
  created_date,
  COUNT(DISTINCT user_id) AS dau
FROM game_logins
GROUP BY created_date
ORDER BY created_date;
-- Thống kê DAU tổng hợp
SELECT
  ROUND(AVG(dau), 0)  AS avg_dau,
  MAX(dau)            AS peak_dau,
  MIN(dau)            AS min_dau
FROM (
  SELECT created_date,
         COUNT(DISTINCT user_id) AS dau
  FROM game_logins
  GROUP BY created_date
) t;

-- Result: 
-- Avg DAU = 528 users/ngày
-- Peak DAU = 1,051 số lượng người chơi đăng nhập đông nhất trong một ngày
-- Min DAU = 297 lượng người chơi đăng nhập ít nhất trong tháng


-- 2. WAU - Weekly Active Users 
SELECT
  CEIL(DAY(created_date) / 7.0)  AS week_num,
  COUNT(DISTINCT user_id)         AS wau
FROM game_logins
GROUP BY week_num
ORDER BY week_num;

-- Result: 
-- Lượng người chơi hoạt động hàng tuần (WAU) đạt đỉnh vào Tuần 2 (1.708 người) 
-- và sau đó có xu hướng giảm dần về các tuần cuối tháng.


-- 3. MAU & Stickiness (DAU/MAU)
-- MAU tháng 6 (Monthly Active Users)
SELECT COUNT(DISTINCT user_id) AS mau
FROM game_logins;
-- Result : 3,346

-- Stickiness = DAU / MAU (đo mức độ quay lại hàng ngày)
SELECT
  ROUND(avg_dau / mau * 100, 1) AS stickiness_pct
FROM
  (SELECT AVG(dau) AS avg_dau
   FROM (SELECT COUNT(DISTINCT user_id) AS dau
         FROM game_logins GROUP BY created_date) d
  ) a,
  (SELECT COUNT(DISTINCT user_id) AS mau
   FROM game_logins) m;
   
-- Result:
-- Stickiness = DAU/MAU ≈ 15.8%. Benchmark ngành game mobile: 20–25% là tốt. 
-- Con số này cho thấy người chơi chưa quay lại đủ thường xuyên → cần cải thiện engagement. 


-- 4. New Users and Returning Users mỗi ngày 
SELECT
  created_date,
  SUM(CASE WHEN created_date = first_login_date
             THEN 1 ELSE 0 END) AS new_users,
  SUM(CASE WHEN created_date > first_login_date
             THEN 1 ELSE 0 END) AS returning_users,
  COUNT(DISTINCT user_id)         AS total_dau
FROM game_logins
GROUP BY created_date
ORDER BY created_date;

-- Result: 
-- Lượng người dùng hoạt động hàng ngày (DAU) chủ yếu được duy trì bởi nhóm người chơi cũ 
-- (Returning Users), trong khi lượng người dùng mới (New Users) chiếm tỷ trọng rất nhỏ 
-- nhưng có sự bùng nổ bất thường vào một vài ngày cụ thể (như giai đoạn 09-11/06).