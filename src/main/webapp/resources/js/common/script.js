// Hàm xác nhận khi xóa
function confirmDelete(message) {
    return confirm(message || 'Bạn có chắc chắn muốn xóa?');
}

// Hàm validate form
function validateForm(formId) {
    const form = document.getElementById(formId);
    if (!form) return true;

    const requiredFields = form.querySelectorAll('[required]');
    for (let field of requiredFields) {
        if (!field.value.trim()) {
            alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            field.focus();
            return false;
        }
    }

    return true;
}

// Hàm format tiền tệ
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
}

// Hàm chuyển đổi ngày thành chuỗi ngày tháng năm
function formatDate(date) {
    if (!date) return '';

    const d = new Date(date);
    const day = d.getDate().toString().padStart(2, '0');
    const month = (d.getMonth() + 1).toString().padStart(2, '0');
    const year = d.getFullYear();

    return `${day}/${month}/${year}`;
}

// Event listener khi DOM đã tải xong
document.addEventListener('DOMContentLoaded', function () {
    // Format tất cả các phần tử có class 'currency'
    const currencyElements = document.querySelectorAll('.currency');
    for (let el of currencyElements) {
        const amount = parseFloat(el.textContent.replace(/[^\d.-]/g, ''));
        if (!isNaN(amount)) {
            el.textContent = formatCurrency(amount);
        }
    }

    // Format tất cả các phần tử có class 'date'
    const dateElements = document.querySelectorAll('.date');
    for (let el of dateElements) {
        const dateStr = el.textContent.trim();
        if (dateStr) {
            el.textContent = formatDate(dateStr);
        }
    }
}); 