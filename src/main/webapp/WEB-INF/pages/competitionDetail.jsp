<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="${competition.title}">
  <a href="${pageContext.request.contextPath}/Competitions" class="btn btn-link px-0 mb-3">&larr; Back to competitions</a>

  <div class="d-flex justify-content-between align-items-start mb-3">
    <h1 class="mb-0">${competition.title}</h1>
    <span class="badge bg-secondary fs-6">${competition.status}</span>
  </div>

  <c:if test="${param.applied == 'true'}">
    <div class="alert alert-success">Your application has been submitted.</div>
  </c:if>

  <c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
  </c:if>

  <p>${competition.description}</p>

  <ul class="list-group mb-4" style="max-width: 480px;">
    <li class="list-group-item d-flex justify-content-between">
      <span>Application opens</span><span>${competition.applicationStart}</span>
    </li>
    <li class="list-group-item d-flex justify-content-between">
      <span>Deadline</span><span>${competition.applicationDeadline}</span>
    </li>
    <li class="list-group-item d-flex justify-content-between">
      <span>Participants</span><span>${competition.minParticipants}–${competition.maxParticipants}</span>
    </li>
    <li class="list-group-item d-flex justify-content-between">
      <span>Internal</span><span>${competition.internal ? 'Yes' : 'No'}</span>
    </li>
  </ul>

  <%-- Department: manage the custom application questions --%>
  <c:if test="${pageContext.request.isUserInRole('DEPARTMENT_REP')}">
    <a href="${pageContext.request.contextPath}/CompetitionApplicants?id=${competition.id}"
       class="btn btn-primary mb-3">View applicants</a>
    <h4 class="mt-4">Application questions</h4>
    <c:if test="${empty fieldDefinitions}">
      <p class="text-muted">No custom questions yet.</p>
    </c:if>
    <ul class="list-group mb-3" style="max-width: 600px;">
      <c:if test="${not empty publishedScores}">
        <h4 class="mt-4">Results</h4>
        <ol class="list-group list-group-numbered mb-4" style="max-width: 480px;">
          <c:forEach var="r" items="${publishedScores}">
            <li class="list-group-item d-flex justify-content-between align-items-center">
              <span>Score: ${r.score}</span>
              <c:if test="${r.winner}"><span class="badge bg-warning text-dark">Winner</span></c:if>
            </li>
          </c:forEach>
        </ol>
      </c:if>
      <c:forEach var="def" items="${fieldDefinitions}">
        <li class="list-group-item d-flex justify-content-between align-items-center">
                    <span>
                        ${def.label}
                        <span class="badge bg-light text-dark">${def.fieldType}</span>
                        <c:if test="${def.required}"><span class="badge bg-warning text-dark">required</span></c:if>
                    </span>
          <form method="POST" action="${pageContext.request.contextPath}/CompetitionFields">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="competition_id" value="${competition.id}">
            <input type="hidden" name="field_id" value="${def.id}">
            <button class="btn btn-sm btn-outline-danger">Remove</button>
          </form>
        </li>
      </c:forEach>
    </ul>
    <form method="POST" action="${pageContext.request.contextPath}/CompetitionFields"
          class="row g-2 align-items-end" style="max-width: 600px;">
      <input type="hidden" name="action" value="add">
      <input type="hidden" name="competition_id" value="${competition.id}">
      <div class="col-sm-5">
        <label class="form-label">Question label</label>
        <input type="text" name="label" class="form-control" required>
      </div>
      <div class="col-sm-3">
        <label class="form-label">Type</label>
        <select name="field_type" class="form-select">
          <option value="TEXT">Short text</option>
          <option value="TEXTAREA">Long text</option>
          <option value="NUMBER">Number</option>
        </select>
      </div>
      <div class="col-sm-2">
        <div class="form-check mt-4">
          <input type="checkbox" name="required" class="form-check-input" id="req">
          <label class="form-check-label" for="req">Required</label>
        </div>
      </div>
      <div class="col-sm-2">
        <button class="btn btn-secondary w-100">Add</button>
      </div>
    </form>
  </c:if>

  <%-- Student: apply, answering the custom questions --%>
  <c:if test="${pageContext.request.isUserInRole('STUDENT')}">
    <c:choose>
      <c:when test="${not empty applicationStatus}">
        <div class="alert alert-info">
          You applied to this competition. Status: <strong>${applicationStatus}</strong>
        </div>
      </c:when>
      <c:otherwise>
        <h4 class="mt-4">Apply</h4>
        <form method="POST" action="${pageContext.request.contextPath}/CompetitionDetail" style="max-width: 600px;">
          <input type="hidden" name="id" value="${competition.id}">
          <c:forEach var="def" items="${fieldDefinitions}">
            <div class="mb-3">
              <label class="form-label">${def.label}<c:if test="${def.required}"> *</c:if></label>
              <c:choose>
                <c:when test="${def.fieldType == 'TEXTAREA'}">
                  <textarea name="field_${def.id}" class="form-control" rows="3" ${def.required ? 'required' : ''}></textarea>
                </c:when>
                <c:when test="${def.fieldType == 'NUMBER'}">
                  <input type="number" name="field_${def.id}" class="form-control" ${def.required ? 'required' : ''}>
                </c:when>
                <c:otherwise>
                  <input type="text" name="field_${def.id}" class="form-control" ${def.required ? 'required' : ''}>
                </c:otherwise>
              </c:choose>
            </div>
          </c:forEach>
          <button type="submit" class="btn btn-primary btn-lg">Apply</button>
        </form>
      </c:otherwise>
    </c:choose>
  </c:if>
</t:pageTemplate>