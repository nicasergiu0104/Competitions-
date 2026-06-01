package com.csee.competitions.servlets;

import com.csee.competitions.common.PhotoContentDto;
import com.csee.competitions.ejb.CompetitionPhotosBean;
import jakarta.inject.Inject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "CompetitionPhotoServlet", value = "/CompetitionPhoto")
public class CompetitionPhotoServlet extends HttpServlet {

    @Inject
    private CompetitionPhotosBean photosBean;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        PhotoContentDto photo = photosBean.findPhotoContent(id);
        if (photo == null || photo.getContent() == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        response.setContentType(photo.getFileType() != null ? photo.getFileType() : "application/octet-stream");
        response.getOutputStream().write(photo.getContent());
    }
}