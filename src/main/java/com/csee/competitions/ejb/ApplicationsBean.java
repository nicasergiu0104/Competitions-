package com.csee.competitions.ejb;
import com.csee.competitions.common.ApplicationDto;
import com.csee.competitions.common.AnswerDto;
import com.csee.competitions.entities.*;
import jakarta.ejb.EJBException;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.ArrayList;
import com.csee.competitions.common.ScoreDto;
import com.csee.competitions.common.MyApplicationDto;
import com.csee.competitions.entities.Competition;
import com.csee.competitions.entities.Tag;
import com.csee.competitions.entities.Category;


@Stateless
public class ApplicationsBean {

    private static final Logger LOG = Logger.getLogger(ApplicationsBean.class.getName());

    // For internal competitions students must use an institutional email — change to your institution's domain
    private static final String INSTITUTIONAL_EMAIL_SUFFIX = "@ulbsibiu.ro";

    @PersistenceContext
    private EntityManager entityManager;

    public ApplicationStatus findStatus(Long competitionId, String username) {
        List<Application> apps = entityManager.createQuery(
                        "SELECT a FROM Application a WHERE a.competition.id = :cid AND a.student.username = :u",
                        Application.class)
                .setParameter("cid", competitionId)
                .setParameter("u", username)
                .getResultList();
        return apps.isEmpty() ? null : apps.get(0).getStatus();
    }

    public void apply(Long competitionId, String username, Map<Long, String> answers) {
        LOG.info("apply");
        try {
            Competition competition = entityManager.find(Competition.class, competitionId);
            User student = findUserByUsername(username);

            if (competition == null || student == null) {
                throw new ApplicationRuleException("Competition or user not found.");
            }

            LocalDateTime now = LocalDateTime.now();
            if (competition.getApplicationStart() != null && now.isBefore(competition.getApplicationStart())) {
                throw new ApplicationRuleException("Applications have not opened yet.");
            }
            if (competition.getApplicationDeadline() != null && now.isAfter(competition.getApplicationDeadline())) {
                throw new ApplicationRuleException("The application deadline has passed.");
            }
            if (competition.isInternal() &&
                    (student.getEmail() == null
                            || !student.getEmail().toLowerCase().endsWith(INSTITUTIONAL_EMAIL_SUFFIX))) {
                throw new ApplicationRuleException(
                        "This is an internal competition — you must use your institutional email.");
            }
            if (findStatus(competitionId, username) != null) {
                throw new ApplicationRuleException("You have already applied to this competition.");
            }

            // validate required questions before creating anything
            for (ApplicationFieldDefinition def : competition.getFieldDefinitions()) {
                if (def.isRequired()) {
                    String value = answers.get(def.getId());
                    if (value == null || value.isBlank()) {
                        throw new ApplicationRuleException("Please fill in the required field: " + def.getLabel());
                    }
                }
            }

            Application application = new Application();
            application.setCompetition(competition);
            application.setStudent(student);
            application.setStatus(ApplicationStatus.APPLIED);
            application.setAppliedAt(now);
            entityManager.persist(application);

            for (ApplicationFieldDefinition def : competition.getFieldDefinitions()) {
                String value = answers.get(def.getId());
                if (value != null && !value.isBlank()) {
                    ApplicationFieldValue afv = new ApplicationFieldValue();
                    afv.setApplication(application);
                    afv.setFieldDefinition(def);
                    afv.setValue(value);
                    entityManager.persist(afv);
                }
            }
        } catch (ApplicationRuleException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    private User findUserByUsername(String username) {
        List<User> users = entityManager.createQuery(
                        "SELECT u FROM User u WHERE u.username = :u", User.class)
                .setParameter("u", username)
                .getResultList();
        return users.isEmpty() ? null : users.get(0);
    }

    public List<ApplicationDto> findApplicationsForCompetition(Long competitionId) {
        LOG.info("findApplicationsForCompetition");
        List<Application> apps = entityManager.createQuery(
                        "SELECT a FROM Application a WHERE a.competition.id = :cid ORDER BY a.appliedAt",
                        Application.class)
                .setParameter("cid", competitionId)
                .getResultList();

        List<ApplicationDto> dtos = new ArrayList<>();
        for (Application a : apps) {
            User s = a.getStudent();
            List<AnswerDto> answers = new ArrayList<>();
            for (ApplicationFieldValue v : a.getFieldValues()) {
                answers.add(new AnswerDto(v.getFieldDefinition().getLabel(), v.getValue()));
            }
            dtos.add(new ApplicationDto(
                    a.getId(), s.getUsername(), s.getFullName(), s.getEmail(),
                    s.getStudyYear(), s.getStudyProgram(), a.getStatus(), a.getAppliedAt(),
                    a.getScore(), a.isWinner(), answers));
        }
        return dtos;
    }

    public void setStatus(Long applicationId, ApplicationStatus status) {
        LOG.info("setStatus");
        try {
            Application a = entityManager.find(Application.class, applicationId);
            if (a != null) {
                a.setStatus(status);
            }
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }
    public void setResult(Long applicationId, Double score, boolean winner) {
        LOG.info("setResult");
        try {
            Application a = entityManager.find(Application.class, applicationId);
            if (a != null) {
                a.setScore(score);
                a.setWinner(winner);
            }
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public List<ScoreDto> findResults(Long competitionId, String currentUsername) {
        List<Application> apps = entityManager.createQuery(
                        "SELECT a FROM Application a WHERE a.competition.id = :cid AND a.score IS NOT NULL " +
                                "ORDER BY a.score DESC", Application.class)
                .setParameter("cid", competitionId)
                .getResultList();
        List<ScoreDto> results = new ArrayList<>();
        for (Application a : apps) {
            boolean mine = currentUsername != null
                    && currentUsername.equals(a.getStudent().getUsername());
            results.add(new ScoreDto(anonCode(a.getId()), a.getScore(), a.isWinner(), mine));
        }
        return results;
    }

    private String anonCode(Long applicationId) {
        int h = ("competitions" + applicationId).hashCode() & 0xFFFF;
        return "Participant " + String.format("%04X", h);
    }

    public void withdraw(Long competitionId, String username) {
        LOG.info("withdraw");
        try {
            List<Application> apps = entityManager.createQuery(
                            "SELECT a FROM Application a WHERE a.competition.id = :cid AND a.student.username = :u",
                            Application.class)
                    .setParameter("cid", competitionId)
                    .setParameter("u", username)
                    .getResultList();
            for (Application a : apps) {
                entityManager.remove(a);
            }
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    public List<MyApplicationDto> findMyApplications(String username) {
        LOG.info("findMyApplications");
        List<Application> apps = entityManager.createQuery(
                        "SELECT a FROM Application a WHERE a.student.username = :u ORDER BY a.appliedAt DESC",
                        Application.class)
                .setParameter("u", username)
                .getResultList();
        List<MyApplicationDto> dtos = new ArrayList<>();
        for (Application a : apps) {
            Competition c = a.getCompetition();
            dtos.add(new MyApplicationDto(
                    c.getId(), c.getTitle(), c.getStatus(),
                    a.getStatus(), a.getScore(), a.isWinner(), a.getAppliedAt()));
        }
        return dtos;
    }


}