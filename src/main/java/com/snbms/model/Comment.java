package com.snbms.model;

import java.util.Date;
import java.util.List;

public class Comment {
    private int id;
    private int noticeId;
    private int userId;
    private String content;
    private Integer parentId;
    private Date postedDate;
    
    // View Fields
    private String authorName;
    private String authorRole;
    private String authorImage;
    private String authorInitials;
    private String authorColor;
    
    private List<Comment> replies;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getNoticeId() { return noticeId; }
    public void setNoticeId(int noticeId) { this.noticeId = noticeId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }

    public Date getPostedDate() { return postedDate; }
    public void setPostedDate(Date postedDate) { this.postedDate = postedDate; }

    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    
    public String getAuthorRole() { return authorRole; }
    public void setAuthorRole(String authorRole) { this.authorRole = authorRole; }
    
    public String getAuthorImage() { return authorImage; }
    public void setAuthorImage(String authorImage) { this.authorImage = authorImage; }
    
    public String getAuthorInitials() { return authorInitials; }
    public void setAuthorInitials(String authorInitials) { this.authorInitials = authorInitials; }
    
    public String getAuthorColor() { return authorColor; }
    public void setAuthorColor(String authorColor) { this.authorColor = authorColor; }

    public List<Comment> getReplies() { return replies; }
    public void setReplies(List<Comment> replies) { this.replies = replies; }
}
