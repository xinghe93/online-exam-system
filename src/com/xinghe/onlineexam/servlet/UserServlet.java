package com.xinghe.onlineexam.servlet;

import com.xinghe.onlineexam.dao.UserDao;
import com.xinghe.onlineexam.dao.ExamDao;
import com.xinghe.onlineexam.dao.impl.UserDaoImpl;
import com.xinghe.onlineexam.dao.impl.ExamDaoImpl;
import com.xinghe.onlineexam.entity.User;
import com.xinghe.onlineexam.entity.ExamRecord;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/userManage")
public class UserServlet extends HttpServlet {

    private UserDao userDao = new UserDaoImpl();
    private ExamDao examDao = new ExamDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        // 未登录，重定向
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("list".equals(action) && "admin".equals(loginUser.getRole())) {
            // 管理员：列出所有用户
            List<User> users = userDao.findAllUsers();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/pages/userList.jsp").forward(req, resp);
        } else if ("score".equals(action) && "admin".equals(loginUser.getRole())) {
            // 管理员：查看指定用户的成绩
            int targetUserId = Integer.parseInt(req.getParameter("userId"));
            User targetUser = userDao.findUserById(targetUserId);
            if (targetUser != null) {
                List<ExamRecord> records = examDao.findExamRecordsByUserId(targetUserId);
                req.setAttribute("targetUser", targetUser);
                req.setAttribute("examRecords", records);
                req.getRequestDispatcher("/pages/userScore.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/userManage?action=list&error=notFound");
            }
        } else {
            // 普通用户或无 action：查看自己的信息
            User user = userDao.findUserById(loginUser.getUserId());
            req.setAttribute("user", user);
            req.getRequestDispatcher("/pages/userInfo.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User loginUser = (User) session.getAttribute("user");

        // 未登录，重定向
        if (loginUser == null) {
            resp.sendRedirect(req.getContextPath() + "/userlogin.jsp");
            return;
        }

        String action = req.getParameter("action");

        if ("update".equals(action)) {
            int targetUserId = Integer.parseInt(req.getParameter("userId"));

            // 普通用户只能更新自己的信息
            if (!"admin".equals(loginUser.getRole()) && loginUser.getUserId() != targetUserId) {
                resp.sendRedirect(req.getContextPath() + "/userManage?error=denied");
                return;
            }

            // 处理新用户名
            String newUserName = req.getParameter("newUserName");
            if (newUserName == null || newUserName.trim().isEmpty()) {
                newUserName = req.getParameter("userName"); // 回退到原用户名
            }

            // 处理密码修改
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword");
            if (newPassword != null && !newPassword.isEmpty()) {
                if (newPassword.length() < 6) {
                    resp.sendRedirect(req.getContextPath() + "/userManage?error=passwordShort");
                    return;
                }
                if (!newPassword.equals(confirmPassword)) {
                    resp.sendRedirect(req.getContextPath() + "/userManage?error=passwordMismatch");
                    return;
                }
            }

            User user = new User();
            user.setUserId(targetUserId);
            user.setUserName(newUserName.trim());
            user.setSex(req.getParameter("sex"));
            user.setEmail(req.getParameter("email"));
            user.setRole(req.getParameter("role"));
            if (newPassword != null && !newPassword.isEmpty()) {
                user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
            }

            // 只有管理员可以修改角色
            if (!"admin".equals(loginUser.getRole())) {
                user.setRole(loginUser.getRole());
            }

            boolean success = userDao.updateUser(user);

            if (success) {
                if (loginUser.getUserId() == targetUserId) {
                    loginUser.setUserName(user.getUserName());
                    loginUser.setSex(user.getSex());
                    loginUser.setEmail(user.getEmail());
                }
                resp.sendRedirect(req.getContextPath() + "/userManage?success=1");
            } else {
                resp.sendRedirect(req.getContextPath() + "/userManage?error=updateFailed");
            }

        } else if ("delete".equals(action)) {
            int targetUserId = Integer.parseInt(req.getParameter("userId"));

            // 不能删除管理员
            User targetUser = userDao.findUserById(targetUserId);
            if (targetUser != null && "admin".equals(targetUser.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/userManage?action=list&error=cannotDeleteAdmin");
                return;
            }

            // 普通用户只能删除自己的账户
            if (!"admin".equals(loginUser.getRole())) {
                if (loginUser.getUserId() != targetUserId) {
                    resp.sendRedirect(req.getContextPath() + "/userManage?error=denied");
                    return;
                }
            } else {
                // 管理员不能删除自己
                if (loginUser.getUserId() == targetUserId) {
                    resp.sendRedirect(req.getContextPath() + "/userManage?action=list&error=cannotDeleteSelf");
                    return;
                }
            }

            boolean success = userDao.deleteUser(targetUserId);

            if (success) {
                if ("admin".equals(loginUser.getRole())) {
                    resp.sendRedirect(req.getContextPath() + "/userManage?action=list&success=1");
                } else {
                    // 普通用户删除自己后注销
                    session.invalidate();
                    resp.sendRedirect(req.getContextPath() + "/userlogin.jsp?success=deleted");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/userManage?error=deleteFailed");
            }
        }
    }
}
