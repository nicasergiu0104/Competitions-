package com.csee.competitions.ejb;

import jakarta.ejb.ApplicationException;

@ApplicationException(rollback = true)
public class ApplicationRuleException extends RuntimeException {
    public ApplicationRuleException(String message) {
        super(message);
    }
}