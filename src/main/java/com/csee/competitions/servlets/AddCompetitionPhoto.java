package com.csee.competitions.servlets;

import com.csee.competitions.ejb.CompetitionPhotosBean;
import jakarta.annotation.security.DeclareRoles;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.HttpConstraint;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.ServletSecurity;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;

@DeclareRoles({"DEPARTMENT_REP"})
@ServletSecurity(@HttpConstraint(rolesAllowed = {"DEPARTMENT_REP"}))
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
@WebServlet(name = "AddCompetitionPhoto", value = "/AddCompetitionPhoto")
public class AddCompetitionPhoto extends HttpServlet {

    @Inject
    private CompetitionPhotosBean photosBean;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long competitionId = Long.parseLong(request.getParameter("competition_id"));

        if ("delete".equals(request.getParameter("action"))) {
            photosBean.deletePhoto(Long.parseLong(request.getParameter("photo_id")));
        } else {
            Part filePart = request.getPart("photo");
            if (filePart != null && filePart.getSize() > 0) {
                String filename = filePart.getSubmittedFileName();
                String fileType = filePart.getContentType();
                byte[] content = filePart.getInputStream().readAllBytes();
                photosBean.addPhoto(competitionId, filename, fileType, content);
            }
        }

        response.sendRedirect(request.getContextPath() + "/CompetitionDetail?id=" + competitionId);
    }
}