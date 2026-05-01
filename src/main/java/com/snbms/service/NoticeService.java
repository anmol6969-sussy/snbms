package com.snbms.service;

import com.snbms.dao.NoticeDao;
import com.snbms.dao.CategoryDao;
import com.snbms.model.Notice;
import com.snbms.model.Category;
import com.snbms.util.ValidationUtil;
import java.util.List;

/**
 * Service class encapsulating business logic for notice operations.
 * Sits between the Controller (Servlets) and the data access layer (NoticeDao),
 * handling validation and coordinating data operations.
 */
public class NoticeService {

    private NoticeDao noticeDao = new NoticeDao();
    private CategoryDao categoryDao = new CategoryDao();

    /**
     * Retrieves all published notices for student view,
     * optionally filtered by pinned status, category, and search term.
     * @param pinned true for pinned notices only
     * @param categoryId optional category filter
     * @param searchQuery optional search keyword
     * @return list of matching Notice objects
     */
    public List<Notice> getStudentNotices(boolean pinned, String categoryId, String searchQuery) {
        return noticeDao.getStudentNotices(pinned, categoryId, searchQuery);
    }

    /**
     * Retrieves all notices for admin view with pagination and filters.
     * @param search optional search term
     * @param categoryId optional category filter
     * @param status optional status filter (Published/Draft)
     * @param page current page number
     * @param pageSize number of records per page
     * @return list of Notice objects for the current page
     */
    public List<Notice> getAdminNotices(String search, String categoryId,
                                         String status, int page, int pageSize) {
        return noticeDao.getNotices(search, categoryId, status, page, pageSize, null);
    }

    /**
     * Counts total notices matching the given filters (used for pagination).
     */
    public int countAdminNotices(String search, String categoryId, String status) {
        return noticeDao.countNotices(search, categoryId, status, null);
    }

    /**
     * Retrieves a single notice by its ID.
     * @param id the notice ID
     * @return Notice object or null if not found
     */
    public Notice getNoticeById(int id) {
        return noticeDao.getNoticeById(id);
    }

    /**
     * Saves a new or updated notice after validation.
     * Uses NoticeDao.saveNotice() which handles both insert and update.
     * @param notice the Notice object to save
     * @return error message string, or null if save was successful
     */
    public String saveNotice(Notice notice) {
        if (ValidationUtil.isEmpty(notice.getTitle())) {
            return "Notice title is required.";
        }
        if (ValidationUtil.isEmpty(notice.getContent())) {
            return "Notice content is required.";
        }
        if (notice.getPostedDate() == null) {
            return "Posted date is required.";
        }
        return noticeDao.saveNotice(notice) ? null : "Failed to save notice. Please try again.";
    }

    /**
     * Deletes a notice by its ID.
     * @param id the notice ID to delete
     * @return true if deletion succeeded
     */
    public boolean deleteNotice(int id) {
        return noticeDao.deleteNotice(id);
    }

    /**
     * Retrieves all available categories.
     * @return list of Category objects
     */
    public List<Category> getAllCategories() {
        return categoryDao.getAllCategories();
    }

    /**
     * Retrieves recent notices up to a given limit (for dashboard widgets).
     * @param limit max number of notices to return
     * @return list of recent Notice objects
     */
    public List<Notice> getRecentNotices(int limit) {
        return noticeDao.getRecentNotices(limit);
    }

    /**
     * Returns the total count of notices (for dashboard stats).
     */
    public int getTotalNotices() {
        return noticeDao.getTotalNotices();
    }
}
