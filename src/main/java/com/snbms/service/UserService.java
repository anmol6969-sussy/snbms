package com.snbms.service;

import com.snbms.dao.UserDao;
import com.snbms.model.User;
import com.snbms.util.PasswordUtil;
import com.snbms.util.ValidationUtil;
import java.util.List;

/**
 * Service class encapsulating business logic for user operations.
 * Acts as an intermediary between the Controller (Servlets) and
 * the data access layer (UserDao), following MVC best practices.
 */
public class UserService {

    private UserDao userDao = new UserDao();

    /**
     * Authenticates a user by verifying credentials against the database.
     * Encrypts the plain text password before comparison.
     * @param username the entered username
     * @param plainPassword the entered plain text password
     * @return authenticated User object, or null if credentials are invalid
     */
    public User authenticate(String username, String plainPassword) {
        if (ValidationUtil.isEmpty(username) || ValidationUtil.isEmpty(plainPassword)) {
            return null;
        }
        String hashedPassword = PasswordUtil.encryptPassword(plainPassword);
        return userDao.authenticate(username, hashedPassword);
    }

    /**
     * Registers a new student account with validation.
     * Encrypts the password before storing.
     * @param username desired username
     * @param fullName student's full name
     * @param email student's email address
     * @param plainPassword chosen password
     * @param confirmPassword password confirmation
     * @return error message string, or null if registration was successful
     */
    public String registerStudent(String username, String fullName, String email,
                                   String plainPassword, String confirmPassword) {

        username = ValidationUtil.sanitize(username);
        fullName = ValidationUtil.sanitize(fullName);
        email = ValidationUtil.sanitize(email);

        if (ValidationUtil.isEmpty(fullName)) {
            return "Full name is required.";
        }
        if (!ValidationUtil.isValidFullName(fullName)) {
            return "Full name must contain letters only — no numbers or special characters.";
        }
        if (ValidationUtil.isEmpty(username)) {
            return "Username is required.";
        }
        if (!ValidationUtil.isValidUsername(username)) {
            return "Username must be 3–30 characters, letters and numbers only.";
        }
        if (ValidationUtil.isEmpty(email)) {
            return "Email address is required.";
        }
        if (!ValidationUtil.isValidEmail(email)) {
            return "Please enter a valid email address.";
        }
        if (ValidationUtil.isEmpty(plainPassword)) {
            return "Password is required.";
        }
        if (!ValidationUtil.isValidPassword(plainPassword)) {
            return "Password must be at least 6 characters.";
        }
        if (!ValidationUtil.passwordsMatch(plainPassword, confirmPassword)) {
            return "Passwords do not match.";
        }
        if (userDao.usernameExists(username)) {
            return "That username is already taken. Please choose another.";
        }
        if (userDao.emailExists(email)) {
            return "An account with that email already exists.";
        }

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPassword(PasswordUtil.encryptPassword(plainPassword));
        newUser.setRole("STUDENT");

        boolean created = userDao.createUser(newUser);
        return created ? null : "Registration failed. Please try again.";
    }

    /**
     * Retrieves a user by their ID.
     * @param id the user's database ID
     * @return User object or null if not found
     */
    public User getUserById(int id) {
        return userDao.getUserById(id);
    }

    /**
     * Updates user status (Active/Inactive).
     * @param id the user's ID
     * @param status new status value
     * @return true if update succeeded
     */
    public boolean updateUserStatus(int id, String status) {
        return userDao.updateUserStatus(id, status);
    }

    /**
     * Creates a new user account (admin-initiated, with role specified).
     * Encrypts the password before storing.
     * @param user the User object to persist
     * @return true if creation succeeded
     */
    public boolean createUser(User user) {
        user.setPassword(PasswordUtil.encryptPassword(user.getPassword()));
        return userDao.createUser(user);
    }

    public List<User> getUsers(String search, String status, int page, int pageSize) {
        return userDao.getUsers(search, status, page, pageSize);
    }

    public int countUsers(String search, String status) {
        return userDao.countUsers(search, status);
    }

    public int getTotalStudents() { return userDao.getTotalStudents(); }
    public int getTotalTeachers() { return userDao.getTotalTeachers(); }
    public List<User> getTeachers() { return userDao.getTeachers(); }

    public boolean updateProfile(int id, String fullName, String profileImage) {
        return userDao.updateProfile(id, fullName, profileImage);
    }
}
