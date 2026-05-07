package com.xinghe.onlineexam.entity;

public class ExamAnswer {
    private int answerId;
    private int examId;
    private int questionId;
    private String userAnswer;
    private int isCorrect;

    public ExamAnswer() {}

    public int getAnswerId() { return answerId; }
    public void setAnswerId(int answerId) { this.answerId = answerId; }

    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }

    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }

    public String getUserAnswer() { return userAnswer; }
    public void setUserAnswer(String userAnswer) { this.userAnswer = userAnswer; }

    public int getIsCorrect() { return isCorrect; }
    public void setIsCorrect(int isCorrect) { this.isCorrect = isCorrect; }
}
