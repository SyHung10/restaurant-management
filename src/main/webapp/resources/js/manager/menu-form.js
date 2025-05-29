document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('menuForm');
    const submitBtn = form.querySelector('button[type="submit"]');
    const imageFileInput = document.getElementById('imageFile');
    const preview = document.getElementById('preview');
    const uploadArea = document.querySelector('.image-upload-area');
    const uploadContent = document.getElementById('uploadContent');

    // Image upload handling
    imageFileInput.addEventListener('change', function(e) {
        handleImageFile(e.target.files[0]);
    });

    // Drag and drop functionality
    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.classList.add('dragover');
    });

    uploadArea.addEventListener('dragleave', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
    });

    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            handleImageFile(files[0]);
            imageFileInput.files = files;
        }
    });

    function handleImageFile(file) {
        if (!file) return;

        // Validate file type
        const validTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
        if (!validTypes.includes(file.type)) {
            alert('Định dạng file không hợp lệ! Vui lòng chọn file JPG, PNG hoặc GIF.');
            imageFileInput.value = '';
            return;
        }

        // Validate file size (5MB)
        if (file.size > 5242880) {
            alert('Kích thước file quá lớn! Vui lòng chọn file nhỏ hơn 5MB.');
            imageFileInput.value = '';
            return;
        }

        // Show preview
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.src = e.target.result;
            preview.style.display = 'block';
            uploadContent.style.display = 'none';
        };
        reader.readAsDataURL(file);
    }

    // Reset preview when clicking upload area with image
    uploadArea.addEventListener('click', function() {
        if (preview.style.display === 'block') {
        preview.style.display = 'none';
            uploadContent.style.display = 'block';
            imageFileInput.value = '';
        }
    });

    // Form validation
    form.addEventListener('submit', function(e) {
        const name = document.getElementById('name').value.trim();
        const categoryId = document.getElementById('categoryId').value;
        const price = document.getElementById('price').value;

        if (!name || !categoryId || !price) {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            return;
        }

        if (parseFloat(price) < 0) {
            e.preventDefault();
            alert('Giá bán phải là số dương!');
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

    // Price formatting
    const priceInput = document.getElementById('price');
    priceInput.addEventListener('input', function() {
        // Remove non-numeric characters except decimal point
        let value = this.value.replace(/[^0-9.]/g, '');
        this.value = value;
    });
}); 