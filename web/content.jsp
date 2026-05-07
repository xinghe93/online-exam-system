<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>在线考试系统</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&family=Cormorant+Garamond:wght@500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #f7f5f0;
            --surface: #ffffff;
            --slate-900: #1a1d23;
            --slate-700: #3d424a;
            --slate-500: #6b7280;
            --slate-300: #c4c9d4;
            --slate-100: #f0f1f3;
            --amber-500: #d97706;
            --amber-600: #b45309;
            --amber-100: #fef3c7;
            --red-500: #ef4444;
            --green-500: #22c55e;
            --green-100: #f0fdf4;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, sans-serif;
            background: var(--bg);
            color: var(--slate-900);
            min-height: 100vh;
        }

        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
            opacity: 0.025;
            pointer-events: none;
            z-index: 0;
        }

        /* Topbar */
        .topbar {
            position: relative;
            z-index: 10;
            background: var(--surface);
            backdrop-filter: blur(10px);
            padding: 0 40px;
            height: 68px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 1px 0 var(--slate-100);
        }

        .topbar-brand {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .topbar-icon {
            width: 36px; height: 36px;
            background: var(--slate-900);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .topbar-icon svg {
            width: 18px; height: 18px;
            fill: none;
            stroke: white;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .topbar-brand h1 {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--slate-900);
            letter-spacing: 0.02em;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-chip {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 6px 16px 6px 8px;
            background: var(--slate-100);
            border-radius: 100px;
            animation: chipIn 0.5s 0.1s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        @keyframes chipIn {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }

        .user-avatar {
            width: 28px; height: 28px;
            background: var(--amber-500);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            color: #fff;
            letter-spacing: 0.02em;
        }

        .user-name {
            font-size: 13px;
            font-weight: 600;
            color: var(--slate-700);
        }

        .role-badge {
            padding: 3px 10px;
            border-radius: 100px;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.04em;
        }
        .role-admin { background: var(--amber-100); color: var(--amber-600); }
        .role-user { background: var(--green-100); color: var(--green-500); }

        .topbar-btn {
            font-size: 13px;
            font-weight: 600;
            color: var(--slate-500);
            text-decoration: none;
            padding: 8px 18px;
            border: 1.5px solid var(--slate-300);
            border-radius: 100px;
            transition: all 0.2s;
            animation: chipIn 0.5s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        .topbar-btn:hover {
            border-color: var(--slate-700);
            color: var(--slate-900);
            background: var(--slate-100);
        }
        .topbar-btn.btn-primary {
            background: var(--amber-500);
            border-color: var(--amber-500);
            color: #fff;
        }
        .topbar-btn.btn-primary:hover {
            background: var(--amber-600);
            border-color: var(--amber-600);
            color: #fff;
        }

        .online-indicator {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--slate-500);
        }

        .online-dot {
            width: 8px;
            height: 8px;
            background: var(--green-500);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        /* Main content */
        .main {
            position: relative;
            z-index: 1;
            max-width: 1040px;
            margin: 0 auto;
            padding: 56px 40px 64px;
        }

        /* Welcome section */
        .welcome {
            margin-bottom: 48px;
            animation: welcomeIn 0.7s 0.15s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        @keyframes welcomeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .welcome-eyebrow {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--amber-600);
            margin-bottom: 8px;
        }

        .welcome h2 {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 36px;
            font-weight: 600;
            color: var(--slate-900);
            letter-spacing: 0.01em;
            line-height: 1.2;
            margin-bottom: 8px;
        }


        .welcome p {
            font-size: 15px;
            color: var(--slate-500);
        }

        /* Grid */
        .card-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }

        @media (max-width: 768px) {
            .card-grid { grid-template-columns: repeat(2, 1fr); }
        }

        .func-card {
            background: var(--surface);
            border-radius: 4px;
            padding: 28px 24px;
            text-decoration: none;
            color: var(--slate-900);
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 2px 8px rgba(26, 29, 35, 0.04);
            transition: all 0.25s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
            opacity: 0;
            animation: cardUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .func-card:nth-child(1) { animation-delay: 0.2s; }
        .func-card:nth-child(2) { animation-delay: 0.27s; }
        .func-card:nth-child(3) { animation-delay: 0.34s; }
        .func-card:nth-child(4) { animation-delay: 0.41s; }
        .func-card:nth-child(5) { animation-delay: 0.48s; }

        @keyframes cardUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .func-card:hover {
            transform: translateY(-4px);
            box-shadow:
                0 4px 4px rgba(26, 29, 35, 0.04),
                0 8px 24px rgba(26, 29, 35, 0.08);
        }

        .func-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: linear-gradient(90deg, var(--amber-600), var(--amber-500));
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s;
        }

        .func-card:hover::before {
            transform: scaleX(1);
        }

        .func-card.disabled {
            opacity: 0.55;
            cursor: not-allowed;
            pointer-events: none;
        }

        .card-icon {
            width: 44px; height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 18px;
            font-size: 20px;
        }

        .icon-blue { background: #eef2ff; color: #4f46e5; }
        .icon-red { background: #fef2f2; color: #ef4444; }
        .icon-orange { background: var(--amber-100); color: var(--amber-600); }
        .icon-green { background: var(--green-100); color: var(--green-500); }
        .icon-purple { background: #f5f3ff; color: #7c3aed; }
        .icon-slate { background: var(--slate-100); color: var(--slate-500); }

        .card-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--slate-900);
            margin-bottom: 5px;
        }

        .card-desc {
            font-size: 13px;
            color: var(--slate-500);
            line-height: 1.5;
        }

        .card-arrow {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            width: 20px; height: 20px;
            opacity: 0;
            transition: all 0.2s;
        }

        .func-card:hover .card-arrow {
            opacity: 1;
            transform: translateY(-50%) translateX(2px);
        }
    </style>
</head>
<body>
    <%
        User loginUser = (User) session.getAttribute("user");
        boolean isAdmin = loginUser != null && "admin".equals(loginUser.getRole());
        String initials = "";
        if (loginUser != null && loginUser.getUserName() != null) {
            initials = loginUser.getUserName().substring(0, 1).toUpperCase();
        }
    %>

    <header class="topbar">
        <div class="topbar-brand">
            <div class="topbar-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                    <path d="M2 17l10 5 10-5"/>
                    <path d="M2 12l10 5 10-5"/>
                </svg>
            </div>
            <h1>在线考试系统</h1>
        </div>
        <div class="topbar-right">
            <div class="online-indicator">
                <span class="online-dot"></span>
                <span>在线 <span id="onlineCount">0</span> 人</span>
            </div>
            <div class="user-chip">
                <div class="user-avatar"><%= initials %></div>
                <span class="user-name"><%= loginUser != null ? loginUser.getUserName() : "未登录" %></span>
                <% if (loginUser != null) { %>
                <span class="role-badge <%= isAdmin ? "role-admin" : "role-user" %>">
                    <%= isAdmin ? "管理员" : "普通用户" %>
                </span>
                <% } %>
            </div>
<% if (loginUser != null) { %>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="topbar-btn">退出登录</a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/userlogin.jsp" class="topbar-btn btn-primary">登录/注册</a>
            <% } %>
        </div>
    </header>

    <main class="main">
        <div class="welcome">
            <div class="welcome-eyebrow">Dashboard</div>
            <h2>欢迎回来，<%= loginUser != null ? loginUser.getUserName() : "游客" %></h2>
            <p><%= isAdmin ? "您拥有管理员权限，可以管理试题和用户" : "选择一个功能开始使用" %></p>
        </div>

        <div class="card-grid">
            <a href="${pageContext.request.contextPath}/userManage" class="func-card">
                <div class="card-icon icon-blue">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 20c0-4 4-6 8-6s8 2 8 6"/>
                    </svg>
                </div>
                <div class="card-title">用户中心</div>
                <div class="card-desc">查看和管理个人信息</div>
                <svg class="card-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
            </a>

            <% if (isAdmin) { %>
            <a href="${pageContext.request.contextPath}/questionManage?action=list" class="func-card">
                <div class="card-icon icon-red">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        <polyline points="14 2 14 8 20 8"/>
                        <line x1="16" y1="13" x2="8" y2="13"/>
                        <line x1="16" y1="17" x2="8" y2="17"/>
                        <polyline points="10 9 9 9 8 9"/>
                    </svg>
                </div>
                <div class="card-title">试题管理</div>
                <div class="card-desc">添加、编辑、删除题目</div>
                <svg class="card-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
            </a>

            <a href="${pageContext.request.contextPath}/userManage?action=list" class="func-card">
                <div class="card-icon icon-green">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                    </svg>
                </div>
                <div class="card-title">用户列表</div>
                <div class="card-desc">查看所有注册用户</div>
                <svg class="card-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
            </a>

            <% } else { %>
            <a href="${pageContext.request.contextPath}/exam?action=start" class="func-card">
                <div class="card-icon icon-purple">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                    </svg>
                </div>
                <div class="card-title">在线考试</div>
                <div class="card-desc">开始作答考试试卷</div>
                <svg class="card-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
            </a>

            <a href="${pageContext.request.contextPath}/exam?action=history" class="func-card">
                <div class="card-icon icon-green">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="20" x2="18" y2="10"/>
                        <line x1="12" y1="20" x2="12" y2="4"/>
                        <line x1="6" y1="20" x2="6" y2="14"/>
                    </svg>
                </div>
                <div class="card-title">成绩查询</div>
                <div class="card-desc">查看历史考试成绩</div>
                <svg class="card-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M5 12h14M12 5l7 7-7 7"/>
                </svg>
            </a>
            <% } %>
        </div>
    </main>

    <script>
        function updateOnlineCount() {
            fetch('${pageContext.request.contextPath}/onlineUsers')
                .then(r => r.json())
                .then(data => {
                    document.getElementById('onlineCount').textContent = data.count;
                })
                .catch(() => {});
        }
        updateOnlineCount();
        setInterval(updateOnlineCount, 10000);
    </script>
</body>
</html>
