package com.csee.competitions.common;

import com.csee.competitions.entities.ApplicationStatus;
import java.time.LocalDateTime;
import java.util.List;

public class ApplicationDto {
    private final Long id;
    private final String username;
    private final String fullName;
    private final String email;
    private final Integer studyYear;
    private final String studyProgram;
    private final ApplicationStatus status;
    private final LocalDateTime appliedAt;
    private final Double score;
    private final boolean winner;
    private final List<AnswerDto> answers;

    public ApplicationDto(Long id, String username, String fullName, String email,
                          Integer studyYear, String studyProgram, ApplicationStatus status,
                          LocalDateTime appliedAt, Double score, boolean winner, List<AnswerDto> answers) {
        this.id = id;
        this.username = username;
        this.fullName = fullName;
        this.email = email;
        this.studyYear = studyYear;
        this.studyProgram = studyProgram;
        this.status = status;
        this.appliedAt = appliedAt;
        this.score = score;
        this.winner = winner;
        this.answers = answers;
    }

    public Long getId() { return id; }
    public String getUsername() { return username; }
    public String getFullName() { return fullName; }
    public String getEmail() { return email; }
    public Integer getStudyYear() { return studyYear; }
    public String getStudyProgram() { return studyProgram; }
    public ApplicationStatus getStatus() { return status; }
    public LocalDateTime getAppliedAt() { return appliedAt; }
    public Double getScore() { return score; }
    public boolean isWinner() { return winner; }
    public List<AnswerDto> getAnswers() { return answers; }
}