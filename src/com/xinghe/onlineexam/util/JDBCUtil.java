package com.xinghe.onlineexam.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class JDBCUtil {

    private static String driver;
    private static String url;
    private static String username;
    private static String password;

    // 静态代码块，加载时读取配置文件
    static {
        Properties props = new Properties();
        try (InputStream is = JDBCUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (is != null) {
                props.load(is);
                driver = props.getProperty("jdbc.driver");
                url = props.getProperty("jdbc.url");
                username = props.getProperty("jdbc.username");
                password = props.getProperty("jdbc.password");
                Class.forName(driver);
            }
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    // 获取数据库连接
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    // 关闭资源
    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 重载：关闭连接和PreparedStatement（没有ResultSet时）
    public static void close(Connection conn, PreparedStatement pstmt) {
        close(conn, pstmt, null);
    }
}
