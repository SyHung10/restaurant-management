// Manager Menu Management JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize page
    initializeMenuManagement();
});

function initializeMenuManagement() {
    // Add fade-in animation to elements
    addFadeInAnimation();
    
    // Setup table interactions
    setupTableInteractions();
    
    // Setup filter interactions
    setupFilterInteractions();
    
    // Setup status change confirmations
    setupStatusChangeConfirmations();
    
    console.log('Manager Menu Management initialized');
}

// Fade in animation for elements
function addFadeInAnimation() {
    const elements = document.querySelectorAll('.fade-in');
    elements.forEach((element, index) => {
        setTimeout(() => {
            element.style.opacity = '0';
            element.style.transform = 'translateY(20px)';
            element.style.transition = 'all 0.5s ease';
            
            setTimeout(() => {
                element.style.opacity = '1';
                element.style.transform = 'translateY(0)';
            }, 50);
        }, index * 100);
    });
}

// Table interactions
function setupTableInteractions() {
    // Enhanced hover effects for table rows
    const tableRows = document.querySelectorAll('.menu-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('mouseenter', function() {
            this.style.boxShadow = '0 4px 12px rgba(80, 120, 200, 0.15)';
            this.style.transform = 'translateY(-1px)';
        });
        
        row.addEventListener('mouseleave', function() {
            this.style.boxShadow = '';
            this.style.transform = '';
        });
    });
    
    // Image hover effects
    const menuImages = document.querySelectorAll('.menu-image');
    menuImages.forEach(img => {
        img.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.15)';
            this.style.zIndex = '10';
            this.style.boxShadow = '0 8px 24px rgba(0, 0, 0, 0.3)';
        });
        
        img.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
            this.style.zIndex = '';
            this.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.1)';
        });
    });
}

// Filter interactions
function setupFilterInteractions() {
    const filterForm = document.querySelector('.filter-row form');
    const filterInputs = filterForm.querySelectorAll('input, select');
    
    // Auto-submit form when filter changes (except for text inputs)
    filterInputs.forEach(input => {
        if (input.type !== 'date' && input.type !== 'text') {
            input.addEventListener('change', function() {
                // Add loading state
                addLoadingState();
                filterForm.submit();
            });
        }
    });
    
    // Debounced submit for date inputs
    let dateTimeout;
    const dateInputs = filterForm.querySelectorAll('input[type="date"]');
    dateInputs.forEach(input => {
        input.addEventListener('change', function() {
            clearTimeout(dateTimeout);
            dateTimeout = setTimeout(() => {
                addLoadingState();
                filterForm.submit();
            }, 500);
        });
    });
}

// Status change confirmations
function setupStatusChangeConfirmations() {
    const statusSelects = document.querySelectorAll('select[name="newStatus"]');
    statusSelects.forEach(select => {
        select.addEventListener('change', function() {
            const menuName = this.closest('tr').querySelector('td:nth-child(2) div').textContent.trim();
            const newStatus = this.value === 'AVAILABLE' ? 'đang bán' : 'tạm ngưng';
            
            if (confirm(`Bạn có chắc chắn muốn chuyển món "${menuName}" sang trạng thái ${newStatus}?`)) {
                addLoadingState();
                this.closest('form').submit();
            } else {
                // Reset to previous value
                this.value = this.value === 'AVAILABLE' ? 'UNAVAILABLE' : 'AVAILABLE';
            }
        });
    });
}

// Add loading state to page
function addLoadingState() {
    const table = document.querySelector('.menu-table');
    if (table) {
        table.classList.add('loading');
    }
    
    // Show loading message
    showNotification('Đang xử lý...', 'info');
}

// Show notification
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existingNotifications = document.querySelectorAll('.notification');
    existingNotifications.forEach(notif => notif.remove());
    
    // Create notification
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${getIconForType(type)}"></i>
            <span>${message}</span>
        </div>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 1000;
        padding: 12px 20px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        color: white;
        font-weight: 500;
        transform: translateX(100%);
        transition: transform 0.3s ease;
        ${getStylesForType(type)}
    `;
    
    document.body.appendChild(notification);
    
    // Animate in
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    // Auto remove
    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 3000);
}

function getIconForType(type) {
    switch(type) {
        case 'success': return 'check-circle';
        case 'error': return 'exclamation-triangle';
        case 'warning': return 'exclamation-circle';
        default: return 'info-circle';
    }
}

function getStylesForType(type) {
    switch(type) {
        case 'success': return 'background: linear-gradient(90deg, #48bb78, #38a169);';
        case 'error': return 'background: linear-gradient(90deg, #f56565, #e53e3e);';
        case 'warning': return 'background: linear-gradient(90deg, #ed8936, #dd6b20);';
        default: return 'background: linear-gradient(90deg, #667eea, #764ba2);';
    }
}

// Search functionality (if implemented later)
function setupSearch() {
    const searchInput = document.querySelector('#searchInput');
    if (searchInput) {
        let searchTimeout;
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                performSearch(this.value);
            }, 300);
        });
    }
}

function performSearch(query) {
    const tableRows = document.querySelectorAll('.menu-table tbody tr');
    tableRows.forEach(row => {
        const menuName = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
        const categoryName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
        
        if (menuName.includes(query.toLowerCase()) || categoryName.includes(query.toLowerCase())) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

// Utility functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Export functions for global access
window.MenuManagement = {
    showNotification,
    addLoadingState,
    formatCurrency
}; 