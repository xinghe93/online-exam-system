<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>登录 - 在线考试系统</title>
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
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            position: relative;
        }

        /* Subtle paper texture overlay */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
            opacity: 0.025;
            pointer-events: none;
            z-index: 0;
        }

        /* Decorative geometric elements */
        .deco-circle {
            position: fixed;
            border-radius: 50%;
            border: 1px solid var(--slate-300);
            opacity: 0.4;
            pointer-events: none;
        }
        .deco-circle-1 {
            width: 600px;
            height: 600px;
            top: -200px;
            right: -200px;
        }
        .deco-circle-2 {
            width: 400px;
            height: 400px;
            bottom: -100px;
            left: -100px;
        }

        .deco-line {
            position: fixed;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--slate-300), transparent);
            opacity: 0.5;
            pointer-events: none;
        }
        .deco-line-1 {
            width: 300px;
            top: 30%;
            left: 5%;
            transform: rotate(-30deg);
        }
        .deco-line-2 {
            width: 200px;
            bottom: 25%;
            right: 8%;
            transform: rotate(15deg);
        }

        /* Main card */
        .login-card {
            position: relative;
            z-index: 1;
            background: var(--surface);
            width: 100%;
            max-width: 420px;
            border-radius: 4px;
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 4px 8px rgba(26, 29, 35, 0.04),
                0 16px 40px rgba(26, 29, 35, 0.06);
            overflow: hidden;
            animation: cardEntrance 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            opacity: 0;
            transform: translateY(24px);
        }

        @keyframes cardEntrance {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Top accent bar */
        .accent-bar {
            height: 3px;
            background: linear-gradient(90deg, var(--amber-600), var(--amber-500), var(--amber-100));
        }

        .card-body {
            padding: 48px 44px 44px;
        }

        /* Logo / Title area */
        .brand {
            text-align: center;
            margin-bottom: 40px;
        }

        .brand-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 48px;
            height: 48px;
            background: var(--slate-900);
            border-radius: 12px;
            margin-bottom: 20px;
            animation: iconEntrance 0.6s 0.2s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            opacity: 0;
            transform: scale(0.8);
        }

        @keyframes iconEntrance {
            to {
                opacity: 1;
                transform: scale(1);
            }
        }

        .brand-icon svg {
            width: 24px;
            height: 24px;
            fill: none;
            stroke: white;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .brand h1 {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 28px;
            font-weight: 600;
            color: var(--slate-900);
            letter-spacing: 0.02em;
            margin-bottom: 6px;
        }

        .brand p {
            font-size: 13px;
            color: var(--slate-500);
            letter-spacing: 0.12em;
            text-transform: uppercase;
        }

        /* Form */
        .form-group {
            margin-bottom: 24px;
            opacity: 0;
            animation: fieldEntrance 0.5s 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .form-group:nth-child(2) {
            animation-delay: 0.4s;
        }

        @keyframes fieldEntrance {
            to {
                opacity: 1;
            }
        }

        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: var(--slate-700);
            letter-spacing: 0.06em;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper svg {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            width: 18px;
            height: 18px;
            fill: none;
            stroke: var(--slate-500);
            stroke-width: 1.5;
            stroke-linecap: round;
            stroke-linejoin: round;
            transition: stroke 0.2s;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px 14px 44px;
            border: 1.5px solid var(--slate-100);
            border-radius: 6px;
            font-family: inherit;
            font-size: 15px;
            color: var(--slate-900);
            background: var(--surface);
            transition: all 0.2s;
        }

        .form-group input::placeholder {
            color: var(--slate-300);
        }

        .form-group input:hover {
            border-color: var(--slate-300);
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--amber-500);
            box-shadow: 0 0 0 3px var(--amber-100);
        }

        .form-group input:focus + svg,
        .input-wrapper:focus-within svg {
            stroke: var(--amber-500);
        }

        /* Submit button */
        .btn {
            width: 100%;
            padding: 15px 24px;
            background: var(--slate-900);
            color: #fff;
            border: none;
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 8px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, var(--amber-600), var(--amber-500));
            opacity: 0;
            transition: opacity 0.3s;
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(26, 29, 35, 0.15);
        }

        .btn:hover::before {
            opacity: 1;
        }

        .btn span {
            position: relative;
            z-index: 1;
        }

        .btn:active {
            transform: translateY(0);
        }

        /* Footer link */
        .card-footer {
            text-align: center;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid var(--slate-100);
            font-size: 13px;
            color: var(--slate-500);
            opacity: 0;
            animation: fieldEntrance 0.5s 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        .card-footer a {
            color: var(--amber-600);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .card-footer a:hover {
            color: var(--amber-500);
        }

        /* Error state */
        .error-msg {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: var(--red-500);
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 24px;
            display: none;
            animation: shake 0.4s ease;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-6px); }
            40%, 80% { transform: translateX(6px); }
        }

        .error-msg.show {
            display: block;
        }

        /* Floating label effect - nothing needed extra since we use uppercase labels above */
    </style>
</head>
<body>
    <!-- Decorative elements -->
    <div class="deco-circle deco-circle-1"></div>
    <div class="deco-circle deco-circle-2"></div>
    <div class="deco-line deco-line-1"></div>
    <div class="deco-line deco-line-2"></div>

    <div class="login-card">
        <div class="accent-bar"></div>
        <div class="card-body">
            <div class="brand">
                <div class="brand-icon">
                    <svg viewBox="0 0 24 24">
                        <path d="M12 2L2 7l10 5 10-5-10-5z"/>
                        <path d="M2 17l10 5 10-5"/>
                        <path d="M2 12l10 5 10-5"/>
                    </svg>
                </div>
                <h1>在线考试系统</h1>
                <p>Examination System</p>
            </div>

            <% if (request.getAttribute("err") != null) { %>
            <div class="error-msg show"><%= request.getAttribute("err") %></div>
            <% } %>

            <form action="<%=request.getContextPath()%>/login" method="post" id="loginForm">
                <div class="form-group">
                    <label for="username">用户名</label>
                    <div class="input-wrapper">
                        <input type="text" id="username" name="username" placeholder="请输入用户名" autocomplete="username" required>
                        <svg viewBox="0 0 24 24">
                            <circle cx="12" cy="8" r="4"/>
                            <path d="M4 20c0-4 4-6 8-6s8 2 8 6"/>
                        </svg>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">密码</label>
                    <div class="input-wrapper">
                        <input type="password" id="password" name="password" placeholder="请输入密码" autocomplete="current-password" required>
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                    </div>
                </div>

                <button type="submit" class="btn"><span>登 录</span></button>
            </form>

            <div class="card-footer">
                还没有账号？<a href="<%=request.getContextPath()%>/register.jsp">立即注册</a>
            </div>
        </div>
    </div>
</body>
</html>
