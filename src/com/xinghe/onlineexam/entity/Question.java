package com.xinghe.onlineexam.entity;

public class Question {
    private int questionId;
    private String title;
    private String optionA;
    private String optionB;
    private String optionC;
    private String optionD;
    private char answer;

    public Question() {
    }

    public Question(int questionId, String title, String optionA, String optionB, String optionC, String optionD, char answer) {
        this.questionId = questionId;
        this.title = title;
        this.optionA = optionA;
        this.optionB = optionB;
        this.optionC = optionC;
        this.optionD = optionD;
        this.answer = answer;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getOptionA() {
        return optionA;
    }

    public void setOptionA(String optionA) {
        this.optionA = optionA;
    }

    public String getOptionB() {
        return optionB;
    }

    public void setOptionB(String optionB) {
        this.optionB = optionB;
    }

    public String getOptionC() {
        return optionC;
    }

    public void setOptionC(String optionC) {
        this.optionC = optionC;
    }

    public String getOptionD() {
        return optionD;
    }

    public void setOptionD(String optionD) {
        this.optionD = optionD;
    }

    public char getAnswer() {
        return answer;
    }

    public void setAnswer(char answer) {
        this.answer = answer;
    }

    @Override
    public String toString() {
        return "Question{" +
                "questionId=" + questionId +
                ", title='" + title + '\'' +
                ", optionA='" + optionA + '\'' +
                ", optionB='" + optionB + '\'' +
                ", optionC='" + optionC + '\'' +
                ", optionD='" + optionD + '\'' +
                ", answer=" + answer +
                '}';
    }
}
