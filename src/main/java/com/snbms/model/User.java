package com.snbms.model;

import java.util.Date;

public class User {
    private int id;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String role; // "ADMIN", "TEACHER", or "STUDENT"
    private String status; // "Active" or "Inactive"
    private String profileImage;
    private Date joinedDate;
    
    // For view presentation
    private String initials;
    private String avatarColorClass;

    public User() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getJoinedDate() { return joinedDate; }
    public void setJoinedDate(Date joinedDate) { this.joinedDate = joinedDate; }
    
    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }
    
    public String getInitials() { return initials; }
    public void setInitials(String initials) { this.initials = initials; }
    
    public String getAvatarColorClass() { return avatarColorClass; }
    public void setAvatarColorClass(String avatarColorClass) { this.avatarColorClass = avatarColorClass; }
}

