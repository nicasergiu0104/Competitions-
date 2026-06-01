package com.csee.competitions.ejb;

import com.csee.competitions.common.PhotoContentDto;
import com.csee.competitions.common.PhotoDto;
import com.csee.competitions.entities.Competition;
import com.csee.competitions.entities.CompetitionPhoto;
import jakarta.ejb.EJBException;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.List;
import java.util.logging.Logger;

@Stateless
public class CompetitionPhotosBean {

    private static final Logger LOG = Logger.getLogger(CompetitionPhotosBean.class.getName());

    @PersistenceContext
    private EntityManager entityManager;

    public void addPhoto(Long competitionId, String filename, String fileType, byte[] content) {
        LOG.info("addPhoto");
        try {
            Competition c = entityManager.find(Competition.class, competitionId);
            CompetitionPhoto p = new CompetitionPhoto();
            p.setCompetition(c);
            p.setFilename(filename);
            p.setFileType(fileType);
            p.setFileContent(content);
            entityManager.persist(p);
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public List<PhotoDto> findPhotos(Long competitionId) {
        return entityManager.createQuery(
                        "SELECT NEW com.csee.competitions.common.PhotoDto(p.id, p.filename) " +
                                "FROM CompetitionPhoto p WHERE p.competition.id = :cid ORDER BY p.id", PhotoDto.class)
                .setParameter("cid", competitionId)
                .getResultList();
    }

    public PhotoContentDto findPhotoContent(Long photoId) {
        CompetitionPhoto p = entityManager.find(CompetitionPhoto.class, photoId);
        if (p == null) return null;
        return new PhotoContentDto(p.getFileType(), p.getFileContent());
    }

    public void deletePhoto(Long photoId) {
        LOG.info("deletePhoto");
        try {
            CompetitionPhoto p = entityManager.find(CompetitionPhoto.class, photoId);
            if (p != null) entityManager.remove(p);
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }
}