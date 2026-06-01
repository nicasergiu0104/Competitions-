package com.csee.competitions.common;

import com.csee.competitions.entities.ApplicationStatus;
import com.csee.competitions.entities.CompetitionStatus;
import java.time.LocalDateTime;

public class MyApplicationDto {
    private final Long competitionId;
    private final String competitionTitle;
    private final CompetitionStatus competitionStatus;
    private final ApplicationStatus applicationStatus;
    private final Double score;
    private final boolean winner;
    private final LocalDateTime appliedAt;

    public MyApplicationDto(Long competitionId, String competitionTitle, CompetitionStatus competitionStatus,
                            ApplicationStatus applicationStatus, Double score, boolean winner, LocalDateTime appliedAt) {
        this.competitionId = competitionId;
        this.competitionTitle = competitionTitle;
        this.competitionStatus = competitionStatus;
        this.applicationStatus = applicationStatus;
        this.score = score;
        this.winner = winner;
        this.appliedAt = appliedAt;
    }

    public Long getCompetitionId() { return competitionId; }
    public String getCompetitionTitle() { return competitionTitle; }
    public CompetitionStatus getCompetitionStatus() { return competitionStatus; }
    public ApplicationStatus getApplicationStatus() { return applicationStatus; }
    public Double getScore() { return score; }
    public boolean isWinner() { return winner; }
    public LocalDateTime getAppliedAt() { return appliedAt; }
}