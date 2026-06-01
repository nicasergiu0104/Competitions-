<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:pageTemplate pageTitle="Login">

  <style>
    .auth-card { max-width: 440px; }
    .auth-brand { display:inline-flex; align-items:center; gap:.5rem; font-family:'Bricolage Grotesque',sans-serif; font-weight:800; letter-spacing:.04em; text-transform:uppercase; font-size:.8rem; color: var(--ink-soft); }
    .auth-brand::before { content:""; width:.65rem; height:.65rem; border-radius:.18rem; background: var(--coral); transform: rotate(12deg); }
    .section-label { font-family:'Bricolage Grotesque', sans-serif; font-weight:800; letter-spacing:-.02em; }
  </style>

  <div class="card auth-card mx-auto mt-4">
    <div class="card-body p-4 p-md-5">
      <div class="auth-brand mb-3">CSEE Competitions</div>
      <h1 class="section-label mb-4">Welcome back</h1>

      <c:if test="${not empty message}">
        <div class="alert alert-danger">${message}</div>
      </c:if>

      <form method="POST" action="j_security_check" class="row g-3">
        <div class="col-12">
          <label class="form-label">Username</label>
          <input type="text" name="j_username" class="form-control" required>
        </div>
        <div class="col-12">
          <label class="form-label">Password</label>
          <input type="password" name="j_password" class="form-control" required>
        </div>
        <div class="col-12 d-grid">
          <button type="submit" class="btn btn-primary btn-lg">Sign in</button>
        </div>
      </form>

      <p class="text-muted small text-center mt-4 mb-0">
        Don't have an account?
        <a href="${pageContext.request.contextPath}/Register" class="fw-semibold">Register</a>
      </p>
    </div>
  </div>
</t:pageTemplate>