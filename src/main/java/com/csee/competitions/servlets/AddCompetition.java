package com.csee.competitions.servlets;
import jakarta.annotation.security.DeclareRoles;
import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.ServletSecurity;
import com.csee.competitions.common.CompetitionDto;
import com.csee.competitions.ejb.CompetitionsBean;
import com.csee.competitions.entities.CompetitionStatus;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDateTime;
@DeclareRoles({"DEPARTMENT_REP"})
@ServletSecurity(@HttpConstraint(rolesAllowed = {"DEPARTMENT_REP"}))
@WebServlet(name = "AddCompetition", value = "/AddCompetition")
public class AddCompetition extends HttpServlet {



    @Inject
    private CompetitionsBean competitionsBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("statuses", CompetitionStatus.values());
        request.getRequestDispatcher("/WEB-INF/pages/addCompetition.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        LocalDateTime start = parseDateTime(request.getParameter("application_start"));
        LocalDateTime deadline = parseDateTime(request.getParameter("application_deadline"));
        int min = parseIntOrZero(request.getParameter("min_participants"));
        int max = parseIntOrZero(request.getParameter("max_participants"));
        boolean internal = request.getParameter("internal") != null;
        CompetitionStatus status = CompetitionStatus.valueOf(request.getParameter("status"));

        CompetitionDto dto = new CompetitionDto(null, title, description, start, deadline,
                min, max, internal, status);
        competitionsBean.createCompetition(dto);

        response.sendRedirect(request.getContextPath() + "/Competitions");
    }

    private LocalDateTime parseDateTime(String value) {
        return (value == null || value.isBlank()) ? null : LocalDateTime.parse(value);
    }

    private int parseIntOrZero(String value) {
        return (value == null || value.isBlank()) ? 0 : Integer.parseInt(value);
    }
}