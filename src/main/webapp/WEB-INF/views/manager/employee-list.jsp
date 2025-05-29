<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý nhân viên - Hệ thống POS</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/manager/global.css"
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
              class="sidebar-nav-link"
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
              href="${pageContext.request.contextPath}/manager/employees"
              class="sidebar-nav-link active"
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
        </nav>
      </div>

      <!-- Main Content -->
      <div class="manager-main">
        <!-- Header -->
        <div class="manager-header">
          <div class="page-header">
            <h1 class="page-title">Quản lý nhân viên</h1>
            <p class="page-subtitle">
              Quản lý thông tin và phân quyền nhân viên
            </p>
          </div>
          <div class="header-actions">
            <div class="search-container">
              <i class="fas fa-search search-icon"></i>
              <input
                type="text"
                placeholder="Tìm kiếm nhân viên..."
                class="search-input"
              />
            </div>
            <a
              href="${pageContext.request.contextPath}/manager/employees/new"
              class="btn btn-primary"
            >
              <i class="fas fa-user-plus"></i>
              <span>Thêm nhân viên</span>
            </a>
          </div>
        </div>

        <!-- Content -->
        <div class="manager-content">
          <!-- Stats Cards -->
          <div class="grid grid-cols-4 mb-xl">
            <div class="card">
              <div class="card-body text-center">
                <div class="text-2xl font-bold text-gray-900">
                  ${employees.size()}
                </div>
                <div class="text-sm text-gray-600">Tổng nhân viên</div>
              </div>
            </div>
            <div class="card">
              <div class="card-body text-center">
                <div class="text-2xl font-bold text-gray-900">
                  <c:set var="managerCount" value="0" />
                  <c:forEach var="employee" items="${employees}">
                    <c:if test="${employee.role == 'MANAGER'}">
                      <c:set var="managerCount" value="${managerCount + 1}" />
                    </c:if>
                  </c:forEach>
                  ${managerCount}
                </div>
                <div class="text-sm text-gray-600">Quản lý</div>
              </div>
            </div>
            <div class="card">
              <div class="card-body text-center">
                <div class="text-2xl font-bold text-gray-900">
                  <c:set var="employeeCount" value="0" />
                  <c:forEach var="employee" items="${employees}">
                    <c:if test="${employee.role == 'EMPLOYEE'}">
                      <c:set var="employeeCount" value="${employeeCount + 1}" />
                    </c:if>
                  </c:forEach>
                  ${employeeCount}
                </div>
                <div class="text-sm text-gray-600">Nhân viên</div>
              </div>
            </div>
            <div class="card">
              <div class="card-body text-center">
                <div class="text-2xl font-bold text-gray-900">
                  <c:set var="adminCount" value="0" />
                  <c:forEach var="employee" items="${employees}">
                    <c:if test="${employee.role == 'ADMIN'}">
                      <c:set var="adminCount" value="${adminCount + 1}" />
                    </c:if>
                  </c:forEach>
                  ${adminCount}
                </div>
                <div class="text-sm text-gray-600">Admin</div>
              </div>
            </div>
          </div>

          <!-- Employee Table -->
          <div class="card">
            <div class="card-header">
              <div class="card-title">Danh sách nhân viên</div>
              <div class="card-subtitle">Tất cả nhân viên trong hệ thống</div>
            </div>
            <div class="table-container">
              <table class="table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Thông tin nhân viên</th>
                    <th>Vai trò</th>
                    <th>Tài khoản</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="employee" items="${employees}">
                    <tr>
                      <td>
                        <span class="font-semibold text-gray-700"
                          >#${employee.employeeId}</span
                        >
                      </td>
                      <td>
                        <div class="flex items-center gap-md">
                          <div
                            style="
                              width: 50px;
                              height: 50px;
                              border-radius: 50%;
                              background: linear-gradient(
                                135deg,
                                var(--primary-color),
                                var(--secondary-color)
                              );
                              display: flex;
                              align-items: center;
                              justify-content: center;
                              color: white;
                              font-weight: 600;
                              font-size: 1.2rem;
                            "
                          >
                            ${employee.name.substring(0,1).toUpperCase()}
                          </div>
                          <div>
                            <div class="font-semibold text-gray-900">
                              ${employee.name}
                            </div>
                            <div class="text-sm text-gray-500">
                              ID: ${employee.employeeId}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td>
                        <c:choose>
                          <c:when test="${employee.role == 'MANAGER'}">
                            <span class="badge badge-info">
                              <i class="fas fa-user-tie"></i>
                              <span>Quản lý</span>
                            </span>
                          </c:when>
                          <c:when test="${employee.role == 'EMPLOYEE'}">
                            <span class="badge badge-success">
                              <i class="fas fa-user"></i>
                              <span>Nhân viên</span>
                            </span>
                          </c:when>
                          <c:when test="${employee.role == 'ADMIN'}">
                            <span class="badge badge-danger">
                              <i class="fas fa-user-shield"></i>
                              <span>Admin</span>
                            </span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge badge-gray"
                              >${employee.role}</span
                            >
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <div class="font-medium text-gray-900">
                          ${employee.username}
                        </div>
                        <div class="text-sm text-gray-500">
                          <i class="fas fa-key"></i> Tài khoản đăng nhập
                        </div>
                      </td>
                      <td>
                        <span class="badge badge-success">
                          <i class="fas fa-check-circle"></i>
                          <span>Hoạt động</span>
                        </span>
                      </td>
                      <td>
                        <div class="flex gap-sm">
                          <a
                            href="${pageContext.request.contextPath}/manager/employees/edit/${employee.employeeId}"
                            class="btn btn-sm btn-secondary"
                            title="Chỉnh sửa thông tin"
                          >
                            <i class="fas fa-edit"></i>
                          </a>
                          <a
                            href="${pageContext.request.contextPath}/manager/employees/delete/${employee.employeeId}"
                            onclick="return confirm('Bạn có chắc muốn xóa nhân viên ${employee.name}? Hành động này không thể hoàn tác!')"
                            class="btn btn-sm btn-danger"
                            title="Xóa nhân viên"
                          >
                            <i class="fas fa-trash"></i>
                          </a>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
            <div class="card-footer">
              <div class="flex justify-between items-center">
                <span class="text-sm text-gray-600">
                  Hiển thị ${employees.size()} nhân viên
                </span>
                <a
                  href="${pageContext.request.contextPath}/manager/dashboard"
                  class="btn btn-secondary"
                >
                  <i class="fas fa-arrow-left"></i>
                  <span>Quay lại Dashboard</span>
                </a>
              </div>
            </div>
          </div>

          <!-- Empty State -->
          <c:if test="${empty employees}">
            <div class="card text-center p-xl">
              <div
                style="
                  color: var(--gray-400);
                  font-size: 4rem;
                  margin-bottom: var(--space-lg);
                "
              >
                <i class="fas fa-users"></i>
              </div>
              <h3 class="text-xl font-semibold text-gray-700 mb-md">
                Chưa có nhân viên nào
              </h3>
              <p class="text-gray-500 mb-lg">
                Thêm nhân viên đầu tiên để bắt đầu quản lý
              </p>
              <a
                href="${pageContext.request.contextPath}/manager/employees/new"
                class="btn btn-primary"
              >
                <i class="fas fa-user-plus"></i>
                <span>Thêm nhân viên đầu tiên</span>
              </a>
            </div>
          </c:if>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/employee-list.js"></script>
  </body>
</html>
