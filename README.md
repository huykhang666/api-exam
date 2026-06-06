# Cổng Thi Trắc Nghiệm Online & Hệ Thống Giám Sát AI (Backend API)

Hệ thống Backend REST API được xây dựng trên nền tảng **Java Spring Boot 3.x** quản lý đề thi, câu hỏi và chấm điểm trực tuyến. Hệ thống được thiết kế tối ưu hóa bảo mật (chống gian lận Client-side F12) và chấm điểm theo quy chế thi THPT Quốc Gia mới nhất.

---

## 🛠️ Tính Năng Nổi Bật

1. **Phòng Thi Bảo Mật Cao (Anti-Cheat)**:
   * API `/api/exams/{id}` trả về cấu trúc đề thi nhưng ẩn hoàn toàn đáp án đúng (`correctAnswer`) và lời giải chi tiết (`explanation`). Điều này ngăn chặn tuyệt đối các hành vi mở F12 DevTools để hack đáp án trước khi nộp bài.

2. **Chấm Điểm Trắc Nghiệm Đúng/Sai Chuẩn THPT 2025**:
   * Áp dụng thang điểm bậc thang khắt khe của Bộ Giáo Dục và Đào Tạo cho câu hỏi Đúng/Sai (mỗi câu gồm 4 ý nhỏ a, b, c, d):
     * Đúng **1 ý**: Được **0.1** trọng số điểm.
     * Đúng **2 ý**: Được **0.25** trọng số điểm.
     * Đúng **3 ý**: Được **0.5** trọng số điểm.
     * Đúng **4 ý**: Được **1.0** trọng số điểm (trọn điểm).

3. **Chấm Điểm Điền Số (Short Answer) Với Sai Số Cực Nhỏ**:
   * Làm sạch khoảng trắng của câu trả lời. Đối với câu trả lời dạng số, hệ thống tự động ép kiểu `double` và so sánh với sai số $|user - correct| < 0.001$, chấp nhận các kết quả làm tròn thập phân của thí sinh.

4. **Nạp Dữ Liệu Tự Động (Auto-Seeding SQL)**:
   * Sử dụng file SQL khởi tạo [seed.sql](database/seed.sql) chứa đề thi thật môn Toán THPT QG 2025 (Mã đề 0101) gồm 22 câu và đề thi Vật Lý THPT QG 2024 để tự động nạp vào cơ sở dữ liệu in-memory H2 khi khởi chạy hệ thống.

5. **Tích Hợp Sẵn Sàng Với Frontend**:
   * Hỗ trợ CORS cấu hình toàn cục cho phép bất kỳ Client nào (React, Angular, Vue, v.v.) kết nối dễ dàng.
   * Nhận điểm trung thực (`honestyScore`) từ Client-side (khi chạy Mock Exam Mode có webcam, khóa toàn màn hình, chống chuyển tab) để lưu trữ và phân tích gian lận.

---

## 📂 Cấu Trúc Thư Mục Dự Án

```text
exam/
├── .idea/                 # Cấu hình IntelliJ IDEA
├── database/
│   └── seed.sql          # File SQL nạp sẵn 2 đề thi thật Toán 2025 & Lý 2024
├── src/
│   ├── main/
│   │   ├── java/com/flyspeech/exam/
│   │   │   ├── config/
│   │   │   │   └── WebConfig.java        # Cấu hình CORS
│   │   │   ├── controller/
│   │   │   │   └── ExamController.java    # Các API Endpoint REST
│   │   │   ├── entity/
│   │   │   │   ├── Exam.java             # Entity Đề thi
│   │   │   │   ├── Question.java         # Entity Câu hỏi
│   │   │   │   └── QuestionType.java     # Enum dạng câu hỏi
│   │   │   ├── repository/
│   │   │   │   └── ExamRepository.java   # Spring Data JPA Repository
│   │   │   ├── service/
│   │   │   │   ├── ExamService.java      # Service Interface
│   │   │   │   └── impl/
│   │   │   │       └── ExamServiceImpl.java # Thuật toán chấm điểm & Bảo mật
│   │   │   └── ExamApplication.java      # Main khởi chạy Spring Boot
│   │   └── resources/
│   │       └── application.properties    # Cấu hình Port, H2 Database & SQL Init
└── pom.xml                # Quản lý thư viện Maven
```

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Dự Án

### Yêu Cầu Hệ Thống
* Java JDK 21 trở lên.
* Trình duyệt web hoặc Postman để kiểm tra API.

### Cách Chạy
1. **Mở dự án trong IntelliJ IDEA**:
   * Nhấp chuột phải vào file `pom.xml` -> Chọn **Add as Maven Project** để IntelliJ tải các thư viện.
   * Nhấn nút **Run** (mũi tên màu xanh) ở class `ExamApplication.java` hoặc gõ lệnh sau ở terminal:
     ```bash
     mvn spring-boot:run
     ```
2. **Truy cập cơ sở dữ liệu in-memory H2 Console**:
   * Địa chỉ: `http://localhost:8080/h2-console`
   * **JDBC URL**: `jdbc:h2:mem:examdb`
   * **User Name**: `sa`
   * **Password**: (để trống)
   * Nhấn **Connect** để truy vấn trực tiếp bảng `exams` và `questions`.

---

## 📡 Chi Tiết Các REST API Endpoints

### 1. Lấy danh sách đề thi (Bento Grid Home)
* **Method**: `GET`
* **URL**: `/api/exams`
* **Mô tả**: Trả về danh sách tổng quan các đề thi (không bao gồm câu hỏi để bảo mật và tăng hiệu năng tải trang chủ).

### 2. Lấy đề thi bảo mật (Vào Phòng Thi)
* **Method**: `GET`
* **URL**: `/api/exams/{id}` (Ví dụ: `/api/exams/1`)
* **Mô tả**: Trả về chi tiết đề thi và danh sách câu hỏi. Cột `correctAnswer` và `explanation` sẽ trả về `null`.

### 3. Nộp bài thi và Chấm điểm
* **Method**: `POST`
* **URL**: `/api/exams/{id}/submit`
* **Mô tả**: Gửi lên đáp án của thí sinh và điểm trung thực. Trả về kết quả chấm điểm chi tiết và lời giải thích.
* **Định dạng Payload (Body - JSON)**:
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
* **Định dạng Kết quả Trả về**:
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
* **Method**: `POST`
* **URL**: `/api/exams`

### 5. Xóa đề thi
* **Method**: `DELETE`
* **URL**: `/api/exams/{id}`
