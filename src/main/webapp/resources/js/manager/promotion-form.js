document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('promotionForm');
    const submitBtn = form.querySelector('button[type="submit"]');
    const voucherCodeInput = document.getElementById('voucherCode');
    const startTimeInput = document.getElementById('startTime');
    const endTimeInput = document.getElementById('endTime');
    const discountPercentInput = document.getElementById('discountPercent');
    const discountValueInput = document.getElementById('discountValue');
    const scopeTypeSelect = document.getElementById('scopeType');
    const targetIdInput = document.getElementById('targetId');
    const maxUsageInput = document.getElementById('maxUsage');
    const orderMinimumInput = document.getElementById('orderMinimum');

    // Auto uppercase for promotion code
    if (voucherCodeInput) {
        voucherCodeInput.addEventListener('input', function() {
            this.value = this.value.toUpperCase().replace(/[^A-Z0-9]/g, '');
        });
    }

    // =============================================
    // UTILITY FUNCTIONS
    // =============================================

    function showError(input, message) {
        // Xóa error cũ nếu có
        const existingError = input.parentNode.querySelector('.error-message');
        if (existingError) {
            existingError.remove();
        }
        
        // Thêm class error
        input.classList.add('error');
        
        // Tạo message mới
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error-message';
        errorDiv.textContent = message;
        errorDiv.style.color = '#dc3545';
        errorDiv.style.fontSize = '0.875rem';
        errorDiv.style.marginTop = '0.25rem';
        
        input.parentNode.appendChild(errorDiv);
    }

    function clearError(input) {
        input.classList.remove('error');
        const existingError = input.parentNode.querySelector('.error-message');
        if (existingError) {
            existingError.remove();
        }
    }

    function formatDateTime(dateString) {
        if (!dateString) return '';
        const date = new Date(dateString);
        return date.toLocaleString('vi-VN');
    }

    // =============================================
    // SCOPE TYPE HANDLER  
    // =============================================

    function toggleTargetId() {
        const scopeType = scopeTypeSelect.value;
        const targetIdGroup = document.getElementById('targetIdGroup');
        
        if (scopeType === 'ALL') {
            targetIdGroup.style.display = 'none';
            targetIdInput.value = '';
            targetIdInput.removeAttribute('required');
            clearError(targetIdInput);
        } else {
            targetIdGroup.style.display = 'block';
            targetIdInput.setAttribute('required', 'required');
        }
    }

    // =============================================
    // DISCOUNT TYPE HANDLER
    // =============================================

    function updateDiscountType(type) {
        const isPercentInput = document.getElementById('isPercent');
        
        if (type === 'percent') {
            // Nếu nhập phần trăm, xóa giá trị cố định
            discountValueInput.value = '';
            isPercentInput.value = 'true';
            clearError(discountValueInput);
        } else if (type === 'value') {
            // Nếu nhập giá trị cố định, xóa phần trăm
            discountPercentInput.value = '';
            isPercentInput.value = 'false';
            clearError(discountPercentInput);
        }
    }

    // =============================================
    // VALIDATION FUNCTIONS
    // =============================================

    function validateRequired(input, fieldName) {
        if (!input.value.trim()) {
            showError(input, `${fieldName} là bắt buộc`);
            return false;
        }
        clearError(input);
        return true;
    }

    function validateVoucherCode() {
        const value = voucherCodeInput.value.trim().toUpperCase();
        
        if (!value) {
            showError(voucherCodeInput, 'Mã khuyến mãi là bắt buộc');
            return false;
        }
        
        // Kiểm tra format: chỉ chữ, số và một số ký tự đặc biệt
        const voucherPattern = /^[A-Z0-9_-]+$/;
        if (!voucherPattern.test(value)) {
            showError(voucherCodeInput, 'Mã khuyến mãi chỉ được chứa chữ cái, số, dấu gạch ngang và gạch dưới');
            return false;
        }
        
        if (value.length < 3 || value.length > 20) {
            showError(voucherCodeInput, 'Mã khuyến mãi phải từ 3-20 ký tự');
            return false;
        }
        
        // Tự động uppercase
        voucherCodeInput.value = value;
        clearError(voucherCodeInput);
        return true;
    }

    function validateDiscountFields() {
        const percentValue = discountPercentInput.value;
        const fixedValue = discountValueInput.value;
        
        // Phải có ít nhất một trong hai loại discount
        if (!percentValue && !fixedValue) {
            showError(discountPercentInput, 'Phải nhập phần trăm giảm hoặc giá trị giảm');
            showError(discountValueInput, 'Phải nhập phần trăm giảm hoặc giá trị giảm');
            return false;
        }
        
        // Không được nhập cả hai cùng lúc
        if (percentValue && fixedValue) {
            showError(discountPercentInput, 'Chỉ được chọn một loại giảm giá');
            showError(discountValueInput, 'Chỉ được chọn một loại giảm giá');
            return false;
        }
        
        // Validate phần trăm
        if (percentValue) {
            const percent = parseFloat(percentValue);
            if (percent <= 0 || percent > 100) {
                showError(discountPercentInput, 'Phần trăm giảm phải từ 0.01% đến 100%');
                return false;
            }
            clearError(discountPercentInput);
            clearError(discountValueInput);
        }
        
        // Validate giá trị cố định
        if (fixedValue) {
            const value = parseFloat(fixedValue);
            if (value <= 0) {
                showError(discountValueInput, 'Giá trị giảm phải lớn hơn 0');
                return false;
            }
            if (value > 10000000) { // 10 triệu
                showError(discountValueInput, 'Giá trị giảm không được vượt quá 10,000,000 VNĐ');
                return false;
            }
            clearError(discountPercentInput);
            clearError(discountValueInput);
        }
        
        return true;
    }

    function validateDateTimes() {
        const startTime = startTimeInput.value;
        const endTime = endTimeInput.value;
        const now = new Date();
        
        let isValid = true;
        
        // Nếu có thời gian bắt đầu
        if (startTime) {
            const startDate = new Date(startTime);
            
            // Kiểm tra thời gian bắt đầu không được trong quá khứ (trừ khi đang edit)
            const isEditing = document.querySelector('input[name="promotionId"]').value;
            if (!isEditing && startDate < now) {
                showError(startTimeInput, 'Thời gian bắt đầu không được trong quá khứ');
                isValid = false;
            } else {
                clearError(startTimeInput);
            }
        }
        
        // Nếu có thời gian kết thúc
        if (endTime) {
            const endDate = new Date(endTime);
            
            // Kiểm tra thời gian kết thúc không được trong quá khứ
            if (endDate < now) {
                showError(endTimeInput, 'Thời gian kết thúc không được trong quá khứ');
                isValid = false;
            } else {
                clearError(endTimeInput);
            }
        }
        
        // Nếu có cả hai thời gian
        if (startTime && endTime) {
            const startDate = new Date(startTime);
            const endDate = new Date(endTime);
            
            if (endDate <= startDate) {
                showError(endTimeInput, 'Thời gian kết thúc phải sau thời gian bắt đầu');
                isValid = false;
            } else {
                clearError(endTimeInput);
            }
            
            // Kiểm tra khoảng thời gian hợp lý (ít nhất 1 giờ)
            const diffHours = (endDate - startDate) / (1000 * 60 * 60);
            if (diffHours < 1) {
                showError(endTimeInput, 'Khuyến mãi phải kéo dài ít nhất 1 giờ');
                isValid = false;
            }
        }
        
        return isValid;
    }

    function validateTargetId() {
        const scopeType = scopeTypeSelect.value;
        
        if (scopeType === 'ALL') {
            clearError(targetIdInput);
            return true;
        }
        
        const targetId = targetIdInput.value;
        if (!targetId) {
            showError(targetIdInput, `ID ${scopeType === 'CATEGORY' ? 'danh mục' : 'món ăn'} là bắt buộc`);
            return false;
        }
        
        const id = parseInt(targetId);
        if (id <= 0) {
            showError(targetIdInput, 'ID phải là số nguyên dương');
            return false;
        }
        
        clearError(targetIdInput);
        return true;
    }

    function validateNumericFields() {
        let isValid = true;
        
        // Validate max usage
        if (maxUsageInput.value) {
            const maxUsage = parseInt(maxUsageInput.value);
            if (maxUsage <= 0) {
                showError(maxUsageInput, 'Số lần sử dụng tối đa phải lớn hơn 0');
                isValid = false;
            } else if (maxUsage > 999999) {
                showError(maxUsageInput, 'Số lần sử dụng tối đa không được vượt quá 999,999');
                isValid = false;
            } else {
                clearError(maxUsageInput);
            }
        }
        
        // Validate order minimum
        if (orderMinimumInput.value) {
            const orderMin = parseFloat(orderMinimumInput.value);
            if (orderMin < 0) {
                showError(orderMinimumInput, 'Giá trị đơn hàng tối thiểu không được âm');
                isValid = false;
            } else if (orderMin > 100000000) { // 100 triệu
                showError(orderMinimumInput, 'Giá trị đơn hàng tối thiểu không được vượt quá 100,000,000 VNĐ');
                isValid = false;
            } else {
                clearError(orderMinimumInput);
            }
        }
        
        return isValid;
    }

    // =============================================
    // EVENT LISTENERS
    // =============================================

    // Scope type change
    scopeTypeSelect.addEventListener('change', toggleTargetId);

    // Discount type changes
    discountPercentInput.addEventListener('input', function() {
        if (this.value) {
            updateDiscountType('percent');
        }
    });

    discountValueInput.addEventListener('input', function() {
        if (this.value) {
            updateDiscountType('value');
        }
    });

    // Voucher code auto uppercase
    voucherCodeInput.addEventListener('input', function() {
        this.value = this.value.toUpperCase();
    });

    // Real-time validation
    voucherCodeInput.addEventListener('blur', validateVoucherCode);
    startTimeInput.addEventListener('change', validateDateTimes);
    endTimeInput.addEventListener('change', validateDateTimes);
    discountPercentInput.addEventListener('blur', validateDiscountFields);
    discountValueInput.addEventListener('blur', validateDiscountFields);
    targetIdInput.addEventListener('blur', validateTargetId);
    maxUsageInput.addEventListener('blur', validateNumericFields);
    orderMinimumInput.addEventListener('blur', validateNumericFields);

    // =============================================
    // FORM SUBMISSION VALIDATION
    // =============================================

    form.addEventListener('submit', function(e) {
        let isFormValid = true;
        
        // Validate required fields
        if (!validateRequired(form.querySelector('#name'), 'Tên khuyến mãi')) {
            isFormValid = false;
        }
        
        if (!validateVoucherCode()) {
            isFormValid = false;
        }
        
        if (!validateRequired(scopeTypeSelect, 'Phạm vi áp dụng')) {
            isFormValid = false;
        }
        
        if (!validateRequired(form.querySelector('#status'), 'Trạng thái')) {
            isFormValid = false;
        }
        
        // Validate business logic
        if (!validateDiscountFields()) {
            isFormValid = false;
        }
        
        if (!validateDateTimes()) {
            isFormValid = false;
        }
        
        if (!validateTargetId()) {
            isFormValid = false;
        }
        
        if (!validateNumericFields()) {
            isFormValid = false;
        }
        
        // Kiểm tra logic phức tạp
        if (isFormValid) {
            // Confirm cho discount lớn
            const percentValue = discountPercentInput.value;
            const fixedValue = discountValueInput.value;
            
            if (percentValue && parseFloat(percentValue) > 50) {
                if (!confirm(`Bạn có chắc muốn tạo khuyến mãi giảm ${percentValue}%? Đây là mức giảm rất cao.`)) {
                    e.preventDefault();
                    return;
                }
            }
            
            if (fixedValue && parseFloat(fixedValue) > 1000000) {
                if (!confirm(`Bạn có chắc muốn tạo khuyến mãi giảm ${parseInt(fixedValue).toLocaleString('vi-VN')} VNĐ? Đây là số tiền rất lớn.`)) {
                    e.preventDefault();
                    return;
                }
            }
        }
        
        if (!isFormValid) {
            e.preventDefault();
            
            // Scroll to first error
            const firstError = form.querySelector('.error');
            if (firstError) {
                firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
                firstError.focus();
            }
            
            // Show summary error
            alert('Vui lòng kiểm tra lại thông tin đã nhập. Có một số lỗi cần được sửa.');
        }
    });

    // =============================================
    // INITIALIZATION
    // =============================================

    // Set initial state
    toggleTargetId();
    
    // Set current datetime for new promotion
    const isNewPromotion = !document.querySelector('input[name="promotionId"]').value;
    if (isNewPromotion && !startTimeInput.value) {
        const now = new Date();
        now.setMinutes(now.getMinutes() - now.getTimezoneOffset()); // Adjust for timezone
        startTimeInput.value = now.toISOString().slice(0, 16);
    }
});

// =============================================
// GLOBAL FUNCTIONS (called from HTML)
// =============================================

function toggleTargetId() {
    const scopeType = document.getElementById('scopeType').value;
    const targetIdGroup = document.getElementById('targetIdGroup');
    const targetIdInput = document.getElementById('targetId');
    
    if (scopeType === 'ALL') {
        targetIdGroup.style.display = 'none';
        targetIdInput.value = '';
        targetIdInput.removeAttribute('required');
    } else {
        targetIdGroup.style.display = 'block';
        targetIdInput.setAttribute('required', 'required');
    }
}

function updateDiscountType(type) {
    const discountPercentInput = document.getElementById('discountPercent');
    const discountValueInput = document.getElementById('discountValue');
    const isPercentInput = document.getElementById('isPercent');
    
    if (type === 'percent') {
        discountValueInput.value = '';
        isPercentInput.value = 'true';
    } else if (type === 'value') {
        discountPercentInput.value = '';
        isPercentInput.value = 'false';
    }
} 