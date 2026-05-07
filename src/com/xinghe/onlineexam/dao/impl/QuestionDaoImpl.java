package com.xinghe.onlineexam.dao.impl;

import com.xinghe.onlineexam.dao.QuestionDao;
import com.xinghe.onlineexam.entity.Question;
import com.xinghe.onlineexam.util.JDBCUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDaoImpl implements QuestionDao {

    private Question mapResultSetToQuestion(ResultSet rs) throws SQLException {
        Question question = new Question();
        question.setQuestionId(rs.getInt("questionId"));
        question.setTitle(rs.getString("title"));
        question.setOptionA(rs.getString("optionA"));
        question.setOptionB(rs.getString("optionB"));
        question.setOptionC(rs.getString("optionC"));
        question.setOptionD(rs.getString("optionD"));
        String answer = rs.getString("answer");
        question.setAnswer(answer != null && !answer.isEmpty() ? answer.charAt(0) : ' ');
        return question;
    }

    @Override
    public List<Question> findAllQuestions() {
        List<Question> questionsList = new ArrayList<>();
        String sql = "SELECT questionId, title, optionA, optionB, optionC, optionD, answer FROM questions";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                questionsList.add(mapResultSetToQuestion(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questionsList;
    }

    @Override
    public Question findQuestionById(int questionId) {
        Question question = null;
        String sql = "SELECT questionId, title, optionA, optionB, optionC, optionD, answer FROM questions WHERE questionId = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, questionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    question = mapResultSetToQuestion(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return question;
    }

    @Override
    public boolean addQuestion(Question question) {
        String sql = "INSERT INTO questions (title, optionA, optionB, optionC, optionD, answer) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, question.getTitle());
            pstmt.setString(2, question.getOptionA());
            pstmt.setString(3, question.getOptionB());
            pstmt.setString(4, question.getOptionC());
            pstmt.setString(5, question.getOptionD());
            pstmt.setString(6, String.valueOf(question.getAnswer()));
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateQuestion(Question question) {
        String sql = "UPDATE questions SET title = ?, optionA = ?, optionB = ?, optionC = ?, optionD = ?, answer = ? WHERE questionId = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, question.getTitle());
            pstmt.setString(2, question.getOptionA());
            pstmt.setString(3, question.getOptionB());
            pstmt.setString(4, question.getOptionC());
            pstmt.setString(5, question.getOptionD());
            pstmt.setString(6, String.valueOf(question.getAnswer()));
            pstmt.setInt(7, question.getQuestionId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Question> findQuestionsByIds(List<Integer> ids) {
        if (ids == null || ids.isEmpty()) return new ArrayList<>();
        List<Question> questions = new ArrayList<>();
        StringBuilder placeholders = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            placeholders.append(i > 0 ? "," : "").append("?");
        }
        String sql = "SELECT questionId, title, optionA, optionB, optionC, optionD, answer FROM questions WHERE questionId IN (" + placeholders + ")";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < ids.size(); i++) {
                pstmt.setInt(i + 1, ids.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) questions.add(mapResultSetToQuestion(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    @Override
    public boolean deleteQuestion(int questionId) {
        String sql = "DELETE FROM questions WHERE questionId = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, questionId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
