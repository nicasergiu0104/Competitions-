<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="My Applications">

    <style>
        .app-table thead th { font-family:'Bricolage Grotesque', sans-serif; text-transform:uppercase; letter-spacing:.06em; font-size:.78rem; color: var(--ink-soft); border-bottom:2px solid var(--line); }
        .app-table tbody td { border-color: var(--line); }
        .app-table tbody tr:last-child td { border-bottom:0; }
        .app-table a { color: var(--ink); font-weight:600; }
        .app-table a:hover { color: var(--cobalt); }
    </style>

    <h1 class="mb-4">My Applications</h1>

    <c:if test="${empty applications}">
        <div class="alert alert-info">You haven't applied to any competitions yet.</div>
    </c:if>

    <c:if test="${not empty applications}">
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table align-middle app-table mb-0">
                        <thead>
                        <tr>
                            <th>Competition</th>
                            <th>My status</th>
                            <th>Result</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="app" items="${applications}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/CompetitionDetail?id=${app.competitionId}">${app.competitionTitle}</a>
                                    <span class="badge bg-secondary ms-1">${app.competitionStatus}</span>
                                </td>
                                <td>
                                    <span class="badge ${app.applicationStatus == 'ACCEPTED' ? 'bg-success' : (app.applicationStatus == 'REJECTED' ? 'bg-danger' : 'bg-secondary')}">${app.applicationStatus}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${app.competitionStatus == 'COMPLETED' and app.score != null}">
                                            Score: ${app.score}
                                            <c:if test="${app.winner}"><span class="badge bg-warning text-dark ms-1">Winner</span></c:if>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">—</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:if>
</t:pageTemplate>