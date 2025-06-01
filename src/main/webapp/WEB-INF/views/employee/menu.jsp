<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>Menu & Đơn hàng bàn ${table.tableNumber}</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/style.css">
                <!-- Thêm Bootstrap CSS -->
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
                <!-- Thêm Font Awesome cho các icon -->
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
                <!-- Thêm CSS tùy chỉnh -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/menu-style.css">
                <!-- Thêm CSS thanh toán -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/payment-modal.css">
                <!-- Thêm CSS trạng thái đơn hàng -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/menu-order-status.css">
                <!-- Thêm CSS cho modal thêm bàn phụ -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/add-table-modal.css">

            </head>

            <body>
                <div class="container-fluid">
                    <!-- Thông báo lỗi thanh toán -->
                    <c:if test="${not empty paymentError}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle mr-2"></i>
                            <strong>Lỗi thanh toán:</strong> ${paymentError}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    
                    <!-- Thông báo thành công thêm bàn phụ -->
                    <c:if test="${not empty addTableSuccess}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle mr-2"></i>
                            <strong>Thành công:</strong> ${addTableSuccess}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    
                    <!-- Thông báo lỗi thêm bàn phụ -->
                    <c:if test="${not empty addTableError}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle mr-2"></i>
                            <strong>Lỗi thêm bàn:</strong> ${addTableError}
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                    </c:if>
                    
                    <div class="row">
                        <!-- Menu Items Section - Chiếm 70% chiều rộng -->
                        <div class="col-lg-9 menu-section">
                            <div class="header-container">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h1 class="page-title">Bàn số ${table.tableNumber} (Tầng ${table.floor})</h1>
                                    <a href="${pageContext.request.contextPath}/employee/table/list"
                                        class="btn btn-outline-secondary btn-sm">
                                        <i class="fas fa-arrow-left mr-2"></i>Quay lại
                                    </a>
                                </div>
                            </div>

                            <ul class="nav nav-pills categories-tabs mb-3" id="categoryTabs" role="tablist">
                                <c:forEach var="category" items="${categories}" varStatus="status">
                                    <li class="nav-item">
                                        <a class="nav-link ${status.index == 0 ? 'active' : ''}"
                                            id="category-${category.categoryId}-tab" data-toggle="tab"
                                            href="#category-${category.categoryId}" role="tab">
                                            ${category.name}
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>

                            <div class="tab-content" id="categoryTabContent">
                                <c:forEach var="category" items="${categories}" varStatus="status">
                                    <div class="tab-pane fade ${status.index == 0 ? 'show active' : ''}"
                                        id="category-${category.categoryId}" role="tabpanel">

                                        <div class="menu-cards-grid">
                                            <c:forEach var="menu" items="${menuByCategory[category.categoryId]}">
                                                <div class="menu-card">
                                                    <div class="menu-image-container">
                                                        <c:choose>
                                                            <c:when test="${not empty menu.imageUrl}">
                                                                <img src="${pageContext.request.contextPath}${menu.imageUrl}"
                                                                    alt="${menu.name}" class="menu-image">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="no-image">Không có ảnh</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="menu-details">
                                                        <div class="menu-name">${menu.name}</div>
                                                        <div class="menu-price">${menu.price}đ</div>
                                                        <button type="button" class="add-to-cart-btn"
                                                            data-id="${menu.dishId}" data-name="${menu.name}"
                                                            data-price="${menu.price}">
                                                            <i class="fas fa-plus"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <!-- Order Summary Section - Chiếm 30% chiều rộng -->
                        <div class="col-lg-3 p-0">
                            <div class="order-summary-panel">
                                <div class="order-summary-header">
                                    <h2 class="order-summary-title">Order Summary</h2>
                                    <span class="customer-info">
                                        <i class="fas fa-user mr-1"></i> ${table.tableNumber}
                                    </span>

                                </div>

                                <!-- Existing Orders Section - Nhóm theo order_id -->
                                <c:if test="${not empty orderDetailViews}">
                                    <div class="existing-orders">
                                        <h3 class="existing-orders-title mb-3">Lịch sử đặt món</h3>

                                        <!-- Lấy danh sách các order_id duy nhất từ orderDetailViews -->
                                        <c:set var="orderIds" value="" />
                                        <c:forEach var="odv" items="${orderDetailViews}">
                                            <c:set var="currentId" value="${odv.orderDetail.orderId}" />
                                            <c:if test="${!fn:contains(orderIds, currentId)}">
                                                <c:set var="orderIds" value="${orderIds},${currentId}" />
                                            </c:if>
                                        </c:forEach>

                                        <!-- Hiển thị các món nhóm theo order_id -->
                                        <c:forTokens var="orderId"
                                            items="${fn:substring(orderIds, 1, fn:length(orderIds))}" delims=",">
                                            <!-- Lấy đối tượng order đầu tiên tương ứng với orderId -->
                                            <c:set var="currentOrder" value="${null}" />
                                            <c:forEach var="odv" items="${orderDetailViews}">
                                                <c:if
                                                    test="${odv.orderDetail.orderId == orderId && currentOrder == null}">
                                                    <c:set var="currentOrder" value="${odv.order}" />
                                                </c:if>
                                            </c:forEach>

                                            <div class="order-group">
                                                <div class="order-header" onclick="toggleOrderContent(this)">
                                                    <span>
                                                        Đơn #${orderId}
                                                        <c:if test="${currentOrder != null}">
                                                            <span
                                                                class="order-status-badge ${currentOrder.status == 'PENDING' ? 'badge-warning' : 
                                                                currentOrder.status == 'PROCESSING' ? 'badge-cooking' : 
                                                                currentOrder.status == 'SERVED' ? 'badge-success' : 
                                                                currentOrder.status == 'CANCELLED' ? 'badge-danger' : 'badge-info'}">
                                                                ${currentOrder.status == 'PENDING' ? 'Chờ xử lý' :
                                                                currentOrder.status == 'PROCESSING' ? 'Cooking' :
                                                                currentOrder.status == 'SERVED' ? 'Ready' :
                                                                currentOrder.status == 'CANCELLED' ? 'Đã hủy' :
                                                                currentOrder.status}
                                                            </span>
                                                        </c:if>
                                                    </span>
                                                    <i class="fas fa-chevron-down"></i>
                                                </div>
                                                <div class="order-content">
                                                    <c:forEach var="odv" items="${orderDetailViews}">
                                                        <c:if test="${odv.orderDetail.orderId == orderId}">
                                                            <div class="order-item">
                                                                <div class="order-item-details">
                                                                    <div class="order-item-name">
                                                                        ${odv.menu.name}
                                                                        <span
                                                                            class="order-item-status 
                                                                        ${odv.orderDetail.status == 'PENDING' ? 'status-in-queue' : 
                                                                          odv.orderDetail.status == 'PROCESSING' ? 'status-cooking' :
                                                                          odv.orderDetail.status == 'SERVED' ? 'status-ready' :
                                                                          odv.orderDetail.status == 'CANCELLED' ? 'status-cancelled' : 'status-in-queue'}">
                                                                            ${odv.orderDetail.status == 'PENDING' ? 'In
                                                                            queue' :
                                                                            odv.orderDetail.status == 'PROCESSING' ?
                                                                            'Cooking' :
                                                                            odv.orderDetail.status == 'SERVED' ? 'Ready'
                                                                            :
                                                                            odv.orderDetail.status == 'CANCELLED' ? 'Đã
                                                                            hủy' : 'In queue'}
                                                                        </span>
                                                                    </div>
                                                                    <div class="order-item-price">
                                                                        ${odv.orderDetail.price}đ x
                                                                        ${odv.orderDetail.quantity}
                                                                    </div>
                                                                </div>
                                                                <div class="order-item-actions">
                                                                    <c:if test="${odv.orderDetail.status == 'PENDING'}">
                                                                        <button class="edit-item btn-edit-quantity"
                                                                            data-order-detail-id="${odv.orderDetail.orderDetailId}"
                                                                            data-item-name="${odv.menu.name}"
                                                                            data-current-quantity="${odv.orderDetail.quantity}">
                                                                            <i class="fas fa-edit"></i>
                                                                        </button>
                                                                        <button class="delete-item btn-cancel-order"
                                                                            data-order-detail-id="${odv.orderDetail.orderDetailId}"
                                                                            data-item-name="${odv.menu.name}">
                                                                            <i class="fas fa-trash"></i>
                                                                        </button>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                        </c:forTokens>
                                    </div>
                                </c:if>

                                <div id="order-items-container">
                                    <div class="empty-cart-container" id="empty-cart-message">
                                        <i class="fas fa-shopping-cart mb-3" style="font-size: 30px;"></i>
                                        <div class="empty-cart-message">Chưa có món nào được chọn</div>
                                    </div>
                                    <div id="cart-items-list">
                                        <!-- Order items will be dynamically added here -->
                                    </div>
                                </div>

                                <div id="order-total" class="order-total" style="display: none;">
                                    Tổng tiền: <span id="total-amount">0</span>
                                </div>

                                <form id="orderForm"
                                    action="${pageContext.request.contextPath}/employee/table/${table.tableId}/order"
                                    method="post">
                                    <input type="hidden" name="numPeople" value="1" />
                                    <!-- Hidden inputs will be dynamically added here -->

                                    <div class="order-actions" id="order-actions" style="display: none;">
                                        <button type="button" id="sendToCommand" class="send-to-command"
                                            onclick="submitOrder()">
                                            <i class="fas fa-paper-plane mr-2"></i>Gửi bếp
                                        </button>
                                    </div>
                                </form>





                                <!-- Add Table Button -->
                                <c:if test="${not empty orderDetailViews}">
                                    <div class="session-tables-info mb-2">
                                        <span class="session-info-label">Bàn đang phục vụ:</span>
                                        <div id="selected-tables-display" class="selected-tables-display">
                                            <c:forEach var="sessionTable" items="${sessionTables}">
                                                <span class="table-tag ${sessionTable.tableId == table.tableId ? 'current-table' : ''}">
                                                    T${sessionTable.tableNumber}
                                                    <c:if test="${sessionTable.tableId == table.tableId}">
                                                        <i class="fas fa-star" title="Bàn hiện tại"></i>
                                                    </c:if>
                                                </span>
                                            </c:forEach>
                                        </div>
                                        <button type="button" class="add-table-btn-new" data-toggle="modal" data-target="#addTableModal">
                                            <i class="fas fa-plus mr-1"></i>Thêm bàn
                                                        </button>
                                    </div>
                                </c:if>

                                <!-- Checkout Button -->
                                <c:if test="${not empty orderDetailViews}">
                    <button type="button" class="checkout-btn" onclick="$('#paymentModal').modal('show')">
                                        <i class="fas fa-credit-card mr-2"></i>Thanh toán
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thêm jQuery và Bootstrap JS -->
                <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>





                <!-- Modal chỉnh sửa số lượng -->
                <div class="modal fade" id="editQuantityModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Chỉnh sửa số lượng</h5>
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <form id="editQuantityForm" method="post">
                                <div class="modal-body">
                                    <p>Món: <strong id="editItemName"></strong></p>
                                    <div class="form-group">
                                        <label>Số lượng mới:</label>
                                        <input type="number" name="quantity" id="editQuantityInput" min="0" class="form-control" required>
                                        <input type="hidden" name="tableId" value="${table.tableId}">
                                    </div>
                                    <div id="zeroQuantityWarning" class="alert alert-warning" style="display:none;">
                                        Số lượng = 0 sẽ hủy món này
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Modal hủy món -->
                <div class="modal fade" id="cancelOrderModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Hủy món</h5>
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <form id="cancelOrderForm" method="post">
                                <div class="modal-body">
                                    <p>Hủy món: <strong id="cancelItemName"></strong></p>
                                    <div class="form-group">
                                        <label>Lý do hủy:</label>
                                        <textarea name="reason" class="form-control" rows="3" required></textarea>
                                        <input type="hidden" name="tableId" value="${table.tableId}">
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-danger">Xác nhận hủy</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Modal thanh toán hoàn chỉnh -->
                <div class="modal fade payment-modal" id="paymentModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Thanh toán bàn ${table.tableNumber}</h5>
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <c:if test="${not empty orderDetailViews}">
                                    <!-- Thông tin bàn -->
                                    <div class="payment-info mb-3">
                                        <h6><i class="fas fa-table mr-2"></i>Thông tin bàn</h6>
                                        <c:choose>
                                            <c:when test="${fn:length(sessionTables) > 1}">
                                                <p><strong>Nhóm bàn:</strong> 
                                                    <c:forEach var="sessionTable" items="${sessionTables}" varStatus="status">
                                                        T${sessionTable.tableNumber}${!status.last ? ', ' : ''}
                                                    </c:forEach>
                                                </p>
                                                <p><strong>Tầng:</strong> ${table.floor}</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p>Bàn số ${table.tableNumber} - Tầng ${table.floor}</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- Danh sách món đã đặt -->
                                    <div class="order-summary mb-3">
                                        <h6><i class="fas fa-list mr-2"></i>Món đã đặt</h6>
                                        <div class="table-responsive">
                                            <table class="table table-sm">
                                                <thead>
                                                    <tr>
                                                        <th>Món</th>
                                                        <th>Đơn giá</th>
                                                        <th>SL</th>
                                                        <th>Thành tiền</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="odv" items="${orderDetailViews}">
                                                        <c:if test="${odv.orderDetail.status != 'CANCELLED'}">
                                                            <tr>
                                                                <td>
                                                                    ${odv.menu.name}
                                                                    <c:if test="${odv.orderDetail.isGift}">
                                                                        <span class="badge badge-success">Tặng</span>
                                                                    </c:if>
                                                                </td>
                                                                <td>${odv.orderDetail.price}đ</td>
                                                                <td>${odv.orderDetail.quantity}</td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${odv.orderDetail.isGift}">
                                                                            0đ
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${odv.orderDetail.price * odv.orderDetail.quantity}đ
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Tính toán tiền -->
                                    <div class="payment-calculation mb-3">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <label>Mã voucher (tùy chọn):</label>
                                                    <div class="input-group">
                                                        <input type="text" id="voucherCodeInput" class="form-control" placeholder="Nhập mã voucher">
                                                        <div class="input-group-append">
                                                            <button type="button" class="btn btn-outline-primary" id="applyVoucherBtn" onclick="applyVoucher()">
                                                                <i class="fas fa-ticket-alt mr-1"></i>Áp mã
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div id="voucherMessage" class="mt-2"></div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="payment-summary">
                                                    <p><strong>Tổng tiền: <span id="totalAmountDisplay">${paymentTotal}đ</span></strong></p>
                                                    <p>Giảm giá voucher: <span id="voucherDiscountDisplay">0đ</span></p>
                                                    <hr>
                                                    <p><strong>Thành tiền: <span id="finalAmountDisplay">${finalAmount}đ</span></strong></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Phương thức thanh toán -->
                                    <div class="payment-method mb-3">
                                        <h6><i class="fas fa-credit-card mr-2"></i>Phương thức thanh toán</h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="paymentMethod" value="CASH" id="cashMethod" checked>
                                                    <label class="form-check-label" for="cashMethod">
                                                        <i class="fas fa-money-bill mr-2"></i>Tiền mặt
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="paymentMethod" value="CARD" id="cardMethod">
                                                    <label class="form-check-label" for="cardMethod">
                                                        <i class="fas fa-credit-card mr-2"></i>Thẻ
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Form thanh toán -->
                                    <form id="paymentForm" action="${pageContext.request.contextPath}/employee/payment/${table.tableId}/confirm" method="post">
                                        <input type="hidden" name="voucherCode" id="hiddenVoucherCode" value="">
                                        <input type="hidden" name="paymentMethod" id="hiddenPaymentMethod" value="CASH">
                                    </form>
                                </c:if>

                                <c:if test="${empty orderDetailViews}">
                                    <div class="alert alert-warning text-center">
                                        <i class="fas fa-exclamation-triangle mr-2"></i>
                                        Chưa có món nào được đặt cho bàn này!
                                </div>
                                </c:if>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                <c:if test="${not empty orderDetailViews}">
                                    <button type="button" class="btn btn-success" onclick="confirmPayment()">
                                        <i class="fas fa-check-circle mr-2"></i>Xác nhận thanh toán
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal thêm bàn phụ -->
                <div class="modal fade add-table-modal" id="addTableModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Chọn bàn phụ</h5>
                                <button type="button" class="close" data-dismiss="modal">
                                    <span>&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <c:choose>
                                    <c:when test="${not empty availableTables}">
                                        <!-- Thông tin số bàn -->
                                        <div class="table-count-info">
                                            <span class="count-number">${fn:length(availableTables)}</span>
                                            <span class="count-label">bàn có thể xem</span>
                                            <div style="font-size: 0.8rem; color: #7f8c8d; margin-top: 5px;">
                                                Chỉ có thể chọn bàn sẵn sàng hoặc đã đặt trước
                                            </div>
                                        </div>

                                        <!-- Form chọn bàn phụ -->
                                        <form id="addTableForm" action="${pageContext.request.contextPath}/employee/table/${table.tableId}/add-additional-tables" method="post">
                                            <!-- Selection Summary -->
                                            <div class="selection-summary" id="selectionSummary">
                                                <h6><i class="fas fa-check-circle mr-2"></i>Bàn đã chọn:</h6>
                                                <div class="selected-tables-list" id="selectedTablesList">
                                                    <!-- Selected tables will be shown here -->
                                                </div>
                                            </div>

                                            <!-- Table Cards Grid -->
                                            <div class="table-cards-grid">
                                                <c:forEach var="availableTable" items="${availableTables}">
                                                    <c:set var="canSelect" value="${availableTable.status == 'AVAILABLE' || availableTable.status == 'RESERVED'}" />
                                                    <c:set var="statusClass" value="${fn:toLowerCase(fn:replace(availableTable.status, '_', '-'))}" />
                                                    
                                                    <div class="table-card-modal ${!canSelect ? 'disabled' : ''}" 
                                                         data-table-id="${availableTable.tableId}"
                                                         data-table-number="${availableTable.tableNumber}"
                                                         data-can-select="${canSelect}">
                                                        
                                                        <c:if test="${canSelect}">
                                                            <div class="selection-indicator"></div>
                                                            <input type="checkbox" name="additionalTableIds" value="${availableTable.tableId}" class="table-checkbox-modal">
                                                        </c:if>
                                                        
                                                        <div class="table-number-modal">
                                                            Bàn ${availableTable.tableNumber}
                                                        </div>
                                                        
                                                        <div class="table-info-modal">
                                                            <div class="table-floor-modal">
                                                                <i class="fas fa-building mr-1"></i>Tầng ${availableTable.floor}
                                                            </div>
                                                            <div class="table-capacity-modal">
                                                                <i class="fas fa-users mr-1"></i>${availableTable.capacity} chỗ
                                                            </div>
                                                        </div>
                                                        
                                                        <div class="table-status-modal ${statusClass}">
                                                            <c:choose>
                                                                <c:when test="${availableTable.status == 'AVAILABLE'}">
                                                                    <i class="fas fa-check mr-1"></i>Sẵn sàng
                                                                </c:when>
                                                                <c:when test="${availableTable.status == 'RESERVED'}">
                                                                    <i class="fas fa-clock mr-1"></i>Đã đặt
                                                                </c:when>
                                                                <c:when test="${availableTable.status == 'SERVING'}">
                                                                    <i class="fas fa-utensils mr-1"></i>Đang phục vụ
                                                                </c:when>
                                                                <c:when test="${availableTable.status == 'PENDING_PAYMENT'}">
                                                                    <i class="fas fa-credit-card mr-1"></i>Chờ thanh toán
                                                                </c:when>
                                                                <c:when test="${availableTable.status == 'PAID'}">
                                                                    <i class="fas fa-check-circle mr-1"></i>Đã thanh toán
                                                                </c:when>
                                                                <c:when test="${availableTable.status == 'CLEANING'}">
                                                                    <i class="fas fa-broom mr-1"></i>Đang dọn dẹp
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="fas fa-question mr-1"></i>${availableTable.status}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        
                                                        <c:if test="${!canSelect}">
                                                            <div class="not-selectable-overlay">
                                                                <i class="fas fa-lock"></i>
                                                                <span>Không thể chọn</span>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Empty State -->
                                        <div class="empty-tables-state">
                                            <i class="fas fa-inbox"></i>
                                            <h5>Không có bàn sẵn sàng</h5>
                                            <p>Hiện tại không có bàn nào có thể thêm vào phiên phục vụ này.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                <c:if test="${not empty availableTables}">
                                    <button type="button" class="btn btn-primary" id="confirmAddTablesBtn" onclick="confirmAddTables()" disabled>
                                        <i class="fas fa-plus mr-2"></i>Thêm bàn đã chọn
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thêm JavaScript tùy chỉnh (không AJAX) -->
                <script src="${pageContext.request.contextPath}/resources/js/employee/menu-no-ajax.js"></script>
                <!-- Thêm JavaScript cho modal thanh toán -->
                <script src="${pageContext.request.contextPath}/resources/js/employee/payment-modal.js"></script>
                <!-- Thêm JavaScript cho modal thêm bàn phụ -->
                <script src="${pageContext.request.contextPath}/resources/js/employee/add-table-modal.js"></script>

                <script>
                    // Thiết lập biến đường dẫn gốc cho JavaScript
                    var contextPath = '${pageContext.request.contextPath}';
                    var currentTableId = '${table.tableId}';
                    var sessionId = '${sessionId}' || null;

                    // Khởi tạo sự kiện click cho các nút thêm món
                    $(document).ready(function () {
                        $('.add-to-cart-btn').on('click', function () {
                            var dishId = $(this).data('id');
                            var name = $(this).data('name');
                            var price = $(this).data('price');
                            addToCart(dishId, name, price);
                        });

                        // Event listeners cho modal chỉnh sửa số lượng
                        $('.btn-edit-quantity').on('click', function() {
                            var orderDetailId = $(this).data('order-detail-id');
                            var itemName = $(this).data('item-name');
                            var currentQuantity = $(this).data('current-quantity');
                            
                            document.getElementById('editItemName').textContent = itemName;
                            document.getElementById('editQuantityInput').value = currentQuantity;
                            document.getElementById('editQuantityForm').action = 
                                contextPath + '/employee/orderDetail/' + orderDetailId + '/updateQuantity';
                            
                            $('#editQuantityModal').modal('show');
                        });

                        // Event listeners cho modal hủy món
                        $('.btn-cancel-order').on('click', function() {
                            var orderDetailId = $(this).data('order-detail-id');
                            var itemName = $(this).data('item-name');
                            
                            document.getElementById('cancelItemName').textContent = itemName;
                            document.getElementById('cancelOrderForm').action = 
                                contextPath + '/employee/orderDetail/' + orderDetailId + '/cancel';
                            
                            $('#cancelOrderModal').modal('show');
                        });

                        // Kiểm tra số lượng = 0 trong modal
                        $('#editQuantityInput').on('input', function() {
                            if (this.value == 0) {
                                document.getElementById('zeroQuantityWarning').style.display = 'block';
                            } else {
                                document.getElementById('zeroQuantityWarning').style.display = 'none';
                            }
                        });

                        // Event listeners cho phương thức thanh toán
                        $('input[name="paymentMethod"]').on('change', function() {
                            document.getElementById('hiddenPaymentMethod').value = this.value;
                        });

                        // Khởi tạo giỏ hàng khi trang được tải
                        renderCart();
                    });

                    // Functions cho modal thanh toán
                    function confirmPayment() {
                        // Lấy voucher code
                        var voucherCode = document.getElementById('voucherCodeInput').value.trim();
                        document.getElementById('hiddenVoucherCode').value = voucherCode;
                        
                        // Submit form
                        document.getElementById('paymentForm').submit();
                    }

                    // Hàm áp dụng voucher (sử dụng form submission thay vì AJAX)
                    function applyVoucher() {
                        var voucherCode = document.getElementById('voucherCodeInput').value.trim();
                        
                        if (!voucherCode) {
                            document.getElementById('voucherMessage').innerHTML = 
                                '<div class="alert alert-warning">Vui lòng nhập mã voucher!</div>';
                            return;
                        }

                        // Hiển thị loading
                        var btn = document.getElementById('applyVoucherBtn');
                        var originalText = btn.innerHTML;
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang kiểm tra...';
                        btn.disabled = true;

                        // Tạo form ẩn để submit
                        var form = document.createElement('form');
                        form.method = 'POST';
                        form.action = contextPath + '/employee/payment/' + currentTableId + '/check-voucher';
                        form.target = 'voucherFrame';
                        form.style.display = 'none';

                        var input = document.createElement('input');
                        input.type = 'hidden';
                        input.name = 'voucherCode';
                        input.value = voucherCode;
                        form.appendChild(input);

                        // Tạo iframe ẩn để nhận kết quả
                        var iframe = document.getElementById('voucherFrame');
                        if (!iframe) {
                            iframe = document.createElement('iframe');
                            iframe.id = 'voucherFrame';
                            iframe.name = 'voucherFrame';
                            iframe.style.display = 'none';
                            document.body.appendChild(iframe);
                        }

                        iframe.onload = function() {
                            // Đọc nội dung từ iframe
                            try {
                                var result = iframe.contentDocument.body.innerHTML;
                                document.getElementById('voucherMessage').innerHTML = result;
                                
                                // Cập nhật payment summary nếu voucher hợp lệ
                                var successDiv = iframe.contentDocument.querySelector('.voucher-result.success');
                                if (successDiv) {
                                    var voucherDiscount = iframe.contentDocument.querySelector('.voucher-discount');
                                    var finalAmount = iframe.contentDocument.querySelector('.final-amount');
                                    
                                    if (voucherDiscount && finalAmount) {
                                        document.getElementById('voucherDiscountDisplay').textContent = voucherDiscount.textContent;
                                        document.getElementById('finalAmountDisplay').textContent = finalAmount.textContent;
                                    }
                                }
                            } catch (e) {
                                document.getElementById('voucherMessage').innerHTML = 
                                    '<div class="alert alert-danger">Có lỗi xảy ra khi kiểm tra voucher!</div>';
                            }
                            
                            // Khôi phục nút
                            btn.innerHTML = originalText;
                            btn.disabled = false;
                        };

                        document.body.appendChild(form);
                        form.submit();
                    }

                    // Hàm để toggle hiển thị nội dung order
                    function toggleOrderContent(header) {
                        var content = header.nextElementSibling;
                        var icon = header.querySelector('.fa-chevron-down');

                        content.classList.toggle('collapsed');
                        icon.classList.toggle('collapsed');
                    }
                </script>
            </body>

            </html>