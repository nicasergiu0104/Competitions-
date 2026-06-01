package com.csee.competitions.common;

public class UserDto {
    private final String username;
    private final String email;
    private final String fullName;
    private final Integer studyYear;
    private final String studyProgram;
    private final String bio;

    public UserDto(String username, String email, String fullName,
                   Integer studyYear, String studyProgram, String bio) {
        this.username = username;
        this.email = email;
        this.fullName = fullName;
        this.studyYear = studyYear;
        this.studyProgram = studyProgram;
        this.bio = bio;
    }

    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getFullName() { return fullName; }
    public Integer getStudyYear() { return studyYear; }
    public String getStudyProgram() { return studyProgram; }
    public String getBio() { return bio; }
}