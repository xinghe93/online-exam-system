<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户列表</title>
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
            color: var(--amber-600);
            margin-bottom: 6px;
        }
        .page-title {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 30px;
            font-weight: 600;
            color: var(--slate-900);
        }
        .user-count {
            font-size: 13px;
            color: var(--slate-500);
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
        thead tr {
            border-bottom: 1px solid var(--slate-100);
        }
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

        .role-tag {
            display: inline-flex;
            align-items: center;
            padding: 3px 10px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 600;
        }
        .role-admin { background: var(--amber-100); color: var(--amber-600); }
        .role-user { background: var(--green-100); color: var(--green-500); }

        .sex-tag {
            font-size: 13px;
            color: var(--slate-500);
        }

        .action-link {
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            padding: 5px 12px;
            border-radius: 4px;
            transition: all 0.15s;
            display: inline-block;
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

        .action-score {
            color: var(--green-500);
            background: var(--green-100);
            border: 1px solid #bbf7d0;
        }

        .action-score:hover {
            background: var(--green-500);
            color: #fff;
            border-color: var(--green-500);
        }

        .empty-state {
            text-align: center;
            padding: 60px 0;
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
                <h2 class="page-title">用户列表</h2>
            </div>
            <span class="user-count">
                <% List<User> users = (List<User>) request.getAttribute("users"); %>
                共 <%= users != null ? users.size() : 0 %> 位用户
            </span>
        </div>

        <% if ("1".equals(request.getParameter("success"))) { %>
        <div class="success-msg">操作成功！</div>
        <% } %>

        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>用户名</th>
                        <th>性别</th>
                        <th>邮箱</th>
                        <th>角色</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (users != null) {
                        for (User u : users) {
                %>
                    <tr>
                        <td><%= u.getUserId() %></td>
                        <td><%= u.getUserName() %></td>
                        <td>
                            <span class="sex-tag">
                                <% if ("M".equals(u.getSex())) out.print("男");
                                   else if ("F".equals(u.getSex())) out.print("女");
                                   else out.print(u.getSex() != null ? u.getSex() : "—"); %>
                            </span>
                        </td>
                        <td><%= u.getEmail() != null ? u.getEmail() : "—" %></td>
                        <td>
                            <span class="role-tag <%= "admin".equals(u.getRole()) ? "role-admin" : "role-user" %>">
                                <%= "admin".equals(u.getRole()) ? "管理员" : "普通用户" %>
                            </span>
                        </td>
                        <td>
                            <% if (!"admin".equals(u.getRole())) { %>
                            <a href="${pageContext.request.contextPath}/userManage?action=score&userId=<%= u.getUserId() %>" class="action-link action-score">成绩</a>
                            <a href="javascript:void(0)" class="action-link action-delete" onclick="confirmDelete(<%= u.getUserId() %>)">删除</a>
                            <% } %>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="6">
                            <div class="empty-state">暂无用户数据</div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/userManage" style="display:none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="userId" id="deleteUserId">
    </form>

    <script>
        function confirmDelete(userId) {
            if (confirm('确定删除该用户？')) {
                document.getElementById('deleteUserId').value = userId;
                document.getElementById('deleteForm').submit();
            }
        }
    </script>
</body>
</html>
