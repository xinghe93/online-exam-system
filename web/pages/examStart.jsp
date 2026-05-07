<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.xinghe.onlineexam.entity.ExamRecord" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>开始考试</title>
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
        .topbar-brand { display: flex; align-items: center; gap: 14px; }
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
        .back-link:hover { border-color: var(--slate-700); color: var(--slate-900); }
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
            max-width: 560px;
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
            color: var(--purple-500);
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
            background: linear-gradient(90deg, var(--purple-500), var(--amber-500), var(--amber-100));
        }
        .card-body {
            padding: 32px 36px;
        }

        /* Last exam summary */
        .last-exam {
            margin-bottom: 24px;
        }
        .last-exam-label {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--slate-500);
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--slate-100);
        }
        .last-exam-row {
            display: flex;
            align-items: center;
            padding: 8px 0;
            font-size: 14px;
        }
        .last-exam-row .label {
            width: 70px;
            color: var(--slate-500);
        }
        .last-exam-row .value {
            font-weight: 600;
            color: var(--slate-900);
        }
        .score-chip {
            display: inline-flex;
            align-items: center;
            padding: 3px 10px;
            border-radius: 100px;
            font-size: 13px;
            font-weight: 700;
        }
        .score-chip.pass { background: var(--green-100); color: var(--green-500); }
        .score-chip.fail { background: var(--red-100); color: var(--red-500); }

        .divider {
            height: 1px;
            background: var(--slate-100);
            margin: 20px 0;
        }

        /* Stats */
        .stats-row {
            display: flex;
            gap: 16px;
            margin-bottom: 24px;
        }
        .stat-box {
            flex: 1;
            padding: 16px;
            background: var(--slate-100);
            border-radius: 8px;
            text-align: center;
        }
        .stat-num {
            font-size: 24px;
            font-weight: 700;
            color: var(--slate-900);
        }
        .stat-lbl {
            font-size: 12px;
            color: var(--slate-500);
            margin-top: 2px;
        }

        /* New exam button */
        .btn-row {
            display: flex;
            gap: 12px;
        }
        .btn {
            flex: 1;
            padding: 14px 20px;
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            font-weight: 600;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            border: none;
        }
        .btn-primary {
            background: var(--purple-500);
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
            box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);
        }
        .btn-primary:hover::before { opacity: 1; }
        .btn-primary span { position: relative; z-index: 1; }
        .btn-secondary {
            background: var(--surface);
            color: var(--slate-500);
            border: 1.5px solid var(--slate-300);
        }
        .btn-secondary:hover { border-color: var(--slate-700); color: var(--slate-900); }
        .btn svg {
            width: 16px; height: 16px;
            stroke: currentColor;
            fill: none;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
            position: relative;
            z-index: 1;
        }

        .no-record {
            text-align: center;
            padding: 24px 0;
            color: var(--slate-500);
            font-size: 14px;
        }
    </style>
</head>
<body>
    <%
        ExamRecord lastExam = (ExamRecord) request.getAttribute("lastExam");
        int completedExams = (int) request.getAttribute("completedExams");
        int totalExams = (int) request.getAttribute("totalExams");
    %>

    <header class="topbar">
        <div class="topbar-brand">
            <div class="topbar-icon">
                <svg viewBox="0 0 24 24">
                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                </svg>
            </div>
            <h1>在线考试系统</h1>
        </div>
        <a href="${pageContext.request.contextPath}/content.jsp" class="back-link">
            <svg viewBox="0 0 24 24"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
            返回主页
        </a>
    </header>

    <main class="main">
        <div class="page-header">
            <div class="page-eyebrow">Examination</div>
            <h2 class="page-title">在线考试</h2>
        </div>

        <div class="card">
            <div class="accent-bar"></div>
            <div class="card-body">
                <% if (lastExam != null) { %>
                <div class="last-exam">
                    <div class="last-exam-label">上次成绩</div>
                    <div class="last-exam-row">
                        <span class="label">考试时间</span>
                        <span class="value"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm").format(lastExam.getExamTime()) %></span>
                    </div>
                    <div class="last-exam-row">
                        <span class="label">答题情况</span>
                        <span class="value"><%= lastExam.getCorrectCount() %> / <%= lastExam.getQuestionCount() %> 题正确</span>
                    </div>
                    <div class="last-exam-row">
                        <span class="label">得分</span>
                        <span class="value">
                            <span class="score-chip <%= lastExam.getScore() >= lastExam.getTotalScore() * 0.6 ? "pass" : "fail" %>">
                                <%= lastExam.getScore() %> / <%= lastExam.getTotalScore() %>
                            </span>
                        </span>
                    </div>
                </div>
                <div class="divider"></div>
                <% } else { %>
                <div class="no-record">暂无考试记录</div>
                <div class="divider"></div>
                <% } %>

                <div class="stats-row">
                    <div class="stat-box">
                        <div class="stat-num"><%= completedExams %></div>
                        <div class="stat-lbl">已完成</div>
                    </div>
                    <div class="stat-box">
                        <div class="stat-num"><%= totalExams - completedExams %></div>
                        <div class="stat-lbl">进行中</div>
                    </div>
                </div>

                <div class="btn-row">
                    <a href="${pageContext.request.contextPath}/exam?action=new" class="btn btn-primary">
                        <svg viewBox="0 0 24 24"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                        <span>开始新考试</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/exam?action=history" class="btn btn-secondary">
                        <svg viewBox="0 0 24 24"><line x1="8" y1="6" x2="21" y2="6"/><line x1="8" y1="12" x2="21" y2="12"/><line x1="8" y1="18" x2="21" y2="18"/><line x1="3" y1="6" x2="3.01" y2="6"/><line x1="3" y1="12" x2="3.01" y2="12"/><line x1="3" y1="18" x2="3.01" y2="18"/></svg>
                        查看全部
                    </a>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
