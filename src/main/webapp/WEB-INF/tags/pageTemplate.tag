<%@tag description="base page template" pageEncoding="UTF-8" %>
<%@attribute name="pageTitle" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Hanken+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --paper: #F6F4EF;
            --paper-2: #FFFFFF;
            --ink: #16181D;
            --ink-soft: #5A5E68;
            --cobalt: #2D4EF5;
            --cobalt-dark: #1F38C4;
            --coral: #FF5A3C;
            --line: #E7E2D8;

            --bs-body-bg: var(--paper);
            --bs-body-color: var(--ink);
            --bs-body-font-family: 'Hanken Grotesk', system-ui, sans-serif;
            --bs-primary: #2D4EF5;
            --bs-primary-rgb: 45, 78, 245;
            --bs-link-color: var(--cobalt);
            --bs-link-color-rgb: 45, 78, 245;
            --bs-link-hover-color: var(--cobalt-dark);
            --bs-border-color: var(--line);
            --bs-border-radius: 0.85rem;
            --bs-border-radius-sm: 0.6rem;
            --bs-border-radius-lg: 1.1rem;
        }

        body {
            background-color: var(--paper);
            background-image:
                    radial-gradient(60rem 40rem at 110% -10%, rgba(45,78,245,0.07), transparent 60%),
                    radial-gradient(50rem 35rem at -10% 0%, rgba(255,90,60,0.05), transparent 55%);
            background-attachment: fixed;
            color: var(--ink);
            font-family: 'Hanken Grotesk', system-ui, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        h1, h2, h3, h4, h5, h6, .navbar-brand {
            font-family: 'Bricolage Grotesque', system-ui, sans-serif;
            font-weight: 700;
            letter-spacing: -0.02em;
            color: var(--ink);
        }
        h1 { font-weight: 800; }

        main.container { animation: riseIn .5s cubic-bezier(.2,.7,.2,1) both; }
        @keyframes riseIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: none; } }

        .btn { font-weight: 600; border-radius: .7rem; transition: transform .12s ease, box-shadow .12s ease, background-color .12s ease; }
        .btn:active { transform: translateY(1px); }
        .btn-primary {
            --bs-btn-bg: var(--cobalt); --bs-btn-border-color: var(--cobalt);
            --bs-btn-hover-bg: var(--cobalt-dark); --bs-btn-hover-border-color: var(--cobalt-dark);
            --bs-btn-active-bg: var(--cobalt-dark); --bs-btn-active-border-color: var(--cobalt-dark);
            box-shadow: 0 6px 16px -6px rgba(45,78,245,.55);
        }
        .btn-primary:hover { box-shadow: 0 10px 22px -8px rgba(45,78,245,.6); }
        .btn-outline-primary {
            --bs-btn-color: var(--cobalt); --bs-btn-border-color: var(--cobalt);
            --bs-btn-hover-bg: var(--cobalt); --bs-btn-hover-border-color: var(--cobalt);
            --bs-btn-active-bg: var(--cobalt-dark); --bs-btn-active-border-color: var(--cobalt-dark);
        }
        .btn-dark { --bs-btn-bg: var(--ink); --bs-btn-border-color: var(--ink); --bs-btn-hover-bg:#000; --bs-btn-hover-border-color:#000; }
        .btn-outline-secondary {
            --bs-btn-color: var(--ink); --bs-btn-border-color: var(--line);
            --bs-btn-hover-bg: var(--ink); --bs-btn-hover-border-color: var(--ink); --bs-btn-hover-color:#fff;
        }
        .btn-outline-danger { --bs-btn-color:#D6402C; --bs-btn-border-color:#E7B7AF; --bs-btn-hover-bg:#D6402C; --bs-btn-hover-border-color:#D6402C; }
        .btn-link { --bs-btn-color: var(--cobalt); --bs-btn-hover-color: var(--cobalt-dark); font-weight:600; text-decoration:none; }

        .card {
            border: 1px solid var(--line);
            border-radius: 1.1rem;
            background: var(--paper-2);
            box-shadow: 0 1px 2px rgba(22,24,29,.04), 0 12px 30px -18px rgba(22,24,29,.18);
            transition: transform .16s ease, box-shadow .16s ease, border-color .16s ease;
        }
        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 1px 2px rgba(22,24,29,.05), 0 20px 40px -16px rgba(45,78,245,.28);
            border-color: rgba(45,78,245,.35);
        }
        .card-title a { color: var(--ink); }
        .card-title a:hover { color: var(--cobalt); }
        .card-footer { background: transparent; border-top: 1px solid var(--line); }

        .badge { font-weight: 600; letter-spacing: .02em; border-radius: .55rem; padding: .4em .7em; }
        .badge.bg-secondary { background: rgba(22,24,29,.08) !important; color: var(--ink) !important; }
        .badge.bg-success  { background: #12805C !important; }
        .badge.bg-danger   { background: #D6402C !important; }
        .badge.bg-warning  { background: var(--coral) !important; color:#fff !important; }

        .nav-tabs { border-bottom: 2px solid var(--line); }
        .nav-tabs .nav-link { color: var(--ink-soft); font-weight: 600; border: none; border-bottom: 2px solid transparent; margin-bottom:-2px; }
        .nav-tabs .nav-link:hover { color: var(--ink); border-bottom-color: var(--line); }
        .nav-tabs .nav-link.active { color: var(--cobalt); background: transparent; border-bottom: 2px solid var(--cobalt); }

        .form-control:focus, .form-select:focus, .form-check-input:focus {
            border-color: var(--cobalt);
            box-shadow: 0 0 0 .2rem rgba(45,78,245,.18);
        }
        .form-check-input:checked { background-color: var(--cobalt); border-color: var(--cobalt); }

        .pagination {
            --bs-pagination-color: var(--ink);
            --bs-pagination-active-bg: var(--cobalt);
            --bs-pagination-active-border-color: var(--cobalt);
            --bs-pagination-hover-color: var(--cobalt-dark);
            --bs-pagination-focus-box-shadow: 0 0 0 .2rem rgba(45,78,245,.18);
        }

        .alert-info { background: rgba(45,78,245,.07); border-color: rgba(45,78,245,.18); color: var(--cobalt-dark); }

        .app-navbar { background: var(--ink); border-bottom: 3px solid var(--cobalt); padding-block: .75rem; }
        .app-navbar .navbar-brand { font-weight: 800; letter-spacing: -.03em; font-size: 1.35rem; color:#fff; display:inline-flex; align-items:center; gap:.55rem; }
        .app-navbar .navbar-brand::before { content:""; width:.7rem; height:.7rem; border-radius:.2rem; background: var(--coral); display:inline-block; transform: rotate(12deg); }
        .app-navbar .nav-link { color: rgba(255,255,255,.78); font-weight:600; position:relative; }
        .app-navbar .nav-link:hover { color:#fff; }
        .app-navbar .nav-link::after { content:""; position:absolute; left:.5rem; right:.5rem; bottom:.2rem; height:2px; background: var(--coral); transform: scaleX(0); transform-origin:left; transition: transform .18s ease; }
        .app-navbar .nav-link:hover::after { transform: scaleX(1); }
        .app-navbar .nav-link.disabled { color: rgba(255,255,255,.5); }

        .app-footer { background: transparent; border-top: 1px solid var(--line); color: var(--ink-soft); }
        .app-footer strong { color: var(--ink); font-family:'Bricolage Grotesque', sans-serif; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
<jsp:include page="/WEB-INF/pages/menu.jsp"/>
<main class="container mt-4 mb-auto">
    <jsp:doBody/>
</main>
<footer class="app-footer text-center py-4 mt-5">
    &copy; <%= java.time.Year.now() %> <strong>Competitions</strong> · CSEE Department
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>