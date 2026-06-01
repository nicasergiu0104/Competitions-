package com.csee.competitions.servlets;

import com.csee.competitions.ejb.CompetitionsBean;
import jakarta.annotation.security.DeclareRoles;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.ServletSecurity;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@DeclareRoles({"DEPARTMENT_REP"})
@ServletSecurity(@HttpConstraint(rolesAllowed = {"DEPARTMENT_REP"}))
@WebServlet(name = "CompetitionTags", value = "/CompetitionTags")
public class CompetitionTags extends HttpServlet {

    @Inject
    private CompetitionsBean competitionsBean;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long competitionId = Long.parseLong(request.getParameter("competition_id"));
        boolean isCategory = "category".equals(request.getParameter("kind"));
        boolean isDelete = "delete".equals(request.getParameter("action"));
        String name = request.getParameter("name");

        if (isCategory) {
            if (isDelete) competitionsBean.removeCategory(competitionId, name);
            else competitionsBean.addCategory(competitionId, name);
        } else {
            if (isDelete) competitionsBean.removeTag(competitionId, name);
            else competitionsBean.addTag(competitionId, name);
        }

        response.sendRedirect(request.getContextPath() + "/CompetitionDetail?id=" + competitionId);
    }
}