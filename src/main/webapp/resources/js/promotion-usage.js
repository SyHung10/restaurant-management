/**
 * JavaScript cho trang quản lý khuyến mãi với tracking usage
 */
document.addEventListener('DOMContentLoaded', function() {
    
    // Animate progress bars khi load trang
    animateProgressBars();
    
    // Setup search functionality
    setupSearch();
    
    // Setup filter functionality
    setupFilters();
    
    // Setup tooltips
    setupTooltips();
    
    // Auto refresh usage data every 30 seconds
    setInterval(refreshUsageData, 30000);
});

/**
 * Animate progress bars với hiệu ứng smooth
 */
function animateProgressBars() {
    const progressBars = document.querySelectorAll('.progress-fill');
    
    progressBars.forEach(bar => {
        const targetWidth = bar.style.width;
        bar.style.width = '0%';
        
        setTimeout(() => {
            bar.style.width = targetWidth;
            bar.classList.add('animate');
        }, 100);
    });
}

/**
 * Setup search functionality
 */
function setupSearch() {
    const searchInput = document.querySelector('.search-input');
    if (!searchInput) return;
    
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        const promotionCards = document.querySelectorAll('.grid.grid-cols-1 .card');
        
        promotionCards.forEach(card => {
            const promotionName = card.querySelector('.card-title span')?.textContent.toLowerCase() || '';
            const voucherCode = card.querySelector('.card-subtitle strong')?.textContent.toLowerCase() || '';
            
            const matches = promotionName.includes(searchTerm) || voucherCode.includes(searchTerm);
            
            if (matches) {
                card.style.display = 'block';
                card.style.animation = 'fadeIn 0.3s ease';
            } else {
                card.style.display = 'none';
            }
        });
        
        // Show no results message if needed
        showNoResultsMessage(searchTerm);
    });
}

/**
 * Setup filter functionality
 */
function setupFilters() {
    // Create filter buttons if they don't exist
    createFilterButtons();
    
    // Add event listeners to filter buttons
    const filterButtons = document.querySelectorAll('.filter-btn');
    filterButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const filter = this.dataset.filter;
            applyFilter(filter);
            
            // Update active state
            filterButtons.forEach(b => b.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

/**
 * Create filter buttons
 */
function createFilterButtons() {
    const headerActions = document.querySelector('.header-actions');
    if (!headerActions || document.querySelector('.filter-container')) return;
    
    const filterContainer = document.createElement('div');
    filterContainer.className = 'filter-container flex gap-sm';
    filterContainer.innerHTML = `
        <button class="filter-btn btn btn-sm btn-secondary active" data-filter="all">
            <i class="fas fa-list"></i>
            <span>Tất cả</span>
        </button>
        <button class="filter-btn btn btn-sm btn-secondary" data-filter="active">
            <i class="fas fa-check-circle"></i>
            <span>Hoạt động</span>
        </button>
        <button class="filter-btn btn btn-sm btn-secondary" data-filter="depleted">
            <i class="fas fa-exclamation-triangle"></i>
            <span>Sắp hết</span>
        </button>
        <button class="filter-btn btn btn-sm btn-secondary" data-filter="expired">
            <i class="fas fa-times-circle"></i>
            <span>Hết lượt</span>
        </button>
    `;
    
    headerActions.insertBefore(filterContainer, headerActions.firstChild);
}

/**
 * Apply filter to promotion cards
 */
function applyFilter(filter) {
    const promotionCards = document.querySelectorAll('.grid.grid-cols-1 .card');
    
    promotionCards.forEach(card => {
        let shouldShow = false;
        
        switch(filter) {
            case 'all':
                shouldShow = true;
                break;
            case 'active':
                shouldShow = card.querySelector('.badge-success') !== null;
                break;
            case 'depleted':
                shouldShow = card.querySelector('.badge-warning') !== null;
                break;
            case 'expired':
                shouldShow = card.querySelector('.badge-danger') !== null;
                break;
        }
        
        if (shouldShow) {
            card.style.display = 'block';
            card.style.animation = 'fadeIn 0.3s ease';
        } else {
            card.style.display = 'none';
        }
    });
}

/**
 * Setup tooltips for usage information
 */
function setupTooltips() {
    const usageElements = document.querySelectorAll('[data-tooltip]');
    
    usageElements.forEach(element => {
        element.addEventListener('mouseenter', showTooltip);
        element.addEventListener('mouseleave', hideTooltip);
    });
}

/**
 * Show tooltip
 */
function showTooltip(event) {
    const tooltip = event.target.getAttribute('data-tooltip');
    if (!tooltip) return;
    
    const tooltipElement = document.createElement('div');
    tooltipElement.className = 'custom-tooltip';
    tooltipElement.textContent = tooltip;
    
    document.body.appendChild(tooltipElement);
    
    const rect = event.target.getBoundingClientRect();
    tooltipElement.style.left = rect.left + (rect.width / 2) - (tooltipElement.offsetWidth / 2) + 'px';
    tooltipElement.style.top = rect.top - tooltipElement.offsetHeight - 8 + 'px';
}

/**
 * Hide tooltip
 */
function hideTooltip() {
    const tooltip = document.querySelector('.custom-tooltip');
    if (tooltip) {
        tooltip.remove();
    }
}

/**
 * Show no results message
 */
function showNoResultsMessage(searchTerm) {
    const visibleCards = document.querySelectorAll('.grid.grid-cols-1 .card[style*="display: block"], .grid.grid-cols-1 .card:not([style*="display: none"])');
    const container = document.querySelector('.grid.grid-cols-1');
    
    // Remove existing no results message
    const existingMessage = document.querySelector('.no-results-message');
    if (existingMessage) {
        existingMessage.remove();
    }
    
    if (visibleCards.length === 0 && searchTerm.trim() !== '') {
        const noResultsDiv = document.createElement('div');
        noResultsDiv.className = 'no-results-message card text-center p-xl';
        noResultsDiv.innerHTML = `
            <div style="color: var(--gray-400); font-size: 3rem; margin-bottom: var(--space-lg);">
                <i class="fas fa-search"></i>
            </div>
            <h3 class="text-xl font-semibold text-gray-700 mb-md">Không tìm thấy khuyến mãi</h3>
            <p class="text-gray-500">Không có khuyến mãi nào phù hợp với từ khóa "<strong>${searchTerm}</strong>"</p>
        `;
        
        container.appendChild(noResultsDiv);
    }
}

/**
 * Refresh usage data (AJAX call)
 */
function refreshUsageData() {
    // Chỉ refresh nếu trang đang được focus
    if (document.hidden) return;
    
    console.log('Refreshing usage data...');
    
    // Có thể implement AJAX call để refresh data ở đây
    // Tuy nhiên theo yêu cầu không dùng AJAX, nên chỉ log
    
    // Alternative: Reload page every 5 minutes
    const lastReload = localStorage.getItem('lastPromotionReload');
    const now = Date.now();
    
    if (!lastReload || (now - parseInt(lastReload)) > 300000) { // 5 minutes
        localStorage.setItem('lastPromotionReload', now.toString());
        // Uncomment để auto reload
        // window.location.reload();
    }
}

/**
 * Format number with thousand separators
 */
function formatNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/**
 * Calculate usage percentage color
 */
function getUsageColor(percentage) {
    if (percentage >= 100) return '#dc2626'; // red
    if (percentage >= 80) return '#d97706';  // orange
    if (percentage >= 60) return '#eab308';  // yellow
    return '#16a34a'; // green
}

/**
 * Add CSS animations
 */
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    
    .custom-tooltip {
        position: absolute;
        background-color: #1f2937;
        color: white;
        padding: 6px 8px;
        border-radius: 4px;
        font-size: 12px;
        white-space: nowrap;
        z-index: 1000;
        pointer-events: none;
    }
    
    .filter-container {
        margin-right: 16px;
    }
    
    .filter-btn.active {
        background-color: var(--primary-color, #2563eb);
        color: white;
    }
`;
document.head.appendChild(style); 