package com.flyspeech.exam.service;

import com.flyspeech.exam.entity.Exam;
import java.util.List;
import java.util.Map;

public interface ExamService {
    List<Exam> getAllExams();
    List<Exam> getExamsBySubject(String subject);
    Exam getExamById(Long id);
    Exam getSecureExamForClient(Long id);
    Exam saveExam(Exam exam);
    void deleteExam(Long id);
    Map<String, Object> evaluateExam(Long examId, Map<String, Object> userAnswers, double honestyScore);
}
