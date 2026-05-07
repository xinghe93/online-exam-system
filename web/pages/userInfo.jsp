<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>个人信息</title>
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
            max-width: 640px;
            margin: 0 auto;
            padding: 56px 24px 64px;
        }

        .page-header {
            margin-bottom: 28px;
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

        .card {
            background: var(--surface);
            border-radius: 4px;
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 4px 8px rgba(26, 29, 35, 0.04),
                0 12px 32px rgba(26, 29, 35, 0.05);
            overflow: hidden;
            animation: fadeUp 0.6s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .accent-bar {
            height: 3px;
            background: linear-gradient(90deg, var(--amber-600), var(--amber-500), var(--amber-100));
        }

        .card-body {
            padding: 32px 36px;
        }

        /* Info rows */
        .info-section {
            margin-bottom: 28px;
        }
        .info-section-title {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--slate-500);
            margin-bottom: 14px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--slate-100);
        }
        .info-row {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid var(--slate-100);
        }
        .info-row:last-child { border-bottom: none; }
        .info-label {
            width: 80px;
            font-size: 13px;
            color: var(--slate-500);
            flex-shrink: 0;
        }
        .info-value {
            font-size: 14px;
            font-weight: 500;
            color: var(--slate-900);
            flex: 1;
        }
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

        /* Form */
        .form-section {
            padding-top: 8px;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-group {
            margin-bottom: 16px;
        }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--slate-700);
            margin-bottom: 8px;
        }
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 14px;
            border: 1.5px solid var(--slate-100);
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            color: var(--slate-900);
            background: var(--surface);
            transition: all 0.2s;
            appearance: none;
        }
        .form-group input::placeholder { color: var(--slate-300); }
        .form-group input:hover,
        .form-group select:hover { border-color: var(--slate-300); }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--amber-500);
            box-shadow: 0 0 0 3px var(--amber-100);
        }
        .form-group input:read-only {
            background: var(--slate-100);
            color: var(--slate-500);
            cursor: not-allowed;
        }

        .input-wrapper {
            position: relative;
        }
        .input-wrapper svg {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            width: 16px; height: 16px;
            fill: none;
            stroke: var(--slate-500);
            stroke-width: 1.5;
            stroke-linecap: round;
            stroke-linejoin: round;
            transition: stroke 0.2s;
        }
        .input-wrapper input {
            padding-left: 38px;
        }
        .input-wrapper:focus-within svg {
            stroke: var(--amber-500);
        }

        .input-match-error {
            font-size: 12px;
            color: var(--red-500);
            margin-top: 6px;
            display: none;
            align-items: center;
            gap: 4px;
        }
        .input-match-error.show { display: flex; }
        .input-match-error svg {
            width: 13px; height: 13px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
            flex-shrink: 0;
        }
        .input-wrapper.error-state input {
            border-color: var(--red-500);
        }
        .input-wrapper.error-state input:focus {
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.15);
        }

        .btn-row {
            display: flex;
            gap: 12px;
            margin-top: 24px;
        }
        .btn {
            flex: 1;
            padding: 13px 20px;
            border: none;
            border-radius: 6px;
            font-family: inherit;
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-primary {
            background: var(--slate-900);
            color: #fff;
            position: relative;
            overflow: hidden;
        }
        .btn-primary::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--amber-600), var(--amber-500));
            opacity: 0;
            transition: opacity 0.3s;
        }
        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(26, 29, 35, 0.15);
        }
        .btn-primary:hover::before { opacity: 1; }
        .btn-primary span { position: relative; z-index: 1; }

        .btn-danger {
            background: var(--red-100);
            color: var(--red-500);
            border: 1.5px solid #fecaca;
        }
        .btn-danger:hover {
            background: var(--red-500);
            color: #fff;
            border-color: var(--red-500);
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

        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
            animation: fadeUp 0.4s ease;
        }
        .alert-error {
            background: var(--red-100);
            border: 1px solid #fecaca;
            color: var(--red-500);
        }
        .alert-warning {
            background: var(--amber-100);
            border: 1px solid #fde68a;
            color: var(--amber-600);
        }
    </style>
</head>
<body>
    <%
        User user = (User) request.getAttribute("user");
        boolean isAdmin = user != null && "admin".equals(user.getRole());
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
            <a href="${pageContext.request.contextPath}/content.jsp" class="back-link">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                返回主页
            </a>
        </div>
    </header>

    <main class="main">
        <div class="page-header">
            <div class="page-eyebrow">Profile</div>
            <h2 class="page-title">个人信息</h2>
        </div>

        <div class="card">
            <div class="accent-bar"></div>
            <div class="card-body">
                <% if ("1".equals(request.getParameter("success"))) { %>
                <div class="success-msg">更新成功！</div>
                <% } else if ("passwordShort".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error">密码长度不能少于6位！</div>
                <% } else if ("passwordMismatch".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error">两次密码输入不一致！</div>
                <% } else if ("updateFailed".equals(request.getParameter("error"))) { %>
                <div class="alert alert-error">更新失败，请重试！</div>
                <% } %>

                <% if (user != null) { %>

                <div class="info-section">
                    <div class="info-section-title">账号信息</div>
                    <div class="info-row">
                        <span class="info-label">用户ID</span>
                        <span class="info-value"><%= user.getUserId() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">角色</span>
                        <span class="info-value">
                            <span class="role-tag <%= isAdmin ? "role-admin" : "role-user" %>">
                                <%= isAdmin ? "管理员" : "普通用户" %>
                            </span>
                        </span>
                    </div>
                </div>

                <div class="form-section">
                    <div class="info-section-title">修改信息</div>
                    <form method="post" action="${pageContext.request.contextPath}/userManage" id="updateForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                        <input type="hidden" name="role" value="<%= user.getRole() %>">

                        <div class="form-grid">
                            <div class="form-group">
                                <label for="newUserName">用户名</label>
                                <div class="input-wrapper">
                                    <input type="text" id="newUserName" name="newUserName" value="<%= user.getUserName() %>" placeholder="请输入用户名" required>
                                    <svg viewBox="0 0 24 24">
                                        <circle cx="12" cy="8" r="4"/>
                                        <path d="M4 20c0-4 4-6 8-6s8 2 8 6"/>
                                    </svg>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="sex">性别</label>
                                <select id="sex" name="sex">
                                    <option value="M" <%= "M".equals(user.getSex()) ? "selected" : "" %>>男</option>
                                    <option value="F" <%= "F".equals(user.getSex()) ? "selected" : "" %>>女</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">邮箱</label>
                            <div class="input-wrapper">
                                <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" placeholder="your@email.com">
                                <svg viewBox="0 0 24 24">
                                    <rect x="2" y="4" width="20" height="16" rx="2"/>
                                    <path d="M2 7l10 7 10-7"/>
                                </svg>
                            </div>
                        </div>

                        <div class="info-section-title" style="margin-top:8px;">修改密码 <span style="font-weight:400;text-transform:none;letter-spacing:0; font-size:11px;color:var(--slate-300);">（不修改请留空）</span></div>

                        <div class="form-group">
                            <label for="newPassword">新密码</label>
                            <div class="input-wrapper">
                                <input type="password" id="newPassword" name="newPassword" placeholder="请输入新密码（至少6位）" autocomplete="new-password">
                                <svg viewBox="0 0 24 24">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword">确认密码</label>
                            <div class="input-wrapper" id="confirmWrapper">
                                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="请再次输入新密码" autocomplete="new-password" oninput="checkPasswordMatch()">
                                <svg viewBox="0 0 24 24">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                    <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                    <circle cx="12" cy="16" r="1" fill="currentColor"/>
                                </svg>
                            </div>
                            <div class="input-match-error" id="matchError">
                                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                                两次密码输入不一致
                            </div>
                        </div>

                        <div class="btn-row">
                            <button type="submit" class="btn btn-primary"><span>保存修改</span></button>
                            <button type="button" class="btn btn-danger" onclick="confirmDelete()">删除账户</button>
                        </div>
                    </form>
                </div>

                <% } else { %>
                <p style="text-align:center;padding:40px 0;color:var(--slate-500);font-size:14px;">
                    未找到用户信息，请先 <a href="${pageContext.request.contextPath}/userlogin.jsp" style="color:var(--amber-600);font-weight:600;">登录</a>
                </p>
                <% } %>
            </div>
        </div>
    </main>

    <% if (user != null) { %>
    <form id="deleteForm" method="post" style="display:none;">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
    </form>
    <script>
        function checkPasswordMatch() {
            var pwd = document.getElementById('newPassword').value;
            var confirmPwd = document.getElementById('confirmPassword').value;
            var wrapper = document.getElementById('confirmWrapper');
            var errorEl = document.getElementById('matchError');
            if (confirmPwd.length === 0) {
                wrapper.classList.remove('error-state');
                errorEl.classList.remove('show');
                return;
            }
            if (pwd !== confirmPwd) {
                wrapper.classList.add('error-state');
                errorEl.classList.add('show');
            } else {
                wrapper.classList.remove('error-state');
                errorEl.classList.remove('show');
            }
        }

        function confirmDelete() {
            if (confirm('确定删除您的账户？此操作不可恢复。')) {
                document.getElementById('deleteForm').submit();
            }
        }

        document.getElementById('updateForm').addEventListener('submit', function(e) {
            var pwd = document.getElementById('newPassword').value;
            var confirmPwd = document.getElementById('confirmPassword').value;
            if (pwd !== confirmPwd) {
                e.preventDefault();
                document.getElementById('confirmWrapper').classList.add('error-state');
                document.getElementById('matchError').classList.add('show');
            }
        });
    </script>
    <% } %>
</body>
</html>
