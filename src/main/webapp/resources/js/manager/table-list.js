// Search functionality
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-input');
    const tableCards = document.querySelectorAll('.table-card');
    
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        tableCards.forEach(card => {
            const tableNumber = card.dataset.tableNumber.toLowerCase();
            const status = card.dataset.status.toLowerCase();
            
            if (tableNumber.includes(searchTerm) || status.includes(searchTerm)) {
                card.style.display = '';
            } else {
                card.style.display = 'none';
            }
        });
    });

    // Confirm delete function
    window.confirmDelete = function(message) {
        return confirm(message);
    };

    // Add hover effects
    tableCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-4px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(-2px)';
        });
    });
}); 