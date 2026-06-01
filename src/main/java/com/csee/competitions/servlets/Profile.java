package com.csee.competitions.servlets;

import com.csee.competitions.ejb.UsersBean;
import jakarta.annotation.security.DeclareRoles;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.ServletSecurity;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@DeclareRoles({"STUDENT", "DEPARTMENT_REP"})
@ServletSecurity(@HttpConstraint(rolesAllowed = {"STUDENT", "DEPARTMENT_REP"}))
@WebServlet(name = "Profile", value = "/Profile")
public class Profile extends HttpServlet {

    @Inject
    private UsersBean usersBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("profile", usersBean.findProfile(request.getRemoteUser()));
        request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String email = request.getParameter("email");
        String fullName = request.getParameter("full_name");
        String studyProgram = request.getParameter("study_program");
        String bio = request.getParameter("bio");
        Integer studyYear = parseIntOrNull(request.getParameter("study_year"));

        usersBean.updateProfile(request.getRemoteUser(), email, fullName, studyYear, studyProgram, bio);
        response.sendRedirect(request.getContextPath() + "/Profile?saved=true");
    }

    private Integer parseIntOrNull(String value) {
        return (value == null || value.isBlank()) ? null : Integer.parseInt(value);
    }
}