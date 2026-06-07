# Cổng Thi Trắc Nghiệm Online & Hệ Thống Giám Sát AI (Backend API)

Hệ thống Backend REST API được xây dựng trên nền tảng **Java Spring Boot 3.x** quản lý đề thi, câu hỏi và chấm điểm trực tuyến. Hệ thống được thiết kế tối ưu hóa bảo mật (chống gian lận Client-side F12) và chấm điểm theo quy chế thi THPT Quốc Gia mới nhất.

---

## 🛠️ Tính Năng Nổi Bật

1. **Phòng Thi Bảo Mật Cao (Anti‑Cheat)**:
   - API `/api/exams/{id}` trả về cấu trúc đề thi nhưng ẩn hoàn toàn đáp án đúng (`correctAnswer`) và lời giải chi tiết (`explanation`). Điều này ngăn chặn tuyệt đối các hành vi mở F12 DevTools để hack đáp án trước khi nộp bài.

2. **Chấm Điểm Trắc Nghiệm Đúng/Sai Chuẩn THPT 2025**:
   - Áp dụng thang điểm bậc thang khắt khe của Bộ Giáo Dục và Đào Tạo cho câu hỏi Đúng/Sai (mỗi câu gồm 4 ý nhỏ a, b, c, d):
     - Đúng **1 ý**: 0.1 điểm.
     - Đúng **2 ý**: 0.25 điểm.
     - Đúng **3 ý**: 0.5 điểm.
     - Đúng **4 ý**: 1.0 điểm (trọn điểm).

3. **Chấm Điểm Điền Số (Short Answer) Với Sai Số Cực Nhỏ**:
   - Làm sạch khoảng trắng của câu trả lời. Đối với câu trả lời dạng số, hệ thống tự động ép kiểu `double` và so sánh với sai số $|user - correct| < 0.001$, chấp nhận các kết quả làm tròn thập phân của thí sinh.

4. **Nạp Dữ Liệu Tự Động (Auto‑Seeding SQL)**:
   - Sử dụng file SQL khởi tạo [seed.sql](database/seed.sql) chứa **50 đề thi** (gồm các đề thi thực tế và các đề mẫu) với hơn 1.500 câu hỏi. Dữ liệu được xử lý đúng mã hoá Unicode, không còn hiện tượng "mojibake".
   - Thêm công cụ **crawler** (`database/crawler.py`) để thu thập tự động các đề thi từ trang https://baitaptracnghiem.com/ và ghi vào `seed.sql`.

5. **Tích Hợp Sẵn Sàng Với Frontend**:
   - Hỗ trợ CORS cấu hình toàn cục cho phép bất kỳ Client nào (React, Angular, Vue, v.v.) kết nối dễ dàng.
   - Nhận điểm trung thực (`honestyScore`) từ Client‑side (khi chạy Mock Exam Mode có webcam, khóa toàn màn hình, chống chuyển tab) để lưu trữ và phân tích gian lận.

---

## 📂 Cấu Trúc Thư Mục Dự Án

```text
exam/
├── .idea/                 # Cấu hình IntelliJ IDEA
├── .maven/                # (không bắt buộc) có thể dùng Maven Wrapper
├── database/
│   ├── seed.sql          # File SQL nạp dữ liệu 50 đề thi, 1.5k câu hỏi
│   └── crawler.py        # Script thu thập đề thi từ internet
├── src/
│   └── main/
│       ├── java/com/flyspeech/exam/
│       │   ├── config/WebConfig.java        # Cấu hình CORS
│       │   ├── controller/ExamController.java    # Các API Endpoint REST
│       │   ├── entity/Exam.java, Question.java, QuestionType.java
│       │   ├── repository/ExamRepository.java
│       │   ├── service/ExamService.java & impl/ExamServiceImpl.java
│       │   └── ExamApplication.java      # Main khởi chạy Spring Boot
│       └── resources/application.properties    # Cấu hình Port, H2 Database & SQL Init
└── pom.xml                # Quản lý thư viện Maven
```

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Dự Án

### Yêu Cầu Hệ Thống
- Java JDK 21 trở lên.
- Maven (hoặc Maven Wrapper) để biên dịch dự án.
- Trình duyệt web hoặc Postman để kiểm tra API.

### Cài Đặt Maven (nếu chưa có)
Bạn có thể cài Maven thông qua Chocolatey:
```powershell
choco install maven -y
```
Hoặc tải trực tiếp từ https://maven.apache.org/download.cgi và thêm `MAVEN_HOME` vào `PATH`.

### Chạy Dự Án
1. **Mở dự án trong IntelliJ IDEA**:
   - Nhấp chuột phải vào file `pom.xml` → **Add as Maven Project** để IntelliJ tải các thư viện.
   - Nhấn nút **Run** (mũi tên màu xanh) ở class `ExamApplication.java`.
2. **Hoặc dùng terminal**:
```bash
mvn spring-boot:run
```
3. **Truy cập H2 Console** để kiểm tra dữ liệu:
   - URL: `http://localhost:8080/h2-console`
   - JDBC URL: `jdbc:h2:mem:examdb`
   - User: `sa`
   - Password: (để trống)

---

## 📡 Chi Tiết Các REST API Endpoints

### 1. Lấy danh sách đề thi (Bento Grid Home)
- **Method**: `GET`
- **URL**: `/api/exams`
- **Mô tả**: Trả về danh sách tổng quan các đề thi (không bao gồm câu hỏi để bảo mật và tăng hiệu năng tải trang chủ).

### 2. Lấy đề thi bảo mật (Vào Phòng Thi)
- **Method**: `GET`
- **URL**: `/api/exams/{id}` (ví dụ: `/api/exams/1`)
- **Mô tả**: Trả về chi tiết đề thi và danh sách câu hỏi. Các trường `correctAnswer` và `explanation` sẽ trả về `null`.

### 3. Nộp bài thi và Chấm điểm
- **Method**: `POST`
- **URL**: `/api/exams/{id}/submit`
- **Mô tả**: Gửi đáp án của thí sinh và điểm trung thực. Trả về kết quả chấm điểm chi tiết và lời giải thích.
- **Payload (JSON)**:
```json
{
  "honestyScore": 95.5,
  "answers": {
    "1": "C",
    "2": "C",
    "13": { "a": "T", "b": "F", "c": "F", "d": "F" },
    "17": "95.9"
  }
}
```
- **Kết quả (JSON)**:
```json
{
  "score": 9.77,
  "correctCount": 21,
  "weightedCorrectCount": 21.5,
  "totalQuestions": 22,
  "honestyScore": 95.5,
  "status": "ĐẠT",
  "details": [
    {
      "questionId": 1,
      "questionText": "Cho hình lăng trụ...",
      "questionType": "SINGLE_CHOICE",
      "userAnswer": "C",
      "correctAnswer": "C",
      "correctness": 1.0,
      "isCorrect": true,
      "explanation": "Ta có..."
    }
  ]
}
```

### 4. Giáo viên tạo đề thi mới
- **Method**: `POST`
- **URL**: `/api/exams`

### 5. Xóa đề thi
- **Method**: `DELETE`
- **URL**: `/api/exams/{id}`

---

## 📄 Ghi Chú Thêm
- **Crawler** (`database/crawler.py`) được cải thiện để xử lý đúng mã hoá Unicode và hiện giờ có thể thu thập tối đa 100 đề thi từ nguồn bên ngoài.
- **seed.sql** chứa đầy đủ 50 đề thi và đã được kiểm tra để không có ký tự garbled.
- Để **kiểm thử API** nhanh, chạy các lệnh `curl` sau khi server khởi động:
```bash
curl http://localhost:8080/api/exams
curl http://localhost:8080/api/exams/1
```
- Các thay đổi đã được **push lên GitHub** tại https://github.com/huykhang666/api-exam.

Enjoy!
