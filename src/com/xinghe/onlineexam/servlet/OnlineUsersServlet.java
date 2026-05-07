package com.xinghe.onlineexam.servlet;

import com.xinghe.onlineexam.entity.User;
import com.xinghe.onlineexam.listener.UserSessionListener;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/onlineUsers")
public class OnlineUsersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");

        ConcurrentHashMap<String, User> onlineUsers = UserSessionListener.getOnlineUsers();
        StringBuilder json = new StringBuilder();
        json.append("{\"count\":").append(onlineUsers.size()).append(",\"users\":[");

        int idx = 0;
        for (User u : onlineUsers.values()) {
            if (idx++ > 0) json.append(",");
            json.append("{\"id\":").append(u.getUserId())
                .append(",\"name\":\"").append(escapeJson(u.getUserName())).append("\"}");
        }
        json.append("]}");

        resp.getWriter().write(json.toString());
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\n", "\\n");
    }
}
