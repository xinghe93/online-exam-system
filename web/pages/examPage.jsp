<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.ExamRecord" %>
<%@ page import="com.xinghe.onlineexam.entity.Question" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>在线考试</title>
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
            background: var(--purple-500);
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

        .timer-box {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 20px;
            background: var(--slate-100);
            border-radius: 100px;
            font-size: 16px;
            font-weight: 700;
            font-variant-numeric: tabular-nums;
            color: var(--slate-900);
        }
        .timer-box svg {
            width: 16px; height: 16px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        .timer-box.warning {
            background: var(--red-100);
            color: var(--red-500);
        }
        .timer-box.warning svg { stroke: var(--red-500); }

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
            max-width: 780px;
            margin: 0 auto;
            padding: 40px 24px 64px;
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
            color: var(--purple-500);
            margin-bottom: 6px;
        }
        .page-title {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 28px;
            font-weight: 600;
            color: var(--slate-900);
        }

        .exam-info-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 28px;
            animation: fadeUp 0.6s 0.15s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        .info-chip {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            background: var(--surface);
            border-radius: 100px;
            font-size: 13px;
            font-weight: 500;
            color: var(--slate-700);
            box-shadow: 0 1px 2px rgba(26, 29, 35, 0.06);
        }
        .info-chip svg {
            width: 14px; height: 14px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .question-card {
            background: var(--surface);
            border-radius: 4px;
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 4px 8px rgba(26, 29, 35, 0.04),
                0 12px 32px rgba(26, 29, 35, 0.05);
            overflow: hidden;
            margin-bottom: 20px;
            animation: fadeUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .q-header {
            padding: 18px 24px;
            border-bottom: 1px solid var(--slate-100);
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .q-number {
            flex-shrink: 0;
            width: 28px; height: 28px;
            background: var(--purple-100);
            color: var(--purple-500);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            font-weight: 700;
        }

        .q-title {
            font-size: 15px;
            font-weight: 500;
            color: var(--slate-900);
            line-height: 1.5;
        }

        .q-options {
            padding: 16px 24px 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .q-option {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border: 1.5px solid var(--slate-100);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.15s;
            font-size: 14px;
            color: var(--slate-700);
        }
        .q-option:hover {
            border-color: var(--purple-500);
            background: var(--purple-100);
        }
        .q-option.selected {
            border-color: var(--purple-500);
            background: var(--purple-100);
            color: var(--purple-500);
        }
        .q-option input { display: none; }

        .option-letter {
            width: 24px; height: 24px;
            border-radius: 50%;
            border: 1.5px solid var(--slate-300);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
            flex-shrink: 0;
            transition: all 0.15s;
        }
        .q-option.selected .option-letter {
            background: var(--purple-500);
            border-color: var(--purple-500);
            color: #fff;
        }

        .submit-row {
            margin-top: 32px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            animation: fadeUp 0.5s 0.3s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .btn {
            padding: 13px 28px;
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
            gap: 8px;
            border: none;
        }
        .btn-primary {
            background: var(--purple-500);
            color: #fff;
        }
        .btn-primary:hover {
            background: #7c3aed;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
        }
        .btn-secondary {
            background: var(--surface);
            color: var(--slate-500);
            border: 1.5px solid var(--slate-300);
        }
        .btn-secondary:hover {
            border-color: var(--slate-700);
            color: var(--slate-900);
        }
        .btn svg {
            width: 14px; height: 14px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
    </style>
</head>
<body>
    <%
        ExamRecord record = (ExamRecord) request.getAttribute("examRecord");
        List<Question> questions = record != null ? record.getQuestions() : null;
        List<String> userAnswers = record != null ? record.getUserAnswers() : null;
        int remainingSeconds = request.getAttribute("remainingSeconds") != null
            ? (int) request.getAttribute("remainingSeconds")
            : 30 * 60;
    %>

    <header class="topbar">
        <div class="topbar-brand">
            <div class="topbar-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                </svg>
            </div>
            <h1>在线考试</h1>
        </div>
        <div class="timer-box" id="timerBox">
            <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
            <span id="timerDisplay">--:--</span>
        </div>
        <div class="topbar-right">
            <a href="${pageContext.request.contextPath}/content.jsp" class="back-link">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                退出考试
            </a>
        </div>
    </header>

    <main class="main">
        <div class="page-header">
            <div class="page-eyebrow">Examination</div>
            <h2 class="page-title">考试进行中</h2>
        </div>

        <div class="exam-info-bar">
            <div class="info-chip">
                <svg viewBox="0 0 24 24"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                共 <%= record != null ? record.getQuestionCount() : 0 %> 题
            </div>
            <div class="info-chip">
                <svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                限时 <%= record != null ? record.getTimeLimit() : 30 %> 分钟
            </div>
            <div class="info-chip">
                <svg viewBox="0 0 24 24"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                每题 1 分
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/exam?action=submit" method="post" id="examForm">
            <input type="hidden" name="action" value="submit">
            <input type="hidden" name="examId" value="<%= record != null ? record.getExamId() : 0 %>">

            <%
                if (questions != null) {
                    for (int i = 0; i < questions.size(); i++) {
                        Question q = questions.get(i);
                        String savedAnswer = (userAnswers != null && i < userAnswers.size()) ? userAnswers.get(i) : "";
            %>
            <div class="question-card" style="animation-delay: <%= 0.15 + i * 0.05 %>s">
                <div class="q-header">
                    <div class="q-number"><%= i + 1 %></div>
                    <div class="q-title"><%= q.getTitle() %></div>
                </div>
                <div class="q-options">
                    <% for (char opt : new char[]{'A','B','C','D'}) {
                        String fieldName = "q_" + q.getQuestionId();
                        String optKey = "option" + opt;
                        String optText = null;
                        if ("A".equals(String.valueOf(opt))) optText = q.getOptionA();
                        else if ("B".equals(String.valueOf(opt))) optText = q.getOptionB();
                        else if ("C".equals(String.valueOf(opt))) optText = q.getOptionC();
                        else if ("D".equals(String.valueOf(opt))) optText = q.getOptionD();
                        boolean isSelected = savedAnswer.equals(String.valueOf(opt));
                    %>
                    <label class="q-option <%= isSelected ? "selected" : "" %>" onclick="selectOption(this, '<%= fieldName %>')">
                        <input type="radio" name="<%= fieldName %>" value="<%= opt %>" <%= isSelected ? "checked" : "" %>>
                        <div class="option-letter"><%= opt %></div>
                        <span><%= optText %></span>
                    </label>
                    <% } %>
                </div>
            </div>
            <% }} %>

            <div class="submit-row">
                <button type="submit" class="btn btn-primary">
                    <svg viewBox="0 0 24 24"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                    <span>提交试卷</span>
                </button>
            </div>
        </form>
    </main>

    <script>
        let remaining = <%= remainingSeconds %>;
        const timerBox = document.getElementById('timerBox');
        const timerDisplay = document.getElementById('timerDisplay');
        const WARNING_THRESHOLD = 300; // 5分钟

        function updateTimer() {
            if (remaining < 0) remaining = 0;
            const minutes = Math.floor(remaining / 60);
            const seconds = remaining % 60;
            timerDisplay.textContent = String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');

            if (remaining <= WARNING_THRESHOLD) {
                timerBox.classList.add('warning');
            }

            if (remaining === 0) {
                document.getElementById('examForm').submit();
                return;
            }
            remaining--;
            setTimeout(updateTimer, 1000);
        }

        updateTimer();

        function selectOption(label, fieldName) {
            label.closest('.q-options').querySelectorAll('.q-option').forEach(el => el.classList.remove('selected'));
            label.classList.add('selected');
            label.querySelector('input').checked = true;
        }

        document.getElementById('examForm').addEventListener('submit', function(e) {
            if (!confirm('确定要提交试卷吗？提交后无法修改答案。')) {
                e.preventDefault();
            }
        });

        window.addEventListener('beforeunload', function(e) {
            if (remaining > 0) {
                e.preventDefault();
                e.returnValue = '考试尚未提交，您确定要离开吗？';
            }
        });
    </script>
</body>
</html>
