// Mảng lưu trữ các món ăn trong giỏ hàng
let cartItems = [];

// Thêm món vào giỏ hàng
function addToCart(dishId, name, price) {
  // Chuyển đổi thành số nếu cần
  dishId = parseInt(dishId);
  price = parseFloat(price);

  // Tạo hiệu ứng thêm món (tùy chọn)
  const button = document.querySelector(
    `.add-to-cart-btn[data-id="${dishId}"]`
  );
  if (button) {
    button.classList.add("adding");
    setTimeout(() => {
      button.classList.remove("adding");
    }, 300);
  }

  // Kiểm tra xem món đã có trong giỏ hàng chưa
  const existingItem = cartItems.find((item) => item.dishId === dishId);

  if (existingItem) {
    // Nếu món đã có trong giỏ, tăng số lượng
    existingItem.quantity += 1;
  } else {
    // Nếu món chưa có trong giỏ, thêm món mới
    cartItems.push({
      dishId: dishId,
      name: name,
      price: price,
      quantity: 1,
    });
  }

  // Cập nhật hiển thị giỏ hàng
  renderCart();

  // Hiển thị thông báo thành công nhanh (tùy chọn)
  showToast(`Đã thêm ${name} vào giỏ hàng`);
}

// Thông báo nhỏ khi thêm món (tùy chọn)
function showToast(message) {
  // Kiểm tra nếu đã có toast hiển thị thì xóa đi
  const existingToast = document.querySelector(".toast-message");
  if (existingToast) {
    existingToast.remove();
  }

  // Tạo phần tử toast mới
  const toast = document.createElement("div");
  toast.className = "toast-message";
  toast.innerText = message;

  // Thêm vào body
  document.body.appendChild(toast);

  // Hiện toast
  setTimeout(() => {
    toast.classList.add("show");
  }, 10);

  // Ẩn và xóa toast sau 2 giây
  setTimeout(() => {
    toast.classList.remove("show");
    setTimeout(() => {
      toast.remove();
    }, 300);
  }, 2000);
}

// Xóa món khỏi giỏ hàng
function removeFromCart(index) {
  const item = cartItems[index];

  // Hiệu ứng xóa (tùy chọn)
  const itemElements = document.querySelectorAll(
    "#cart-items-list .order-item"
  );
  if (itemElements[index]) {
    itemElements[index].classList.add("removing");
    setTimeout(() => {
      // Xóa khỏi mảng
      cartItems.splice(index, 1);
      renderCart();
    }, 300);
  } else {
    cartItems.splice(index, 1);
    renderCart();
  }
}

// Hiển thị các món trong giỏ hàng
function renderCart() {
  const cartItemsList = document.getElementById("cart-items-list");
  const emptyCartMessage = document.getElementById("empty-cart-message");
  const orderActions = document.getElementById("order-actions");
  const orderTotal = document.getElementById("order-total");

  // Xóa tất cả các món hiện tại trong danh sách giỏ hàng
  cartItemsList.innerHTML = "";

  // Kiểm tra nếu giỏ hàng trống
  if (cartItems.length === 0) {
    emptyCartMessage.style.display = "flex";
    cartItemsList.style.display = "none";
    orderActions.style.display = "none";
    orderTotal.style.display = "none";
    return;
  }

  // Giỏ hàng có món, ẩn thông báo giỏ hàng trống và hiển thị danh sách
  emptyCartMessage.style.display = "none";
  cartItemsList.style.display = "block";

  // Hiển thị các món trong giỏ hàng
  let totalAmount = 0;

  cartItems.forEach((item, index) => {
    const itemTotal = item.price * item.quantity;
    totalAmount += itemTotal;

    const orderItem = document.createElement("div");
    orderItem.className = "order-item";
    orderItem.innerHTML = `
            <div class="order-item-details">
                <div class="order-item-name">${item.name}</div>
                <div class="order-item-price">${item.price}đ x ${item.quantity}</div>
            </div>
            <div class="order-item-actions">
                <button class="edit-item" onclick="editItemQuantity(${index})">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="delete-item" onclick="removeFromCart(${index})">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;

    cartItemsList.appendChild(orderItem);
  });

  // Hiển thị tổng tiền với dạng số có dấu phân cách hàng nghìn
  document.getElementById("total-amount").textContent =
    formatCurrency(totalAmount);
  orderTotal.style.display = "block";

  // Hiển thị phần order-actions
  orderActions.style.display = "flex";

  // Log để debug
  console.log("Đã render giỏ hàng với " + cartItems.length + " món");
}

// Định dạng tiền tệ
function formatCurrency(amount) {
  return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Chỉnh sửa số lượng món
function editItemQuantity(index) {
  const item = cartItems[index];
  const newQuantity = prompt(
    `Số lượng mới cho món ${item.name}:`,
    item.quantity
  );

  if (newQuantity !== null) {
    const quantity = parseInt(newQuantity);
    if (!isNaN(quantity) && quantity > 0) {
      item.quantity = quantity;
      renderCart();
    } else if (quantity === 0) {
      removeFromCart(index);
    } else {
      alert("Vui lòng nhập số lượng hợp lệ.");
    }
  }
}

// Gửi đơn hàng
function submitOrder() {
  if (cartItems.length === 0) {
    alert("Vui lòng chọn ít nhất một món.");
    return;
  }

  const form = document.getElementById("orderForm");

  // Xóa các input hidden hiện tại
  const existingInputs = form.querySelectorAll(
    'input[name="dishIds"], input[name="quantities"]'
  );
  existingInputs.forEach((input) => input.remove());

  // Thêm input hidden cho mỗi món
  cartItems.forEach((item) => {
    const dishIdInput = document.createElement("input");
    dishIdInput.type = "hidden";
    dishIdInput.name = "dishIds";
    dishIdInput.value = item.dishId;
    form.appendChild(dishIdInput);

    const quantityInput = document.createElement("input");
    quantityInput.type = "hidden";
    quantityInput.name = "quantities";
    quantityInput.value = item.quantity;
    form.appendChild(quantityInput);
  });

  // Submit form thông thường
  form.submit();
}

function editExistingItemQuantity(orderDetailId, itemName, currentQuantity) {
  const newQuantity = prompt(
    `Số lượng mới cho món ${itemName}:`,
    currentQuantity
  );

  if (newQuantity !== null) {
    const quantity = parseInt(newQuantity);
    if (!isNaN(quantity) && quantity >= 0) {
      if (quantity === 0) {
        // Hủy món nếu số lượng = 0
        const reason = prompt("Lý do hủy món:");
        if (reason && reason.trim()) {
          // Tạo form ẩn để submit
          const form = document.createElement("form");
          form.method = "POST";
          form.action =
            contextPath + "/employee/orderDetail/" + orderDetailId + "/cancel";

          const reasonInput = document.createElement("input");
          reasonInput.type = "hidden";
          reasonInput.name = "reason";
          reasonInput.value = reason.trim();
          form.appendChild(reasonInput);

          const tableIdInput = document.createElement("input");
          tableIdInput.type = "hidden";
          tableIdInput.name = "tableId";
          tableIdInput.value = currentTableId || tableId;
          form.appendChild(tableIdInput);

          document.body.appendChild(form);
          form.submit();
        } else {
          alert("Vui lòng nhập lý do hủy món.");
        }
      } else {
        // Cập nhật số lượng
        const form = document.createElement("form");
        form.method = "POST";
        form.action =
          contextPath +
          "/employee/orderDetail/" +
          orderDetailId +
          "/updateQuantity";

        const quantityInput = document.createElement("input");
        quantityInput.type = "hidden";
        quantityInput.name = "quantity";
        quantityInput.value = quantity;
        form.appendChild(quantityInput);

        const tableIdInput = document.createElement("input");
        tableIdInput.type = "hidden";
        tableIdInput.name = "tableId";
        tableIdInput.value = currentTableId || tableId;
        form.appendChild(tableIdInput);

        document.body.appendChild(form);
        form.submit();
      }
    } else {
      alert("Vui lòng nhập số lượng hợp lệ.");
    }
  }
}

// Hiển thị form hủy món
function showCancelModal(orderDetailId, itemName) {
  const reason = prompt(`Lý do hủy món ${itemName}:`);
  if (reason && reason.trim()) {
    // Tạo form ẩn để submit
    const form = document.createElement("form");
    form.method = "POST";
    form.action =
      contextPath + "/employee/orderDetail/" + orderDetailId + "/cancel";

    const reasonInput = document.createElement("input");
    reasonInput.type = "hidden";
    reasonInput.name = "reason";
    reasonInput.value = reason.trim();
    form.appendChild(reasonInput);

    const tableIdInput = document.createElement("input");
    tableIdInput.type = "hidden";
    tableIdInput.name = "tableId";
    tableIdInput.value = tableId;
    form.appendChild(tableIdInput);

    document.body.appendChild(form);
    form.submit();
  } else {
    alert("Vui lòng nhập lý do hủy món.");
  }
}

// Hàm để toggle hiển thị nội dung order
function toggleOrderContent(header) {
  var content = header.nextElementSibling;
  var icon = header.querySelector(".fa-chevron-down");

  content.classList.toggle("collapsed");
  icon.classList.toggle("collapsed");
}

// Khởi tạo khi trang được tải
$(document).ready(function () {
  // Thêm CSS styles
  const styleElement = document.createElement("style");
  styleElement.textContent = `
        .toast-message {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #28a745;
            color: white;
            padding: 12px 20px;
            border-radius: 5px;
            z-index: 10000;
            opacity: 0;
            transform: translateX(100px);
            transition: opacity 0.3s, transform 0.3s;
        }
        
        .toast-message.show {
            opacity: 1;
            transform: translateX(0);
        }
        
        .order-item {
            transform: translateY(0);
            opacity: 1;
        }
        
        .order-item.removing {
            transform: translateX(100px);
            opacity: 0;
            transition: transform 0.3s, opacity 0.3s;
        }
        
        .add-to-cart-btn.adding {
            transform: scale(0.8);
            transition: transform 0.3s;
        }

        /* Thu gọn/mở rộng hiệu ứng */
        .existing-orders-content {
            transition: max-height 0.3s ease-out;
            overflow: hidden;
        }
        
        .existing-orders-content.collapsed {
            max-height: 0 !important;
        }
        
        .existing-orders-toggle {
            transition: transform 0.3s ease;
        }
        
        .existing-orders-toggle.collapsed {
            transform: rotate(180deg);
        }
    `;
  document.head.appendChild(styleElement);

  // Khởi tạo phần món đã đặt ở trạng thái mở
  const existingOrdersContent = document.getElementById(
    "existing-orders-content"
  );
  if (existingOrdersContent) {
    // Đặt max-height dựa trên chiều cao thực tế
    const actualHeight = existingOrdersContent.scrollHeight;
    existingOrdersContent.style.maxHeight = actualHeight + "px";
  }

  // Khởi tạo giỏ hàng khi trang được tải
  renderCart();
});
