<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý đơn hàng - Bếp</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/manager/global.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/table-list.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/employee/kitchen.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/kitchen/modal.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/kitchen/kitchen.css" />
  </head>
  <body>
    <div class="manager-layout">
      <!-- Sidebar -->
      <div class="manager-sidebar">
        <div class="sidebar-header">
          <div class="sidebar-logo">🍳 BẾP</div>
          <div class="sidebar-subtitle">Quản lý bếp</div>
        </div>
        <nav class="sidebar-nav">
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/kitchen/kanban"
              class="sidebar-nav-link active"
            >
              <i class="fas fa-receipt sidebar-nav-icon"></i>
              <span>Quản lý đơn hàng</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/kitchen/menu-status"
              class="sidebar-nav-link"
            >
              <i class="fas fa-utensils sidebar-nav-icon"></i>
              <span>Trạng thái menu</span>
            </a>
          </div>
          <div class="sidebar-nav-item logout-item" style="margin-top: auto">
            <a
              href="${pageContext.request.contextPath}/logout"
              class="sidebar-nav-link"
            >
              <i class="fas fa-sign-out-alt sidebar-nav-icon"></i>
              <span>Đăng xuất</span>
            </a>
          </div>
        </nav>
      </div>
      <!-- Main Content -->
      <div class="manager-main">
        <div class="manager-header">
          <div class="page-header">
            <h1 class="page-title">
              <i class="fas fa-receipt"></i> Quản lý đơn hàng
            </h1>
            <p class="page-subtitle">Theo dõi và xử lý các đơn hàng</p>
          </div>
        </div>
        <div class="manager-content">
          <!-- Overview -->
          <div class="overview-bar">
            <div class="overview-box overview-total">
              <div class="overview-label">Tổng đơn</div>
              <div class="overview-value">${totalCount}</div>
            </div>
            <div class="overview-box overview-pending">
              <div class="overview-label">Pending</div>
              <div class="overview-value">${pendingCount}</div>
            </div>
            <div class="overview-box overview-served">
              <div class="overview-label">Served</div>
              <div class="overview-value">${servedCount}</div>
            </div>
            <div class="overview-box overview-cancelled">
              <div class="overview-label">Cancelled</div>
              <div class="overview-value">${cancelledCount}</div>
            </div>
          </div>
          <!-- Filter date range và trạng thái -->
          <form method="get" class="order-filter" action="${pageContext.request.contextPath}/kitchen/kanban">
            <label>Từ:</label>
            <input type="date" name="fromDate" value="${fromDate}" style="height:36px;"/>
            <label>Đến:</label>
            <input type="date" name="toDate" value="${toDate}" style="height:36px;"/>
            <label>Trạng thái:</label>
            <select name="filterStatus" style="height:36px; border-radius:7px; padding:0 10px;">
              <option value="" ${empty filterStatus ? 'selected' : ''}>Tất cả</option>
              <option value="PENDING" ${filterStatus == 'PENDING' ? 'selected' : ''}>PENDING</option>
              <option value="PROCESSING" ${filterStatus == 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
              <option value="SERVED" ${filterStatus == 'SERVED' ? 'selected' : ''}>SERVED</option>
              <option value="CANCELLED" ${filterStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
            </select>
            <button type="submit" class="btn" style="height:36px;padding:0 14px;">Lọc</button>
          </form>
          <!-- Order Table -->
          <table class="order-table">
            <thead>
              <tr>
                <th>Order ID</th>
                <th>Create Time</th>
                <th>Status</th>
                <th>Pending</th>
                <th>Served</th>
                <th>Cancelled</th>
                <th>Total</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="order" items="${orders}">
                <tr class="order-row" style="font-weight:600;">
                  <td>${order.orderId}</td>
                  <td><fmt:formatDate value="${order.orderTime}" pattern="HH:mm dd/MM/yyyy"/></td>
                  <td>
                    <form action="${pageContext.request.contextPath}/kitchen/order/${order.orderId}/change-status" method="post" style="display:inline;" onClick="event.stopPropagation();">
                      <input type="hidden" name="redirectQuery" id="redirectQuery-order-${order.orderId}" />
                      <input type="hidden" name="fromDate" value="${fromDate}"/>
                      <input type="hidden" name="toDate" value="${toDate}"/>
                      <div class="dropdown">
                        <button type="button" class="badge-status badge-${order.status.toLowerCase()} pastel-badge" onclick="toggleStatusDropdown(event, '${order.orderId}')">
                          ${order.status} <i class="fa fa-caret-down"></i>
                        </button>
                        <div class="dropdown-content" id="status-dropdown-${order.orderId}">
                          <button type="submit" name="status" value="PENDING" onclick="setRedirectQueryOrder('${order.orderId}')">PENDING</button>
                          <button type="submit" name="status" value="PROCESSING" onclick="setRedirectQueryOrder('${order.orderId}')">PROCESSING</button>
                          <button type="submit" name="status" value="SERVED" onclick="setRedirectQueryOrder('${order.orderId}')">SERVED</button>
                          <button type="submit" name="status" value="CANCELLED" onclick="setRedirectQueryOrder('${order.orderId}')">CANCELLED</button>
                        </div>
                      </div>
                    </form>
                  </td>
                  <td>${orderPendingMap[order.orderId]}</td>
                  <td>${orderServedMap[order.orderId]}</td>
                  <td>${orderCancelledMap[order.orderId]}</td>
                  <td>${orderTotalMap[order.orderId]}</td>
                  <td>
                    <button type="button" class="toggle-detail-btn" onclick="toggleOrderDetail('${order.orderId}', this)">
                      <i class="fa fa-chevron-down"></i>
                    </button>
                  </td>
                </tr>
                <tr class="order-detail-row" id="order-detail-${order.orderId}" style="display:none;">
                  <td colspan="8" style="padding:0;">
                    <div class="order-detail-container">
                      <table class="order-detail-table" style="margin:auto;">
                        <thead>
                          <tr>
                            <th class="id-col" style="width:9%;">ID</th>
                            <th style="width:20%;">Tên món</th>
                            <th style="width:8%;">Số lượng</th>
                            <th style="width:13%;">Giá</th>
                            <th style="width:15%;">Trạng thái</th>
                            <th class="cancel-reason">Lý do hủy</th>
                          </tr>
                        </thead>
                        <tbody>
                          <c:forEach var="item" items="${orderDetailsMap[order.orderId]}">
                            <tr>
                              <td class="id-col">${item.orderDetail.orderDetailId}</td>
                              <td>${item.menu.name}</td>
                              <td>${item.orderDetail.quantity}</td>
                              <td><fmt:formatNumber value='${item.menu.price}' type='currency' currencySymbol='₫'/></td>
                              <td>
                                <form action="${pageContext.request.contextPath}/kitchen/orderDetail/${item.orderDetail.orderDetailId}/change-status" method="post" style="display:inline;">
                                  <input type="hidden" name="redirectQuery" id="redirectQuery-${item.orderDetail.orderDetailId}" />
                                  <input type="hidden" name="reason" id="cancelReasonInput-${item.orderDetail.orderDetailId}" />
                                  <div class="dropdown">
                                    <select class="badge-status badge-${item.orderDetail.status.toLowerCase()} pastel-badge"
                                            name="status"
                                            onchange="handleStatusChange(event, '${item.orderDetail.orderDetailId}', this.form)">
                                      <option value="PENDING" ${item.orderDetail.status == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                      <option value="PROCESSING" ${item.orderDetail.status == 'PROCESSING' ? 'selected' : ''}>PROCESSING</option>
                                      <option value="SERVED" ${item.orderDetail.status == 'SERVED' ? 'selected' : ''}>SERVED</option>
                                      <option value="CANCELLED" ${item.orderDetail.status == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                    </select>
                                  </div>
                                </form>
                              </td>
                              <td class="cancel-reason">${item.orderDetail.cancelReason}</td>
                            </tr>
                          </c:forEach>
                        </tbody>
                      </table>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
          <!-- Modal nhập lý do hủy -->
          <jsp:include page="cancel-form-fragment.jsp" />
        </div>
      </div>
    </div>
    <script>
      var contextPath = '${pageContext.request.contextPath}';
      function toggleOrderDetail(orderId, btn) {
        var row = document.getElementById('order-detail-' + orderId);
        var icon = btn.querySelector('i');
        var currentDisplay = window.getComputedStyle(row).display;
        if (currentDisplay === 'none') {
          row.style.display = 'table-row';
          if (icon) icon.classList.replace('fa-chevron-down', 'fa-chevron-up');
        } else {
          row.style.display = 'none';
          if (icon) icon.classList.replace('fa-chevron-up', 'fa-chevron-down');
        }
      }
      function toggleStatusDropdown(e, id) {
        e.stopPropagation();
        var el = document.getElementById('status-dropdown-' + id);
        if (!el) el = document.getElementById('status-dropdown-detail' + id);
        if (el.style.display === 'block') {
          el.style.display = 'none';
        } else {
          document.querySelectorAll('.dropdown-content').forEach(function(d) { d.style.display = 'none'; });
          el.style.display = 'block';
        }
      }
      document.addEventListener('click', function() {
        document.querySelectorAll('.dropdown-content').forEach(function(d) { d.style.display = 'none'; });
      });
      let currentCancelForm = null;
      let currentCancelOrderDetailId = null;
      function handleStatusChange(e, orderDetailId, form) {
        if (e.target.value === 'CANCELLED') {
          e.preventDefault();
          currentCancelForm = form;
          currentCancelOrderDetailId = orderDetailId;
          form.action = contextPath + '/kitchen/orderDetail/' + orderDetailId + '/cancel';
          document.getElementById('cancelModal').style.display = 'flex';
          document.getElementById('cancelReason').value = '';
        } else {
          form.action = contextPath + '/kitchen/orderDetail/' + orderDetailId + '/change-status';
          var query = window.location.search;
          var input = document.getElementById('redirectQuery-' + orderDetailId);
          if (input) input.value = query;
          form.submit();
        }
      }
      function submitCancelReason() {
        var reason = document.getElementById('cancelReason').value.trim();
        if (!reason) {
          alert('Vui lòng nhập lý do hủy món!');
          return;
        }
        var input = document.getElementById('cancelReasonInput-' + currentCancelOrderDetailId);
        if (input) input.value = reason;
        var query = window.location.search;
        var redirectInput = document.getElementById('redirectQuery-' + currentCancelOrderDetailId);
        if (redirectInput) redirectInput.value = query;
        currentCancelForm.submit();
        closeCancelModal();
      }
      function setRedirectQueryOrder(orderId) {
        var query = window.location.search;
        var input = document.getElementById('redirectQuery-order-' + orderId);
        if (input) input.value = query;
      }
      function closeCancelModal() {
        document.getElementById('cancelModal').style.display = 'none';
      }
    </script>
  </body>
</html>
