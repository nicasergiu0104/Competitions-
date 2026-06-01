package com.csee.competitions.servlets;

import com.csee.competitions.common.CompetitionDto;
import com.csee.competitions.ejb.CompetitionsBean;
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
import java.util.List;

@DeclareRoles({"DEPARTMENT_REP", "STUDENT"})
@ServletSecurity(httpMethodConstraints = {
        @HttpMethodConstraint(value = "POST", rolesAllowed = {"DEPARTMENT_REP"})
})
@WebServlet(name = "Competitions", value = "/Competitions")
public class Competitions extends HttpServlet {

    private static final int PAGE_SIZE = 6;

    @Inject
    private CompetitionsBean competitionsBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean past = "past".equals(request.getParameter("view"));
        String q = request.getParameter("q");
        int page = parsePage(request.getParameter("page"));

        List<CompetitionDto> competitions = competitionsBean.findCompetitions(past, q, page, PAGE_SIZE);
        long total = competitionsBean.countCompetitions(past, q);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        request.setAttribute("competitions", competitions);
        request.setAttribute("view", past ? "past" : "upcoming");
        request.setAttribute("q", q);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/WEB-INF/pages/competitions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        competitionsBean.deleteCompetition(id);
        response.sendRedirect(request.getContextPath() + "/Competitions");
    }

    private int parsePage(String value) {
        try {
            return Math.max(value == null ? 0 : Integer.parseInt(value), 0);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }
}