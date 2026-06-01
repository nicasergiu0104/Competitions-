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
import com.csee.competitions.common.ApplicationDto;
import com.csee.competitions.common.AnswerDto;
import com.csee.competitions.common.CompetitionDto;
import com.csee.competitions.common.FieldDefinitionDto;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@DeclareRoles({"DEPARTMENT_REP"})
@ServletSecurity(@HttpConstraint(rolesAllowed = {"DEPARTMENT_REP"}))
@WebServlet(name = "CompetitionApplicants", value = "/CompetitionApplicants")
public class CompetitionApplicants extends HttpServlet {

    @Inject
    private CompetitionsBean competitionsBean;

    @Inject
    private ApplicationsBean applicationsBean;
    private void exportCsv(Long competitionId, HttpServletResponse response) throws IOException {
        CompetitionDto competition = competitionsBean.findCompetitionById(competitionId);
        List<ApplicationDto> applications = applicationsBean.findApplicationsForCompetition(competitionId);
        List<FieldDefinitionDto> fields = competitionsBean.findFieldDefinitions(competitionId);

        response.setContentType("text/csv;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        String safeTitle = (competition == null ? "competition"
                : competition.getTitle()).replaceAll("[^a-zA-Z0-9-_]", "_");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"applicants_" + safeTitle + ".csv\"");

        PrintWriter out = response.getWriter();
        out.write('\uFEFF'); // BOM so Excel detects UTF-8

        StringBuilder header = new StringBuilder();
        header.append(csv("Username")).append(',')
                .append(csv("Full Name")).append(',')
                .append(csv("Email")).append(',')
                .append(csv("Study Program")).append(',')
                .append(csv("Study Year")).append(',')
                .append(csv("Status")).append(',')
                .append(csv("Applied At")).append(',')
                .append(csv("Score")).append(',')
                .append(csv("Winner"));
        for (FieldDefinitionDto f : fields) {
            header.append(',').append(csv(f.getLabel()));
        }
        out.print(header + "\r\n");

        for (ApplicationDto app : applications) {
            Map<String, String> answers = new HashMap<>();
            if (app.getAnswers() != null) {
                for (AnswerDto a : app.getAnswers()) {
                    answers.put(a.getLabel(), a.getValue());
                }
            }
            StringBuilder row = new StringBuilder();
            row.append(csv(app.getUsername())).append(',')
                    .append(csv(app.getFullName())).append(',')
                    .append(csv(app.getEmail())).append(',')
                    .append(csv(app.getStudyProgram())).append(',')
                    .append(csv(app.getStudyYear() == null ? "" : app.getStudyYear().toString())).append(',')
                    .append(csv(app.getStatus() == null ? "" : app.getStatus().name())).append(',')
                    .append(csv(app.getAppliedAt() == null ? "" : app.getAppliedAt().toString())).append(',')
                    .append(csv(app.getScore() == null ? "" : app.getScore().toString())).append(',')
                    .append(csv(app.isWinner() ? "Yes" : "No"));
            for (FieldDefinitionDto f : fields) {
                row.append(',').append(csv(answers.getOrDefault(f.getLabel(), "")));
            }
            out.print(row + "\r\n");
        }
        out.flush();
    }

    private String csv(String value) {
        if (value == null) return "\"\"";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));

        if ("csv".equals(request.getParameter("export"))) {
            exportCsv(id, response);
            return;
        }

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