package com.csee.competitions.entities;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "competitions")
public class Competition {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(length = 2000)
    private String description;

    private LocalDateTime applicationStart;
    private LocalDateTime applicationDeadline;

    private int minParticipants;
    private int maxParticipants;
    private boolean publishScores;

    public boolean isPublishScores() { return publishScores; }
    public void setPublishScores(boolean publishScores) { this.publishScores = publishScores; }
    private boolean internal;

    @Enumerated(EnumType.STRING)
    private CompetitionStatus status;

    @ManyToMany
    @JoinTable(name = "competition_tags")
    private List<Tag> tags = new ArrayList<>();

    @ManyToMany
    @JoinTable(name = "competition_categories")
    private List<Category> categories = new ArrayList<>();
    @OneToMany(mappedBy = "competition", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ApplicationFieldDefinition> fieldDefinitions = new ArrayList<>();

    public List<ApplicationFieldDefinition> getFieldDefinitions() { return fieldDefinitions; }
    public void setFieldDefinitions(List<ApplicationFieldDefinition> fieldDefinitions) { this.fieldDefinitions = fieldDefinitions; }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public LocalDateTime getApplicationStart() { return applicationStart; }
    public void setApplicationStart(LocalDateTime applicationStart) { this.applicationStart = applicationStart; }

    public LocalDateTime getApplicationDeadline() { return applicationDeadline; }
    public void setApplicationDeadline(LocalDateTime applicationDeadline) { this.applicationDeadline = applicationDeadline; }

    public int getMinParticipants() { return minParticipants; }
    public void setMinParticipants(int minParticipants) { this.minParticipants = minParticipants; }

    public int getMaxParticipants() { return maxParticipants; }
    public void setMaxParticipants(int maxParticipants) { this.maxParticipants = maxParticipants; }

    public boolean isInternal() { return internal; }
    public void setInternal(boolean internal) { this.internal = internal; }

    public CompetitionStatus getStatus() { return status; }
    public void setStatus(CompetitionStatus status) { this.status = status; }

    public List<Tag> getTags() { return tags; }
    public void setTags(List<Tag> tags) { this.tags = tags; }

    public List<Category> getCategories() { return categories; }
    public void setCategories(List<Category> categories) { this.categories = categories; }
}