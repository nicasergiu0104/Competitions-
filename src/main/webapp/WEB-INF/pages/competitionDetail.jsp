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
  <c:if test="${param.withdrawn == 'true'}">
    <div class="alert alert-warning">You have withdrawn your application.</div>
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

  <%-- Tags & participant categories — visible to everyone --%>
  <c:if test="${not empty tags or not empty categories}">
    <div class="mb-4">
      <c:if test="${not empty tags}">
        <div class="mb-2">
          <span class="text-muted me-1">Tags:</span>
          <c:forEach var="tag" items="${tags}">
            <span class="badge bg-info text-dark me-1">${tag}</span>
          </c:forEach>
        </div>
      </c:if>
      <c:if test="${not empty categories}">
        <div>
          <span class="text-muted me-1">Participant categories:</span>
          <c:forEach var="cat" items="${categories}">
            <span class="badge bg-light text-dark border me-1">${cat}</span>
          </c:forEach>
        </div>
      </c:if>
    </div>
  </c:if>

  <%-- Published results (anonymized) — visible to everyone --%>
  <c:if test="${not empty publishedScores}">
    <h4 class="mt-4">Results</h4>
    <ol class="list-group list-group-numbered mb-4" style="max-width: 480px;">
      <c:forEach var="r" items="${publishedScores}">
        <li class="list-group-item d-flex justify-content-between align-items-center ${r.mine ? 'list-group-item-primary' : ''}">
          <span>
            ${r.code}
            <c:if test="${r.mine}"><span class="badge bg-primary ms-1">You</span></c:if>
          </span>
          <span class="d-flex align-items-center gap-2">
            <span>Score: ${r.score}</span>
            <c:if test="${r.winner}"><span class="badge bg-warning text-dark">Winner</span></c:if>
          </span>
        </li>
      </c:forEach>
    </ol>
  </c:if>

  <%-- Photos — visible to everyone --%>
  <c:if test="${not empty photos}">
    <h4 class="mt-4">Photos</h4>
    <div class="row row-cols-2 row-cols-md-3 g-3 mb-4">
      <c:forEach var="photo" items="${photos}">
        <div class="col">
          <div class="position-relative">
            <img src="${pageContext.request.contextPath}/CompetitionPhoto?id=${photo.id}"
                 class="img-fluid rounded border" alt="${photo.filename}">
            <c:if test="${pageContext.request.isUserInRole('DEPARTMENT_REP')}">
              <form method="POST" action="${pageContext.request.contextPath}/AddCompetitionPhoto"
                    class="position-absolute top-0 end-0 m-1"
                    onsubmit="return confirm('Delete this photo?');">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="competition_id" value="${competition.id}">
                <input type="hidden" name="photo_id" value="${photo.id}">
                <button class="btn btn-sm btn-danger">&times;</button>
              </form>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </c:if>

  <%-- Department controls --%>
  <c:if test="${pageContext.request.isUserInRole('DEPARTMENT_REP')}">
    <a href="${pageContext.request.contextPath}/CompetitionApplicants?id=${competition.id}"
       class="btn btn-primary mb-3">View applicants</a>

    <form method="POST" action="${pageContext.request.contextPath}/AddCompetitionPhoto"
          enctype="multipart/form-data" class="row g-2 align-items-center mb-4" style="max-width: 600px;">
      <input type="hidden" name="competition_id" value="${competition.id}">
      <div class="col">
        <input type="file" name="photo" accept="image/*" class="form-control" required>
      </div>
      <div class="col-auto">
        <button class="btn btn-secondary">Upload photo</button>
      </div>
    </form>

    <h4 class="mt-4">Tags</h4>
    <div class="d-flex flex-wrap gap-2 mb-2">
      <c:forEach var="tag" items="${tags}">
        <span class="badge bg-info text-dark d-flex align-items-center">
          ${tag}
          <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags" class="ms-2">
            <input type="hidden" name="kind" value="tag">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="competition_id" value="${competition.id}">
            <input type="hidden" name="name" value="${tag}">
            <button type="submit" class="btn btn-sm p-0 border-0 bg-transparent" style="line-height:1;">&times;</button>
          </form>
        </span>
      </c:forEach>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags"
          class="row g-2 align-items-center mb-3" style="max-width: 480px;">
      <input type="hidden" name="kind" value="tag">
      <input type="hidden" name="action" value="add">
      <input type="hidden" name="competition_id" value="${competition.id}">
      <div class="col">
        <input type="text" name="name" class="form-control" placeholder="Add a tag" required>
      </div>
      <div class="col-auto">
        <button class="btn btn-outline-secondary">Add tag</button>
      </div>
    </form>

    <h4 class="mt-4">Participant categories</h4>
    <div class="d-flex flex-wrap gap-2 mb-2">
      <c:forEach var="cat" items="${categories}">
        <span class="badge bg-light text-dark border d-flex align-items-center">
          ${cat}
          <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags" class="ms-2">
            <input type="hidden" name="kind" value="category">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="competition_id" value="${competition.id}">
            <input type="hidden" name="name" value="${cat}">
            <button type="submit" class="btn btn-sm p-0 border-0 bg-transparent" style="line-height:1;">&times;</button>
          </form>
        </span>
      </c:forEach>
    </div>
    <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags"
          class="row g-2 align-items-center mb-3" style="max-width: 480px;">
      <input type="hidden" name="kind" value="category">
      <input type="hidden" name="action" value="add">
      <input type="hidden" name="competition_id" value="${competition.id}">
      <div class="col">
        <input type="text" name="name" class="form-control" placeholder="Add a participant category" required>
      </div>
      <div class="col-auto">
        <button class="btn btn-outline-secondary">Add category</button>
      </div>
    </form>

    <h4 class="mt-4">Application questions</h4>
    <c:if test="${empty fieldDefinitions}">
      <p class="text-muted">No custom questions yet.</p>
    </c:if>
    <ul class="list-group mb-3" style="max-width: 600px;">
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

  <%-- Student: apply, or see status with a withdraw option --%>
  <c:if test="${pageContext.request.isUserInRole('STUDENT')}">
    <c:choose>
      <c:when test="${not empty applicationStatus}">
        <div class="alert alert-info d-flex justify-content-between align-items-center">
          <span>You applied to this competition. Status: <strong>${applicationStatus}</strong></span>
          <form method="POST" action="${pageContext.request.contextPath}/CompetitionDetail"
                onsubmit="return confirm('Withdraw your application?');" class="mb-0">
            <input type="hidden" name="id" value="${competition.id}">
            <input type="hidden" name="action" value="withdraw">
            <button class="btn btn-sm btn-outline-danger">Withdraw</button>
          </form>
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