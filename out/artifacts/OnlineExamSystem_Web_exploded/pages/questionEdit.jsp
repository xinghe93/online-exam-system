<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.Question" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>编辑试题</title>
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

        .main {
            position: relative;
            z-index: 1;
            max-width: 680px;
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
        .question-id {
            font-family: 'Plus Jakarta Sans', sans-serif;
            font-size: 14px;
            font-weight: 500;
            color: var(--slate-500);
            margin-left: 8px;
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
            background: linear-gradient(90deg, var(--orange-500), var(--amber-500), var(--amber-100));
        }
        .card-body {
            padding: 36px 40px;
        }

        .form-section-title {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--slate-500);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--slate-100);
        }

        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 0.04em;
            color: var(--slate-700);
            margin-bottom: 8px;
        }
        .form-group label .required {
            color: var(--red-500);
            margin-left: 2px;
        }

        .form-group input,
        .form-group textarea,
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
        .form-group textarea {
            resize: vertical;
            min-height: 90px;
            line-height: 1.5;
        }
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--amber-500);
            box-shadow: 0 0 0 3px var(--amber-100);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder { color: var(--slate-300); }
        .form-group input:hover,
        .form-group textarea:hover,
        .form-group select:hover { border-color: var(--slate-300); }

        .options-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }
        .option-input {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .option-letter {
            width: 32px; height: 32px;
            background: var(--slate-100);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 700;
            color: var(--slate-700);
            flex-shrink: 0;
        }
        .option-letter input { display: none; }
        .option-input input[type="text"] {
            flex: 1;
            padding: 10px 12px;
        }

        .answer-select {
            display: flex;
            gap: 10px;
        }
        .answer-option {
            flex: 1;
            padding: 12px;
            border: 1.5px solid var(--slate-100);
            border-radius: 6px;
            text-align: center;
            font-size: 14px;
            font-weight: 600;
            color: var(--slate-500);
            cursor: pointer;
            transition: all 0.15s;
        }
        .answer-option:hover {
            border-color: var(--slate-300);
            color: var(--slate-700);
        }
        .answer-option.selected {
            border-color: var(--amber-500);
            background: var(--amber-100);
            color: var(--amber-600);
        }
        .answer-option input { display: none; }

        .form-tip {
            font-size: 12px;
            color: var(--slate-500);
            margin-top: 6px;
        }

        .btn-row {
            display: flex;
            gap: 12px;
            margin-top: 28px;
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
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-submit {
            background: var(--orange-500);
            color: #fff;
        }
        .btn-submit:hover {
            background: #ea580c;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
        }
        .btn-back {
            background: var(--surface);
            color: var(--slate-500);
            border: 1.5px solid var(--slate-300);
        }
        .btn-back:hover {
            border-color: var(--slate-700);
            color: var(--slate-900);
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
    </style>
</head>
<body>
    <%
        Question question = (Question) request.getAttribute("question");
        if (question == null) {
            response.sendRedirect(request.getContextPath() + "/questionManage?action=list");
            return;
        }

        String error = request.getParameter("error");
        String currentAnswer = String.valueOf(question.getAnswer());
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
            <div class="page-eyebrow">Question Bank</div>
            <h2 class="page-title">编辑试题<span class="question-id">#<%= question.getQuestionId() %></span></h2>
        </div>

        <% if ("empty".equals(error)) { %>
            <div class="alert alert-error">请填写所有必填项！</div>
        <% } else if ("invalidAnswer".equals(error)) { %>
            <div class="alert alert-error">答案必须是 A、B、C 或 D！</div>
        <% } else if ("updateFailed".equals(error)) { %>
            <div class="alert alert-error">更新失败！</div>
        <% } %>

        <div class="card">
            <div class="accent-bar"></div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/questionManage" method="post" id="questionForm">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="questionId" value="<%= question.getQuestionId() %>">

                    <div class="form-section-title">题目内容</div>

                    <div class="form-group">
                        <label>题目描述 <span class="required">*</span></label>
                        <textarea name="title" required><%= question.getTitle() %></textarea>
                    </div>

                    <div class="form-section-title" style="margin-top:24px;">选项</div>

                    <div class="options-grid">
                        <div class="option-input">
                            <div class="option-letter">A</div>
                            <input type="text" name="optionA" value="<%= question.getOptionA() %>" required>
                        </div>
                        <div class="option-input">
                            <div class="option-letter">B</div>
                            <input type="text" name="optionB" value="<%= question.getOptionB() %>" required>
                        </div>
                        <div class="option-input">
                            <div class="option-letter">C</div>
                            <input type="text" name="optionC" value="<%= question.getOptionC() %>" required>
                        </div>
                        <div class="option-input">
                            <div class="option-letter">D</div>
                            <input type="text" name="optionD" value="<%= question.getOptionD() %>" required>
                        </div>
                    </div>

                    <div class="form-section-title" style="margin-top:24px;">正确答案</div>

                    <div class="answer-select">
                        <label class="answer-option <%= "A".equals(currentAnswer) ? "selected" : "" %>" onclick="selectAnswer('A')">
                            <input type="radio" name="answer" value="A" id="ansA" <%= "A".equals(currentAnswer) ? "checked" : "" %>>
                            <span>A</span>
                        </label>
                        <label class="answer-option <%= "B".equals(currentAnswer) ? "selected" : "" %>" onclick="selectAnswer('B')">
                            <input type="radio" name="answer" value="B" id="ansB" <%= "B".equals(currentAnswer) ? "checked" : "" %>>
                            <span>B</span>
                        </label>
                        <label class="answer-option <%= "C".equals(currentAnswer) ? "selected" : "" %>" onclick="selectAnswer('C')">
                            <input type="radio" name="answer" value="C" id="ansC" <%= "C".equals(currentAnswer) ? "checked" : "" %>>
                            <span>C</span>
                        </label>
                        <label class="answer-option <%= "D".equals(currentAnswer) ? "selected" : "" %>" onclick="selectAnswer('D')">
                            <input type="radio" name="answer" value="D" id="ansD" <%= "D".equals(currentAnswer) ? "checked" : "" %>>
                            <span>D</span>
                        </label>
                    </div>
                    <p class="form-tip">选择正确答案对应的选项</p>

                    <div class="btn-row">
                        <button type="submit" class="btn btn-submit">保存修改</button>
                        <a href="${pageContext.request.contextPath}/questionManage?action=list" class="btn btn-back">取消</a>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        function selectAnswer(val) {
            document.querySelectorAll('.answer-option').forEach(el => el.classList.remove('selected'));
            document.getElementById('ans' + val).checked = true;
            document.getElementById('ans' + val).parentElement.classList.add('selected');
        }
        document.querySelector('form').addEventListener('submit', function(e) {
            var answer = document.querySelector('input[name="answer"]:checked');
            if (!answer) {
                alert('请选择正确答案');
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
