package com.csee.competitions.ejb;

import com.csee.competitions.common.CompetitionDto;
import com.csee.competitions.entities.*;
import jakarta.ejb.EJBException;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import com.csee.competitions.common.FieldDefinitionDto;

import java.time.LocalDateTime;


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
                List<Application> apps = entityManager.createQuery(
                                "SELECT a FROM Application a WHERE a.competition.id = :id", Application.class)
                        .setParameter("id", id)
                        .getResultList();
                for (Application a : apps) {
                    entityManager.remove(a);
                }
                entityManager.createQuery("DELETE FROM CompetitionPhoto p WHERE p.competition.id = :id")
                        .setParameter("id", id)
                        .executeUpdate();
                entityManager.flush();
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

    public List<CompetitionDto> findCompetitions(boolean past, String search, String tag, int page, int pageSize) {
        boolean hasTag = tag != null && !tag.isBlank();
        String jpql = "SELECT c FROM Competition c";
        if (hasTag) jpql += " JOIN c.tags t";
        jpql += " WHERE " + dateCondition(past);
        if (search != null && !search.isBlank()) {
            jpql += " AND (LOWER(c.title) LIKE :q OR LOWER(c.description) LIKE :q)";
        }
        if (hasTag) jpql += " AND LOWER(t.name) = LOWER(:tag)";
        jpql += past ? " ORDER BY c.applicationDeadline DESC" : " ORDER BY c.applicationDeadline ASC";

        TypedQuery<Competition> query = entityManager.createQuery(jpql, Competition.class);
        query.setParameter("now", LocalDateTime.now());
        query.setParameter("completed", CompetitionStatus.COMPLETED);
        if (search != null && !search.isBlank()) {
            query.setParameter("q", "%" + search.toLowerCase() + "%");
        }
        if (hasTag) query.setParameter("tag", tag);
        query.setFirstResult(page * pageSize);
        query.setMaxResults(pageSize);

        List<CompetitionDto> dtos = new ArrayList<>();
        for (Competition c : query.getResultList()) {
            dtos.add(toDto(c));
        }
        return dtos;
    }

    public long countCompetitions(boolean past, String search, String tag) {
        boolean hasTag = tag != null && !tag.isBlank();
        String jpql = "SELECT COUNT(DISTINCT c) FROM Competition c";
        if (hasTag) jpql += " JOIN c.tags t";
        jpql += " WHERE " + dateCondition(past);
        if (search != null && !search.isBlank()) {
            jpql += " AND (LOWER(c.title) LIKE :q OR LOWER(c.description) LIKE :q)";
        }
        if (hasTag) jpql += " AND LOWER(t.name) = LOWER(:tag)";

        TypedQuery<Long> query = entityManager.createQuery(jpql, Long.class);
        query.setParameter("now", LocalDateTime.now());
        query.setParameter("completed", CompetitionStatus.COMPLETED);
        if (search != null && !search.isBlank()) {
            query.setParameter("q", "%" + search.toLowerCase() + "%");
        }
        if (hasTag) query.setParameter("tag", tag);
        return query.getSingleResult();
    }

    private String dateCondition(boolean past) {
        return past
                ? "(c.status = :completed OR c.applicationDeadline < :now)"
                : "(c.status <> :completed AND (c.applicationDeadline IS NULL OR c.applicationDeadline >= :now))";
    }

    public List<String> findTagNames(Long competitionId) {
        Competition c = entityManager.find(Competition.class, competitionId);
        List<String> names = new ArrayList<>();
        if (c != null) {
            for (Tag t : c.getTags()) names.add(t.getName());
        }
        return names;
    }

    public List<String> findCategoryNames(Long competitionId) {
        Competition c = entityManager.find(Competition.class, competitionId);
        List<String> names = new ArrayList<>();
        if (c != null) {
            for (Category cat : c.getCategories()) names.add(cat.getName());
        }
        return names;
    }

    public void addTag(Long competitionId, String name) {
        LOG.info("addTag");
        try {
            if (name == null || name.trim().isEmpty()) return;
            String trimmed = name.trim();
            Competition c = entityManager.find(Competition.class, competitionId);
            boolean exists = c.getTags().stream().anyMatch(t -> t.getName().equalsIgnoreCase(trimmed));
            if (!exists) c.getTags().add(findOrCreateTag(trimmed));
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public void removeTag(Long competitionId, String name) {
        LOG.info("removeTag");
        try {
            Competition c = entityManager.find(Competition.class, competitionId);
            c.getTags().removeIf(t -> t.getName().equalsIgnoreCase(name));
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public void addCategory(Long competitionId, String name) {
        LOG.info("addCategory");
        try {
            if (name == null || name.trim().isEmpty()) return;
            String trimmed = name.trim();
            Competition c = entityManager.find(Competition.class, competitionId);
            boolean exists = c.getCategories().stream().anyMatch(cat -> cat.getName().equalsIgnoreCase(trimmed));
            if (!exists) c.getCategories().add(findOrCreateCategory(trimmed));
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public void removeCategory(Long competitionId, String name) {
        LOG.info("removeCategory");
        try {
            Competition c = entityManager.find(Competition.class, competitionId);
            c.getCategories().removeIf(cat -> cat.getName().equalsIgnoreCase(name));
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    private Tag findOrCreateTag(String name) {
        List<Tag> found = entityManager.createQuery(
                        "SELECT t FROM Tag t WHERE LOWER(t.name) = LOWER(:n)", Tag.class)
                .setParameter("n", name).getResultList();
        if (!found.isEmpty()) return found.get(0);
        Tag t = new Tag();
        t.setName(name);
        entityManager.persist(t);
        return t;
    }

    private Category findOrCreateCategory(String name) {
        List<Category> found = entityManager.createQuery(
                        "SELECT c FROM Category c WHERE LOWER(c.name) = LOWER(:n)", Category.class)
                .setParameter("n", name).getResultList();
        if (!found.isEmpty()) return found.get(0);
        Category c = new Category();
        c.setName(name);
        entityManager.persist(c);
        return c;
    }

    public List<String> findAllTagNames() {
        return entityManager.createQuery(
                        "SELECT t.name FROM Tag t ORDER BY t.name", String.class)
                .getResultList();
    }

}