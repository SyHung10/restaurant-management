document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('employeeForm');
    const submitBtn = form.querySelector('button[type="submit"]');
    const passwordInput = document.getElementById('password');
    const passwordStrength = document.getElementById('passwordStrength');
    const strengthText = document.getElementById('strengthText');
    const strengthBar = document.getElementById('strengthBar');
    
    // Password strength checker
    passwordInput.addEventListener('input', function() {
        const password = this.value;
        
        if (password.length > 0) {
            passwordStrength.style.display = 'block';
            const strength = calculatePasswordStrength(password);
            updatePasswordStrength(strength);
        } else {
            passwordStrength.style.display = 'none';
        }
    });
    
    function calculatePasswordStrength(password) {
        let score = 0;
        
        if (password.length >= 6) score++;
        if (password.length >= 8) score++;
        if (/[a-z]/.test(password)) score++;
        if (/[A-Z]/.test(password)) score++;
        if (/[0-9]/.test(password)) score++;
        if (/[^A-Za-z0-9]/.test(password)) score++;
        
        return Math.min(score, 4);
    }
    
    function updatePasswordStrength(strength) {
        const levels = ['Rất yếu', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];
        const classes = ['strength-weak', 'strength-weak', 'strength-medium', 'strength-strong', 'strength-very-strong'];
        
        strengthText.textContent = 'Độ mạnh mật khẩu: ' + levels[strength];
        strengthBar.className = 'strength-bar ' + classes[strength];
    }
    
    // Form validation
    form.addEventListener('submit', function(e) {
        const name = document.getElementById('name').value.trim();
        const role = document.getElementById('role').value;
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        
        if (!name || !role || !username || !password) {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }
        
        if (password.length < 6) {
            e.preventDefault();
            alert('Mật khẩu phải có ít nhất 6 ký tự!');
            return;
        }
        
        if (!/^[a-zA-Z0-9_]+$/.test(username)) {
            e.preventDefault();
            alert('Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới!');
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
    
    // Username validation
    document.getElementById('username').addEventListener('input', function() {
        const username = this.value;
        if (username && !/^[a-zA-Z0-9_]+$/.test(username)) {
            this.style.borderColor = 'var(--danger-color)';
        } else {
            this.style.borderColor = 'var(--gray-300)';
        }
    });
}); 