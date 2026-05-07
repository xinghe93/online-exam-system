<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.ExamRecord" %>
<%@ page import="com.xinghe.onlineexam.entity.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户成绩 - <%= ((User)request.getAttribute("targetUser")).getUserName() %></title>
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
            --red-100: #fef2f2;
            --green-500: #22c55e;
            --green-100: #f0fdf4;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        html {
            overflow-y: auto;
            scrollbar-gutter: stable;
        }
        html::-webkit-scrollbar {
            width: 6px;
        }
        html::-webkit-scrollbar-track {
            background: transparent;
        }
        html::-webkit-scrollbar-thumb {
            background: var(--slate-300);
            border-radius: 3px;
        }
        html::-webkit-scrollbar-thumb:hover {
            background: var(--slate-500);
        }
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

        .topbar {
            position: relative;
            z-index: 10;
            background: var(--surface);
            padding: 0 40px;
            height: 68px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 1px 0 var(--slate-100);
        }
        .topbar-brand {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .topbar-icon {
            width: 36px; height: 36px;
            background: var(--green-500);
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
            font-size: 26px;
            font-weight: 600;
            color: var(--slate-900);
            letter-spacing: 0.02em;
        }
        .topbar-right {
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .back-link {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            color: var(--slate-500);
            text-decoration: none;
            padding: 8px 16px;
            border: 1.5px solid var(--slate-300);
            border-radius: 100px;
            transition: all 0.2s;
        }
        .back-link:hover {
            border-color: var(--slate-700);
            color: var(--slate-900);
        }
        .back-link svg {
            width: 14px; height: 14px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .main {
            position: relative;
            z-index: 1;
            max-width: 900px;
            margin: 0 auto;
            padding: 56px 40px 64px;
        }

        .page-header {
            margin-bottom: 28px;
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            animation: fadeUp 0.6s 0.1s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(16px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .page-eyebrow {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: var(--green-500);
            margin-bottom: 6px;
        }
        .page-title {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 30px;
            font-weight: 600;
            color: var(--slate-900);
        }

        .user-info {
            background: var(--surface);
            border-radius: 4px;
            padding: 20px 24px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 20px;
            box-shadow: 0 1px 2px rgba(26, 29, 35, 0.04);
            animation: fadeUp 0.6s 0.15s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        .user-avatar {
            width: 48px; height: 48px;
            background: var(--amber-500);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: 700;
            color: #fff;
        }
        .user-details h3 {
            font-size: 16px;
            font-weight: 600;
            color: var(--slate-900);
        }
        .user-details p {
            font-size: 13px;
            color: var(--slate-500);
            margin-top: 2px;
        }

        .table-card {
            background: var(--surface);
            border-radius: 4px;
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 4px 8px rgba(26, 29, 35, 0.04),
                0 12px 32px rgba(26, 29, 35, 0.05);
            overflow: hidden;
            animation: fadeUp 0.6s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }
        thead tr { border-bottom: 1px solid var(--slate-100); }
        th {
            padding: 14px 20px;
            text-align: left;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--slate-500);
            background: var(--slate-100);
        }
        td {
            padding: 16px 20px;
            font-size: 14px;
            color: var(--slate-700);
            border-bottom: 1px solid var(--slate-100);
        }
        tr:last-child td { border-bottom: none; }
        tbody tr {
            transition: background 0.15s;
        }
        tbody tr:hover td { background: #fafaf8; }

        .score-chip {
            display: inline-flex;
            align-items: center;
            padding: 4px 12px;
            border-radius: 100px;
            font-size: 14px;
            font-weight: 700;
        }
        .score-pass { background: var(--green-100); color: var(--green-500); }
        .score-fail { background: var(--red-100); color: var(--red-500); }
        .score-progress { background: var(--amber-100); color: var(--amber-600); }

        .status-tag {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-done { color: var(--green-500); }
        .status-done::before {
            content: '';
            width: 6px; height: 6px;
            background: var(--green-500);
            border-radius: 50%;
        }
        .status-progress { color: var(--amber-600); }
        .status-progress::before {
            content: '';
            width: 6px; height: 6px;
            background: var(--amber-500);
            border-radius: 50%;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.4; }
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--slate-500);
        }
        .empty-state svg {
            width: 48px; height: 48px;
            stroke: var(--slate-300);
            fill: none;
            stroke-width: 1.5;
            margin-bottom: 16px;
        }
        .empty-state p {
            font-size: 14px;
        }
    </style>
</head>
<body>
    <%
        User targetUser = (User) request.getAttribute("targetUser");
        List<ExamRecord> records = (List<ExamRecord>) request.getAttribute("examRecords");
        String initials = targetUser.getUserName().substring(0, 1).toUpperCase();
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
            <a href="${pageContext.request.contextPath}/userManage?action=list" class="back-link">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                返回用户列表
            </a>
        </div>
    </header>

    <main class="main">
        <div class="page-header">
            <div>
                <div class="page-eyebrow">Admin</div>
                <h2 class="page-title"><%= targetUser.getUserName() %> 的成绩记录</h2>
            </div>
        </div>

        <div class="user-info">
            <div class="user-avatar"><%= initials %></div>
            <div class="user-details">
                <h3><%= targetUser.getUserName() %></h3>
                <p><%= targetUser.getEmail() != null ? targetUser.getEmail() : "未设置邮箱" %> &nbsp;|&nbsp; 共 <%= records.size() %> 次考试记录</p>
            </div>
        </div>

        <div class="table-card">
            <% if (records != null && !records.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>考试时间</th>
                        <th>题数</th>
                        <th>正确</th>
                        <th>得分</th>
                        <th>用时</th>
                        <th>状态</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (ExamRecord r : records) { %>
                    <tr>
                        <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(r.getExamTime()) %></td>
                        <td><%= r.getQuestionCount() %></td>
                        <td><%= r.getCorrectCount() %></td>
                        <td>
                            <span class="score-chip <%= r.getStatus() == 1 ? (r.getScore() >= r.getTotalScore() * 0.6 ? "score-pass" : "score-fail") : "score-progress" %>">
                                <%= r.getScore() %>/<%= r.getTotalScore() %>
                            </span>
                        </td>
                        <td>
                            <% if (r.getEndTime() != null) { %>
                                <%= (r.getEndTime().getTime() - r.getStartTime().getTime()) / 1000 / 60 %> 分钟
                            <% } else { %>
                                —
                            <% } %>
                        </td>
                        <td>
                            <span class="status-tag <%= r.getStatus() == 1 ? "status-done" : "status-progress" %>">
                                <%= r.getStatus() == 1 ? "已完成" : "进行中" %>
                            </span>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <div class="empty-state">
                <svg viewBox="0 0 24 24">
                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                </svg>
                <p>暂无考试记录</p>
            </div>
            <% } %>
        </div>
    </main>
</body>
</html>