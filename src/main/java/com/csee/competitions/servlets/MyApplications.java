package com.csee.competitions.servlets;

import com.csee.competitions.ejb.ApplicationsBean;
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

@DeclareRoles({"STUDENT"})
@ServletSecurity(@HttpConstraint(rolesAllowed = {"STUDENT"}))
@WebServlet(name = "MyApplications", value = "/MyApplications")
public class MyApplications extends HttpServlet {

    @Inject
    private ApplicationsBean applicationsBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("applications", applicationsBean.findMyApplications(request.getRemoteUser()));
        request.getRequestDispatcher("/WEB-INF/pages/myApplications.jsp").forward(request, response);
    }
}