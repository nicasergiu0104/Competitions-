<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<t:pageTemplate pageTitle="Applicants">

  <style>
    .applicant-avatar { width:46px; height:46px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-family:'Bricolage Grotesque',sans-serif; font-weight:800; color:#fff; background:linear-gradient(135deg, var(--cobalt), var(--coral)); flex:0 0 auto; }
    .winner-card { border-left:4px solid var(--coral); }
    .section-label { font-family:'Bricolage Grotesque', sans-serif; font-weight:700; letter-spacing:-.01em; }
    .answers-dl dt { color: var(--ink-soft); font-weight:600; }
    .answers-dl dd { margin-bottom:.4rem; }
    .count-pill { background: rgba(45,78,245,.1); color: var(--cobalt-dark); font-weight:600; border-radius:.6rem; padding:.3rem .65rem; font-size:.85rem; }
  </style>

  <a href="${pageContext.request.contextPath}/CompetitionDetail?id=${competition.id}"
     class="btn btn-link px-0 mb-2">&larr; Back to competition</a>

  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
    <div class="d-flex align-items-center gap-3">
      <h1 class="mb-0">Applicants</h1>
      <span class="count-pill">${fn:length(applications)} total</span>
    </div>
    <span class="badge bg-secondary fs-6">${competition.status}</span>
  </div>
  <p class="text-muted mb-4">${competition.title}</p>

  <div class="card mb-4">
    <div class="card-body d-flex flex-wrap gap-2">
      <a href="${pageContext.request.contextPath}/CompetitionApplicants?id=${competition.id}&export=csv"
         class="btn btn-outline-primary">Download CSV</a>
      <c:if test="${competition.status != 'COMPLETED'}">
        <form method="POST" action="${pageContext.request.contextPath}/CompetitionApplicants"
              onsubmit="return confirm('Mark this competition as complete?');">
          <input type="hidden" name="competition_id" value="${competition.id}">
          <input type="hidden" name="action" value="complete">
          <button class="btn btn-dark">Mark complete</button>
        </form>
      </c:if>
      <form method="POST" action="${pageContext.request.contextPath}/CompetitionApplicants">
        <input type="hidden" name="competition_id" value="${competition.id}">
        <input type="hidden" name="action" value="${scoresPublished ? 'unpublish' : 'publish'}">
        <button class="btn btn-outline-secondary">
            ${scoresPublished ? 'Unpublish anonymized scores' : 'Publish anonymized scores'}
        </button>
      </form>
    </div>
  </div>

  <c:if test="${empty applications}">
    <div class="alert alert-info">No applications yet.</div>
  </c:if>

  <c:forEach var="app" items="${applications}">
    <div class="card mb-3 ${app.winner ? 'winner-card' : ''}">
      <div class="card-body">
        <div class="d-flex justify-content-between align-items-start gap-3">
          <div class="d-flex align-items-center gap-3">
            <div class="applicant-avatar">
              <c:choose>
                <c:when test="${not empty app.fullName}">${app.fullName.substring(0,1).toUpperCase()}</c:when>
                <c:otherwise>${app.username.substring(0,1).toUpperCase()}</c:otherwise>
              </c:choose>
            </div>
            <div>
              <h5 class="mb-0 section-label">
                <c:choose>
                  <c:when test="${not empty app.fullName}">${app.fullName}</c:when>
                  <c:otherwise>${app.username}</c:otherwise>
                </c:choose>
                <c:if test="${app.winner}"><span class="badge bg-warning text-dark ms-2">Winner</span></c:if>
              </h5>
              <div class="text-muted small">
                  ${app.email}
                <c:if test="${not empty app.studyProgram}"> · ${app.studyProgram}</c:if>
                <c:if test="${not empty app.studyYear}"> · Year ${app.studyYear}</c:if>
              </div>
            </div>
          </div>
          <span class="badge ${app.status == 'ACCEPTED' ? 'bg-success' : (app.status == 'REJECTED' ? 'bg-danger' : 'bg-secondary')}">${app.status}</span>
        </div>

        <c:if test="${not empty app.answers}">
          <dl class="row mt-3 mb-0 answers-dl">
            <c:forEach var="ans" items="${app.answers}">
              <dt class="col-sm-3">${ans.label}</dt>
              <dd class="col-sm-9">${ans.value}</dd>
            </c:forEach>
          </dl>
        </c:if>
      </div>
      <div class="card-footer">
        <div class="d-flex gap-2 mb-2">
          <form method="POST" action="${pageContext.request.contextPath}/CompetitionApplicants">
            <input type="hidden" name="competition_id" value="${competition.id}">
            <input type="hidden" name="application_id" value="${app.id}">
            <input type="hidden" name="action" value="accept">
            <button class="btn btn-sm btn-success" ${app.status == 'ACCEPTED' ? 'disabled' : ''}>Accept</button>
          </form>
          <form method="POST" action="${pageContext.request.contextPath}/CompetitionApplicants">
            <input type="hidden" name="competition_id" value="${competition.id}">
            <input type="hidden" name="application_id" value="${app.id}">
            <input type="hidden" name="action" value="reject">
            <button class="btn btn-sm btn-outline-danger" ${app.status == 'REJECTED' ? 'disabled' : ''}>Reject</button>
          </form>
        </div>
        <form method="POST" action="${pageContext.request.contextPath}/CompetitionApplicants"
              class="row g-2 align-items-center">
          <input type="hidden" name="competition_id" value="${competition.id}">
          <input type="hidden" name="application_id" value="${app.id}">
          <input type="hidden" name="action" value="result">
          <div class="col-auto"><label class="col-form-label">Score</label></div>
          <div class="col-auto">
            <input type="number" step="any" name="score" class="form-control form-control-sm"
                   value="${app.score}" style="width: 120px;">
          </div>
          <div class="col-auto form-check">
            <input type="checkbox" name="winner" class="form-check-input"
                   id="win_${app.id}" ${app.winner ? 'checked' : ''}>
            <label class="form-check-label" for="win_${app.id}">Winner</label>
          </div>
          <div class="col-auto">
            <button class="btn btn-sm btn-primary">Save result</button>
          </div>
        </form>
      </div>
    </div>
  </c:forEach>
</t:pageTemplate>