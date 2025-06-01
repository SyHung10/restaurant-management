// Search functionality
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-input');
    const tableRows = document.querySelectorAll('.table tbody tr');
    
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        tableRows.forEach(row => {
            const menuName = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const category = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
            
            if (menuName.includes(searchTerm) || category.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });
    
    // Add loading states to buttons
    document.querySelectorAll('.btn').forEach(btn => {
        if (btn.href && btn.href.includes('/toggle-status/')) {
            btn.addEventListener('click', function() {
                this.classList.add('loading');
            });
        }
    });
}); 