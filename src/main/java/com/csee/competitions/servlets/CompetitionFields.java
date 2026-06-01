package com.csee.competitions.servlets;

import com.csee.competitions.ejb.CompetitionsBean;
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

@DeclareRoles({"DEPARTMENT_REP"})
@ServletSecurity(@HttpConstraint(rolesAllowed = {"DEPARTMENT_REP"}))
@WebServlet(name = "CompetitionFields", value = "/CompetitionFields")
public class CompetitionFields extends HttpServlet {

    @Inject
    private CompetitionsBean competitionsBean;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long competitionId = Long.parseLong(request.getParameter("competition_id"));
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            Long fieldId = Long.parseLong(request.getParameter("field_id"));
            competitionsBean.deleteFieldDefinition(fieldId);
        } else {
            String label = request.getParameter("label");
            String fieldType = request.getParameter("field_type");
            boolean required = request.getParameter("required") != null;
            competitionsBean.addFieldDefinition(competitionId, label, fieldType, required);
        }

        response.sendRedirect(request.getContextPath() + "/CompetitionDetail?id=" + competitionId);
    }
}