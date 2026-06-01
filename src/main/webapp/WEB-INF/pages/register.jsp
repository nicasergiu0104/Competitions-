<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<t:pageTemplate pageTitle="Register">
  <h1 class="mb-4">Create a student account</h1>
  <form method="POST" action="${pageContext.request.contextPath}/Register"
        class="row g-3" style="max-width: 420px;">
    <div class="col-12">
      <label class="form-label">Username</label>
      <input type="text" name="username" class="form-control" required>
    </div>
    <div class="col-12">
      <label class="form-label">Email</label>
      <input type="email" name="email" class="form-control" required>
    </div>
    <div class="col-12">
      <label class="form-label">Password</label>
      <input type="password" name="password" class="form-control" required>
    </div>
    <div class="col-12">
      <button type="submit" class="btn btn-primary">Register</button>
    </div>
  </form>
</t:pageTemplate>