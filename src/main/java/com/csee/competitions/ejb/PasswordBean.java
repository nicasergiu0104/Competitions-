package com.csee.competitions.ejb;

import jakarta.ejb.Stateless;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;

@Stateless
public class PasswordBean {

    private static final Logger LOG = Logger.getLogger(PasswordBean.class.getName());

    public String convertToSha256(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hex = new StringBuilder();
            for (byte b : hash) {
                String h = Integer.toHexString(0xff & b);
                if (h.length() == 1) hex.append('0');
                hex.append(h);
            }
            return hex.toString();
        } catch (NoSuchAlgorithmException ex) {
            LOG.log(Level.SEVERE, "Could not hash password", ex);
            return null;
        }
    }
}