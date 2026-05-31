package com.csee.competitions.ejb;

import com.csee.competitions.entities.Competition;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.logging.Logger;

@Stateless
public class CompetitionsBean {

    private static final Logger LOG = Logger.getLogger(CompetitionsBean.class.getName());

    @PersistenceContext
    private EntityManager entityManager;

    public List<Competition> findAllCompetitions() {
        LOG.info("findAllCompetitions");
        TypedQuery<Competition> query =
                entityManager.createQuery("SELECT c FROM Competition c", Competition.class);
        return query.getResultList();
    }
}