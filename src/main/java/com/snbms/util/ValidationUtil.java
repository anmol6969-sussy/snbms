package com.snbms.util;

/**
 * Utility class providing reusable input validation methods
 * used across servlets during form processing.
 */
public class ValidationUtil {

    /**
     * Checks if a string is null or blank.
     * @param value the string to check
     * @return true if null or empty
     */
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Validates an email address format.
     * @param email the email to validate
     * @return true if valid email format
     */
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    /**
     * Validates that a full name contains only letters and spaces.
     * Prevents numeric data in name fields.
     * @param name the full name to validate
     * @return true if valid (letters and spaces only)
     */
    public static boolean isValidFullName(String name) {
        if (isEmpty(name)) return false;
        return name.matches("^[A-Za-z\\s'-]{2,100}$");
    }

    /**
     * Validates a username (alphanumeric, 3-30 characters).
     * @param username the username to validate
     * @return true if valid format
     */
    public static boolean isValidUsername(String username) {
        if (isEmpty(username)) return false;
        return username.matches("^[A-Za-z0-9_]{3,30}$");
    }

    /**
     * Validates password strength (minimum 6 characters).
     * @param password the password to validate
     * @return true if meets minimum requirements
     */
    public static boolean isValidPassword(String password) {
        if (isEmpty(password)) return false;
        return password.length() >= 6;
    }

    /**
     * Checks if two password fields match.
     * @param password original password
     * @param confirmPassword confirmation password
     * @return true if both match
     */
    public static boolean passwordsMatch(String password, String confirmPassword) {
        if (password == null || confirmPassword == null) return false;
        return password.equals(confirmPassword);
    }

    /**
     * Sanitizes a string by trimming whitespace.
     * @param value the string to sanitize
     * @return trimmed string or empty string if null
     */
    public static String sanitize(String value) {
        return value == null ? "" : value.trim();
    }
}
