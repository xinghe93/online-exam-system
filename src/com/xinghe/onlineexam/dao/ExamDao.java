package com.xinghe.onlineexam.dao;

import com.xinghe.onlineexam.entity.ExamAnswer;
import com.xinghe.onlineexam.entity.ExamRecord;
import java.util.List;

public interface ExamDao {
    boolean saveExamRecord(ExamRecord record);
    boolean updateExamRecord(ExamRecord record);
    ExamRecord findExamById(int examId);
    List<ExamRecord> findExamRecordsByUserId(int userId);
    ExamRecord findInProgressExam(int userId);
    ExamRecord findLastCompletedExam(int userId);

    boolean saveAnswers(List<ExamAnswer> answers);
    List<ExamAnswer> findAnswersByExamId(int examId);
}
