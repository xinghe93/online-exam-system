package com.xinghe.onlineexam.dao.impl;

import com.xinghe.onlineexam.dao.UserDao;
import com.xinghe.onlineexam.entity.User;
import com.xinghe.onlineexam.util.JDBCUtil;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDaoImpl implements UserDao {

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("userId"));
        user.setUserName(rs.getString("userName"));
        user.setPassword(rs.getString("password"));
        user.setSex(rs.getString("sex"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        return user;
    }

    @Override
    public List<User> findAllUsers() {
        List<User> usersList = new ArrayList<>();
        String sql = "SELECT userId, userName, password, sex, email, role FROM users";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                usersList.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usersList;
    }

    @Override
    public User findUserByName(String userName) {
        User user = null;
        String sql = "SELECT userId, userName, password, sex, email, role FROM users WHERE userName = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userName);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public User findUserById(int userId) {
        User user = null;
        String sql = "SELECT userId, userName, password, sex, email, role FROM users WHERE userId = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public User findUserByEmail(String email) {
        User user = null;
        String sql = "SELECT userId, userName, password, sex, email, role FROM users WHERE email = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public boolean validateLogin(String userName, String password) {
        User user = findUserByName(userName);
        if (user != null) {
            return BCrypt.checkpw(password, user.getPassword());
        }
        return false;
    }

    @Override
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (userName, password, sex, email, role) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUserName());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getSex());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getRole() != null ? user.getRole() : "user");
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET userName = ?, sex = ?, email = ?, role = ?";
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            sql += ", password = ?";
        }
        sql += " WHERE userId = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int idx = 1;
            pstmt.setString(idx++, user.getUserName());
            pstmt.setString(idx++, user.getSex());
            pstmt.setString(idx++, user.getEmail());
            pstmt.setString(idx++, user.getRole());
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                pstmt.setString(idx++, user.getPassword());
            }
            pstmt.setInt(idx++, user.getUserId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE userId = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
