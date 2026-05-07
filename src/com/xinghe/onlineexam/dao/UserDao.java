package com.xinghe.onlineexam.dao;

import com.xinghe.onlineexam.entity.User;
import java.util.List;

public interface UserDao {
    List<User> findAllUsers();
    User findUserByName(String userName);
    User findUserById(int userId);
    User findUserByEmail(String email);
    boolean validateLogin(String userName, String password);
    boolean addUser(User user);
    boolean updateUser(User user);
    boolean deleteUser(int userId);
}
