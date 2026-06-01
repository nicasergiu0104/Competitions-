package com.csee.competitions.servlets;

import com.csee.competitions.common.CompetitionDto;
import com.csee.competitions.ejb.CompetitionsBean;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "Competitions", value = "/Competitions")
public class Competitions extends HttpServlet {

    @Inject
    private CompetitionsBean competitionsBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<CompetitionDto> competitions = competitionsBean.findAllCompetitions();
        request.setAttribute("competitions", competitions);
        request.getRequestDispatcher("/WEB-INF/pages/competitions.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        competitionsBean.deleteCompetition(id);
        response.sendRedirect(request.getContextPath() + "/Competitions");
    }


}