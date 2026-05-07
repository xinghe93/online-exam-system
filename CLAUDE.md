# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在本仓库中工作时提供指导。

## 项目概述

基于 JSP/Servlet 和 MySQL 数据库的在线考试系统。

## 编译与运行

- **编译**: 使用 IDEA 编译 (Ctrl+F9) 或直接使用 `javac`
- **运行**: 部署到 Tomcat 或其他 servlet 容器
- **依赖库**: servlet-api 和 mysql-connector-j-8.0.33 已配置为项目库

## 项目架构

```
src/com/xinghe/onlineexam/
├── entity/
│   ├── User.java       # 用户实体类
│   └── Question.java   # 题目实体类
├── dao/
│   ├── UserDao.java            # 用户 DAO 接口
│   ├── QuestionDao.java        # 题目 DAO 接口
│   └── impl/
│       ├── UserDaoImpl.java    # 用户 DAO 实现
│       └── QuestionDaoImpl.java # 题目 DAO 实现
├── servlet/
│   └── RegisterServlet.java    # 注册 Servlet，映射 /register
└── util/
    └── JDBCUtil.java           # 数据库工具类

web/
├── userlogin.jsp       # 登录页面，提交表单到 /login
├── content.jsp         # 登录成功后的主页面
├── fail.html           # 登录失败跳转页面
├── pages/              # 内部页面目录
└── WEB-INF/web.xml     # Web 配置 (Servlet 4.0)
```

## 关键模式

- **Servlet 3.0+**: 使用 `@WebServlet` 注解进行 URL 映射（无需在 web.xml 中配置 servlet）
- **DAO 模式**: 实体类在 `dao/` 目录下，采用接口 + 实现的结构
- **请求转发**: 成功时使用 `req.getRequestDispatcher("/content.jsp").forward(req, resp)`，失败时使用 `resp.sendRedirect()`
- **编码设置**: Servlet 通过 `req.setCharacterEncoding("UTF-8")` 和 `resp.setCharacterEncoding("UTF-8")` 设置 UTF-8 编码

## 数据库配置

- `db.properties` - 数据库配置文件，位于 src 目录
- `JDBCUtil.java` - 通过 ClassLoader 读取 db.properties 配置文件

## 配置说明

- `web/WEB-INF/web.xml` - 精简版 web.xml（servlet 配置使用注解方式）
- `OnlineExamSystem.iml` - IDEA 模块文件，包含依赖库配置
