<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="Add Competition">

  <h1 class="mb-4">Add Competition</h1>

  <div class="card" style="max-width: 760px;">
    <div class="card-body">
      <form method="POST" action="${pageContext.request.contextPath}/AddCompetition" class="row g-3">
        <div class="col-12">
          <label class="form-label">Title</label>
          <input type="text" name="title" class="form-control" required>
        </div>
        <div class="col-12">
          <label class="form-label">Description</label>
          <textarea name="description" class="form-control" rows="4"></textarea>
        </div>
        <div class="col-md-6">
          <label class="form-label">Application start</label>
          <input type="datetime-local" name="application_start" class="form-control">
        </div>
        <div class="col-md-6">
          <label class="form-label">Application deadline</label>
          <input type="datetime-local" name="application_deadline" class="form-control">
        </div>
        <div class="col-md-6">
          <label class="form-label">Min participants</label>
          <input type="number" name="min_participants" class="form-control" value="0" min="0">
        </div>
        <div class="col-md-6">
          <label class="form-label">Max participants</label>
          <input type="number" name="max_participants" class="form-control" value="0" min="0">
        </div>
        <div class="col-md-6">
          <label class="form-label">Status</label>
          <select name="status" class="form-select">
            <c:forEach var="s" items="${statuses}">
              <option value="${s}">${s}</option>
            </c:forEach>
          </select>
        </div>
        <div class="col-md-6 d-flex align-items-end">
          <div class="form-check">
            <input type="checkbox" name="internal" class="form-check-input" id="internal">
            <label class="form-check-label" for="internal">Internal (institutional email required)</label>
          </div>
        </div>
        <div class="col-12 d-flex gap-2">
          <button type="submit" class="btn btn-primary">Save</button>
          <a href="${pageContext.request.contextPath}/Competitions" class="btn btn-outline-secondary">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</t:pageTemplate>