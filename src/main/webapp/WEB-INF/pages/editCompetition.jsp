<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="Edit Competition">
  <h1 class="mb-4">Edit Competition</h1>
  <form method="POST" action="${pageContext.request.contextPath}/EditCompetition"
        class="row g-3" style="max-width: 720px;">
    <input type="hidden" name="id" value="${competition.id}">
    <div class="col-12">
      <label class="form-label">Title</label>
      <input type="text" name="title" class="form-control" value="${competition.title}" required>
    </div>
    <div class="col-12">
      <label class="form-label">Description</label>
      <textarea name="description" class="form-control" rows="4">${competition.description}</textarea>
    </div>
    <div class="col-md-6">
      <label class="form-label">Application start</label>
      <input type="datetime-local" name="application_start" class="form-control" value="${competition.applicationStart}">
    </div>
    <div class="col-md-6">
      <label class="form-label">Application deadline</label>
      <input type="datetime-local" name="application_deadline" class="form-control" value="${competition.applicationDeadline}">
    </div>
    <div class="col-md-6">
      <label class="form-label">Min participants</label>
      <input type="number" name="min_participants" class="form-control" value="${competition.minParticipants}" min="0">
    </div>
    <div class="col-md-6">
      <label class="form-label">Max participants</label>
      <input type="number" name="max_participants" class="form-control" value="${competition.maxParticipants}" min="0">
    </div>
    <div class="col-md-6">
      <label class="form-label">Status</label>
      <select name="status" class="form-select">
        <c:forEach var="s" items="${statuses}">
          <option value="${s}" ${s == competition.status ? 'selected' : ''}>${s}</option>
        </c:forEach>
      </select>
    </div>
    <div class="col-md-6 d-flex align-items-end">
      <div class="form-check">
        <input type="checkbox" name="internal" class="form-check-input" id="internal" ${competition.internal ? 'checked' : ''}>
        <label class="form-check-label" for="internal">Internal (institutional email required)</label>
      </div>
    </div>
    <div class="col-12">
      <button type="submit" class="btn btn-primary">Save changes</button>
      <a href="${pageContext.request.contextPath}/Competitions" class="btn btn-outline-secondary">Cancel</a>
    </div>
  </form>
</t:pageTemplate>