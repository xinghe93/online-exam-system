# JavaWeb实验 - 在线考试系统

本文件描述了 JavaWeb 实验 - 在线考试系统 的详细内容。

## 实验一  Jsp+Servlet实现在线考试系统

### 一、实验目的

掌握JSP+Servlet+JavaBean开发模式，理解Web请求响应机制，学习数据库操作和用户会话管理。

### 二、实验环境

- 操作系统：Windows 10/11 64 位 / MacOS
- 开发工具：IntelliJ IDEA 2022
- Web 服务器：Apache Tomcat 10.0.x
- 开发环境：JDK 17 及以上版本
- 数据库：MySQL 8.0 及以上（配套可视化工具可选：Navicat/DBeaver/SQLyog）
- 前端技术：HTML、CSS、JavaScript

### 三、实验任务

#### 任务1：用户信息管理模块

子任务：
- 用户信息注册
- 用户信息查询（进一步：分本人查询个人信息，管理员查询全部信息）
- 用户信息删除（进一步：只做注销处理）
- 用户信息更新（进一步：只能更新本人信息）

准备工作：
1. 创建用户信息表 `users`
```sql
CREATE TABLE users (
    userId   INT PRIMARY KEY AUTO_INCREMENT,   -- 用户编号
    userName VARCHAR(50),                      -- 用户名称
    password VARCHAR(60),                      -- 用户密码
    sex      CHAR(1),                          -- 用户性别：'男' 或 '女'
    email    VARCHAR(50),                      -- 用户邮箱
    role     VARCHAR(20) DEFAULT 'user'        -- 角色：默认普通用户
);
```

#### 任务2：试题信息管理模块

子任务：
- 添加试题
- 查询试题
- 删除试题
- 更新试题

准备工作：
准备试题信息表（单选题，每道题有4个选项，一个正确答案）：
```sql
CREATE TABLE questions (
    questionId INT PRIMARY KEY AUTO_INCREMENT, -- 题目编号
    title      VARCHAR(50),                    -- 题目内容，如：10-8=?
    optionA    VARCHAR(20),                    -- A: 9
    optionB    VARCHAR(20),                    -- B: 1
    optionC    VARCHAR(20),                    -- C: 2
    optionD    VARCHAR(20),                    -- D: 0
    answer     CHAR(1)                         -- 正确答案
);
```

#### 任务3：考试记录模块

创建考试记录表和答题表：
```sql
CREATE TABLE exam_records (
    examId         INT AUTO_INCREMENT PRIMARY KEY,
    userId         INT NOT NULL,
    examTime       DATETIME NOT NULL,
    score          INT DEFAULT 0,
    totalScore     INT DEFAULT 0,
    questionCount  INT NOT NULL,
    correctCount   INT DEFAULT 0,
    status         TINYINT DEFAULT 0,
    startTime      DATETIME NOT NULL,
    endTime        DATETIME DEFAULT NULL,
    questionIds    VARCHAR(500) NOT NULL,
    timeLimit      INT DEFAULT 30
);

CREATE TABLE exam_answers (
    answerId   INT AUTO_INCREMENT PRIMARY KEY,
    examId     INT NOT NULL,
    questionId INT NOT NULL,
    userAnswer CHAR(1) DEFAULT NULL,
    isCorrect  TINYINT DEFAULT 0,
    FOREIGN KEY (examId) REFERENCES exam_records(examId) ON DELETE CASCADE
);
```

#### 任务4：随机出题与在线阅卷

任务描述：用户点击【参加考试】，系统【随机】提取10道考试题，交给用户答题。

开发任务：

1. 根据用户提供答案与正确答案比较得到用户分数

2. 将用户分数交到成绩页面做输出

### 四、实验要求

1. **数据库要求**：创建users用户表、questions试题表、exam_records考试记录表和exam_answers答题表，表结构符合业务需求，字段类型、约束设置合理。

2. **代码结构要求**：按实体层（entity）、工具层（util）、数据访问层（dao）、控制层（servlet）分包开发，目录结构规范。

3. **工具类要求**：封装JdbcUtil数据库工具类，实现连接、关闭等方法的复用，做好异常捕获。

4. **功能完整性要求**：核心模块功能无缺失，操作流程可正常闭环，无明显运行错误。

### 五、项目结构

```
src/com/xinghe/onlineexam/
├── entity/
│   ├── User.java       # 用户实体类
│   ├── Question.java   # 题目实体类
│   └── ...
├── dao/
│   ├── UserDao.java            # 用户 DAO 接口
│   ├── QuestionDao.java        # 题目 DAO 接口
│   └── impl/
│       ├── UserDaoImpl.java    # 用户 DAO 实现
│       └── QuestionDaoImpl.java # 题目 DAO 实现
├── servlet/
│   ├── RegisterServlet.java    # 注册 Servlet
│   └── ...
└── util/
    └── JDBCUtil.java           # 数据库工具类

web/
├── userlogin.jsp       # 登录页面
├── register.jsp        # 注册页面
├── content.jsp         # 主页面
├── pages/             # 功能页面目录
│   ├── examHistory.jsp  # 考试记录
│   ├── examStart.jsp    # 开始考试
│   ├── examPage.jsp     # 答题页面
│   ├── examResult.jsp   # 考试成绩
│   ├── questionList.jsp # 题目列表
│   ├── questionAdd.jsp  # 添加题目
│   ├── questionEdit.jsp # 编辑题目
│   ├── userList.jsp    # 用户列表
│   ├── userInfo.jsp    # 用户信息
│   └── userScore.jsp   # 用户成绩
└── WEB-INF/web.xml    # Web 配置
```

### 六、数据库配置

配置文件：`src/db.properties`

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/online_exam
jdbc.username=root
jdbc.password=<password>
```

### 七、技术说明

- **Servlet 3.0+**：使用 `@WebServlet` 注解进行 URL 映射
- **DAO 模式**：采用接口 + 实现的结构
- **请求转发**：成功时使用 `req.getRequestDispatcher()`，失败时使用 `resp.sendRedirect()`
- **编码设置**：通过 `req.setCharacterEncoding("UTF-8")` 设置 UTF-8 编码
