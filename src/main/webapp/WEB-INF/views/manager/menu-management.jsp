<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Quản lý Menu - Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/menu-management.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
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
                    <a href="${pageContext.request.contextPath}/manager/menus" class="sidebar-nav-link active">
                        <i class="fas fa-utensils sidebar-nav-icon"></i>
                        <span>Quản lý món ăn</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/categories" class="sidebar-nav-link">
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
                <div class="menu-header">
                    <div class="menu-header-left">
                        <h1 class="page-title">
                            <i class="fas fa-utensils"></i> Quản lý Menu
                        </h1>
                        <p class="page-subtitle">Quản lý món ăn, trạng thái và báo cáo doanh thu</p>
                    </div>
                    <div class="menu-header-right">
                        <!-- Nút thêm món mới đã di chuyển xuống filter section -->
                    </div>
                </div>
            </div>

            <div class="manager-content menu-management-container">
                <!-- Statistics Section -->
                <div class="stats-section fade-in">
                    <div class="stat-card">
                        <div class="stat-number">${menus.size()}</div>
                        <div class="stat-label">Tổng món ăn</div>
                        <i class="fas fa-utensils stat-icon"></i>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="availableCount" value="0"/>
                            <c:forEach var="menu" items="${menus}">
                                <c:if test="${menu.status == 'AVAILABLE'}">
                                    <c:set var="availableCount" value="${availableCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${availableCount}
                        </div>
                        <div class="stat-label">Món đang bán</div>
                        <i class="fas fa-check-circle stat-icon"></i>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:set var="unavailableCount" value="0"/>
                            <c:forEach var="menu" items="${menus}">
                                <c:if test="${menu.status == 'UNAVAILABLE'}">
                                    <c:set var="unavailableCount" value="${unavailableCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${unavailableCount}
                        </div>
                        <div class="stat-label">Món tạm ngưng</div>
                        <i class="fas fa-pause-circle stat-icon"></i>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol=""/>₫
                        </div>
                        <div class="stat-label">Tổng doanh thu</div>
                        <i class="fas fa-chart-line stat-icon"></i>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-section fade-in">
                    <form method="get" action="${pageContext.request.contextPath}/manager/menus" class="filter-row">
                        <div class="filter-group">
                            <label class="filter-label">Từ ngày:</label>
                            <input type="date" name="fromDate" value="${fromDate}" class="filter-input" />
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Đến ngày:</label>
                            <input type="date" name="toDate" value="${toDate}" class="filter-input" />
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Danh mục:</label>
                            <select name="categoryId" class="filter-select">
                                <option value="">Tất cả danh mục</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}" ${param.categoryId == category.categoryId ? 'selected' : ''}>
                                        ${category.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">Trạng thái:</label>
                            <select name="status" class="filter-select">
                                <option value="">Tất cả trạng thái</option>
                                <option value="AVAILABLE" ${param.status == 'AVAILABLE' ? 'selected' : ''}>Đang bán</option>
                                <option value="UNAVAILABLE" ${param.status == 'UNAVAILABLE' ? 'selected' : ''}>Tạm ngưng</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">&nbsp;</label>
                            <button type="submit" class="btn-primary">
                                <i class="fas fa-filter"></i>
                                Lọc
                            </button>
                        </div>
                        <div class="filter-group">
                            <label class="filter-label">&nbsp;</label>
                            <a href="${pageContext.request.contextPath}/manager/menus/new" class="btn-primary">
                                <i class="fas fa-plus"></i>
                                Thêm món mới
                            </a>
                        </div>
                    </form>
                </div>

                <!-- Menu Table -->
                <div class="card fade-in">
                    <div class="card-header">
                        <div class="card-title">Danh sách món ăn</div>
                        <div class="card-subtitle">Quản lý toàn bộ món ăn và báo cáo doanh thu</div>
                    </div>
                    <div class="table-container">
                        <table class="menu-table">
                            <thead>
                                <tr>
                                    <th>Ảnh</th>
                                    <th>Tên món</th>
                                    <th>Danh mục</th>
                                    <th>Giá</th>
                                    <th>Doanh thu</th>
                                    <th>Đã bán</th>
                                    <th>Hủy</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="menu" items="${menus}">
                                    <tr>
                                        <td style="width:80px;">
                                            <c:choose>
                                                <c:when test="${not empty menu.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}${menu.imageUrl}" 
                                                         alt="${menu.name}" class="menu-image"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="no-image">
                                                        <i class="fas fa-image"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: #1e293b;">${menu.name}</div>
                                        </td>
                                        <td>
                                            <span class="category-item">${menu.category.name}</span>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: #059669;">
                                                <fmt:formatNumber value="${menu.price}" type="currency" currencySymbol=""/>₫
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: #dc2626;">
                                                <fmt:formatNumber value="${revenueMap[menu.dishId]}" type="currency" currencySymbol=""/>₫
                                            </div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600;">${orderCountMap[menu.dishId] != null ? orderCountMap[menu.dishId] : 0}</div>
                                        </td>
                                        <td>
                                            <div style="font-weight: 600; color: #dc2626;">${cancelCountMap[menu.dishId] != null ? cancelCountMap[menu.dishId] : 0}</div>
                                        </td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/manager/menu/${menu.dishId}/change-status" style="display:inline;">
                                                <input type="hidden" name="fromDate" value="${fromDate}"/>
                                                <input type="hidden" name="toDate" value="${toDate}"/>
                                                <input type="hidden" name="categoryId" value="${param.categoryId}"/>
                                                <input type="hidden" name="status" value="${param.status}"/>
                                                <select name="newStatus" class="filter-select" onchange="this.form.submit()" style="min-width: 120px;">
                                                    <option value="AVAILABLE" ${menu.status=='AVAILABLE' ? 'selected' : ''}>Đang bán</option>
                                                    <option value="UNAVAILABLE" ${menu.status=='UNAVAILABLE' ? 'selected' : ''}>Tạm ngưng</option>
                                                </select>
                                            </form>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="${pageContext.request.contextPath}/manager/menus/edit/${menu.dishId}" 
                                                   class="action-btn action-btn-edit" title="Chỉnh sửa">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/manager/menus/delete/${menu.dishId}" 
                                                   class="action-btn action-btn-delete" title="Xóa"
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa món ${menu.name} không?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/resources/js/manager/menu-management.js"></script>
</body>
</html> 