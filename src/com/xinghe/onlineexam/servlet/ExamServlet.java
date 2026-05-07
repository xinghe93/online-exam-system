package com.xinghe.onlineexam.servlet;

import com.xinghe.onlineexam.dao.ExamDao;
import com.xinghe.onlineexam.dao.QuestionDao;
import com.xinghe.onlineexam.dao.impl.ExamDaoImpl;
import com.xinghe.onlineexam.dao.impl.QuestionDaoImpl;
import com.xinghe.onlineexam.entity.ExamAnswer;
import com.xinghe.onlineexam.entity.ExamRecord;
import com.xinghe.onlineexam.entity.Question;
import com.xinghe.onlineexam.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

@WebServlet("/exam")
public class ExamServlet extends HttpServlet {

    private ExamDao examDao = new ExamDaoImpl();
    private QuestionDao questionDao = new QuestionDaoImpl();

    private static final int DEFAULT_QUESTION_COUNT = 10;
    private static final int DEFAULT_TIME_LIMIT = 30;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
            return;
        }

        if ("admin".equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/content.jsp?error=adminCannotExam");
            return;
        }

        String action = req.getParameter("action");

        switch (action) {
            case "start":
                handleStartExam(req, resp, loginUser);
                break;
            case "new":
                handleNewExam(req, resp, loginUser);
                break;
            case "detail":
                handleExamDetail(req, resp, loginUser);
                break;
            case "history":
                handleExamHistory(req, resp, loginUser);
                break;
            case "submit":
                handleSubmitExam(req, resp, loginUser);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/content.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
            return;
        }

        String action = req.getParameter("action");
        if ("submit".equals(action)) {
            handleSubmitExam(req, resp, loginUser);
        } else {
            resp.sendRedirect(req.getContextPath() + "/exam?action=history");
        }
    }

    private void handleStartExam(HttpServletRequest req, HttpServletResponse resp, User loginUser) throws ServletException, IOException {
        // 检查进行中的考试
        ExamRecord inProgress = examDao.findInProgressExam(loginUser.getUserId());
        if (inProgress != null) {
            resp.sendRedirect(req.getContextPath() + "/exam?action=detail&examId=" + inProgress.getExamId());
            return;
        }

        // 获取上次完成的考试成绩
        ExamRecord lastExam = examDao.findLastCompletedExam(loginUser.getUserId());
        req.setAttribute("lastExam", lastExam);

        // 统计总考试次数
        List<ExamRecord> allRecords = examDao.findExamRecordsByUserId(loginUser.getUserId());
        req.setAttribute("totalExams", allRecords.size());
        req.setAttribute("completedExams", (int) allRecords.stream().filter(r -> r.getStatus() == 1).count());

        req.getRequestDispatcher("/pages/examStart.jsp").forward(req, resp);
    }

    private void handleNewExam(HttpServletRequest req, HttpServletResponse resp, User loginUser) throws ServletException, IOException {
        String countStr = req.getParameter("count");
        int questionCount = countStr != null ? Integer.parseInt(countStr) : DEFAULT_QUESTION_COUNT;

        List<Question> all = questionDao.findAllQuestions();
        if (all.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/content.jsp?error=noQuestions");
            return;
        }

        // 去重：按 questionId 去重，防止数据库返回重复记录
        java.util.LinkedHashSet<Integer> uniqueIds = new java.util.LinkedHashSet<>();
        for (Question q : all) uniqueIds.add(q.getQuestionId());
        List<Question> unique = new ArrayList<>();
        for (Question q : all) {
            if (uniqueIds.remove(q.getQuestionId())) unique.add(q);
        }
        all = unique;

        if (all.size() < questionCount) {
            questionCount = all.size();
        }

        List<Question> shuffled = new ArrayList<>(all);
        Collections.shuffle(shuffled);
        List<Question> selected = shuffled.subList(0, questionCount);

        List<Integer> ids = new ArrayList<>();
        for (Question q : selected) ids.add(q.getQuestionId());
        String idsStr = String.join(",", ids.stream().map(String::valueOf).toArray(String[]::new));

        ExamRecord record = new ExamRecord();
        record.setUserId(loginUser.getUserId());
        record.setExamTime(new Date());
        record.setStartTime(new Date());
        record.setQuestionCount(questionCount);
        record.setTotalScore(questionCount);
        record.setStatus(0);
        record.setQuestionIds(idsStr);
        record.setTimeLimit(DEFAULT_TIME_LIMIT);
        record.setQuestions(selected);

        if (!examDao.saveExamRecord(record)) {
            resp.sendRedirect(req.getContextPath() + "/content.jsp?error=startExamFailed");
            return;
        }

        req.getSession().setAttribute("currentExamId", record.getExamId());
        req.setAttribute("examRecord", record);
        req.getRequestDispatcher("/pages/examPage.jsp").forward(req, resp);
    }

    private void handleExamDetail(HttpServletRequest req, HttpServletResponse resp, User loginUser) throws ServletException, IOException {
        int examId = Integer.parseInt(req.getParameter("examId"));
        ExamRecord record = examDao.findExamById(examId);

        if (record == null || record.getUserId() != loginUser.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/exam?action=history&error=notFound");
            return;
        }

        if (record.getStatus() == 1) {
            List<Question> questions = loadQuestionsFromIds(record.getQuestionIds());
            record.setQuestions(questions);
            List<ExamAnswer> answers = examDao.findAnswersByExamId(examId);
            req.setAttribute("examRecord", record);
            req.setAttribute("questions", questions);
            req.setAttribute("answers", answers);
            req.getRequestDispatcher("/pages/examResult.jsp").forward(req, resp);
            return;
        }

        List<Question> questions = loadQuestionsFromIds(record.getQuestionIds());
        record.setQuestions(questions);

        List<ExamAnswer> answers = examDao.findAnswersByExamId(examId);
        Map<Integer, String> answerMap = new HashMap<>();
        for (ExamAnswer a : answers) {
            if (a.getUserAnswer() != null) {
                answerMap.put(a.getQuestionId(), a.getUserAnswer());
            }
        }
        List<String> orderedAnswers = new ArrayList<>();
        for (Question q : questions) {
            orderedAnswers.add(answerMap.getOrDefault(q.getQuestionId(), ""));
        }
        record.setUserAnswers(orderedAnswers);

        long elapsed = (System.currentTimeMillis() - record.getStartTime().getTime()) / 1000;
        int remaining = record.getTimeLimit() * 60 - (int) elapsed;

        req.setAttribute("examRecord", record);
        req.setAttribute("remainingSeconds", remaining > 0 ? remaining : 0);
        req.getRequestDispatcher("/pages/examPage.jsp").forward(req, resp);
    }

    private void handleExamHistory(HttpServletRequest req, HttpServletResponse resp, User loginUser) throws ServletException, IOException {
        List<ExamRecord> records = examDao.findExamRecordsByUserId(loginUser.getUserId());
        req.setAttribute("examRecords", records);
        req.getRequestDispatcher("/pages/examHistory.jsp").forward(req, resp);
    }

    private void handleSubmitExam(HttpServletRequest req, HttpServletResponse resp, User loginUser) throws ServletException, IOException {
        int examId = Integer.parseInt(req.getParameter("examId"));
        ExamRecord record = examDao.findExamById(examId);

        if (record == null || record.getUserId() != loginUser.getUserId()) {
            resp.sendRedirect(req.getContextPath() + "/exam?action=history&error=notFound");
            return;
        }

        if (record.getStatus() == 1) {
            resp.sendRedirect(req.getContextPath() + "/exam?action=history");
            return;
        }

        List<Question> questions = loadQuestionsFromIds(record.getQuestionIds());
        List<ExamAnswer> answerList = new ArrayList<>();
        int correctCount = 0;

        for (Question q : questions) {
            String userAnswer = req.getParameter("q_" + q.getQuestionId());
            boolean isCorrect = userAnswer != null && userAnswer.equalsIgnoreCase(String.valueOf(q.getAnswer()));
            if (isCorrect) correctCount++;

            ExamAnswer a = new ExamAnswer();
            a.setExamId(examId);
            a.setQuestionId(q.getQuestionId());
            a.setUserAnswer(userAnswer);
            a.setIsCorrect(isCorrect ? 1 : 0);
            answerList.add(a);
        }

        examDao.saveAnswers(answerList);

        record.setScore(correctCount);
        record.setCorrectCount(correctCount);
        record.setStatus(1);
        record.setEndTime(new Date());
        examDao.updateExamRecord(record);

        req.getSession().removeAttribute("currentExamId");

        req.setAttribute("examRecord", record);
        req.setAttribute("questions", questions);
        req.setAttribute("answers", answerList);
        req.getRequestDispatcher("/pages/examResult.jsp").forward(req, resp);
    }

    private List<Question> loadQuestionsFromIds(String idsStr) {
        if (idsStr == null || idsStr.isEmpty()) return new ArrayList<>();
        List<Integer> ids = new ArrayList<>();
        for (String s : idsStr.split(",")) {
            try { ids.add(Integer.parseInt(s.trim())); } catch (NumberFormatException ignored) {}
        }
        return questionDao.findQuestionsByIds(ids);
    }
}
