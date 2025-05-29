// JavaScript cho modal thêm bàn phụ - không AJAX, chỉ form submission

let selectedTables = [];

// Hàm toggle chọn bàn
function toggleTableSelection(cardElement, tableId, tableNumber) {
    // Kiểm tra nếu bàn bị disabled thì không cho phép chọn
    if (cardElement.classList.contains('disabled')) {
        return;
    }
    
    const checkbox = cardElement.querySelector('.table-checkbox-modal');
    if (!checkbox) {
        return; // Không có checkbox nghĩa là bàn không thể chọn
    }
    
    const isSelected = cardElement.classList.contains('selected');
    
    if (isSelected) {
        // Bỏ chọn bàn
        cardElement.classList.remove('selected');
        checkbox.checked = false;
        
        // Remove from selectedTables array
        selectedTables = selectedTables.filter(table => table.id !== tableId);
    } else {
        // Chọn bàn
        cardElement.classList.add('selected');
        checkbox.checked = true;
        
        // Add to selectedTables array
        selectedTables.push({
            id: tableId,
            number: tableNumber
        });
    }
    
    // Update selection summary
    updateSelectionSummary();
    
    // Update confirm button state
    updateConfirmButton();
}

// Cập nhật phần tóm tắt bàn đã chọn
function updateSelectionSummary() {
    const summaryElement = document.getElementById('selectionSummary');
    const listElement = document.getElementById('selectedTablesList');
    
    if (selectedTables.length > 0) {
        summaryElement.classList.add('show');
        
        // Tạo danh sách bàn đã chọn
        const tagsHTML = selectedTables.map(table => 
            `<span class="selected-table-tag">Bàn ${table.number}</span>`
        ).join('');
        
        listElement.innerHTML = tagsHTML;
    } else {
        summaryElement.classList.remove('show');
    }
}

// Cập nhật trạng thái nút xác nhận
function updateConfirmButton() {
    const confirmBtn = document.getElementById('confirmAddTablesBtn');
    
    if (confirmBtn) {
        if (selectedTables.length > 0) {
            confirmBtn.disabled = false;
            confirmBtn.innerHTML = `<i class="fas fa-plus mr-2"></i>Thêm ${selectedTables.length} bàn đã chọn`;
        } else {
            confirmBtn.disabled = true;
            confirmBtn.innerHTML = '<i class="fas fa-plus mr-2"></i>Thêm bàn đã chọn';
        }
    }
}

// Xác nhận thêm bàn
function confirmAddTables() {
    if (selectedTables.length === 0) {
        alert('Vui lòng chọn ít nhất một bàn!');
        return;
    }
    
    // Hiển thị loading state
    const confirmBtn = document.getElementById('confirmAddTablesBtn');
    confirmBtn.disabled = true;
    confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin mr-2"></i>Đang xử lý...';
    
    // Submit form
    document.getElementById('addTableForm').submit();
}

// Reset modal khi đóng
function resetAddTableModal() {
    selectedTables = [];
    
    // Bỏ chọn tất cả cards
    const cards = document.querySelectorAll('.table-card-modal');
    cards.forEach(card => {
        card.classList.remove('selected');
        const checkbox = card.querySelector('.table-checkbox-modal');
        if (checkbox) {
            checkbox.checked = false;
        }
    });
    
    // Reset UI elements
    updateSelectionSummary();
    updateConfirmButton();
    
    // Reset confirm button
    const confirmBtn = document.getElementById('confirmAddTablesBtn');
    if (confirmBtn) {
        confirmBtn.disabled = true;
        confirmBtn.innerHTML = '<i class="fas fa-plus mr-2"></i>Thêm bàn đã chọn';
    }
}

// Event listeners khi DOM ready
document.addEventListener('DOMContentLoaded', function() {
    // Thêm event listener cho tất cả table cards
    document.addEventListener('click', function(e) {
        const card = e.target.closest('.table-card-modal');
        if (card) {
            const tableId = parseInt(card.dataset.tableId);
            const tableNumber = card.dataset.tableNumber;
            const canSelect = card.dataset.canSelect === 'true';
            
            if (canSelect) {
                toggleTableSelection(card, tableId, tableNumber);
            }
        }
    });
    
    // Reset modal khi đóng
    $('#addTableModal').on('hidden.bs.modal', function() {
        resetAddTableModal();
    });
    
    // Xử lý khi modal được mở
    $('#addTableModal').on('shown.bs.modal', function() {
        // Focus vào modal body
        setTimeout(function() {
            const modalBody = document.querySelector('#addTableModal .modal-body');
            if (modalBody) {
                modalBody.scrollTop = 0;
            }
        }, 100);
    });
    
    // Keyboard navigation
    document.addEventListener('keydown', function(e) {
        // Kiểm tra modal có đang mở không
        const modal = document.getElementById('addTableModal');
        if (!modal || !modal.classList.contains('show')) return;
        
        // ESC key để đóng modal
        if (e.key === 'Escape') {
            $('#addTableModal').modal('hide');
        }
        
        // Enter key để xác nhận nếu có bàn được chọn
        if (e.key === 'Enter' && selectedTables.length > 0) {
            e.preventDefault();
            confirmAddTables();
        }
    });
});

// Utility functions
function filterTablesByFloor(floor) {
    const cards = document.querySelectorAll('.table-card-modal');
    
    cards.forEach(card => {
        const floorText = card.querySelector('.table-floor-modal').textContent;
        const tableFloor = floorText.match(/\d+/)[0];
        
        if (floor === 'all' || tableFloor === floor.toString()) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

function getTotalSelectedTables() {
    return selectedTables.length;
}

function getSelectedTableIds() {
    return selectedTables.map(table => table.id);
}

function getSelectedTableNumbers() {
    return selectedTables.map(table => table.number);
}

// Animation cho card selection
function animateCardSelection(cardElement, isSelecting) {
    if (isSelecting) {
        cardElement.style.transform = 'scale(1.05)';
        setTimeout(() => {
            cardElement.style.transform = '';
        }, 200);
    }
}

// Log để debug (chỉ trong development)
if (window.location.hostname === 'localhost') {
    console.log('Add Table Modal JS loaded - No AJAX mode');
} 