package com.xinghe.onlineexam.servlet;

import com.xinghe.onlineexam.dao.QuestionDao;
import com.xinghe.onlineexam.dao.impl.QuestionDaoImpl;
import com.xinghe.onlineexam.entity.Question;
import com.xinghe.onlineexam.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/questionManage")
public class QuestionServlet extends HttpServlet {

    private QuestionDao questionDao = new QuestionDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
            return;
        }

        if (!"admin".equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/content.jsp?error=denied");
            return;
        }

        String action = req.getParameter("action");

        if ("list".equals(action)) {
            List<Question> questions = questionDao.findAllQuestions();
            req.setAttribute("questions", questions);
            req.getRequestDispatcher("/pages/questionList.jsp").forward(req, resp);
        } else if ("edit".equals(action)) {
            int questionId = Integer.parseInt(req.getParameter("questionId"));
            Question question = questionDao.findQuestionById(questionId);
            req.setAttribute("question", question);
            req.getRequestDispatcher("/pages/questionEdit.jsp").forward(req, resp);
        } else if ("add".equals(action)) {
            req.getRequestDispatcher("/pages/questionAdd.jsp").forward(req, resp);
        } else if ("delete".equals(action)) {
            int questionId = Integer.parseInt(req.getParameter("questionId"));
            boolean success = questionDao.deleteQuestion(questionId);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=list&success=delete");
            } else {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=list&error=deleteFailed");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/questionManage?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
            return;
        }

        if (!"admin".equals(loginUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/content.jsp?error=denied");
            return;
        }

        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            String title = req.getParameter("title");
            String optionA = req.getParameter("optionA");
            String optionB = req.getParameter("optionB");
            String optionC = req.getParameter("optionC");
            String optionD = req.getParameter("optionD");
            String answerStr = req.getParameter("answer");

            if (title == null || title.trim().isEmpty() ||
                optionA == null || optionA.trim().isEmpty() ||
                optionB == null || optionB.trim().isEmpty() ||
                optionC == null || optionC.trim().isEmpty() ||
                optionD == null || optionD.trim().isEmpty() ||
                answerStr == null || answerStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=add&error=empty");
                return;
            }

            char answer = answerStr.toUpperCase().charAt(0);
            if (answer < 'A' || answer > 'D') {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=add&error=invalidAnswer");
                return;
            }

            Question question = new Question();
            question.setTitle(title.trim());
            question.setOptionA(optionA.trim());
            question.setOptionB(optionB.trim());
            question.setOptionC(optionC.trim());
            question.setOptionD(optionD.trim());
            question.setAnswer(answer);

            boolean success = questionDao.addQuestion(question);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=list&success=add");
            } else {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=add&error=addFailed");
            }

        } else if ("update".equals(action)) {
            int questionId = Integer.parseInt(req.getParameter("questionId"));
            String title = req.getParameter("title");
            String optionA = req.getParameter("optionA");
            String optionB = req.getParameter("optionB");
            String optionC = req.getParameter("optionC");
            String optionD = req.getParameter("optionD");
            String answerStr = req.getParameter("answer");

            if (title == null || title.trim().isEmpty() ||
                optionA == null || optionA.trim().isEmpty() ||
                optionB == null || optionB.trim().isEmpty() ||
                optionC == null || optionC.trim().isEmpty() ||
                optionD == null || optionD.trim().isEmpty() ||
                answerStr == null || answerStr.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=edit&questionId=" + questionId + "&error=empty");
                return;
            }

            char answer = answerStr.toUpperCase().charAt(0);
            if (answer < 'A' || answer > 'D') {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=edit&questionId=" + questionId + "&error=invalidAnswer");
                return;
            }

            Question question = new Question();
            question.setQuestionId(questionId);
            question.setTitle(title.trim());
            question.setOptionA(optionA.trim());
            question.setOptionB(optionB.trim());
            question.setOptionC(optionC.trim());
            question.setOptionD(optionD.trim());
            question.setAnswer(answer);

            boolean success = questionDao.updateQuestion(question);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=list&success=update");
            } else {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=edit&questionId=" + questionId + "&error=updateFailed");
            }

        } else if ("delete".equals(action)) {
            int questionId = Integer.parseInt(req.getParameter("questionId"));
            boolean success = questionDao.deleteQuestion(questionId);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=list&success=delete");
            } else {
                resp.sendRedirect(req.getContextPath() + "/questionManage?action=list&error=deleteFailed");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/questionManage?action=list");
        }
    }
}
