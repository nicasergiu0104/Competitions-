<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="My Profile">

  <style>
    .profile-avatar {
      width:96px; height:96px; border-radius:50%;
      display:flex; align-items:center; justify-content:center;
      font-family:'Bricolage Grotesque', sans-serif; font-weight:800; font-size:2.4rem;
      color:#fff; background:linear-gradient(135deg, var(--cobalt), var(--coral));
      margin:0 auto; box-shadow:0 10px 24px -10px rgba(45,78,245,.55);
    }
    .role-pill { background: rgba(45,78,245,.1); color: var(--cobalt-dark); font-weight:600; border-radius:.6rem; padding:.35rem .7rem; font-size:.8rem; }
    .section-label { font-family:'Bricolage Grotesque', sans-serif; font-weight:700; letter-spacing:-.01em; }
  </style>

  <h1 class="mb-4">My Profile</h1>

  <c:if test="${param.saved == 'true'}">
    <div class="alert alert-success">Profile saved.</div>
  </c:if>

  <div class="row g-4">
      <%-- Identity card --%>
    <div class="col-lg-4">
      <div class="card text-center" style="position:sticky; top:1rem;">
        <div class="card-body py-4">
          <div class="profile-avatar mb-3">${profile.username.substring(0,1).toUpperCase()}</div>
          <h4 class="section-label mb-1">${profile.username}</h4>
          <span class="role-pill">
            <c:choose>
              <c:when test="${pageContext.request.isUserInRole('DEPARTMENT_REP')}">Department</c:when>
              <c:otherwise>Student</c:otherwise>
            </c:choose>
          </span>
          <c:if test="${not empty profile.email}">
            <div class="text-muted small mt-3">${profile.email}</div>
          </c:if>
        </div>
      </div>
    </div>

      <%-- Edit form --%>
    <div class="col-lg-8">
      <div class="card">
        <div class="card-body">
          <h4 class="section-label mb-4">Account details</h4>
          <form method="POST" action="${pageContext.request.contextPath}/Profile" class="row g-3">
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
              <textarea name="bio" class="form-control" rows="4">${profile.bio}</textarea>
            </div>
            <div class="col-12">
              <button type="submit" class="btn btn-primary">Save</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</t:pageTemplate>