<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="Login">
  <h1 class="mb-4">Login</h1>
  <c:if test="${not empty message}">
    <div class="alert alert-danger">${message}</div>
  </c:if>
  <form method="POST" action="j_security_check" class="row g-3" style="max-width: 420px;">
    <div class="col-12">
      <label class="form-label">Username</label>
      <input type="text" name="j_username" class="form-control" required>
    </div>
    <div class="col-12">
      <label class="form-label">Password</label>
      <input type="password" name="j_password" class="form-control" required>
    </div>
    <div class="col-12">
      <button type="submit" class="btn btn-primary">Sign in</button>
    </div>
  </form>
</t:pageTemplate>