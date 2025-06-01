// Dashboard functionality
document.addEventListener('DOMContentLoaded', function() {
    // Auto refresh functionality
    const refreshBtn = document.querySelector('.btn-secondary');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', function() {
            this.classList.add('loading');
            setTimeout(() => {
                location.reload();
            }, 1000);
        });
    }

    // Search functionality
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            // Implement global search functionality if needed
            console.log('Searching for:', this.value);
        });
    }

    // Animation for stats
    const statValues = document.querySelectorAll('.stat-value');
    statValues.forEach(stat => {
        const finalValue = stat.textContent;
        if (!isNaN(finalValue)) {
            animateNumber(stat, 0, parseInt(finalValue), 1000);
        }
    });

    // Add welcome message based on time
    const now = new Date();
    const hour = now.getHours();
    let greeting = 'Chào mừng';
    
    if (hour < 12) {
        greeting = 'Chào buổi sáng';
    } else if (hour < 18) {
        greeting = 'Chào buổi chiều';
    } else {
        greeting = 'Chào buổi tối';
    }

    const welcomeTitle = document.querySelector('.welcome-title');
    if (welcomeTitle) {
        welcomeTitle.textContent = greeting + ' đến với Hệ thống POS';
    }
});

// Animate numbers
function animateNumber(element, start, end, duration) {
    const range = end - start;
    const startTime = performance.now();
    
    function updateNumber(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        const current = Math.floor(progress * range + start);
        
        element.textContent = current;
        
        if (progress < 1) {
            requestAnimationFrame(updateNumber);
        }
    }
    
    requestAnimationFrame(updateNumber);
} 