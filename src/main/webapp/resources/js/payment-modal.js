// Kiểm tra khi trang load xem có thông báo thành công không
document.addEventListener("DOMContentLoaded", function () {
  // Kiểm tra URL có parameter paymentSuccess không
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get("paymentSuccess") === "true") {
    const amount = urlParams.get("amount");
    showSuccessModal(amount);

    // Xóa parameter khỏi URL để tránh hiện modal khi refresh
    const url = new URL(window.location);
    url.searchParams.delete("paymentSuccess");
    url.searchParams.delete("amount");
    window.history.replaceState({}, document.title, url);
  }

  // Kiểm tra nếu có thông báo lỗi thanh toán, tự động mở modal thanh toán
  const paymentErrorAlert = document.querySelector(".alert-danger");
  if (
    paymentErrorAlert &&
    paymentErrorAlert.textContent.includes("Lỗi thanh toán")
  ) {
    // Delay một chút để alert hiển thị trước
    setTimeout(function () {
      $("#paymentModal").modal("show");
    }, 1500);
  }
});

// Hiển thị modal thành công
function showSuccessModal(amount) {
  const successModalHtml = `
        <div class="modal fade success-modal" id="paymentSuccessModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="w-100">
                            <div class="success-icon">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <h5 class="modal-title">Thanh toán thành công!</h5>
                        </div>
                    </div>
                    <div class="modal-body">
                        <div class="success-message">
                            Giao dịch đã được xử lý thành công
                        </div>
                        <div class="payment-details">
                            <p><strong>Số tiền đã thanh toán:</strong></p>
                            <div class="amount-display">${formatCurrency(
                              amount
                            )}</div>
                            <p class="text-muted">
                                <i class="fas fa-clock"></i>
                                ${new Date().toLocaleString("vi-VN")}
                            </p>
                        </div>
                        <p class="text-success">
                            <i class="fas fa-check"></i>
                            Thanh toán đã được xử lý thành công!
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick="closeSuccessModal()">
                            <i class="fas fa-home"></i> Về trang chủ
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;

  // Thêm modal vào body
  document.body.insertAdjacentHTML("beforeend", successModalHtml);

  // Hiển thị modal
  $("#paymentSuccessModal")
    .modal({
      backdrop: "static",
      keyboard: false,
    })
    .modal("show");
}

// Đóng modal thành công và về trang chủ
function closeSuccessModal() {
  $("#paymentSuccessModal").modal("hide");

  // Chuyển về trang danh sách bàn sau khi đóng modal
  setTimeout(function () {
    // Sử dụng context path từ trang hiện tại
    const contextPath = window.location.pathname.split("/")[1];
    window.location.href = "/" + contextPath + "/employee/table/list";
  }, 300);
}

// Format số tiền
function formatCurrency(amount) {
  if (!amount) return "0 VNĐ";

  // Chuyển thành số nếu là string
  const number = typeof amount === "string" ? parseFloat(amount) : amount;

  // Format với dấu phẩy phân cách hàng nghìn
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
  }).format(number);
}

// Xử lý khi người dùng nhập voucher code
function handleVoucherInput() {
  const voucherInput = document.getElementById("voucherCode");
  const applyBtn = document.getElementById("applyVoucherBtn");

  if (voucherInput && applyBtn) {
    voucherInput.addEventListener("input", function () {
      if (this.value.trim().length > 0) {
        applyBtn.disabled = false;
        applyBtn.textContent = "Áp dụng";
      } else {
        applyBtn.disabled = true;
        applyBtn.textContent = "Nhập mã";
      }
    });

    // Xử lý khi nhấn Enter trong input voucher
    voucherInput.addEventListener("keypress", function (e) {
      if (e.key === "Enter" && this.value.trim().length > 0) {
        e.preventDefault();
        applyBtn.click();
      }
    });
  }
}

// Validate form thanh toán trước khi submit
function validatePaymentForm() {
  const paymentMethod = document.querySelector(
    'input[name="paymentMethod"]:checked'
  );

  if (!paymentMethod) {
    alert("Vui lòng chọn phương thức thanh toán!");
    return false;
  }

  // Xác nhận thanh toán
  const confirmation = confirm(
    "Bạn có chắc chắn muốn xác nhận thanh toán?\n\n" +
      "Phương thức: " +
      (paymentMethod.value === "CASH" ? "Tiền mặt" : "Thẻ") +
      "\n" +
      "Thao tác này không thể hoàn tác."
  );

  if (!confirmation) {
    return false;
  }

  // Hiện loading state
  const submitBtn = document.querySelector("#paymentModal .btn-success");
  if (submitBtn) {
    submitBtn.disabled = true;
    submitBtn.innerHTML =
      '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
  }

  return true;
}

// Khôi phục trạng thái button khi có lỗi
function resetPaymentButton() {
  const submitBtn = document.querySelector("#paymentModal .btn-success");
  if (submitBtn) {
    submitBtn.disabled = false;
    submitBtn.innerHTML =
      '<i class="fas fa-credit-card"></i> Xác nhận thanh toán';
  }
}

// Xử lý khi modal payment được mở
function handlePaymentModalOpen() {
  // Focus vào input voucher nếu có
  const voucherInput = document.getElementById("voucherCode");
  if (voucherInput) {
    setTimeout(function () {
      voucherInput.focus();
    }, 500);
  }

  // Thiết lập event handlers
  handleVoucherInput();

  // Thiết lập validate cho form
  const paymentForm = document.getElementById("paymentForm");
  if (paymentForm) {
    paymentForm.addEventListener("submit", function (e) {
      if (!validatePaymentForm()) {
        e.preventDefault();
        return false;
      }
    });
  }
}

// Event listeners khi DOM ready
document.addEventListener("DOMContentLoaded", function () {
  // Xử lý khi modal payment được mở
  $("#paymentModal").on("shown.bs.modal", handlePaymentModalOpen);

  // Reset button khi modal đóng
  $("#paymentModal").on("hidden.bs.modal", resetPaymentButton);

  // Xử lý click nút thanh toán trong menu
  const paymentBtns = document.querySelectorAll(
    '[data-target="#paymentModal"]'
  );
  paymentBtns.forEach((btn) => {
    btn.addEventListener("click", function () {
      // Có thể thêm logic prepare data ở đây nếu cần
    });
  });
});

// Utility function để scroll smooth
function scrollToTop() {
  window.scrollTo({
    top: 0,
    behavior: "smooth",
  });
}
