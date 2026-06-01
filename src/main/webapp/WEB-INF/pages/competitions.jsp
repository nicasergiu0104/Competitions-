<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="Competitions">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="mb-0">Competitions</h1>
    <c:if test="${pageContext.request.isUserInRole('DEPARTMENT_REP')}">
      <a href="${pageContext.request.contextPath}/AddCompetition" class="btn btn-primary">Add Competition</a>
    </c:if>
  </div>

  <c:if test="${empty competitions}">
    <div class="alert alert-info">No competitions yet.</div>
  </c:if>

  <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
    <c:forEach var="comp" items="${competitions}">
      <div class="col">
        <div class="card h-100">
          <div class="card-body">
            <div class="d-flex justify-content-between align-items-start">
              <h5 class="card-title">
                <a href="${pageContext.request.contextPath}/CompetitionDetail?id=${comp.id}"
                   class="text-decoration-none">${comp.title}</a>
              </h5>
              <span class="badge bg-secondary">${comp.status}</span>
            </div>
            <p class="card-text">${comp.description}</p>
          </div>
          <div class="card-footer d-flex justify-content-between align-items-center">
            <span class="text-muted small">Deadline: ${comp.applicationDeadline}</span>
            <c:if test="${pageContext.request.isUserInRole('DEPARTMENT_REP')}">
              <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/EditCompetition?id=${comp.id}"
                   class="btn btn-sm btn-outline-secondary">Edit</a>
                <form method="POST" action="${pageContext.request.contextPath}/Competitions"
                      onsubmit="return confirm('Delete this competition?');">
                  <input type="hidden" name="id" value="${comp.id}">
                  <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                </form>
              </div>
            </c:if>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
</t:pageTemplate>