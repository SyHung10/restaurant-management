document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('tableForm');
    const submitBtn = form.querySelector('button[type="submit"]');
    
    // Form validation
    form.addEventListener('submit', function(e) {
        const floor = document.getElementById('floor').value;
        const tableNumber = document.getElementById('tableNumber').value;
        const capacity = document.getElementById('capacity').value;
        
        if (!floor || !tableNumber || !capacity) {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }
        
        if (parseInt(floor) < 1 || parseInt(floor) > 10) {
            e.preventDefault();
            alert('Số tầng phải từ 1 đến 10!');
            return;
        }
        
        if (parseInt(capacity) < 1 || parseInt(capacity) > 20) {
            e.preventDefault();
            alert('Sức chứa phải từ 1 đến 20 người!');
            return;
        }
        
        // Loading state
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
    });
    
    // Real-time validation
    const inputs = form.querySelectorAll('.form-input, .form-select');
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (this.hasAttribute('required') && !this.value.trim()) {
                this.style.borderColor = 'var(--danger-color)';
            } else {
                this.style.borderColor = 'var(--gray-300)';
            }
        });
        
        input.addEventListener('focus', function() {
            this.style.borderColor = 'var(--primary-color)';
        });
    });
}); 