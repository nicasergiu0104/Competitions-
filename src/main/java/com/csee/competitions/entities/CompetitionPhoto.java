package com.csee.competitions.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "competition_photos")
public class CompetitionPhoto {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "competition_id")
    private Competition competition;

    private String filename;
    private String fileType;

    @Lob
    @Column(columnDefinition = "LONGBLOB")
    private byte[] fileContent;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Competition getCompetition() { return competition; }
    public void setCompetition(Competition competition) { this.competition = competition; }

    public String getFilename() { return filename; }
    public void setFilename(String filename) { this.filename = filename; }

    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }

    public byte[] getFileContent() { return fileContent; }
    public void setFileContent(byte[] fileContent) { this.fileContent = fileContent; }
}