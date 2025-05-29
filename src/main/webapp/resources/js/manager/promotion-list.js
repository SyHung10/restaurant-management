// Search functionality
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-input');
    const promotionCards = document.querySelectorAll('.grid .card');
    
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        promotionCards.forEach(card => {
            const title = card.querySelector('.card-title span');
            const subtitle = card.querySelector('.card-subtitle');
            
            if (title && subtitle) {
                const titleText = title.textContent.toLowerCase();
                const subtitleText = subtitle.textContent.toLowerCase();
                
                if (titleText.includes(searchTerm) || subtitleText.includes(searchTerm)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            }
        });
    });
    
    // Add smooth hover effects
    promotionCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = '';
        });
    });
}); 