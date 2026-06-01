<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="My Profile">
  <h1 class="mb-4">My Profile</h1>
  <c:if test="${param.saved == 'true'}">
    <div class="alert alert-success">Profile saved.</div>
  </c:if>
  <form method="POST" action="${pageContext.request.contextPath}/Profile" class="row g-3" style="max-width: 600px;">
    <div class="col-12">
      <label class="form-label">Username</label>
      <input type="text" class="form-control" value="${profile.username}" disabled>
    </div>
    <div class="col-12">
      <label class="form-label">Email</label>
      <input type="email" name="email" class="form-control" value="${profile.email}" required>
    </div>
    <div class="col-12">
      <label class="form-label">Full name</label>
      <input type="text" name="full_name" class="form-control" value="${profile.fullName}">
    </div>
    <div class="col-md-4">
      <label class="form-label">Year of study</label>
      <input type="number" name="study_year" class="form-control" value="${profile.studyYear}" min="1" max="8">
    </div>
    <div class="col-md-8">
      <label class="form-label">Study program</label>
      <input type="text" name="study_program" class="form-control" value="${profile.studyProgram}"
             placeholder="e.g. Computer Science">
    </div>
    <div class="col-12">
      <label class="form-label">About you</label>
      <textarea name="bio" class="form-control" rows="3">${profile.bio}</textarea>
    </div>
    <div class="col-12">
      <button type="submit" class="btn btn-primary">Save</button>
    </div>
  </form>
</t:pageTemplate>