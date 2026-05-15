# Mobile Game Performance & User Behavior Analysis

## 📌 Tổng quan dự án
Dự án này tập trung phân tích dữ liệu người dùng và doanh thu của một sản phẩm Mobile Game nhằm đánh giá "sức khỏe" của sản phẩm. Mục tiêu chính là tìm ra các điểm nghẽn trong phễu chuyển đổi, đánh giá hiệu quả giữ chân người chơi (Retention) và phân tích hành vi nạp tiền (Monetization) để đưa ra các đề xuất tối ưu hóa vận hành.

## 🛠 Công cụ sử dụng
* **MySQL:** Xử lý dữ liệu thô, làm sạch và xây dựng hệ thống View phân tích.
* **Power BI:** Trực quan hóa dữ liệu, thiết kế Dashboard theo dõi KPI thời gian thực.
* **Excel:** Phân tích nhanh và kiểm tra tính nhất quán của dữ liệu.

## 📊 Các chỉ số và Insight quan trọng

### 1. Phân tích giữ chân (Retention Analysis)
* **Chỉ số:** D1 Retention: **29.4%**, D7: **12%**, D30: **2.7%**.
* **Insight:** Tỷ lệ giữ chân sụt giảm nghiêm trọng ngay sau ngày đầu tiên. Điều này cho thấy giai đoạn trải nghiệm ban đầu (FTUE - First Time User Experience) chưa đủ hấp dẫn hoặc game gặp lỗi kỹ thuật khiến người chơi rời bỏ sớm.
* **Đề xuất:** Tối ưu hóa luồng hướng dẫn tân thủ, bổ sung phần thưởng đăng nhập 7 ngày để cải thiện tỷ lệ D7.

### 2. Mức độ gắn kết (Engagement & Stickiness)
* **Chỉ số:** Stickiness (DAU/MAU) đạt **15.8%**.
* **Insight:** Theo benchmark ngành game mobile (thường từ 20-25%), con số 15.8% cho thấy người chơi chưa có thói quen quay lại hàng ngày.
* **Đề xuất:** Triển khai các nhiệm vụ hằng ngày (Daily Quests) và thông báo đẩy (Push Notifications) cá nhân hóa để nhắc nhở người chơi.

### 3. Phân tích doanh thu (Monetization & Payer Segmentation)
* **Tỷ lệ chuyển đổi (Conversion Rate):** Đạt **2.24%** (75 người nạp trên tổng số hơn 3.300 người chơi).
* **Cơ cấu doanh thu:** Nhóm **Whales** (Cá voi - chỉ 11 người) đóng góp tới **84%** tổng doanh thu toàn game.
* **Kênh thanh toán:** Ví điện tử (eWallet) chiếm tỷ trọng cao nhất (~47%).
* **Insight:** Doanh thu đang phụ thuộc quá lớn vào một nhóm nhỏ người chơi cao cấp. Đây là rủi ro lớn nếu nhóm này rời bỏ sản phẩm.
* **Đề xuất:** Thiết kế các gói nạp "phá băng" giá rẻ (Starter Pack) để chuyển đổi tệp người chơi miễn phí thành người chơi trả phí (Minnows/Dolphins).

## 📂 Cấu trúc mã nguồn
* `Chuẩn bị dữ liệu & Schema.sql`: Khởi tạo database và quy trình làm sạch dữ liệu.
* `Cohort & Retention.sql`: Truy vấn tính toán tỷ lệ giữ chân theo nhóm (Cohort).
* `Payer Analysis.sql`: Phân tích sâu hành vi và phân khúc người nạp tiền.
* `User Activity.sql`: Đo lường các chỉ số DAU, WAU, MAU và Stickiness.
* `View tổng hợp.sql`: Hệ thống View chuẩn hóa để kết nối trực tiếp với Power BI.

## 🚀 Kết luận
Dự án đã cung cấp một cái nhìn toàn diện về thực trạng của sản phẩm Game. Mặc dù doanh thu từ nhóm người dùng trung thành rất tốt, nhưng bài toán cấp bách nhất hiện nay là cải thiện trải nghiệm người dùng mới để giảm thiểu tỷ lệ rời bỏ trong tuần đầu tiên.

---
**Người thực hiện:** Lê Đình Huy
**Vị trí:** Data Analyst Internship Candidate
