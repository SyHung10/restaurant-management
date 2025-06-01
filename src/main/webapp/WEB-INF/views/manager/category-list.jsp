<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - HT Restaurant Manager</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/category-management.css">
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
                    <a href="${pageContext.request.contextPath}/manager/dashboard" class="sidebar-nav-link">
                        <i class="fas fa-tachometer-alt sidebar-nav-icon"></i>
                        <span>Dashboard</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/tables" class="sidebar-nav-link">
                        <i class="fas fa-th sidebar-nav-icon"></i>
                        <span>Quản lý bàn</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/menus" class="sidebar-nav-link">
                        <i class="fas fa-utensils sidebar-nav-icon"></i>
                        <span>Quản lý món ăn</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/categories" class="sidebar-nav-link active">
                        <i class="fas fa-tags sidebar-nav-icon"></i>
                        <span>Quản lý danh mục</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/employees" class="sidebar-nav-link">
                        <i class="fas fa-users sidebar-nav-icon"></i>
                        <span>Quản lý nhân viên</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/promotions" class="sidebar-nav-link">
                        <i class="fas fa-percent sidebar-nav-icon"></i>
                        <span>Quản lý khuyến mãi</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/reports" class="sidebar-nav-link">
                        <i class="fas fa-chart-bar sidebar-nav-icon"></i>
                        <span>Báo cáo</span>
                    </a>
                </div>
                <div class="sidebar-nav-item logout-item" style="margin-top: auto">
                    <a href="${pageContext.request.contextPath}/logout" class="sidebar-nav-link">
                        <i class="fas fa-sign-out-alt sidebar-nav-icon"></i>
                        <span>Đăng xuất</span>
                    </a>
                </div>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="manager-main">
            <div class="manager-header">
                <div class="category-header">
                    <div class="category-header-left">
                        <h1 class="page-title">
                            <i class="fas fa-tags"></i> Quản lý danh mục
                        </h1>
                        <p class="page-subtitle">Quản lý danh mục món ăn và thống kê</p>
                    </div>
                    <div class="category-header-right">
                        <a href="${pageContext.request.contextPath}/manager/categories/new" class="btn-primary">
                            <i class="fas fa-plus"></i>
                            <span>Thêm danh mục</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="manager-content category-management-container">
                <!-- Statistics Section -->
                <div class="stats-section fade-in">
                    <div class="stat-card">
                        <div class="stat-number">${categories.size()}</div>
                        <div class="stat-label">Tổng danh mục</div>
                        <i class="fas fa-tags stat-icon"></i>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="activeCount" value="0"/>
                            <c:forEach var="category" items="${categories}">
                                <c:if test="${category.status == 'ACTIVE'}">
                                    <c:set var="activeCount" value="${activeCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${activeCount}
                        </div>
                        <div class="stat-label">Danh mục kích hoạt</div>
                        <i class="fas fa-check-circle stat-icon"></i>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="inactiveCount" value="0"/>
                            <c:forEach var="category" items="${categories}">
                                <c:if test="${category.status == 'INACTIVE'}">
                                    <c:set var="inactiveCount" value="${inactiveCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${inactiveCount}
                        </div>
                        <div class="stat-label">Danh mục tạm ngưng</div>
                        <i class="fas fa-pause-circle stat-icon"></i>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:choose>
                                <c:when test="${categories.size() > 0}">
                                    <c:set var="maxOrder" value="0"/>
                                    <c:forEach var="category" items="${categories}">
                                        <c:if test="${category.displayOrder > maxOrder}">
                                            <c:set var="maxOrder" value="${category.displayOrder}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${maxOrder}
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Thứ tự cao nhất</div>
                        <i class="fas fa-sort-numeric-up stat-icon"></i>
                    </div>
                </div>

                <!-- Error/Success Messages -->
                <c:if test="${not empty param.error}">
                    <div class="error-message fade-in">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${param.error}
                    </div>
                </c:if>
                
                <c:if test="${not empty param.success}">
                    <div class="success-message fade-in">
                        <i class="fas fa-check-circle"></i>
                        ${param.success}
                    </div>
                </c:if>

                <!-- Filter Section -->
                <div class="filter-section fade-in">
                    <form method="get" action="${pageContext.request.contextPath}/manager/categories" class="filter-row">
                        <div class="filter-group">
                            <label class="filter-label">Trạng thái:</label>
                            <select name="status" class="filter-select" onchange="this.form.submit()">
                                <option value="">Tất cả trạng thái</option>
                                <option value="ACTIVE" ${param.status == 'ACTIVE' ? 'selected' : ''}>Kích hoạt</option>
                                <option value="INACTIVE" ${param.status == 'INACTIVE' ? 'selected' : ''}>Tạm ngưng</option>
                            </select>
                        </div>
                    </form>
                </div>

                <!-- Category Table -->
                <div class="card fade-in">
                    <div class="card-header">
                        <div class="card-title">Danh sách danh mục</div>
                        <div class="card-subtitle">Quản lý toàn bộ danh mục món ăn</div>
                    </div>
                    <div class="table-container">
                        <table class="category-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Mã danh mục</th>
                                    <th>Tên danh mục</th>
                                    <th>Thứ tự hiển thị</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="category" items="${categories}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 600; color: #64748b;">#${category.categoryId}</div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: #1e293b;">${category.code}</div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: #1e293b;">${category.name}</div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: #059669;">${category.displayOrder}</div>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${category.status == 'ACTIVE'}">
                                                    <span class="status-badge status-active">
                                                        <i class="fas fa-check-circle"></i>
                                                        Kích hoạt
                                                    </span>
                                                </c:when>
                                                <c:when test="${category.status == 'INACTIVE'}">
                                                    <span class="status-badge status-inactive">
                                                        <i class="fas fa-pause-circle"></i>
                                                        Tạm ngưng
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">${category.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/manager/categories/edit/${category.categoryId}" 
                                                   class="action-btn action-btn-edit" title="Chỉnh sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/categories/delete/${category.categoryId}" 
                                                   class="action-btn action-btn-delete" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục ${category.name} không?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty categories}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 40px; color: #64748b;">
                                            <i class="fas fa-tags" style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                                            <div style="font-size: 16px; font-weight: 500;">Chưa có danh mục nào</div>
                                            <div style="font-size: 14px; margin-top: 8px;">Nhấn "Thêm danh mục" để bắt đầu</div>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript cho category management -->
    <script src="${pageContext.request.contextPath}/resources/js/manager/category-management.js"></script>
</body>
</html>
