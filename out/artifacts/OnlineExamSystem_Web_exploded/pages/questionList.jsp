<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.Question" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>试题管理</title>
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
            --orange-500: #f97316;
            --orange-100: #ffedd5;
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

        .add-btn {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            color: #fff;
            text-decoration: none;
            padding: 8px 18px;
            background: var(--green-500);
            border-radius: 100px;
            transition: all 0.2s;
        }
        .add-btn:hover {
            background: #16a34a;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
        }
        .add-btn svg {
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
            max-width: 1100px;
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
            color: var(--amber-600);
            margin-bottom: 6px;
        }
        .page-title {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 30px;
            font-weight: 600;
            color: var(--slate-900);
        }
        .count-badge {
            font-size: 13px;
            color: var(--slate-500);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
            animation: fadeUp 0.4s ease;
        }
        .alert-success {
            background: var(--green-100);
            border: 1px solid #bbf7d0;
            color: #15803d;
        }
        .alert-error {
            background: var(--red-100);
            border: 1px solid #fecaca;
            color: var(--red-500);
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
            padding: 14px 16px;
            text-align: left;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--slate-500);
            background: var(--slate-100);
        }
        td {
            padding: 16px;
            font-size: 13px;
            color: var(--slate-700);
            border-bottom: 1px solid var(--slate-100);
        }
        tr:last-child td { border-bottom: none; }
        tbody tr {
            transition: background 0.15s;
        }
        tbody tr:hover td { background: #fafaf8; }

        .question-title {
            max-width: 320px;
            color: var(--slate-900);
            font-weight: 500;
            line-height: 1.4;
        }

        .option-cell {
            max-width: 140px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .answer-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 26px; height: 26px;
            background: var(--amber-100);
            color: var(--amber-600);
            border-radius: 6px;
            font-size: 13px;
            font-weight: 700;
        }

        .action-group {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            padding: 5px 12px;
            border-radius: 4px;
            transition: all 0.15s;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            border: none;
            cursor: pointer;
            font-family: inherit;
        }
        .action-btn svg {
            width: 12px; height: 12px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        .action-edit {
            color: var(--orange-500);
            background: var(--orange-100);
            border: 1px solid #fed7aa;
        }
        .action-edit:hover {
            background: var(--orange-500);
            color: #fff;
            border-color: var(--orange-500);
        }
        .action-delete {
            color: var(--red-500);
            background: var(--red-100);
            border: 1px solid #fecaca;
        }
        .action-delete:hover {
            background: var(--red-500);
            color: #fff;
            border-color: var(--red-500);
        }

        .empty-state {
            text-align: center;
            padding: 64px 0;
            color: var(--slate-500);
            font-size: 14px;
        }
    </style>
</head>
<body>
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
            <a href="${pageContext.request.contextPath}/content.jsp" class="back-link">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                返回主页
            </a>
        </div>
    </header>

    <main class="main">
        <div class="page-header">
            <div>
                <div class="page-eyebrow">Administration</div>
                <h2 class="page-title">试题列表</h2>
            </div>
            <div style="display:flex;align-items:center;gap:12px;">
                <a href="${pageContext.request.contextPath}/questionManage?action=add" class="add-btn">
                    <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                    添加试题
                </a>
                <span class="count-badge">
                    <% List<Question> questions = (List<Question>) request.getAttribute("questions"); %>
                    共 <%= questions != null ? questions.size() : 0 %> 题
                </span>
            </div>
        </div>

        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            if ("add".equals(success)) { %>
            <div class="alert alert-success">试题添加成功！</div>
        <% } else if ("update".equals(success)) { %>
            <div class="alert alert-success">试题更新成功！</div>
        <% } else if ("delete".equals(success)) { %>
            <div class="alert alert-success">试题删除成功！</div>
        <% } else if ("addFailed".equals(error)) { %>
            <div class="alert alert-error">试题添加失败！</div>
        <% } else if ("deleteFailed".equals(error)) { %>
            <div class="alert alert-error">试题删除失败！</div>
        <% } else if ("denied".equals(error)) { %>
            <div class="alert alert-error">您没有权限执行此操作！</div>
        <% } %>

        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>题目</th>
                        <th>A</th>
                        <th>B</th>
                        <th>C</th>
                        <th>D</th>
                        <th>答案</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (questions != null && !questions.isEmpty()) {
                        for (Question q : questions) {
                %>
                    <tr>
                        <td><%= q.getQuestionId() %></td>
                        <td class="question-title"><%= q.getTitle() %></td>
                        <td class="option-cell"><%= q.getOptionA() %></td>
                        <td class="option-cell"><%= q.getOptionB() %></td>
                        <td class="option-cell"><%= q.getOptionC() %></td>
                        <td class="option-cell"><%= q.getOptionD() %></td>
                        <td><span class="answer-badge"><%= q.getAnswer() %></span></td>
                        <td>
                            <div class="action-group">
                                <a href="${pageContext.request.contextPath}/questionManage?action=edit&questionId=<%= q.getQuestionId() %>" class="action-btn action-edit">
                                    <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                                    编辑
                                </a>
                                <a href="javascript:void(0)" class="action-btn action-delete" onclick="confirmDelete(<%= q.getQuestionId() %>, '<%= q.getTitle().replace("'", "\\'") %>')">
                                    <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a1 1 0 0 1 1-1h4a1 1 0 0 1 1 1v2"/></svg>
                                    删除
                                </a>
                            </div>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="8">
                            <div class="empty-state">暂无试题，请点击"添加试题"按钮添加</div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        function confirmDelete(questionId, title) {
            if (confirm('确定要删除题目 "' + title + '" 吗？')) {
                window.location.href = '${pageContext.request.contextPath}/questionManage?action=delete&questionId=' + questionId;
            }
        }
    </script>
</body>
</html>
