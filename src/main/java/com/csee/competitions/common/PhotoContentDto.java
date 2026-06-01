package com.csee.competitions.common;

public class PhotoContentDto {
    private final String fileType;
    private final byte[] content;
    public PhotoContentDto(String fileType, byte[] content) { this.fileType = fileType; this.content = content; }
    public String getFileType() { return fileType; }
    public byte[] getContent() { return content; }
}