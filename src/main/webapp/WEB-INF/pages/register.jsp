<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<t:pageTemplate pageTitle="Register">

  <style>
    .auth-card { max-width: 440px; }
    .auth-brand { display:inline-flex; align-items:center; gap:.5rem; font-family:'Bricolage Grotesque',sans-serif; font-weight:800; letter-spacing:.04em; text-transform:uppercase; font-size:.8rem; color: var(--ink-soft); }
    .auth-brand::before { content:""; width:.65rem; height:.65rem; border-radius:.18rem; background: var(--coral); transform: rotate(12deg); }
    .section-label { font-family:'Bricolage Grotesque', sans-serif; font-weight:800; letter-spacing:-.02em; }
  </style>

  <div class="card auth-card mx-auto mt-4">
    <div class="card-body p-4 p-md-5">
      <div class="auth-brand mb-3">CSEE Competitions</div>
      <h1 class="section-label mb-1">Create your account</h1>
      <p class="text-muted small mb-4">Student registration</p>

      <form method="POST" action="${pageContext.request.contextPath}/Register" class="row g-3">
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
        <div class="col-12 d-grid">
          <button type="submit" class="btn btn-primary btn-lg">Register</button>
        </div>
      </form>

      <p class="text-muted small text-center mt-4 mb-0">
        Already have an account?
        <a href="${pageContext.request.contextPath}/Login" class="fw-semibold">Sign in</a>
      </p>
    </div>
  </div>
</t:pageTemplate>