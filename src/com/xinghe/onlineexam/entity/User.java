package com.xinghe.onlineexam.entity;

public class User {
    private int userId;
    private String userName;
    private String password;
    private String sex;
    private String email;
    private String role; // admin 或 user

    public User() {
    }

    public User(int userId, String userName, String password, String sex, String email, String role) {
        this.userId = userId;
        this.userName = userName;
        this.password = password;
        this.sex = sex;
        this.email = email;
        this.role = role;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", userName='" + userName + '\'' +
                ", password='" + "******" + '\'' +
                ", sex='" + sex + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}
