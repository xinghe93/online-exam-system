package com.xinghe.onlineexam.listener;

import com.xinghe.onlineexam.entity.User;
import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.concurrent.ConcurrentHashMap;

@WebListener
public class UserSessionListener implements HttpSessionListener {

    private static final ConcurrentHashMap<String, User> onlineUsers = new ConcurrentHashMap<>();

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        System.out.println("[Session] 会话创建: " + se.getSession().getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            onlineUsers.remove(session.getId());
            System.out.println("[Online] 用户退出: " + user.getUserName() + "，当前在线: " + onlineUsers.size());
        }
    }

    public static void addUser(HttpSession session, User user) {
        onlineUsers.put(session.getId(), user);
        System.out.println("[Online] 用户登录: " + user.getUserName() + "，当前在线: " + onlineUsers.size());
    }

    public static void removeUser(HttpSession session) {
        User user = onlineUsers.remove(session.getId());
        if (user != null) {
            System.out.println("[Online] 用户退出: " + user.getUserName() + "，当前在线: " + onlineUsers.size());
        }
    }

    public static int getOnlineCount() {
        return onlineUsers.size();
    }

    public static ConcurrentHashMap<String, User> getOnlineUsers() {
        return onlineUsers;
    }
}
