/**
 * Category Management JavaScript
 * Handles interactions for category list and form pages
 */

document.addEventListener('DOMContentLoaded', function() {
    initializeCategoryManagement();
});

function initializeCategoryManagement() {
    // Add fade-in animation
    addFadeInAnimation();
    
    // Setup table interactions
    setupTableInteractions();
    
    // Setup form validation if on form page
    if (document.querySelector('form[action*="/categories/save"]')) {
        setupFormValidation();
        setupAutoCodeGeneration();
    }
    
    // Setup filter interactions if on list page
    if (document.querySelector('.filter-section')) {
        setupFilterInteractions();
    }
}

function addFadeInAnimation() {
    var elements = document.querySelectorAll('.fade-in');
    elements.forEach(function(el, index) {
        setTimeout(function() {
            el.style.opacity = '1';
            el.style.transform = 'translateY(0)';
        }, index * 100);
    });
}

function setupTableInteractions() {
    var tableRows = document.querySelectorAll('.category-table tbody tr');
    tableRows.forEach(function(row) {
        row.addEventListener('mouseenter', function() {
            this.style.backgroundColor = '#f8fafc';
        });
        row.addEventListener('mouseleave', function() {
            this.style.backgroundColor = '';
        });
    });
}

function setupFormValidation() {
    var form = document.querySelector('form[action*="/categories/save"]');
    if (!form) return;

    form.addEventListener('submit', function(e) {
        var code = document.querySelector('input[name="code"]').value.trim();
        var name = document.querySelector('input[name="name"]').value.trim();

        if (!code || !name) {
            e.preventDefault();
            showNotification('Vui lòng điền đầy đủ thông tin bắt buộc!', 'error');
            return false;
        }

        // Validate code format (only letters, numbers, underscore)
        if (!/^[A-Z0-9_]+$/.test(code)) {
            e.preventDefault();
            showNotification('Mã danh mục chỉ được chứa chữ hoa, số và dấu gạch dưới (_)!', 'error');
            return false;
        }

        showNotification('Đang lưu danh mục...', 'info');
    });
}

function setupAutoCodeGeneration() {
    var nameInput = document.querySelector('input[name="name"]');
    var codeInput = document.querySelector('input[name="code"]');
    
    if (nameInput && codeInput && !codeInput.readOnly) {
        nameInput.addEventListener('input', function() {
            if (!codeInput.value) {
                var generatedCode = this.value
                    .toUpperCase()
                    .replace(/[^A-Z0-9\s]/g, '')
                    .replace(/\s+/g, '_')
                    .substring(0, 20);
                codeInput.value = generatedCode;
            }
        });
    }
}

function setupFilterInteractions() {
    // Auto-submit form when filter changes
    var filterSelects = document.querySelectorAll('.filter-select');
    filterSelects.forEach(function(select) {
        select.addEventListener('change', function() {
            // Add loading state
            this.style.opacity = '0.6';
            this.form.submit();
        });
    });
}

function showNotification(message, type) {
    if (!type) type = 'info';
    
    // Remove existing notifications
    var existingNotifications = document.querySelectorAll('.notification');
    existingNotifications.forEach(function(notif) {
        notif.remove();
    });

    // Create notification element
    var notification = document.createElement('div');
    notification.className = 'notification notification-' + type;
    notification.innerHTML = 
        '<div class="notification-content">' +
            '<i class="fas ' + getIconForType(type) + '"></i>' +
            '<span>' + message + '</span>' +
        '</div>' +
        '<button class="notification-close" onclick="this.parentElement.remove()">' +
            '<i class="fas fa-times"></i>' +
        '</button>';

    // Apply styles
    var styles = getStylesForType(type);
    for (var key in styles) {
        notification.style[key] = styles[key];
    }

    // Add to page
    document.body.appendChild(notification);

    // Auto-remove after 5 seconds
    if (type !== 'error') {
        setTimeout(function() {
            if (notification.parentElement) {
                notification.style.opacity = '0';
                setTimeout(function() {
                    if (notification.parentElement) {
                        notification.remove();
                    }
                }, 300);
            }
        }, 5000);
    }
}

function getIconForType(type) {
    var icons = {
        'info': 'fa-info-circle',
        'success': 'fa-check-circle',
        'warning': 'fa-exclamation-triangle',
        'error': 'fa-times-circle'
    };
    return icons[type] || icons.info;
}

function getStylesForType(type) {
    var baseStyle = {
        position: 'fixed',
        top: '20px',
        right: '20px',
        padding: '16px 20px',
        borderRadius: '8px',
        boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)',
        zIndex: '9999',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        minWidth: '300px',
        maxWidth: '500px',
        fontSize: '14px',
        fontWeight: '500',
        transition: 'all 0.3s ease'
    };

    var typeStyles = {
        'info': { background: '#dbeafe', color: '#1e40af', border: '1px solid #93c5fd' },
        'success': { background: '#dcfce7', color: '#166534', border: '1px solid #86efac' },
        'warning': { background: '#fef3c7', color: '#92400e', border: '1px solid #fbbf24' },
        'error': { background: '#fef2f2', color: '#dc2626', border: '1px solid #fca5a5' }
    };

    var result = {};
    for (var key in baseStyle) {
        result[key] = baseStyle[key];
    }
    if (typeStyles[type]) {
        for (var key in typeStyles[type]) {
            result[key] = typeStyles[type][key];
        }
    }
    return result;
} 