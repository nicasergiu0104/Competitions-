package com.csee.competitions.servlets;

import com.csee.competitions.ejb.ApplicationsBean;
import com.csee.competitions.ejb.CompetitionsBean;
import com.csee.competitions.entities.ApplicationStatus;
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
@WebServlet(name = "CompetitionApplicants", value = "/CompetitionApplicants")
public class CompetitionApplicants extends HttpServlet {

    @Inject
    private CompetitionsBean competitionsBean;

    @Inject
    private ApplicationsBean applicationsBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("competition", competitionsBean.findCompetitionById(id));
        request.setAttribute("applications", applicationsBean.findApplicationsForCompetition(id));
        request.setAttribute("scoresPublished", competitionsBean.isScoresPublished(id));
        request.getRequestDispatcher("/WEB-INF/pages/applicants.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long competitionId = Long.parseLong(request.getParameter("competition_id"));
        String action = request.getParameter("action");

        switch (action == null ? "" : action) {
            case "accept" -> applicationsBean.setStatus(
                    Long.parseLong(request.getParameter("application_id")), ApplicationStatus.ACCEPTED);
            case "reject" -> applicationsBean.setStatus(
                    Long.parseLong(request.getParameter("application_id")), ApplicationStatus.REJECTED);
            case "result" -> {
                Long appId = Long.parseLong(request.getParameter("application_id"));
                String scoreStr = request.getParameter("score");
                Double score = (scoreStr == null || scoreStr.isBlank()) ? null : Double.parseDouble(scoreStr);
                boolean winner = request.getParameter("winner") != null;
                applicationsBean.setResult(appId, score, winner);
            }
            case "complete" -> competitionsBean.markComplete(competitionId);
            case "publish" -> competitionsBean.setPublishScores(competitionId, true);
            case "unpublish" -> competitionsBean.setPublishScores(competitionId, false);
            default -> { }
        }

        response.sendRedirect(request.getContextPath() + "/CompetitionApplicants?id=" + competitionId);
    }
}