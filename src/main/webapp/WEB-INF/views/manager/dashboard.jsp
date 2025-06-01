<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - Hệ thống POS Nhà hàng</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/manager/global.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/manager/dashboard.css"
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
              href="${pageContext.request.contextPath}/manager/dashboard"
              class="sidebar-nav-link active"
            >
              <i class="fas fa-tachometer-alt sidebar-nav-icon"></i>
              <span>Dashboard</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/manager/tables"
              class="sidebar-nav-link"
            >
              <i class="fas fa-th sidebar-nav-icon"></i>
              <span>Quản lý bàn</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/manager/menus"
              class="sidebar-nav-link"
            >
              <i class="fas fa-utensils sidebar-nav-icon"></i>
              <span>Quản lý món ăn</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/manager/categories"
              class="sidebar-nav-link"
            >
              <i class="fas fa-tags sidebar-nav-icon"></i>
              <span>Quản lý danh mục</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/manager/employees"
              class="sidebar-nav-link"
            >
              <i class="fas fa-users sidebar-nav-icon"></i>
              <span>Quản lý nhân viên</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/manager/promotions"
              class="sidebar-nav-link"
            >
              <i class="fas fa-percent sidebar-nav-icon"></i>
              <span>Quản lý khuyến mãi</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/manager/reports"
              class="sidebar-nav-link"
            >
              <i class="fas fa-chart-bar sidebar-nav-icon"></i>
              <span>Báo cáo</span>
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
          <div class="page-header">
            <h1 class="page-title">Dashboard</h1>
            <p class="page-subtitle">Tổng quan hệ thống quản lý nhà hàng</p>
          </div>
          <div class="header-actions">
            <button class="btn btn-secondary">
              <i class="fas fa-sync-alt"></i>
              <span>Làm mới</span>
            </button>
          </div>
        </div>

        <!-- Content -->
        <div class="manager-content">
          <!-- Welcome Section -->
          <div class="dashboard-welcome">
            <div class="welcome-content">
              <h2 class="welcome-title">Chào mừng đến với Hệ thống POS</h2>
              <p class="welcome-subtitle">
                Nhà hàng Hùng Tuấn - Quản lý hiệu quả, phục vụ tận tâm
              </p>
            </div>
          </div>

          <!-- Stats Section -->
          <div class="grid grid-cols-4 gap-lg mb-xl">
            <div class="stat-card">
              <div class="stat-header">
                <div>
                  <div class="stat-value">${tables.size()}</div>
                  <div class="stat-label">Tổng số bàn</div>
                </div>
                <div
                  class="stat-icon"
                  style="
                    background: linear-gradient(
                      135deg,
                      var(--primary-color),
                      var(--secondary-color)
                    );
                  "
                >
                  <i class="fas fa-th"></i>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-header">
                <div>
                  <div class="stat-value">${menus.size()}</div>
                  <div class="stat-label">Tổng số món ăn</div>
                </div>
                <div
                  class="stat-icon"
                  style="
                    background: linear-gradient(
                      135deg,
                      var(--success-color),
                      #38a169
                    );
                  "
                >
                  <i class="fas fa-utensils"></i>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-header">
                <div>
                  <div class="stat-value">${employees.size()}</div>
                  <div class="stat-label">Tổng số nhân viên</div>
                </div>
                <div
                  class="stat-icon"
                  style="
                    background: linear-gradient(
                      135deg,
                      var(--warning-color),
                      #dd6b20
                    );
                  "
                >
                  <i class="fas fa-users"></i>
                </div>
              </div>
            </div>

            <div class="stat-card">
              <div class="stat-header">
                <div>
                  <div class="stat-value">
                    <c:choose>
                      <c:when test="${todayRevenue != null}">
                        <fmt:formatNumber value="${todayRevenue / 1000000}" type="number" maxFractionDigits="1"/>M
                      </c:when>
                      <c:otherwise>
                        0M
                      </c:otherwise>
                    </c:choose>
                  </div>
                  <div class="stat-label">Doanh thu hôm nay</div>
                </div>
                <div
                  class="stat-icon"
                  style="
                    background: linear-gradient(
                      135deg,
                      var(--info-color),
                      #2b77c7
                    );
                  "
                >
                  <i class="fas fa-money-bill-wave"></i>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Actions Section -->
          <div class="card mb-xl">
            <div class="card-header">
              <div class="card-title">Truy cập nhanh</div>
              <div class="card-subtitle">Các tác vụ thường dùng</div>
            </div>
            <div class="card-body">
              <div class="grid grid-cols-4 gap-lg">
                <a
                  href="${pageContext.request.contextPath}/manager/tables/new"
                  class="quick-action-card"
                >
                  <div
                    class="quick-action-icon"
                    style="
                      background: linear-gradient(
                        135deg,
                        var(--primary-color),
                        var(--secondary-color)
                      );
                    "
                  >
                    <i class="fas fa-plus-circle"></i>
                  </div>
                  <div class="quick-action-title">Thêm bàn mới</div>
                  <div class="quick-action-desc">Thêm bàn vào hệ thống</div>
                </a>

                <a
                  href="${pageContext.request.contextPath}/manager/menus/new"
                  class="quick-action-card"
                >
                  <div
                    class="quick-action-icon"
                    style="
                      background: linear-gradient(
                        135deg,
                        var(--success-color),
                        #38a169
                      );
                    "
                  >
                    <i class="fas fa-hamburger"></i>
                  </div>
                  <div class="quick-action-title">Thêm món ăn</div>
                  <div class="quick-action-desc">Cập nhật thực đơn</div>
                </a>

                <a
                  href="${pageContext.request.contextPath}/manager/employees/new"
                  class="quick-action-card"
                >
                  <div
                    class="quick-action-icon"
                    style="
                      background: linear-gradient(
                        135deg,
                        var(--warning-color),
                        #dd6b20
                      );
                    "
                  >
                    <i class="fas fa-user-plus"></i>
                  </div>
                  <div class="quick-action-title">Thêm nhân viên</div>
                  <div class="quick-action-desc">Quản lý nhân sự</div>
                </a>

                <a
                  href="${pageContext.request.contextPath}/manager/promotions/new"
                  class="quick-action-card"
                >
                  <div
                    class="quick-action-icon"
                    style="
                      background: linear-gradient(
                        135deg,
                        var(--info-color),
                        #2b77c7
                      );
                    "
                  >
                    <i class="fas fa-percent"></i>
                  </div>
                  <div class="quick-action-title">Thêm khuyến mãi</div>
                  <div class="quick-action-desc">Chương trình ưu đãi</div>
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>
  </body>
</html>
