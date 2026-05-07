<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>注册 - 在线考试系统</title>
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
            scrollbar-width: none;
            -ms-overflow-style: none;
        }
        html::-webkit-scrollbar {
            display: none;
        }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, sans-serif;
            background: var(--bg);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            position: relative;
            overflow-x: hidden;
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

        .deco-circle {
            position: fixed;
            border-radius: 50%;
            border: 1px solid var(--slate-300);
            opacity: 0.4;
            pointer-events: none;
        }
        .deco-circle-1 {
            width: 600px; height: 600px;
            top: -200px; right: -200px;
        }
        .deco-circle-2 {
            width: 400px; height: 400px;
            bottom: -100px; left: -100px;
        }

        .deco-dots {
            position: fixed;
            top: 20%;
            left: 8%;
            display: grid;
            grid-template-columns: repeat(3, 6px);
            gap: 8px;
            opacity: 0.25;
        }
        .deco-dots span {
            width: 6px; height: 6px;
            background: var(--slate-500);
            border-radius: 50%;
        }

        .register-card {
            position: relative;
            z-index: 1;
            background: var(--surface);
            width: 100%;
            max-width: 440px;
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
            to { opacity: 1; transform: translateY(0); }
        }

        .accent-bar {
            height: 3px;
            background: linear-gradient(90deg, var(--amber-600), var(--amber-500), var(--amber-100));
        }

        .card-body {
            padding: 44px 44px 40px;
        }

        .brand {
            text-align: center;
            margin-bottom: 36px;
        }

        .brand-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 44px;
            height: 44px;
            background: var(--slate-900);
            border-radius: 10px;
            margin-bottom: 16px;
            animation: iconEntrance 0.6s 0.15s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            opacity: 0;
            transform: scale(0.8);
        }

        @keyframes iconEntrance {
            to { opacity: 1; transform: scale(1); }
        }

        .brand-icon svg {
            width: 22px; height: 22px;
            fill: none;
            stroke: white;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .brand h1 {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 26px;
            font-weight: 600;
            color: var(--slate-900);
            letter-spacing: 0.02em;
            margin-bottom: 4px;
        }

        .brand p {
            font-size: 12px;
            color: var(--slate-500);
            letter-spacing: 0.12em;
            text-transform: uppercase;
        }

        .form-group {
            margin-bottom: 20px;
            opacity: 0;
            animation: fieldEntrance 0.5s 0.25s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
        .form-group:nth-child(2) { animation-delay: 0.32s; }
        .form-group:nth-child(3) { animation-delay: 0.39s; }
        .form-group:nth-child(4) { animation-delay: 0.46s; }
        .form-group:nth-child(5) { animation-delay: 0.53s; }

        @keyframes fieldEntrance {
            to { opacity: 1; }
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .form-group label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: var(--slate-700);
            letter-spacing: 0.06em;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .form-group {
            width: 100%;
        }

        .sex-selector {
            display: flex;
            gap: 12px;
        }

        .sex-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 11px 20px;
            border: 1.5px solid var(--slate-100);
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            background: var(--surface);
        }

        .sex-btn input[type="radio"] {
            display: none;
        }

        .sex-icon {
            font-size: 16px;
            color: var(--slate-500);
        }

        .sex-label {
            font-size: 14px;
            font-weight: 500;
            color: var(--slate-700);
        }

        .sex-btn:hover {
            border-color: var(--amber-400);
        }

        .sex-btn input[type="radio"]:checked + .sex-icon {
            color: var(--amber-500);
        }

        .sex-btn input[type="radio"]:checked ~ .sex-label {
            color: var(--amber-600);
        }

        .sex-btn:has(input[type="radio"]:checked) {
            border-color: var(--amber-500);
            background: var(--amber-100);
        }

        .sex-error {
            display: none;
            font-size: 12px;
            color: var(--red-500);
            margin-top: 6px;
        }

        .sex-error.show {
            display: block;
        }

        .input-wrapper {
            position: relative;
            width: 100%;
        }

        .input-wrapper svg {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            width: 17px; height: 17px;
            fill: none;
            stroke: var(--slate-500);
            stroke-width: 1.5;
            stroke-linecap: round;
            stroke-linejoin: round;
            transition: stroke 0.2s;
        }

        .input-wrapper input,
        .input-wrapper select {
            width: 100%;
            min-width: 200px;
            padding: 13px 16px 13px 42px;
            border: 1.5px solid var(--slate-100);
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            color: var(--slate-900);
            background: var(--surface);
            transition: all 0.2s;
            appearance: none;
        }

        .input-wrapper select {
            padding-left: 42px;
            cursor: pointer;
        }

        .input-wrapper select option {
            color: var(--slate-900);
        }

        .input-wrapper input::placeholder { color: var(--slate-300); }

        .input-wrapper input:hover,
        .input-wrapper select:hover {
            border-color: var(--slate-300);
        }

        .input-wrapper input:focus,
        .input-wrapper select:focus {
            outline: none;
            border-color: var(--amber-500);
            box-shadow: 0 0 0 3px var(--amber-100);
        }

        .input-wrapper:focus-within svg {
            stroke: var(--amber-500);
        }

        .btn {
            width: 100%;
            padding: 14px 24px;
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
            margin-top: 4px;
            position: relative;
            overflow: hidden;
            opacity: 0;
            animation: fieldEntrance 0.5s 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
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

        .btn:hover::before { opacity: 1; }
        .btn:active { transform: translateY(0); }
        .btn span { position: relative; z-index: 1; }

        .strength-bar {
            height: 3px;
            background: var(--slate-100);
            border-radius: 2px;
            margin-top: 6px;
        }
        .strength-bar div {
            height: 100%;
            width: 0;
            border-radius: 2px;
            transition: width 0.3s, background 0.3s;
        }
        .strength-weak { width: 33%; background: var(--red-500); }
        .strength-medium { width: 66%; background: #f59e0b; }
        .strength-strong { width: 100%; background: var(--green-500); }

        .card-footer {
            text-align: center;
            margin-top: 28px;
            padding-top: 20px;
            border-top: 1px solid var(--slate-100);
            font-size: 13px;
            color: var(--slate-500);
            opacity: 0;
            animation: fieldEntrance 0.5s 0.67s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }
        .card-footer a {
            color: var(--amber-600);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }
        .card-footer a:hover { color: var(--amber-500); }

        .server-error {
            background: var(--red-100);
            border: 1px solid #fecaca;
            color: var(--red-500);
            padding: 12px 16px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 20px;
            display: none;
            animation: shake 0.4s ease;
        }
        .server-error.show { display: block; }

        .input-match-error {
            font-size: 12px;
            color: var(--red-500);
            margin-top: 6px;
            height: 0;
            overflow: hidden;
            opacity: 0;
            transition: height 0.2s, opacity 0.2s;
            align-items: center;
            gap: 4px;
        }
        .input-match-error.show {
            height: 18px;
            overflow: visible;
            opacity: 1;
        }
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

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-6px); }
            40%, 80% { transform: translateX(6px); }
        }
    </style>
</head>
<body>
    <div class="deco-circle deco-circle-1"></div>
    <div class="deco-circle deco-circle-2"></div>
    <div class="deco-dots">
        <span></span><span></span><span></span>
        <span></span><span></span><span></span>
        <span></span><span></span><span></span>
    </div>

    <div class="register-card">
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
            <div class="server-error show"><%= request.getAttribute("err") %></div>
            <% } %>

            <form action="<%=request.getContextPath()%>/register" method="post" id="registerForm" onsubmit="return validateForm()">
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
                        <input type="password" id="password" name="password" placeholder="请输入密码" autocomplete="new-password" required oninput="updateStrength()">
                        <svg viewBox="0 0 24 24">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                        </svg>
                    </div>
                    <div class="strength-bar"><div id="strengthIndicator"></div></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">确认密码</label>
                    <div class="input-wrapper" id="confirmWrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="请再次输入密码" autocomplete="new-password" required oninput="checkPasswordMatch()">
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

                <div class="form-group">
                        <label>性别</label>
                        <div class="sex-selector">
                            <label class="sex-btn">
                                <input type="radio" name="sex" value="M">
                                <span class="sex-icon">♂</span>
                                <span class="sex-label">男</span>
                            </label>
                            <label class="sex-btn">
                                <input type="radio" name="sex" value="F">
                                <span class="sex-icon">♀</span>
                                <span class="sex-label">女</span>
                            </label>
                        </div>
                        <div class="sex-error" id="sexError">请选择性别</div>
                    </div>

                    <div class="form-group">
                        <label for="email">邮箱</label>
                    <div class="input-wrapper">
                        <input type="email" id="email" name="email" placeholder="your@email.com" required>
                        <svg viewBox="0 0 24 24">
                            <rect x="2" y="4" width="20" height="16" rx="2"/>
                            <path d="M2 7l10 7 10-7"/>
                        </svg>
                    </div>
                </div>

                <button type="submit" class="btn"><span>创 建 账 号</span></button>
            </form>

            <div class="card-footer">
                已有账号？<a href="<%=request.getContextPath()%>/userlogin.jsp">立即登录</a>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            var sexSelected = document.querySelector('input[name="sex"]:checked');
            var sexError = document.getElementById('sexError');
            if (!sexSelected) {
                sexError.classList.add('show');
                return false;
            }
            sexError.classList.remove('show');
            return true;
        }

        document.querySelectorAll('input[name="sex"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                document.getElementById('sexError').classList.remove('show');
            });
        });

        function checkPasswordMatch() {
            var pwd = document.getElementById('password').value;
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

        function updateStrength() {
            var pwd = document.getElementById('password').value;
            var indicator = document.getElementById('strengthIndicator');
            indicator.className = '';
            indicator.style.width = '0';
            if (pwd.length === 0) return;
            var score = 0;
            if (pwd.length >= 6) score++;
            if (pwd.length >= 10) score++;
            if (/[A-Z]/.test(pwd)) score++;
            if (/[a-z]/.test(pwd)) score++;
            if (/[0-9]/.test(pwd)) score++;
            if (/[^A-Za-z0-9]/.test(pwd)) score++;
            if (score <= 1) {
                indicator.className = 'strength-weak';
                indicator.style.width = '33%';
            } else if (score <= 3) {
                indicator.className = 'strength-medium';
                indicator.style.width = '66%';
            } else {
                indicator.className = 'strength-strong';
                indicator.style.width = '100%';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            var form = document.getElementById('registerForm');
            if (form) {
                form.addEventListener('submit', function(e) {
                    var pwd = document.getElementById('password').value;
                    var confirmPwd = document.getElementById('confirmPassword').value;
                    if (pwd.length < 6) {
                        e.preventDefault();
                        alert('密码长度不能少于6位');
                        return;
                    }
                    if (pwd !== confirmPwd) {
                        e.preventDefault();
                        document.getElementById('confirmWrapper').classList.add('error-state');
                        document.getElementById('matchError').classList.add('show');
                        return;
                    }
                });
            }
        });
    </script>
</body>
</html>
