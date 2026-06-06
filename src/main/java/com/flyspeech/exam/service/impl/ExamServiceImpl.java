package com.flyspeech.exam.service.impl;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.flyspeech.exam.entity.Exam;
import com.flyspeech.exam.entity.Question;
import com.flyspeech.exam.entity.QuestionType;
import com.flyspeech.exam.repository.ExamRepository;
import com.flyspeech.exam.service.ExamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.*;

@Service
public class ExamServiceImpl implements ExamService {

    private final ExamRepository examRepository;
    private final ObjectMapper objectMapper;

    @Autowired
    public ExamServiceImpl(ExamRepository examRepository, ObjectMapper objectMapper) {
        this.examRepository = examRepository;
        this.objectMapper = objectMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Exam> getAllExams() {
        return examRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Exam> getExamsBySubject(String subject) {
        return examRepository.findBySubjectIgnoreCase(subject);
    }

    @Override
    @Transactional(readOnly = true)
    public Exam getExamById(Long id) {
        return examRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Không tìm thấy đề thi với ID: " + id));
    }

    @Override
    @Transactional(readOnly = true)
    public Exam getSecureExamForClient(Long id) {
        Exam exam = getExamById(id);
        
        // Create a secure copy of questions where correctAnswer and explanation are hidden
        List<Question> secureQuestions = exam.getQuestions().stream().map(q -> {
            Question sq = new Question();
            sq.setId(q.getId());
            sq.setQuestionText(q.getQuestionText());
            sq.setQuestionType(q.getQuestionType());
            sq.setOptionsJson(q.getOptionsJson());
            sq.setCorrectAnswer(null); // Hide correctAnswer
            sq.setExplanation(null);   // Hide explanation
            sq.setExam(null);          // Avoid recursion
            return sq;
        }).toList();

        Exam secureExam = new Exam();
        secureExam.setId(exam.getId());
        secureExam.setTitle(exam.getTitle());
        secureExam.setSubject(exam.getSubject());
        secureExam.setDuration(exam.getDuration());
        secureExam.setDescription(exam.getDescription());
        secureExam.setCreatedAt(exam.getCreatedAt());
        secureExam.setQuestions(secureQuestions);

        return secureExam;
    }

    @Override
    @Transactional
    public Exam saveExam(Exam exam) {
        // Ensure bidirectional relationship is properly set
        if (exam.getQuestions() != null) {
            for (Question question : exam.getQuestions()) {
                question.setExam(exam);
            }
        }
        return examRepository.save(exam);
    }

    @Override
    @Transactional
    public void deleteExam(Long id) {
        if (!examRepository.existsById(id)) {
            throw new NoSuchElementException("Không tìm thấy đề thi với ID: " + id + " để xóa");
        }
        examRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> evaluateExam(Long examId, Map<String, Object> userAnswers, double honestyScore) {
        Exam exam = getExamById(examId);
        List<Question> questions = exam.getQuestions();
        
        int totalQuestions = questions.size();
        if (totalQuestions == 0) {
            Map<String, Object> emptyResult = new HashMap<>();
            emptyResult.put("score", 0.0);
            emptyResult.put("correctCount", 0);
            emptyResult.put("totalQuestions", 0);
            emptyResult.put("honestyScore", honestyScore);
            emptyResult.put("status", "TRƯỢT");
            emptyResult.put("details", Collections.emptyList());
            return emptyResult;
        }

        double totalScoreWeight = 0.0;
        int fullyCorrectCount = 0;
        List<Map<String, Object>> details = new ArrayList<>();

        for (Question q : questions) {
            String questionIdStr = String.valueOf(q.getId());
            Object userAnsObj = userAnswers.get(questionIdStr);
            
            double correctness = 0.0; // range 0.0 to 1.0
            Object parsedCorrectAnswer = null;
            Object parsedUserAnswer = null;

            if (userAnsObj != null) {
                if (q.getQuestionType() == QuestionType.SINGLE_CHOICE) {
                    String userAns = cleanString(String.valueOf(userAnsObj));
                    String correctAns = cleanString(q.getCorrectAnswer());
                    parsedUserAnswer = userAns;
                    parsedCorrectAnswer = correctAns;

                    if (userAns.equalsIgnoreCase(correctAns)) {
                        correctness = 1.0;
                    }
                } else if (q.getQuestionType() == QuestionType.TRUE_FALSE) {
                    try {
                        // Parse correct answer JSON: e.g. {"a":"T", "b":"F", "c":"T", "d":"F"}
                        Map<String, String> correctMap = objectMapper.readValue(q.getCorrectAnswer(), new TypeReference<Map<String, String>>() {});
                        parsedCorrectAnswer = correctMap;

                        // Parse user answer (expected to be a Map/JSON representation)
                        Map<String, String> userMap = new HashMap<>();
                        if (userAnsObj instanceof Map) {
                            Map<?, ?> rawMap = (Map<?, ?>) userAnsObj;
                            for (Map.Entry<?, ?> entry : rawMap.entrySet()) {
                                userMap.put(String.valueOf(entry.getKey()).trim().toLowerCase(), String.valueOf(entry.getValue()));
                            }
                        } else {
                            // Try parsing as JSON string if passed as string
                            try {
                                userMap = objectMapper.readValue(String.valueOf(userAnsObj), new TypeReference<Map<String, String>>() {});
                            } catch (Exception ignored) {}
                        }
                        parsedUserAnswer = userMap;

                        int matchSubCount = 0;
                        String[] subKeys = {"a", "b", "c", "d"};
                        for (String subKey : subKeys) {
                            String correctVal = correctMap.get(subKey);
                            String userVal = userMap.get(subKey);
                            if (isTFMatch(userVal, correctVal)) {
                                matchSubCount++;
                            }
                        }

                        // Ministry of Education 2025 True/False scale
                        if (matchSubCount == 1) {
                            correctness = 0.1;
                        } else if (matchSubCount == 2) {
                            correctness = 0.25;
                        } else if (matchSubCount == 3) {
                            correctness = 0.5;
                        } else if (matchSubCount == 4) {
                            correctness = 1.0;
                        }
                    } catch (IOException e) {
                        // Fallback in case of JSON parse errors
                        parsedCorrectAnswer = q.getCorrectAnswer();
                        parsedUserAnswer = userAnsObj;
                        correctness = 0.0;
                    }
                } else if (q.getQuestionType() == QuestionType.SHORT_ANSWER) {
                    String userAns = String.valueOf(userAnsObj).trim().replaceAll("\\s+", "");
                    String correctAns = cleanString(q.getCorrectAnswer()).replaceAll("\\s+", "");
                    parsedUserAnswer = userAns;
                    parsedCorrectAnswer = correctAns;

                    try {
                        double userDouble = Double.parseDouble(userAns);
                        double correctDouble = Double.parseDouble(correctAns);
                        if (Math.abs(userDouble - correctDouble) < 0.001) {
                            correctness = 1.0;
                        }
                    } catch (NumberFormatException e) {
                        // Fallback to string matching
                        if (userAns.equalsIgnoreCase(correctAns)) {
                            correctness = 1.0;
                        }
                    }
                }
            } else {
                // If user did not answer
                if (q.getQuestionType() == QuestionType.TRUE_FALSE) {
                    try {
                        parsedCorrectAnswer = objectMapper.readValue(q.getCorrectAnswer(), new TypeReference<Map<String, String>>() {});
                    } catch (Exception e) {
                        parsedCorrectAnswer = q.getCorrectAnswer();
                    }
                } else {
                    parsedCorrectAnswer = cleanString(q.getCorrectAnswer());
                }
                parsedUserAnswer = null;
                correctness = 0.0;
            }

            if (correctness == 1.0) {
                fullyCorrectCount++;
            }

            totalScoreWeight += correctness;

            Map<String, Object> detail = new HashMap<>();
            detail.put("questionId", q.getId());
            detail.put("questionText", q.getQuestionText());
            detail.put("questionType", q.getQuestionType());
            detail.put("optionsJson", parseJsonQuietly(q.getOptionsJson()));
            detail.put("userAnswer", parsedUserAnswer);
            detail.put("correctAnswer", parsedCorrectAnswer);
            detail.put("correctness", correctness);
            detail.put("isCorrect", correctness == 1.0);
            detail.put("explanation", q.getExplanation());
            details.add(detail);
        }

        // Calculate final score scaled to 10.0
        double rawScore = (totalScoreWeight / totalQuestions) * 10.0;
        double roundedScore = Math.round(rawScore * 100.0) / 100.0;

        String status = roundedScore >= 5.0 ? "ĐẠT" : "TRƯỢT";

        Map<String, Object> result = new HashMap<>();
        result.put("score", roundedScore);
        result.put("correctCount", fullyCorrectCount);
        result.put("weightedCorrectCount", Math.round(totalScoreWeight * 100.0) / 100.0);
        result.put("totalQuestions", totalQuestions);
        result.put("honestyScore", honestyScore);
        result.put("status", status);
        result.put("details", details);

        return result;
    }

    private String cleanString(String input) {
        if (input == null) return "";
        // Strip out leading/trailing JSON quotes if the database holds string as "A" instead of A
        String str = input.trim();
        if (str.startsWith("\"") && str.endsWith("\"") && str.length() >= 2) {
            str = str.substring(1, str.length() - 1);
        }
        return str.trim();
    }

    private boolean isTFMatch(String userVal, String correctVal) {
        if (userVal == null || correctVal == null) return false;
        String u = userVal.trim().toUpperCase();
        String c = correctVal.trim().toUpperCase();

        String uNorm = (u.startsWith("T") || u.startsWith("Đ") || u.startsWith("D") || u.equals("TRUE") || u.equals("1")) ? "T" : "F";
        String cNorm = (c.startsWith("T") || c.startsWith("Đ") || c.startsWith("D") || c.equals("TRUE") || c.equals("1")) ? "T" : "F";

        return uNorm.equals(cNorm);
    }

    private Object parseJsonQuietly(String json) {
        if (json == null || json.trim().isEmpty()) return null;
        try {
            return objectMapper.readValue(json, Object.class);
        } catch (Exception e) {
            return json;
        }
    }
}
