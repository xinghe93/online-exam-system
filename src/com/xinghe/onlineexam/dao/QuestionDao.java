package com.xinghe.onlineexam.dao;

import com.xinghe.onlineexam.entity.Question;
import java.util.List;

public interface QuestionDao {
    List<Question> findAllQuestions();
    Question findQuestionById(int questionId);
    List<Question> findQuestionsByIds(List<Integer> ids);
    boolean addQuestion(Question question);
    boolean updateQuestion(Question question);
    boolean deleteQuestion(int questionId);
}
