// Search functionality
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('.search-input');
    const tableRows = document.querySelectorAll('.table tbody tr');
    
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        
        tableRows.forEach(row => {
            const employeeName = row.querySelector('td:nth-child(2) .font-semibold').textContent.toLowerCase();
            const role = row.querySelector('td:nth-child(3)').textContent.toLowerCase();
            const username = row.querySelector('td:nth-child(4) .font-medium').textContent.toLowerCase();
            
            if (employeeName.includes(searchTerm) || role.includes(searchTerm) || username.includes(searchTerm)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    });

    // Confirm delete function
    window.confirmDelete = function(message) {
        return confirm(message);
    };
}); 