package com.snbms.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;

/**
 * Utility class for password encryption using SHA-256 hashing.
 * Ensures passwords are never stored in plain text.
 */
public class PasswordUtil {

    /**
     * Encrypts a plain text password using SHA-256 algorithm.
     * @param plainText the raw password entered by the user
     * @return SHA-256 hashed password as a hex string
     */
    public static String encryptPassword(String plainText) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(plainText.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    /**
     * Verifies a plain text password against a stored hashed password.
     * @param plainText the raw password to check
     * @param hashedPassword the stored hashed password
     * @return true if the passwords match, false otherwise
     */
    public static boolean verifyPassword(String plainText, String hashedPassword) {
        if (plainText == null || hashedPassword == null) return false;
        return encryptPassword(plainText).equals(hashedPassword);
    }
}
