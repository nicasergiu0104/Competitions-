package com.csee.competitions.common;

public class PhotoDto {
    private final Long id;
    private final String filename;
    public PhotoDto(Long id, String filename) { this.id = id; this.filename = filename; }
    public Long getId() { return id; }
    public String getFilename() { return filename; }
}