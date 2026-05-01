/* ============================================================
   SNBMS — app.js  — Vanilla JS interactions
   ============================================================ */

document.addEventListener('DOMContentLoaded', function () {

  /* ── 1. Sidebar hamburger toggle ───────────────────────── */
  const toggleBtn = document.getElementById('sidebarToggle');
  const sidebar   = document.getElementById('snbmsSidebar');
  const overlay   = document.getElementById('sidebarOverlay');

  if (toggleBtn && sidebar) {
    toggleBtn.addEventListener('click', function () {
      sidebar.classList.toggle('sidebar-open');
      if (overlay) overlay.classList.toggle('active');
    });
  }

  if (overlay) {
    overlay.addEventListener('click', function () {
      if (sidebar) sidebar.classList.remove('sidebar-open');
      overlay.classList.remove('active');
    });
  }

  /* ── 2. Active sidebar link highlighting ─────────────────── */
  const sidebarLinks = document.querySelectorAll('.sidebar-nav-link');
  const currentPath  = window.location.pathname;

  sidebarLinks.forEach(function (link) {
    const href = link.getAttribute('href');
    if (href && currentPath === href) {
      link.classList.add('active');
    }
  });

  /* ── 3. Live search / filter on notice tables ────────────── */
  const searchInputs = document.querySelectorAll('.search-input');

  searchInputs.forEach(function (input) {
    input.addEventListener('keyup', function () {
      const query    = input.value.toLowerCase().trim();
      const targetId = input.getAttribute('data-target');
      let rows;

      if (targetId) {
        const container = document.getElementById(targetId);
        if (!container) return;
        rows = container.querySelectorAll('[data-search-title]');
      } else {
        rows = document.querySelectorAll('[data-search-title]');
      }

      rows.forEach(function (row) {
        const title = (row.getAttribute('data-search-title') || '').toLowerCase();
        row.style.display = title.includes(query) ? '' : 'none';
      });
    });
  });

  /* ── 4. Delete confirmation modal ────────────────────────── */
  const deleteModal = document.getElementById('deleteConfirmModal');
  const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

  document.querySelectorAll('.btn-confirm-delete').forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      e.preventDefault();
      const url = btn.getAttribute('data-url');
      if (confirmDeleteBtn) {
        confirmDeleteBtn.onclick = function () {
          const form = document.createElement('form');
          form.method = 'POST';
          form.action = url;
          document.body.appendChild(form);
          form.submit();
        };
      }
      if (deleteModal) {
        const bsModal = new bootstrap.Modal(deleteModal);
        bsModal.show();
      }
    });
  });

  /* ── 5. Expiry date validation ───────────────────────────── */
  const expiryDateInput  = document.getElementById('expiryDate');
  const postedDateInput  = document.getElementById('postedDate');
  const expiryDateError  = document.getElementById('expiryDateError');

  if (expiryDateInput && postedDateInput) {
    expiryDateInput.addEventListener('change', function () {
      if (expiryDateInput.value && postedDateInput.value) {
        if (expiryDateInput.value < postedDateInput.value) {
          if (expiryDateError) {
            expiryDateError.style.display = 'block';
            expiryDateError.textContent   = 'Expiry date must be on or after posted date';
          }
          expiryDateInput.value = '';
        } else {
          if (expiryDateError) expiryDateError.style.display = 'none';
        }
      }
    });
  }

  /* ── 6. Notice form inline validation ───────────────────── */
  const noticeForm    = document.getElementById('noticeForm');
  const titleInput    = document.getElementById('noticeTitle');
  const contentInput  = document.getElementById('noticeContent');
  const titleError    = document.getElementById('titleError');
  const contentError  = document.getElementById('contentError');

  if (noticeForm) {
    noticeForm.addEventListener('submit', function (e) {
      let valid = true;

      if (titleInput && titleInput.value.trim().length < 5) {
        valid = false;
        if (titleError) {
          titleError.style.display = 'block';
          titleError.textContent   = 'Title must be at least 5 characters long';
        }
      } else {
        if (titleError) titleError.style.display = 'none';
      }

      if (contentInput && contentInput.value.trim().length < 20) {
        valid = false;
        if (contentError) {
          contentError.style.display = 'block';
          contentError.textContent   = 'Content must be at least 20 characters long';
        }
      } else {
        if (contentError) contentError.style.display = 'none';
      }

      if (!valid) e.preventDefault();
    });
  }

  /* ── 7. Toggle inline add-category form ─────────────────── */
  const addCategoryBtn  = document.getElementById('addCategoryBtn');
  const categoryForm    = document.getElementById('inlineCategoryForm');
  const cancelCategoryBtn = document.getElementById('cancelCategoryBtn');

  if (addCategoryBtn && categoryForm) {
    addCategoryBtn.addEventListener('click', function () {
      categoryForm.classList.toggle('visible');
    });
  }

  if (cancelCategoryBtn && categoryForm) {
    cancelCategoryBtn.addEventListener('click', function () {
      categoryForm.classList.remove('visible');
    });
  }

  /* ── 8. Set today's date for posted date default (new notice) */
  const postedDateField = document.getElementById('postedDate');
  if (postedDateField && !postedDateField.value) {
    const today = new Date();
    const yyyy  = today.getFullYear();
    const mm    = String(today.getMonth() + 1).padStart(2, '0');
    const dd    = String(today.getDate()).padStart(2, '0');
    postedDateField.value = `${yyyy}-${mm}-${dd}`;
  }

  /* ── 9. Student search: client-side live filtering ────────── */
  const studentSearchInput = document.getElementById('studentSearchInput');
  if (studentSearchInput) {
    studentSearchInput.addEventListener('keyup', function () {
      const q = studentSearchInput.value.toLowerCase().trim();
      document.querySelectorAll('[data-search-name]').forEach(function (row) {
        const name  = (row.getAttribute('data-search-name')  || '').toLowerCase();
        const email = (row.getAttribute('data-search-email') || '').toLowerCase();
        row.style.display = (name.includes(q) || email.includes(q)) ? '' : 'none';
      });
    });
  }

});
