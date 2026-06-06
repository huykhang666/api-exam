package com.flyspeech.exam.controller;

import com.flyspeech.exam.entity.Exam;
import com.flyspeech.exam.service.ExamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/api/exams")
@CrossOrigin(origins = "*") // Allow any UI client to access
public class ExamController {

    private final ExamService examService;

    @Autowired
    public ExamController(ExamService examService) {
        this.examService = examService;
    }

    // GET /api/exams: Lấy danh sách đề thi (không kèm chi tiết câu hỏi để bảo mật)
    @GetMapping
    public ResponseEntity<List<Exam>> getAllExams() {
        List<Exam> exams = examService.getAllExams();
        List<Exam> summaries = exams.stream().map(e -> {
            Exam summary = new Exam();
            summary.setId(e.getId());
            summary.setTitle(e.getTitle());
            summary.setSubject(e.getSubject());
            summary.setDuration(e.getDuration());
            summary.setDescription(e.getDescription());
            summary.setCreatedAt(e.getCreatedAt());
            // Hide questions list on main homepage Bento grid for performance and security
            summary.setQuestions(null);
            return summary;
        }).toList();
        return ResponseEntity.ok(summaries);
    }

    // GET /api/exams/subject/{subjectName}: Lọc đề theo môn
    @GetMapping("/subject/{subjectName}")
    public ResponseEntity<List<Exam>> getExamsBySubject(@PathVariable String subjectName) {
        List<Exam> exams = examService.getExamsBySubject(subjectName);
        List<Exam> summaries = exams.stream().map(e -> {
            Exam summary = new Exam();
            summary.setId(e.getId());
            summary.setTitle(e.getTitle());
            summary.setSubject(e.getSubject());
            summary.setDuration(e.getDuration());
            summary.setDescription(e.getDescription());
            summary.setCreatedAt(e.getCreatedAt());
            summary.setQuestions(null);
            return summary;
        }).toList();
        return ResponseEntity.ok(summaries);
    }

    // GET /api/exams/{id}: Lấy phòng thi bảo mật (gọi hàm getSecureExamForClient)
    @GetMapping("/{id}")
    public ResponseEntity<?> getSecureExam(@PathVariable Long id) {
        try {
            Exam secureExam = examService.getSecureExamForClient(id);
            return ResponseEntity.ok(secureExam);
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", e.getMessage()));
        }
    }

    // POST /api/exams/{id}/submit: Nhận payload nộp bài chấm điểm
    @PostMapping("/{id}/submit")
    public ResponseEntity<?> submitExam(
            @PathVariable Long id,
            @RequestBody SubmitPayload payload) {
        try {
            if (payload == null) {
                return ResponseEntity.badRequest().body(Map.of("error", "Payload nộp bài không hợp lệ"));
            }
            Map<String, Object> evaluation = examService.evaluateExam(id, payload.getAnswers(), payload.getHonestyScore());
            return ResponseEntity.ok(evaluation);
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Đã xảy ra lỗi khi chấm điểm: " + e.getMessage()));
        }
    }

    // POST /api/exams: Giáo viên tạo đề mới hoặc cập nhật đề
    @PostMapping
    public ResponseEntity<?> createExam(@RequestBody Exam exam) {
        try {
            Exam saved = examService.saveExam(exam);
            return ResponseEntity.status(HttpStatus.CREATED).body(saved);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(Map.of("error", "Không thể tạo đề thi: " + e.getMessage()));
        }
    }

    // DELETE /api/exams/{id}: Xóa đề
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteExam(@PathVariable Long id) {
        try {
            examService.deleteExam(id);
            return ResponseEntity.ok(Map.of("message", "Xóa đề thi thành công!"));
        } catch (NoSuchElementException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(Map.of("error", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "Không thể xóa đề thi: " + e.getMessage()));
        }
    }

    // DTO class for submission payload
    public static class SubmitPayload {
        private Map<String, Object> answers;
        private double honestyScore;

        public Map<String, Object> getAnswers() {
            return answers;
        }

        public void setAnswers(Map<String, Object> answers) {
            this.answers = answers;
        }

        public double getHonestyScore() {
            return honestyScore;
        }

        public void setHonestyScore(double honestyScore) {
            this.honestyScore = honestyScore;
        }
    }
}
