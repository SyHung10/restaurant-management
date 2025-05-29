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
      href="${pageContext.request.contextPath}/resources/css/manager-global.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/table-list.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/kitchen.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      .overview-bar { display: flex; gap: 24px; margin-bottom: 24px; }
      .overview-box { flex: 1; background: linear-gradient(135deg, #f8fafc, #e0e7ef 80%); border-radius: 14px; box-shadow: 0 1px 6px 0 rgba(80,120,200,0.08); padding: 18px 0; text-align: center; }
      .overview-label { color: #888; font-size: 1em; margin-bottom: 2px; }
      .overview-value { font-size: 2em; font-weight: 700; color: #333; }
      .overview-pending { background: linear-gradient(135deg, #fffde4, #f9f9d2 80%); }
      .overview-served { background: linear-gradient(135deg, #e6faea, #d0f5e8 80%); }
      .overview-cancelled { background: linear-gradient(135deg, #ffeaea, #f9dada 80%); }
      .overview-total { background: linear-gradient(135deg, #e6f0fa, #d2e3f9 80%); }
      .order-filter { display: flex; gap: 12px; align-items: center; width: 100%; margin-bottom: 18px; }
      .order-filter select, .order-filter input[type=date] { padding: 6px 12px; border-radius: 7px; border: 1px solid #d1d5db; background: #f8fafc; font-size: 1em; }
      .order-filter .btn { background: linear-gradient(90deg, #667eea, #764ba2); color: #fff; border: none; border-radius: 7px; padding: 7px 32px; font-weight: 500; height: 36px; min-width: 120px; font-size: 1.08em; }
      .order-table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 14px;
        box-shadow: 0 1px 6px 0 rgba(80,120,200,0.08);
      }
      .order-table th, .order-table td { padding: 12px 10px; text-align: center; border-bottom: 1px solid #f0f0f0; }
      .order-table th { background: #f8fafc; color: #b0b0b0; font-weight: 500; }
      .order-table td { font-weight: 600; text-align: center; }
      .order-table tr.order-row { cursor: pointer; transition: background 0.15s; }
      .order-table tr.order-row:hover { background: #f5f7fa; }
      .order-table tr.order-detail-row { background: #f9fafb; }
      .badge-status { border-radius: 8px; padding: 3px 14px; font-weight: 600; font-size: 0.95em; display: inline-block; }
      .badge-pending { background: #fffde4; color: #b59f00; }
      .badge-served { background: #e6faea; color: #43b36a; }
      .badge-cancelled { background: #ffeaea; color: #e53e3e; }
      .badge-processing { background: #e6f0fa; color: #2b77c7; }
      .pastel-status-dropdown { border-radius: 7px; border: 1.5px solid #e0e7ef; background: #f8fafc; padding: 4px 10px; font-weight: 500; color: #333; }
      .order-detail-table { width: 100%; border-collapse: collapse; margin-top: 8px; }
      .order-detail-table th, .order-detail-table td { padding: 8px 6px; border-bottom: 1px solid #ececec; text-align: left; }
      .order-detail-table th { background: #f5f7fa; font-size: 1em; }
      .order-detail-table td select { font-size: 0.98em; }
      .order-detail-table .badge-status { font-size: 0.95em; }
      @media (max-width: 900px) { .overview-bar { flex-direction: column; gap: 12px; } .order-table th, .order-table td { padding: 8px 4px; } }
      .pastel-badge { border: none; box-shadow: none; }
      .active-badge { box-shadow:0 0 0 2px #a0aec0; }
      .order-detail-container {
        border:2px solid #e0e7ef; border-radius:12px; margin:12px auto; padding:12px 0; max-width:1400px; width:99%; background:#f8fafc;
      }
      .order-detail-table {
        margin:auto; width:100%; table-layout:fixed;
      }
      .order-detail-table th, .order-detail-table td {
        overflow-wrap: break-word;
        word-break: break-word;
      }
      .order-detail-table th.cancel-reason,
      .order-detail-table td.cancel-reason {
        width:32%;
      }
      .order-row { font-weight:600; }
      .order-table th { font-weight:400; }
      .order-detail-table th { color: #b0b0b0; font-weight: 500; text-align: left; }
      .order-detail-table td { font-weight: 600; text-align: left; }
      .order-detail-table { margin:auto; }
      .order-detail-row { background: #f9fafb; }
      .order-table tr.order-row:hover { background: #f5f7fa; }
      .order-table tr.order-row.active-row { background: #e6f0fa; }
      .order-detail-container { box-shadow:0 2px 12px 0 rgba(80,120,200,0.08); }
      .order-filter { max-width: 420px; margin-bottom: 18px; }
      @media (max-width: 900px) { .order-filter { max-width:100%; } }
      .dropdown { position: relative; display: inline-block; }
      .dropdown-content {
        display: none;
        position: absolute;
        z-index: 9999;
        background: #fff;
        min-width: 120px;
        box-shadow: 0 2px 8px #e0e7ef;
        border-radius: 8px;
        padding: 4px 0;
        left: 0;
        top: 110%;
      }
      .dropdown-content button {
        background: none;
        border: none;
        width: 100%;
        text-align: left;
        padding: 8px 16px;
        font-weight: 500;
        color: #333;
        cursor: pointer;
      }
      .dropdown-content button:hover { background: #f5f7fa; }
      .toggle-detail-btn {
        background: none;
        border: none;
        cursor: pointer;
        font-size: 1.2em;
        color: #888;
        transition: color 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 32px;
        height: 32px;
      }
      .toggle-detail-btn:hover {
        color: #333;
      }
      .modal {
        position: fixed;
        z-index: 10000;
        left: 0;
        top: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        justify-content: center;
      }
      .modal-content {
        background: #fff;
        border-radius: 10px;
        padding: 24px;
        min-width: 320px;
        max-width: 90vw;
        box-shadow: 0 2px 16px #8884;
        position: relative;
      }
      .close {
        position: absolute;
        right: 16px;
        top: 12px;
        font-size: 1.5em;
        cursor: pointer;
        color: #888;
      }
      .order-detail-table th.id-col,
      .order-detail-table td.id-col {
        padding-left: 16px;
      }
    </style>
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
          <!-- Filter date range -->
          <form method="get" class="order-filter" action="${pageContext.request.contextPath}/kitchen/kanban">
            <label>Từ:</label>
            <input type="date" name="fromDate" value="${fromDate}" style="height:36px;"/>
            <label>Đến:</label>
            <input type="date" name="toDate" value="${toDate}" style="height:36px;"/>
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
                      <input type="hidden" name="fromDate" value="${fromDate}"/>
                      <input type="hidden" name="toDate" value="${toDate}"/>
                      <div class="dropdown">
                        <button type="button" class="badge-status badge-${order.status.toLowerCase()} pastel-badge" onclick="toggleStatusDropdown(event, ${order.orderId})">
                          ${order.status} <i class="fa fa-caret-down"></i>
                        </button>
                        <div class="dropdown-content" id="status-dropdown-${order.orderId}">
                          <button type="submit" name="status" value="PENDING">PENDING</button>
                          <button type="submit" name="status" value="PROCESSING">PROCESSING</button>
                          <button type="submit" name="status" value="SERVED">SERVED</button>
                          <button type="submit" name="status" value="CANCELLED">CANCELLED</button>
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
                                  <input type="hidden" name="dateType" value="${selectedDateType}"/>
                                  <input type="hidden" name="specificDate" value="${selectedDate}"/>
                                  <div class="dropdown">
                                    <select class="badge-status badge-${item.orderDetail.status.toLowerCase()} pastel-badge"
                                            name="status"
                                            onchange="handleStatusChange(event, '${item.orderDetail.orderDetailId}', this.form, '${selectedDateType}', '${selectedDate}')">
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
          <div id="cancelModal" class="modal" style="display:none;">
            <div class="modal-content">
              <span class="close" onclick="closeCancelModal()">&times;</span>
              <h3>Lý do hủy món</h3>
              <form id="cancelForm" method="post">
                <input type="hidden" name="dateType" id="modalDateType" />
                <input type="hidden" name="specificDate" id="modalSpecificDate" />
                <input type="hidden" name="status" value="CANCELLED" />
                <textarea name="reason" id="cancelReason" rows="3" style="width:100%;" required></textarea>
                <div style="margin-top:12px; text-align:right;">
                  <button type="button" onclick="closeCancelModal()" style="margin-right:8px;">Đóng</button>
                  <button type="submit" class="btn">Xác nhận</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script>
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
      let cancelFormAction = '';
      function handleStatusChange(e, orderDetailId, form, dateType, specificDate) {
        if (e.target.value === 'CANCELLED') {
          e.preventDefault();
          cancelFormAction = form.action;
          document.getElementById('cancelForm').action = cancelFormAction;
          document.getElementById('modalDateType').value = dateType;
          document.getElementById('modalSpecificDate').value = specificDate;
          document.getElementById('cancelModal').style.display = 'flex';
          document.getElementById('cancelReason').value = '';
        } else {
          form.submit();
        }
      }
      function closeCancelModal() {
        document.getElementById('cancelModal').style.display = 'none';
      }
    </script>
  </body>
</html>
