package com.csee.competitions.ejb;

import com.csee.competitions.common.UserDto;
import com.csee.competitions.entities.User;
import com.csee.competitions.entities.UserGroup;
import jakarta.ejb.EJBException;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import java.util.Collection;
import java.util.List;
import java.util.logging.Logger;

@Stateless
public class UsersBean {

    private static final Logger LOG = Logger.getLogger(UsersBean.class.getName());

    @PersistenceContext
    private EntityManager entityManager;

    @Inject
    private PasswordBean passwordBean;

    public void createUser(String username, String email, String password, Collection<String> groups) {
        LOG.info("createUser");
        try {
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(passwordBean.convertToSha256(password));
            entityManager.persist(user);

            for (String group : groups) {
                UserGroup ug = new UserGroup();
                ug.setUsername(username);
                ug.setUserGroup(group);
                entityManager.persist(ug);
            }
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }
    public UserDto findProfile(String username) {
        User u = findByUsername(username);
        if (u == null) return null;
        return new UserDto(u.getUsername(), u.getEmail(), u.getFullName(),
                u.getStudyYear(), u.getStudyProgram(), u.getBio());
    }

    public void updateProfile(String username, String email, String fullName,
                              Integer studyYear, String studyProgram, String bio) {
        try {
            User u = findByUsername(username);
            if (u != null) {
                u.setEmail(email);
                u.setFullName(fullName);
                u.setStudyYear(studyYear);
                u.setStudyProgram(studyProgram);
                u.setBio(bio);
            }
        } catch (Exception ex) {
            throw new EJBException(ex);
        }
    }

    private User findByUsername(String username) {
        List<User> users = entityManager.createQuery(
                        "SELECT u FROM User u WHERE u.username = :u", User.class)
                .setParameter("u", username)
                .getResultList();
        return users.isEmpty() ? null : users.get(0);
    }


}