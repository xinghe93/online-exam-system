<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.ExamRecord" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>成绩查询</title>
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
            --purple-500: #8b5cf6;
            --purple-100: #f3e8ff;
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

        .exam-btn {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            color: #fff;
            text-decoration: none;
            padding: 8px 18px;
            background: var(--purple-500);
            border-radius: 100px;
            transition: all 0.2s;
        }
        .exam-btn:hover {
            background: #7c3aed;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
        }
        .exam-btn svg {
            width: 14px; height: 14px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .success-msg {
            background: var(--green-100);
            border: 1px solid #bbf7d0;
            color: #15803d;
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
            animation: fadeUp 0.4s ease;
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

        .action-link {
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            padding: 5px 12px;
            border-radius: 4px;
            transition: all 0.15s;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        .action-view {
            color: var(--purple-500);
            background: var(--purple-100);
            border: 1px solid #e9d5ff;
        }
        .action-view:hover {
            background: var(--purple-500);
            color: #fff;
            border-color: var(--purple-500);
        }
        .action-link svg {
            width: 12px; height: 12px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .empty-state {
            text-align: center;
            padding: 64px 0;
            color: var(--slate-500);
            font-size: 14px;
        }

        .empty-msg {
            margin-bottom: 16px;
        }
    </style>
</head>
<body>
    <header class="topbar">
        <div class="topbar-brand">
            <div class="topbar-icon">
                <svg viewBox="0 0 24 24">
                    <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                </svg>
            </div>
            <h1>在线考试系统</h1>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/content.jsp" class="back-link">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                返回主页
            </a>
        </div>
    </header>

    <main class="main">
        <div class="page-header">
            <div>
                <div class="page-eyebrow">Records</div>
                <h2 class="page-title">成绩记录</h2>
            </div>
            <a href="${pageContext.request.contextPath}/exam?action=start" class="exam-btn">
                <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                开始考试
            </a>
        </div>

        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>考试时间</th>
                        <th>题目数量</th>
                        <th>正确题数</th>
                        <th>得分</th>
                        <th>用时</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    List<ExamRecord> records = (List<ExamRecord>) request.getAttribute("examRecords");
                    if (records != null && !records.isEmpty()) {
                        for (ExamRecord r : records) {
                            long durationMin = 0;
                            if (r.getEndTime() != null) {
                                durationMin = (r.getEndTime().getTime() - r.getStartTime().getTime()) / 60000;
                            } else if (r.getStatus() == 0) {
                                durationMin = (System.currentTimeMillis() - r.getStartTime().getTime()) / 60000;
                            }
                            String scoreClass = r.getStatus() == 0 ? "score-progress"
                                : (r.getScore() >= r.getTotalScore() * 0.6 ? "score-pass" : "score-fail");
                %>
                    <tr>
                        <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(r.getExamTime()) %></td>
                        <td><%= r.getQuestionCount() %> 题</td>
                        <td><%= r.getCorrectCount() %> 题</td>
                        <td>
                            <span class="score-chip <%= scoreClass %>">
                                <%= r.getScore() %>/<%= r.getTotalScore() %>
                            </span>
                        </td>
                        <td><%= durationMin %> 分钟</td>
                        <td>
                            <span class="status-tag <%= r.getStatus() == 1 ? "status-done" : "status-progress" %>">
                                <%= r.getStatusText() %>
                            </span>
                        </td>
                        <td>
                            <% if (r.getStatus() == 0) { %>
                            <a href="${pageContext.request.contextPath}/exam?action=detail&examId=<%= r.getExamId() %>" class="action-link action-view">
                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                继续
                            </a>
                            <% } else { %>
                            <a href="${pageContext.request.contextPath}/exam?action=detail&examId=<%= r.getExamId() %>" class="action-link action-view">
                                <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                查看
                            </a>
                            <% } %>
                        </td>
                    </tr>
                <% }} else { %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <div class="empty-msg">暂无考试记录</div>
                                <a href="${pageContext.request.contextPath}/exam?action=start" class="action-link action-view" style="display:inline-flex;">
                                    <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                    参加考试
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
