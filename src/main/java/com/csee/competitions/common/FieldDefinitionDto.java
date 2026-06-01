package com.csee.competitions.common;

public class FieldDefinitionDto {
    private final Long id;
    private final String label;
    private final String fieldType;
    private final boolean required;

    public FieldDefinitionDto(Long id, String label, String fieldType, boolean required) {
        this.id = id;
        this.label = label;
        this.fieldType = fieldType;
        this.required = required;
    }

    public Long getId() { return id; }
    public String getLabel() { return label; }
    public String getFieldType() { return fieldType; }
    public boolean isRequired() { return required; }
}