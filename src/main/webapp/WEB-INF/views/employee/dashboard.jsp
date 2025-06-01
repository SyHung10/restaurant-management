<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Tổng quan - Nhân viên</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/manager/global.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/employee.css"
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
  </head>
  <body>
    <div class="manager-layout">
      <!-- Sidebar -->
      <div class="manager-sidebar">
        <div class="sidebar-header">
          <div class="sidebar-logo">🍴 HT POS</div>
          <div class="sidebar-subtitle">Hệ thống quản lý nhà hàng</div>
        </div>
        <nav class="sidebar-nav">
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/employee/dashboard"
              class="sidebar-nav-link active"
            >
              <i class="fas fa-chart-line sidebar-nav-icon"></i>
              <span>Tổng quan</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/employee/table/list"
              class="sidebar-nav-link"
            >
              <i class="fas fa-table sidebar-nav-icon"></i>
              <span>Quản lý bàn</span>
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
        <!-- Header -->
        <div class="manager-header">
          <div class="header-content">
            <h1 class="page-title">
              <i class="fas fa-chart-line"></i>
              <span>Tổng quan</span>
            </h1>
            <p class="page-description">Tổng quan trạng thái bàn</p>
          </div>
        </div>

        <!-- Content -->
        <div class="manager-content">
          <div class="grid grid-cols-4 gap-md mb-lg">
            <div class="employee-stats-card">
              <div>Tổng bàn</div>
              <div class="text-2xl font-bold">${totalTables}</div>
            </div>
            <div class="employee-stats-card">
              <div>Đang phục vụ</div>
              <div class="text-2xl font-bold">${servingTables}</div>
            </div>
            <div class="employee-stats-card">
              <div>Chờ thanh toán</div>
              <div class="text-2xl font-bold">${pendingPaymentTables}</div>
            </div>
            <div class="employee-stats-card">
              <div>Đang dọn dẹp</div>
              <div class="text-2xl font-bold">${cleanedTables}</div>
            </div>
          </div>
          <!-- Payment History Filter -->
          <form
            method="get"
            class="order-filter"
            action="${pageContext.request.contextPath}/employee/dashboard"
          >
            <label>Từ:</label>
            <input
              type="date"
              name="fromDate"
              value="${fromDate}"
              style="height: 36px"
            />
            <label>Đến:</label>
            <input
              type="date"
              name="toDate"
              value="${toDate}"
              style="height: 36px"
            />
            <button
              type="submit"
              class="btn"
              style="height: 36px; padding: 0 14px"
            >
              Lọc
            </button>
          </form>
          <!-- Payment History Table -->
          <table class="order-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>Thời gian</th>
                <th>Tổng tiền</th>
                <th>Mã khuyến mãi</th>
                <th>Giảm voucher</th>
                <th>Thành tiền</th>
                <th>Phương thức</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="p" items="${payments}">
                <tr>
                  <td>${p.paymentId}</td>
                  <td>
                    <fmt:formatDate
                      value="${p.paymentTime}"
                      pattern="HH:mm dd/MM/yyyy"
                    />
                  </td>
                  <td>
                    <fmt:formatNumber
                      value="${p.totalAmount}"
                      type="currency"
                      currencySymbol="₫"
                    />
                  </td>
                  <td>${p.promotionId}</td>
                  <td>
                    <fmt:formatNumber
                      value="${p.voucherDiscount}"
                      type="currency"
                      currencySymbol="₫"
                    />
                  </td>
                  <td>
                    <fmt:formatNumber
                      value="${p.finalAmount}"
                      type="currency"
                      currencySymbol="₫"
                    />
                  </td>
                  <td>${p.paymentMethod}</td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </body>
</html>