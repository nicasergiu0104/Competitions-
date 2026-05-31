package com.csee.competitions.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "application_field_values")
public class ApplicationFieldValue {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "application_id")
    private Application application;

    @ManyToOne(optional = false)
    @JoinColumn(name = "field_definition_id")
    private ApplicationFieldDefinition fieldDefinition;

    @Column(length = 2000)
    private String value;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Application getApplication() { return application; }
    public void setApplication(Application application) { this.application = application; }

    public ApplicationFieldDefinition getFieldDefinition() { return fieldDefinition; }
    public void setFieldDefinition(ApplicationFieldDefinition fieldDefinition) { this.fieldDefinition = fieldDefinition; }

    public String getValue() { return value; }
    public void setValue(String value) { this.value = value; }
}