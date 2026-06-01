package com.csee.competitions.servlets;

import com.csee.competitions.common.CompetitionDto;
import com.csee.competitions.ejb.ApplicationRuleException;
import com.csee.competitions.ejb.ApplicationsBean;
import com.csee.competitions.ejb.CompetitionPhotosBean;
import com.csee.competitions.ejb.CompetitionsBean;
import com.csee.competitions.entities.ApplicationStatus;
import jakarta.annotation.security.DeclareRoles;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.HttpMethodConstraint;
import jakarta.servlet.annotation.ServletSecurity;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@DeclareRoles({"DEPARTMENT_REP", "STUDENT"})
@ServletSecurity(httpMethodConstraints = {
        @HttpMethodConstraint(value = "POST", rolesAllowed = {"STUDENT"})
})
@WebServlet(name = "CompetitionDetail", value = "/CompetitionDetail")
public class CompetitionDetail extends HttpServlet {

    @Inject
    private CompetitionsBean competitionsBean;

    @Inject
    private ApplicationsBean applicationsBean;

    @Inject
    private CompetitionPhotosBean photosBean;


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("competition", competitionsBean.findCompetitionById(id));
        request.setAttribute("fieldDefinitions", competitionsBean.findFieldDefinitions(id));
        request.setAttribute("photos", photosBean.findPhotos(id));
        request.setAttribute("tags", competitionsBean.findTagNames(id));
        request.setAttribute("categories", competitionsBean.findCategoryNames(id));

        if (competitionsBean.isScoresPublished(id)) {
            request.setAttribute("publishedScores", applicationsBean.findResults(id, request.getRemoteUser()));
        }

        String username = request.getRemoteUser();
        if (username != null && request.isUserInRole("STUDENT")) {
            request.setAttribute("applicationStatus", applicationsBean.findStatus(id, username));
        }
        request.getRequestDispatcher("/WEB-INF/pages/competitionDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        String username = request.getRemoteUser();

        if ("withdraw".equals(request.getParameter("action"))) {
            applicationsBean.withdraw(id, username);
            response.sendRedirect(request.getContextPath() + "/CompetitionDetail?id=" + id + "&withdrawn=true");
            return;
        }

        java.util.Map<Long, String> answers = new java.util.HashMap<>();
        for (com.csee.competitions.common.FieldDefinitionDto def : competitionsBean.findFieldDefinitions(id)) {
            answers.put(def.getId(), request.getParameter("field_" + def.getId()));
        }

        try {
            applicationsBean.apply(id, username, answers);
            response.sendRedirect(request.getContextPath() + "/CompetitionDetail?id=" + id + "&applied=true");
        } catch (com.csee.competitions.ejb.ApplicationRuleException ex) {
            request.setAttribute("error", ex.getMessage());
            doGet(request, response);
        }
    }
}