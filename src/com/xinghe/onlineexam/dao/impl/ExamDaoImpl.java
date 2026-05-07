package com.xinghe.onlineexam.dao.impl;

import com.xinghe.onlineexam.dao.ExamDao;
import com.xinghe.onlineexam.entity.ExamAnswer;
import com.xinghe.onlineexam.entity.ExamRecord;
import com.xinghe.onlineexam.util.JDBCUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDaoImpl implements ExamDao {

    @Override
    public boolean saveExamRecord(ExamRecord record) {
        String sql = "INSERT INTO exam_records (userId, examTime, score, totalScore, questionCount, correctCount, status, startTime, questionIds, timeLimit) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, record.getUserId());
            pstmt.setTimestamp(2, new Timestamp(record.getExamTime().getTime()));
            pstmt.setInt(3, record.getScore());
            pstmt.setInt(4, record.getTotalScore());
            pstmt.setInt(5, record.getQuestionCount());
            pstmt.setInt(6, record.getCorrectCount());
            pstmt.setInt(7, record.getStatus());
            pstmt.setTimestamp(8, new Timestamp(record.getStartTime().getTime()));
            pstmt.setString(9, record.getQuestionIds());
            pstmt.setInt(10, record.getTimeLimit());
            boolean success = pstmt.executeUpdate() > 0;
            if (success) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) record.setExamId(rs.getInt(1));
                }
            }
            return success;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateExamRecord(ExamRecord record) {
        String sql = "UPDATE exam_records SET score=?, totalScore=?, correctCount=?, status=?, endTime=? WHERE examId=?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, record.getScore());
            pstmt.setInt(2, record.getTotalScore());
            pstmt.setInt(3, record.getCorrectCount());
            pstmt.setInt(4, record.getStatus());
            if (record.getEndTime() != null) {
                pstmt.setTimestamp(5, new Timestamp(record.getEndTime().getTime()));
            } else {
                pstmt.setNull(5, Types.TIMESTAMP);
            }
            pstmt.setInt(6, record.getExamId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public ExamRecord findExamById(int examId) {
        String sql = "SELECT * FROM exam_records WHERE examId=?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, examId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<ExamRecord> findExamRecordsByUserId(int userId) {
        List<ExamRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM exam_records WHERE userId=? ORDER BY examTime DESC";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public ExamRecord findInProgressExam(int userId) {
        String sql = "SELECT * FROM exam_records WHERE userId=? AND status=0 ORDER BY startTime DESC LIMIT 1";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public ExamRecord findLastCompletedExam(int userId) {
        String sql = "SELECT * FROM exam_records WHERE userId=? AND status=1 ORDER BY examTime DESC LIMIT 1";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean saveAnswers(List<ExamAnswer> answers) {
        String sql = "INSERT INTO exam_answers (examId, questionId, userAnswer, isCorrect) VALUES (?, ?, ?, ?)";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (ExamAnswer a : answers) {
                pstmt.setInt(1, a.getExamId());
                pstmt.setInt(2, a.getQuestionId());
                pstmt.setString(3, a.getUserAnswer());
                pstmt.setInt(4, a.getIsCorrect());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<ExamAnswer> findAnswersByExamId(int examId) {
        List<ExamAnswer> list = new ArrayList<>();
        String sql = "SELECT * FROM exam_answers WHERE examId=?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, examId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ExamAnswer a = new ExamAnswer();
                    a.setAnswerId(rs.getInt("answerId"));
                    a.setExamId(rs.getInt("examId"));
                    a.setQuestionId(rs.getInt("questionId"));
                    a.setUserAnswer(rs.getString("userAnswer"));
                    a.setIsCorrect(rs.getInt("isCorrect"));
                    list.add(a);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private ExamRecord mapResultSet(ResultSet rs) throws SQLException {
        ExamRecord r = new ExamRecord();
        r.setExamId(rs.getInt("examId"));
        r.setUserId(rs.getInt("userId"));
        r.setExamTime(rs.getTimestamp("examTime"));
        r.setScore(rs.getInt("score"));
        r.setTotalScore(rs.getInt("totalScore"));
        r.setQuestionCount(rs.getInt("questionCount"));
        r.setCorrectCount(rs.getInt("correctCount"));
        r.setStatus(rs.getInt("status"));
        r.setStartTime(rs.getTimestamp("startTime"));
        Timestamp endTime = rs.getTimestamp("endTime");
        r.setEndTime(endTime != null ? endTime : null);
        r.setQuestionIds(rs.getString("questionIds"));
        r.setTimeLimit(rs.getInt("timeLimit"));
        return r;
    }
}
