<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<t:pageTemplate pageTitle="${competition.title}">

  <style>
    .detail-chip { display:inline-flex; align-items:center; gap:.35rem; padding:.35rem .7rem; border-radius:.6rem; font-weight:600; font-size:.85rem; line-height:1; }
    .detail-chip.tag { background: rgba(45,78,245,.1); color: var(--cobalt-dark); }
    .detail-chip.cat { background:#fff; border:1px solid var(--line); color: var(--ink); }
    .detail-chip form { display:inline; margin:0; }
    .detail-chip .chip-x { background:transparent; border:0; padding:0; line-height:1; color:inherit; opacity:.55; font-size:1.05rem; cursor:pointer; }
    .detail-chip .chip-x:hover { opacity:1; }
    .meta-row { display:flex; justify-content:space-between; align-items:center; gap:1rem; padding:.65rem 0; border-bottom:1px solid var(--line); }
    .meta-row:last-child { border-bottom:0; }
    .meta-row .label { color: var(--ink-soft); font-weight:500; }
    .meta-row .value { font-weight:700; text-align:right; }
    .gallery-img { width:100%; height:170px; object-fit:cover; border-radius:.8rem; border:1px solid var(--line); }
    .section-label { font-family:'Bricolage Grotesque', sans-serif; font-weight:700; letter-spacing:-.01em; }
    .badge.bg-primary { background: var(--cobalt) !important; }
    .admin-card { border-left: 4px solid var(--coral); }
    .meta-label { letter-spacing:.09em; color: var(--ink-soft); }
  </style>

  <a href="${pageContext.request.contextPath}/Competitions" class="btn btn-link px-0 mb-2">&larr; Back to competitions</a>

  <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
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

  <div class="row g-4">
      <%-- ============ MAIN COLUMN ============ --%>
    <div class="col-lg-8">

      <p class="lead">${competition.description}</p>

        <%-- Tags & participant categories — visible to everyone --%>
      <c:if test="${not empty tags or not empty categories}">
        <div class="mb-4">
          <c:if test="${not empty tags}">
            <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
              <span class="text-muted">Tags:</span>
              <c:forEach var="tag" items="${tags}">
                <span class="detail-chip tag">${tag}</span>
              </c:forEach>
            </div>
          </c:if>
          <c:if test="${not empty categories}">
            <div class="d-flex flex-wrap align-items-center gap-2">
              <span class="text-muted">Participant categories:</span>
              <c:forEach var="cat" items="${categories}">
                <span class="detail-chip cat">${cat}</span>
              </c:forEach>
            </div>
          </c:if>
        </div>
      </c:if>

        <%-- Published results (anonymized) — visible to everyone --%>
      <c:if test="${not empty publishedScores}">
        <h4 class="section-label mt-2 mb-3">Results</h4>
        <ol class="list-group list-group-numbered mb-4">
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
        <h4 class="section-label mt-2 mb-3">Photos</h4>
        <div class="row row-cols-2 row-cols-md-3 g-3 mb-4">
          <c:forEach var="photo" items="${photos}">
            <div class="col">
              <div class="position-relative">
                <img src="${pageContext.request.contextPath}/CompetitionPhoto?id=${photo.id}"
                     class="gallery-img" alt="${photo.filename}">
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
            <div class="card mt-2">
              <div class="card-body">
                <h4 class="section-label mb-3">Apply</h4>
                <form method="POST" action="${pageContext.request.contextPath}/CompetitionDetail">
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
              </div>
            </div>
          </c:otherwise>
        </c:choose>
      </c:if>

        <%-- ============ DEPARTMENT CONTROLS ============ --%>
      <c:if test="${pageContext.request.isUserInRole('DEPARTMENT_REP')}">
        <div class="card admin-card mt-4">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-center mb-4">
              <h4 class="section-label mb-0">Department controls</h4>
              <a href="${pageContext.request.contextPath}/CompetitionApplicants?id=${competition.id}"
                 class="btn btn-primary">View applicants</a>
            </div>

              <%-- Photo upload --%>
            <h6 class="meta-label text-uppercase small mb-2">Upload photo</h6>
            <form method="POST" action="${pageContext.request.contextPath}/AddCompetitionPhoto"
                  enctype="multipart/form-data" class="row g-2 align-items-center mb-4">
              <input type="hidden" name="competition_id" value="${competition.id}">
              <div class="col">
                <input type="file" name="photo" accept="image/*" class="form-control" required>
              </div>
              <div class="col-auto">
                <button class="btn btn-outline-secondary">Upload</button>
              </div>
            </form>

              <%-- Tags --%>
            <h6 class="meta-label text-uppercase small mb-2">Tags</h6>
            <div class="d-flex flex-wrap gap-2 mb-2">
              <c:forEach var="tag" items="${tags}">
                <span class="detail-chip tag">
                  ${tag}
                  <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags">
                    <input type="hidden" name="kind" value="tag">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="competition_id" value="${competition.id}">
                    <input type="hidden" name="name" value="${tag}">
                    <button type="submit" class="chip-x">&times;</button>
                  </form>
                </span>
              </c:forEach>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags"
                  class="row g-2 align-items-center mb-4" style="max-width: 480px;">
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

              <%-- Participant categories --%>
            <h6 class="meta-label text-uppercase small mb-2">Participant categories</h6>
            <div class="d-flex flex-wrap gap-2 mb-2">
              <c:forEach var="cat" items="${categories}">
                <span class="detail-chip cat">
                  ${cat}
                  <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags">
                    <input type="hidden" name="kind" value="category">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="competition_id" value="${competition.id}">
                    <input type="hidden" name="name" value="${cat}">
                    <button type="submit" class="chip-x">&times;</button>
                  </form>
                </span>
              </c:forEach>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/CompetitionTags"
                  class="row g-2 align-items-center mb-4" style="max-width: 480px;">
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

              <%-- Application questions --%>
            <h6 class="meta-label text-uppercase small mb-2">Application questions</h6>
            <c:if test="${empty fieldDefinitions}">
              <p class="text-muted">No custom questions yet.</p>
            </c:if>
            <ul class="list-group mb-3">
              <c:forEach var="def" items="${fieldDefinitions}">
                <li class="list-group-item d-flex justify-content-between align-items-center">
                  <span>
                    ${def.label}
                    <span class="badge bg-secondary ms-1">${def.fieldType}</span>
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
                  class="row g-2 align-items-end">
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
                <button class="btn btn-primary w-100">Add</button>
              </div>
            </form>
          </div>
        </div>
      </c:if>

    </div>

      <%-- ============ SIDEBAR ============ --%>
    <div class="col-lg-4">
      <div class="card" style="position:sticky; top:1rem;">
        <div class="card-body">
          <h6 class="meta-label text-uppercase small mb-3">Details</h6>
          <div class="meta-row"><span class="label">Status</span><span class="value">${competition.status}</span></div>
          <div class="meta-row"><span class="label">Opens</span><span class="value">${fn:replace(competition.applicationStart, 'T', ' ')}</span></div>
          <div class="meta-row"><span class="label">Deadline</span><span class="value">${fn:replace(competition.applicationDeadline, 'T', ' ')}</span></div>
          <div class="meta-row"><span class="label">Participants</span><span class="value">${competition.minParticipants}&ndash;${competition.maxParticipants}</span></div>
          <div class="meta-row"><span class="label">Internal</span><span class="value">${competition.internal ? 'Yes' : 'No'}</span></div>
        </div>
      </div>
    </div>
  </div>
</t:pageTemplate>