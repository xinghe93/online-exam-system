package com.xinghe.onlineexam.entity;

import java.util.Date;
import java.util.List;

public class ExamRecord {
    private int examId;
    private int userId;
    private Date examTime;
    private int score;
    private int totalScore;
    private int questionCount;
    private int correctCount;
    private int status; // 0=进行中 1=已完成
    private Date startTime;
    private Date endTime;
    private String questionIds;
    private int timeLimit;

    // 非数据库字段
    private List<Question> questions;
    private List<String> userAnswers;

    public ExamRecord() {}

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Date getExamTime() { return examTime; }
    public void setExamTime(Date examTime) { this.examTime = examTime; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public int getTotalScore() { return totalScore; }
    public void setTotalScore(int totalScore) { this.totalScore = totalScore; }

    public int getQuestionCount() { return questionCount; }
    public void setQuestionCount(int questionCount) { this.questionCount = questionCount; }

    public int getCorrectCount() { return correctCount; }
    public void setCorrectCount(int correctCount) { this.correctCount = correctCount; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }

    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }

    public String getQuestionIds() { return questionIds; }
    public void setQuestionIds(String questionIds) { this.questionIds = questionIds; }

    public int getTimeLimit() { return timeLimit; }
    public void setTimeLimit(int timeLimit) { this.timeLimit = timeLimit; }

    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }

    public List<String> getUserAnswers() { return userAnswers; }
    public void setUserAnswers(List<String> userAnswers) { this.userAnswers = userAnswers; }

    public String getStatusText() {
        return status == 0 ? "进行中" : "已完成";
    }
}
