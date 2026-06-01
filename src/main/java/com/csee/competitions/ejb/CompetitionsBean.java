package com.csee.competitions.ejb;

import com.csee.competitions.common.CompetitionDto;
import com.csee.competitions.entities.Competition;
import jakarta.ejb.EJBException;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import com.csee.competitions.common.FieldDefinitionDto;
import com.csee.competitions.entities.ApplicationFieldDefinition;
import com.csee.competitions.entities.Application;
import com.csee.competitions.entities.CompetitionStatus;
@Stateless
public class CompetitionsBean {

    private static final Logger LOG = Logger.getLogger(CompetitionsBean.class.getName());

    @PersistenceContext
    private EntityManager entityManager;

    public List<CompetitionDto> findAllCompetitions() {
        LOG.info("findAllCompetitions");
        try {
            TypedQuery<Competition> query = entityManager.createQuery(
                    "SELECT c FROM Competition c ORDER BY c.applicationDeadline", Competition.class);
            List<CompetitionDto> dtos = new ArrayList<>();
            for (Competition c : query.getResultList()) {
                dtos.add(toDto(c));
            }
            return dtos;
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public CompetitionDto findCompetitionById(Long id) {
        LOG.info("findCompetitionById");
        Competition c = entityManager.find(Competition.class, id);
        return c == null ? null : toDto(c);
    }

    public void createCompetition(CompetitionDto dto) {
        LOG.info("createCompetition");
        try {
            Competition c = new Competition();
            applyDto(c, dto);
            entityManager.persist(c);
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public void updateCompetition(CompetitionDto dto) {
        LOG.info("updateCompetition");
        try {
            Competition c = entityManager.find(Competition.class, dto.getId());
            applyDto(c, dto);
            //  these changes flush to the DB automatically
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    private void applyDto(Competition c, CompetitionDto dto) {
        c.setTitle(dto.getTitle());
        c.setDescription(dto.getDescription());
        c.setApplicationStart(dto.getApplicationStart());
        c.setApplicationDeadline(dto.getApplicationDeadline());
        c.setMinParticipants(dto.getMinParticipants());
        c.setMaxParticipants(dto.getMaxParticipants());
        c.setInternal(dto.isInternal());
        c.setStatus(dto.getStatus());
    }
    public void deleteCompetition(Long id) {
        LOG.info("deleteCompetition");
        try {
            Competition c = entityManager.find(Competition.class, id);
            if (c != null) {
                // remove applications first (each cascades to its answer values)
                List<Application> apps = entityManager.createQuery(
                                "SELECT a FROM Application a WHERE a.competition.id = :id", Application.class)
                        .setParameter("id", id)
                        .getResultList();
                for (Application a : apps) {
                    entityManager.remove(a);
                }
                entityManager.flush(); // make those deletes happen before we remove the competition

                // the competition's field definitions cascade-delete with it
                entityManager.remove(c);
            }
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    private CompetitionDto toDto(Competition c) {
        return new CompetitionDto(
                c.getId(), c.getTitle(), c.getDescription(),
                c.getApplicationStart(), c.getApplicationDeadline(),
                c.getMinParticipants(), c.getMaxParticipants(),
                c.isInternal(), c.getStatus());
    }
    public List<FieldDefinitionDto> findFieldDefinitions(Long competitionId) {
        Competition c = entityManager.find(Competition.class, competitionId);
        List<FieldDefinitionDto> list = new ArrayList<>();
        if (c != null) {
            for (ApplicationFieldDefinition d : c.getFieldDefinitions()) {
                list.add(new FieldDefinitionDto(d.getId(), d.getLabel(), d.getFieldType(), d.isRequired()));
            }
        }
        return list;
    }

    public void addFieldDefinition(Long competitionId, String label, String fieldType, boolean required) {
        try {
            Competition c = entityManager.find(Competition.class, competitionId);
            ApplicationFieldDefinition d = new ApplicationFieldDefinition();
            d.setCompetition(c);
            d.setLabel(label);
            d.setFieldType(fieldType);
            d.setRequired(required);
            c.getFieldDefinitions().add(d);
            entityManager.persist(d);
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public void deleteFieldDefinition(Long fieldDefinitionId) {
        try {
            ApplicationFieldDefinition d = entityManager.find(ApplicationFieldDefinition.class, fieldDefinitionId);
            if (d != null) {
                d.getCompetition().getFieldDefinitions().remove(d);
                entityManager.remove(d);
            }
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }
    public void markComplete(Long id) {
        try {
            Competition c = entityManager.find(Competition.class, id);
            if (c != null) c.setStatus(CompetitionStatus.COMPLETED);
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public void setPublishScores(Long id, boolean publish) {
        try {
            Competition c = entityManager.find(Competition.class, id);
            if (c != null) c.setPublishScores(publish);
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public boolean isScoresPublished(Long id) {
        Competition c = entityManager.find(Competition.class, id);
        return c != null && c.isPublishScores();
    }

}