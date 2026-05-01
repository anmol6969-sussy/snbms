package com.snbms.model;

public class Category {
    private int id;
    private String name;
    private String description;
    
    // For view presentation
    private int noticeCount;
    private boolean hasNotices;
    private String badgeClass;

    public Category() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public int getNoticeCount() { return noticeCount; }
    public void setNoticeCount(int noticeCount) { this.noticeCount = noticeCount; }
    
    public boolean isHasNotices() { return hasNotices; }
    public void setHasNotices(boolean hasNotices) { this.hasNotices = hasNotices; }
    
    public String getBadgeClass() { return badgeClass; }
    public void setBadgeClass(String badgeClass) { this.badgeClass = badgeClass; }
}

