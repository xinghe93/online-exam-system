package com.xinghe.onlineexam.servlet;

import com.xinghe.onlineexam.dao.UserDao;
import com.xinghe.onlineexam.dao.impl.UserDaoImpl;
import com.xinghe.onlineexam.entity.User;
import com.xinghe.onlineexam.listener.UserSessionListener;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDao.findUserByName(username);
        if (user != null && org.mindrot.jbcrypt.BCrypt.checkpw(password, user.getPassword())) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);
            UserSessionListener.addUser(session, user);
            resp.sendRedirect(req.getContextPath() + "/content.jsp");
        } else {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp?error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            UserSessionListener.removeUser(session);
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
    }
}
