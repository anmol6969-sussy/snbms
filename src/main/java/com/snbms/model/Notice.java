package com.snbms.model;

import java.text.SimpleDateFormat;
import java.util.Date;

public class Notice {
    private int id;
    private String title;
    private String content;
    private String imageUrl;
    private int categoryId;
    private String status; // "Published" or "Draft" or "Active" or "Inactive"
    private Date postedDate;
    private Date expiryDate;
    private boolean isPinned;
    private int authorId;
    
    // For view presentation
    private String categoryName;
    private String categoryBadgeClass;
    private String statusBadgeClass;
    private String authorName;

    public Notice() {}
    
    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Date getPostedDate() { return postedDate; }
    public void setPostedDate(Date postedDate) { this.postedDate = postedDate; }
    
    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }
    
    public boolean getIsPinned() { return isPinned; }
    public void setIsPinned(boolean isPinned) { this.isPinned = isPinned; }
    
    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }
    
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    
    public String getCategoryBadgeClass() { return categoryBadgeClass; }
    public void setCategoryBadgeClass(String categoryBadgeClass) { this.categoryBadgeClass = categoryBadgeClass; }
    
    public String getStatusBadgeClass() { return statusBadgeClass; }
    public void setStatusBadgeClass(String statusBadgeClass) { this.statusBadgeClass = statusBadgeClass; }
    
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    
    public String getPostedDateStr() {
        return postedDate != null ? sdf.format(postedDate) : "";
    }
    
    public String getExpiryDateStr() {
        return expiryDate != null ? sdf.format(expiryDate) : null;
    }
}

