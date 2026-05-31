package com.csee.competitions.servlets;

import com.csee.competitions.ejb.CompetitionsBean;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DbCheck", value = "/db-check")
public class DoCheck extends HttpServlet {

    @Inject
    private CompetitionsBean competitionsBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int count = competitionsBean.findAllCompetitions().size();
        response.setContentType("text/plain");
        response.getWriter().write("Competitions in database: " + count);
    }
}