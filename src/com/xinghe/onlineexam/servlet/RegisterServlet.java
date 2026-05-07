package com.xinghe.onlineexam.servlet;

import com.xinghe.onlineexam.dao.UserDao;
import com.xinghe.onlineexam.dao.impl.UserDaoImpl;
import com.xinghe.onlineexam.entity.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String sex = req.getParameter("sex");
        String email = req.getParameter("email");

        // 用户名查重
        if (userDao.findUserByName(username) != null) {
            req.setAttribute("err", "用户名已存在");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 邮箱查重
        if (userDao.findUserByEmail(email) != null) {
            req.setAttribute("err", "邮箱已被注册");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // 封装用户信息并注册
        User user = new User();
        user.setUserName(username);
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
        user.setSex(sex);
        user.setEmail(email);

        boolean flag = userDao.addUser(user);

        // 结果处理
        if (flag) {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
        } else {
            req.setAttribute("err", "注册失败");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
