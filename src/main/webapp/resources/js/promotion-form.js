document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('promotionForm');
    const submitBtn = form.querySelector('button[type="submit"]');
    const typeSelect = document.getElementById('type');
    const discountWrapper = document.getElementById('discountWrapper');
    const discountInput = document.getElementById('discountValue');
    const codeInput = document.getElementById('voucherCode');
    const startTimeInput = document.getElementById('startTime');
    const endTimeInput = document.getElementById('endTime');

    // Update discount input based on type
    typeSelect.addEventListener('change', function() {
        const type = this.value;
        discountWrapper.className = 'discount-input-wrapper';
        
        if (type === 'VOUCHER') {
            discountWrapper.classList.add('discount-voucher');
            discountInput.placeholder = '0';
            discountInput.removeAttribute('max');
        } else if (type === 'HOUR') {
            discountWrapper.classList.add('discount-hour');
            discountInput.placeholder = '0-100';
            discountInput.max = '100';
        }
    });

    // Initialize discount wrapper
    if (typeSelect.value) {
        typeSelect.dispatchEvent(new Event('change'));
    }

    // Auto uppercase for promotion code
    codeInput.addEventListener('input', function() {
        this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
    });

    // Form validation
    form.addEventListener('submit', function(e) {
        const name = document.getElementById('name').value.trim();
        const code = document.getElementById('voucherCode').value.trim();
        const type = document.getElementById('type').value;
        const discountValue = document.getElementById('discountValue').value;
        const startTime = document.getElementById('startTime').value;
        const endTime = document.getElementById('endTime').value;

        if (!name || !code || !type || !discountValue || !startTime || !endTime) {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }

        if (parseFloat(discountValue) <= 0) {
            e.preventDefault();
            alert('Giá trị giảm phải lớn hơn 0!');
            return;
        }

        if (type === 'HOUR' && parseFloat(discountValue) > 100) {
            e.preventDefault();
            alert('Giá trị giảm theo phần trăm không được vượt quá 100%!');
            return;
        }

        if (new Date(startTime) >= new Date(endTime)) {
            e.preventDefault();
            alert('Thời gian bắt đầu phải trước thời gian kết thúc!');
            return;
        }

        if (new Date(startTime) < new Date()) {
            if (!confirm('Thời gian bắt đầu đã qua. Bạn có chắc muốn tạo khuyến mãi này?')) {
                e.preventDefault();
                return;
            }
        }

        // Loading state
        submitBtn.classList.add('loading');
        submitBtn.disabled = true;
    });

    // Real-time validation
    const inputs = form.querySelectorAll('.form-input, .form-select, .form-textarea');
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

    // Set minimum date for start time to now
    const now = new Date();
    const nowString = now.toISOString().slice(0, 16);
    startTimeInput.min = nowString;

    // Update end time minimum when start time changes
    startTimeInput.addEventListener('change', function() {
        endTimeInput.min = this.value;
    });
}); 