<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.ExamRecord" %>
<%@ page import="com.xinghe.onlineexam.entity.Question" %>
<%@ page import="com.xinghe.onlineexam.entity.ExamAnswer" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>考试成绩</title>
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
            font-size: 20px;
            font-weight: 600;
            color: var(--slate-900);
        }
        .topbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .back-list-link {
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
        .back-list-link:hover {
            border-color: var(--slate-700);
            color: var(--slate-900);
        }
        .back-list-link svg {
            width: 14px; height: 14px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
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
            max-width: 780px;
            margin: 0 auto;
            padding: 56px 24px 64px;
        }

        .page-header {
            margin-bottom: 32px;
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

        .score-card {
            background: var(--surface);
            border-radius: 4px;
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 4px 8px rgba(26, 29, 35, 0.04),
                0 12px 32px rgba(26, 29, 35, 0.05);
            overflow: hidden;
            margin-bottom: 28px;
            animation: fadeUp 0.6s 0.2s cubic-bezier(0.16, 1, 0.3, 1) both;
        }
        .accent-bar {
            height: 4px;
            background: linear-gradient(90deg, var(--green-500), #4ade80, var(--green-100));
        }
        .score-body {
            padding: 36px 40px;
            text-align: center;
        }
        .score-big {
            font-family: 'Cormorant Garamond', Georgia, serif;
            font-size: 72px;
            font-weight: 600;
            color: var(--slate-900);
            line-height: 1;
            margin-bottom: 8px;
        }
        .score-total {
            font-size: 18px;
            color: var(--slate-500);
            margin-bottom: 24px;
        }
        .score-stats {
            display: flex;
            justify-content: center;
            gap: 32px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--slate-900);
        }
        .stat-label {
            font-size: 12px;
            color: var(--slate-500);
            margin-top: 2px;
        }
        .stat-correct .stat-value { color: var(--green-500); }
        .stat-wrong .stat-value { color: var(--red-500); }

        .btn-row {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 28px;
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

        /* Review section */
        .review-header {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--slate-500);
            margin-bottom: 16px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--slate-100);
            animation: fadeUp 0.5s 0.3s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .question-card {
            background: var(--surface);
            border-radius: 4px;
            box-shadow:
                0 1px 2px rgba(26, 29, 35, 0.04),
                0 4px 8px rgba(26, 29, 35, 0.04);
            overflow: hidden;
            margin-bottom: 16px;
            animation: fadeUp 0.5s cubic-bezier(0.16, 1, 0.3, 1) both;
        }

        .q-header {
            padding: 16px 20px;
            border-bottom: 1px solid var(--slate-100);
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .q-number {
            flex-shrink: 0;
            width: 26px; height: 26px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
        }
        .q-correct { background: var(--green-100); color: var(--green-500); }
        .q-wrong { background: var(--red-100); color: var(--red-500); }

        .q-title {
            font-size: 14px;
            font-weight: 500;
            color: var(--slate-900);
            line-height: 1.5;
        }

        .q-options {
            padding: 12px 20px 16px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .q-option {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            padding: 8px 12px;
            border-radius: 6px;
        }
        .q-option.correct-answer {
            background: var(--green-100);
            color: #15803d;
        }
        .q-option.wrong-answer {
            background: var(--red-100);
            color: var(--red-500);
        }
        .q-option.neutral {
            color: var(--slate-500);
        }

        .option-letter {
            width: 22px; height: 22px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            flex-shrink: 0;
            background: rgba(255,255,255,0.6);
        }
        .q-option.correct-answer .option-letter { background: var(--green-500); color: #fff; }
        .q-option.wrong-answer .option-letter { background: var(--red-500); color: #fff; }
    </style>
</head>
<body>
    <%
        ExamRecord record = (ExamRecord) request.getAttribute("examRecord");
        List<Question> questions = (List<Question>) request.getAttribute("questions");
        List<ExamAnswer> answers = (List<ExamAnswer>) request.getAttribute("answers");
    %>

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
            <a href="${pageContext.request.contextPath}/exam?action=history" class="back-list-link">
                <svg viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                返回列表
            </a>
            <a href="${pageContext.request.contextPath}/content.jsp" class="back-link">
                <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                返回主页
            </a>
        </div>
    </header>

    <main class="main">
        <div class="page-header">
            <div class="page-eyebrow">Result</div>
            <h2 class="page-title">考试成绩</h2>
        </div>

        <% if (record != null) { %>
        <div class="score-card">
            <div class="accent-bar"></div>
            <div class="score-body">
                <div class="score-big"><%= record.getScore() %></div>
                <div class="score-total">满分 <%= record.getTotalScore() %> 分</div>
                <div class="score-stats">
                    <div class="stat-item stat-correct">
                        <div class="stat-value"><%= record.getCorrectCount() %></div>
                        <div class="stat-label">正确</div>
                    </div>
                    <div class="stat-item stat-wrong">
                        <div class="stat-value"><%= record.getQuestionCount() - record.getCorrectCount() %></div>
                        <div class="stat-label">错误</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">
                            <%= record.getEndTime() != null
                                ? (record.getEndTime().getTime() - record.getStartTime().getTime()) / 60000 + "分钟"
                                : "--" %>
                        </div>
                        <div class="stat-label">用时</div>
                    </div>
                </div>
                <div class="btn-row">
                    <a href="${pageContext.request.contextPath}/exam?action=start" class="btn btn-primary">
                        <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        再考一次
                    </a>
                    <a href="${pageContext.request.contextPath}/exam?action=history" class="btn btn-secondary">
                        <svg viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                        成绩记录
                    </a>
                </div>
            </div>
        </div>
        <% } %>

        <% if (questions != null && answers != null) { %>
        <div class="review-header">题目回顾</div>
        <%
            java.util.Map<Integer, ExamAnswer> answerMap = new java.util.HashMap<>();
            for (ExamAnswer a : answers) answerMap.put(a.getQuestionId(), a);
            for (int i = 0; i < questions.size(); i++) {
                Question q = questions.get(i);
                ExamAnswer ua = answerMap.get(q.getQuestionId());
                boolean isCorrect = ua != null && ua.getIsCorrect() == 1;
                String userAns = ua != null ? ua.getUserAnswer() : null;
        %>
        <div class="question-card" style="animation-delay: <%= 0.3 + i * 0.04 %>s">
            <div class="q-header">
                <div class="q-number <%= isCorrect ? "q-correct" : "q-wrong" %>">
                    <%= isCorrect ? "✓" : "✗" %>
                </div>
                <div class="q-title"><%= (i+1) %>. <%= q.getTitle() %></div>
            </div>
            <div class="q-options">
                <% for (char opt : new char[]{'A','B','C','D'}) {
                    String optText = "A".equals(String.valueOf(opt)) ? q.getOptionA()
                                : "B".equals(String.valueOf(opt)) ? q.getOptionB()
                                : "C".equals(String.valueOf(opt)) ? q.getOptionC()
                                : q.getOptionD();
                    boolean isCorrectOpt = opt == q.getAnswer();
                    boolean isUserWrong = !isCorrect && String.valueOf(opt).equals(userAns);
                %>
                <div class="q-option <%= isCorrectOpt ? "correct-answer" : (isUserWrong ? "wrong-answer" : "neutral") %>">
                    <div class="option-letter"><%= opt %></div>
                    <span><%= optText %></span>
                    <% if (isCorrectOpt) { %> <span style="margin-left:auto;font-size:12px;font-weight:600;">正确答案</span> <% } %>
                    <% if (isUserWrong) { %> <span style="margin-left:auto;font-size:12px;font-weight:600;">您的答案</span> <% } %>
                </div>
                <% } %>
            </div>
        </div>
        <% }} %>
    </main>
</body>
</html>
