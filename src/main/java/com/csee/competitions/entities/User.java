package com.csee.competitions.entities;
import java.util.ArrayList;
import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(nullable = false)
    private String email;

    private String password;
    private String fullName;
    private Integer studyYear;
    private String studyProgram;

    @Column(length = 1000)
    private String bio;

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public Integer getStudyYear() { return studyYear; }
    public void setStudyYear(Integer studyYear) { this.studyYear = studyYear; }

    public String getStudyProgram() { return studyProgram; }
    public void setStudyProgram(String studyProgram) { this.studyProgram = studyProgram; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    @OneToMany(mappedBy = "student")
    private List<Application> applications = new ArrayList<>();

    public List<Application> getApplications() { return applications; }
    public void setApplications(List<Application> applications) { this.applications = applications; }

}