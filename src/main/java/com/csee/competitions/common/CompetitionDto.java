package com.csee.competitions.common;

import com.csee.competitions.entities.CompetitionStatus;
import java.time.LocalDateTime;

public class CompetitionDto {

    private final Long id;
    private final String title;
    private final String description;
    private final LocalDateTime applicationStart;
    private final LocalDateTime applicationDeadline;
    private final int minParticipants;
    private final int maxParticipants;
    private final boolean internal;
    private final CompetitionStatus status;

    public CompetitionDto(Long id, String title, String description,
                          LocalDateTime applicationStart, LocalDateTime applicationDeadline,
                          int minParticipants, int maxParticipants, boolean internal,
                          CompetitionStatus status) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.applicationStart = applicationStart;
        this.applicationDeadline = applicationDeadline;
        this.minParticipants = minParticipants;
        this.maxParticipants = maxParticipants;
        this.internal = internal;
        this.status = status;
    }

    public Long getId() { return id; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public LocalDateTime getApplicationStart() { return applicationStart; }
    public LocalDateTime getApplicationDeadline() { return applicationDeadline; }
    public int getMinParticipants() { return minParticipants; }
    public int getMaxParticipants() { return maxParticipants; }
    public boolean isInternal() { return internal; }
    public CompetitionStatus getStatus() { return status; }
}