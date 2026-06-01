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

  <c:url var="upcomingUrl" value="/Competitions">
    <c:param name="view" value="upcoming"/>
    <c:param name="q" value="${q}"/>
    <c:param name="tag" value="${tagFilter}"/>
  </c:url>
  <c:url var="pastUrl" value="/Competitions">
    <c:param name="view" value="past"/>
    <c:param name="q" value="${q}"/>
    <c:param name="tag" value="${tagFilter}"/>
  </c:url>

  <ul class="nav nav-tabs mb-3">
    <li class="nav-item">
      <a class="nav-link ${view == 'upcoming' ? 'active' : ''}" href="${upcomingUrl}">Upcoming</a>
    </li>
    <li class="nav-item">
      <a class="nav-link ${view == 'past' ? 'active' : ''}" href="${pastUrl}">Past</a>
    </li>
  </ul>

  <form method="GET" action="${pageContext.request.contextPath}/Competitions" class="row g-2 mb-3" style="max-width: 560px;">
    <input type="hidden" name="view" value="${view}">
    <input type="hidden" name="tag" value="${tagFilter}">
    <div class="col">
      <input type="text" name="q" class="form-control" placeholder="Search by title or description..." value="${q}">
    </div>
    <div class="col-auto">
      <button class="btn btn-outline-secondary">Search</button>
    </div>
    <c:if test="${not empty q}">
      <div class="col-auto">
        <c:url var="clearSearchUrl" value="/Competitions">
          <c:param name="view" value="${view}"/>
          <c:param name="tag" value="${tagFilter}"/>
        </c:url>
        <a href="${clearSearchUrl}" class="btn btn-link">Clear</a>
      </div>
    </c:if>
  </form>

  <c:if test="${not empty allTags}">
    <div class="mb-4 d-flex flex-wrap gap-2 align-items-center">
      <span class="text-muted small me-1">Filter by tag:</span>
      <c:url var="allTagsUrl" value="/Competitions">
        <c:param name="view" value="${view}"/>
        <c:param name="q" value="${q}"/>
      </c:url>
      <a href="${allTagsUrl}"
         class="btn btn-sm ${empty tagFilter ? 'btn-primary' : 'btn-outline-secondary'}">All</a>
      <c:forEach var="tagName" items="${allTags}">
        <c:url var="tagUrl" value="/Competitions">
          <c:param name="view" value="${view}"/>
          <c:param name="q" value="${q}"/>
          <c:param name="tag" value="${tagName}"/>
        </c:url>
        <a href="${tagUrl}"
           class="btn btn-sm ${tagFilter == tagName ? 'btn-primary' : 'btn-outline-secondary'}">${tagName}</a>
      </c:forEach>
    </div>
  </c:if>

  <c:if test="${empty competitions}">
    <div class="alert alert-info">No competitions found.</div>
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

  <c:if test="${totalPages > 1}">
    <c:url var="prevUrl" value="/Competitions">
      <c:param name="view" value="${view}"/>
      <c:param name="q" value="${q}"/>
      <c:param name="tag" value="${tagFilter}"/>
      <c:param name="page" value="${page - 1}"/>
    </c:url>
    <c:url var="nextUrl" value="/Competitions">
      <c:param name="view" value="${view}"/>
      <c:param name="q" value="${q}"/>
      <c:param name="tag" value="${tagFilter}"/>
      <c:param name="page" value="${page + 1}"/>
    </c:url>
    <nav class="mt-4">
      <ul class="pagination justify-content-center">
        <li class="page-item ${page == 0 ? 'disabled' : ''}">
          <a class="page-link" href="${prevUrl}">Previous</a>
        </li>
        <li class="page-item disabled">
          <span class="page-link">Page ${page + 1} of ${totalPages}</span>
        </li>
        <li class="page-item ${page + 1 >= totalPages ? 'disabled' : ''}">
          <a class="page-link" href="${nextUrl}">Next</a>
        </li>
      </ul>
    </nav>
  </c:if>
</t:pageTemplate>