<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
        <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khuyến mãi - Hệ thống POS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager-global.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
                    <a href="${pageContext.request.contextPath}/manager/employees" class="sidebar-nav-link">
                        <i class="fas fa-users sidebar-nav-icon"></i>
                        <span>Quản lý nhân viên</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/manager/promotions" class="sidebar-nav-link active">
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
            </nav>
        </div>

        <!-- Main Content -->
        <div class="manager-main">
            <!-- Header -->
            <div class="manager-header">
                <div class="page-header">
                    <h1 class="page-title">Quản lý khuyến mãi</h1>
                    <p class="page-subtitle">Thiết lập và quản lý các chương trình khuyến mãi</p>
                </div>
                <div class="header-actions">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" placeholder="Tìm kiếm khuyến mãi..." class="search-input">
                    </div>
                    <a href="${pageContext.request.contextPath}/manager/promotions/new" class="btn btn-primary">
                        <i class="fas fa-plus"></i>
                        <span>Thêm khuyến mãi</span>
                    </a>
                </div>
            </div>

            <!-- Content -->
            <div class="manager-content">
                <!-- Stats Cards -->
                <div class="grid grid-cols-4 mb-xl">
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">${promotions.size()}</div>
                            <div class="text-sm text-gray-600">Tổng khuyến mãi</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">
                                <c:set var="activeCount" value="0"/>
                                <c:forEach var="promotion" items="${promotions}">
                                    <c:if test="${promotion.status == 'ACTIVE'}">
                                        <c:set var="activeCount" value="${activeCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${activeCount}
                            </div>
                            <div class="text-sm text-gray-600">Đang hoạt động</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">
                                <c:set var="hourCount" value="0"/>
                                <c:forEach var="promotion" items="${promotions}">
                                    <c:if test="${promotion.type == 'HOUR'}">
                                        <c:set var="hourCount" value="${hourCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${hourCount}
                            </div>
                            <div class="text-sm text-gray-600">Giờ vàng</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">
                                <c:set var="voucherCount" value="0"/>
                                <c:forEach var="promotion" items="${promotions}">
                                    <c:if test="${promotion.type == 'VOUCHER'}">
                                        <c:set var="voucherCount" value="${voucherCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${voucherCount}
                            </div>
                            <div class="text-sm text-gray-600">Voucher</div>
                        </div>
                    </div>
                </div>

                <!-- Promotions Grid -->
                <div class="grid grid-cols-1 gap-lg">
                    <c:forEach var="promotion" items="${promotions}">
                        <div class="card">
                            <div class="card-header">
                                <div class="flex justify-between items-start">
                                    <div>
                                        <div class="card-title flex items-center gap-md">
                                            <c:choose>
                                                <c:when test="${promotion.type == 'HOUR'}">
                                                    <i class="fas fa-clock text-warning-color"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-ticket-alt text-primary-color"></i>
                                                </c:otherwise>
                                            </c:choose>
                                            <span>${promotion.name}</span>
                                        </div>
                                        <div class="card-subtitle">
                                            <c:choose>
                                                <c:when test="${promotion.type == 'HOUR'}">
                                                    Khuyến mãi giờ vàng
                                                </c:when>
                                                <c:otherwise>
                                                    Mã voucher: <strong>${promotion.voucherCode}</strong>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="flex gap-sm">
                                        <c:choose>
                                            <c:when test="${promotion.status == 'ACTIVE'}">
                                                <span class="badge badge-success">
                                                    <i class="fas fa-check"></i>
                                                    <span>Hoạt động</span>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-gray">
                                                    <i class="fas fa-pause"></i>
                                                    <span>Tạm dừng</span>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="grid grid-cols-2 gap-lg">
                                    <!-- Left column -->
                                    <div>
                                        <div class="mb-md">
                                            <div class="text-sm font-semibold text-gray-700 mb-xs">Mức giảm giá</div>
                                            <div class="text-lg font-bold" style="color: var(--success-color);">
                                                <c:choose>
                                                    <c:when test="${promotion.type == 'HOUR'}">
                                                        ${promotion.discountPercent}%
                                                    </c:when>
                                                    <c:otherwise>
                                <c:choose>
                                                            <c:when test="${promotion.isPercent}">
                                                                ${promotion.discountPercent}%
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${promotion.discountValue}đ
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:otherwise>
                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${promotion.type == 'HOUR' && promotion.startTime != null}">
                                            <div class="mb-md">
                                                <div class="text-sm font-semibold text-gray-700 mb-xs">Khung giờ áp dụng</div>
                                                <div class="flex items-center gap-sm">
                                                    <i class="fas fa-clock text-gray-400"></i>
                                                    <span>${promotion.startTime} - ${promotion.endTime}</span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Right column -->
                                    <div>
                                        <c:if test="${promotion.type == 'VOUCHER'}">
                                            <c:if test="${promotion.expiryDate != null}">
                                                <div class="mb-md">
                                                    <div class="text-sm font-semibold text-gray-700 mb-xs">Hạn sử dụng</div>
                                                    <div class="flex items-center gap-sm">
                                                        <i class="fas fa-calendar text-gray-400"></i>
                                                        <span>${promotion.expiryDate}</span>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${promotion.maxUsage != null}">
                                                <div class="mb-md">
                                                    <div class="text-sm font-semibold text-gray-700 mb-xs">Số lần sử dụng tối đa</div>
                                                    <div class="flex items-center gap-sm">
                                                        <i class="fas fa-user-check text-gray-400"></i>
                                                        <span>${promotion.maxUsage} lượt</span>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="flex justify-between items-center">
                                    <span class="text-xs text-gray-500">
                                        ID: #${promotion.promotionId}
                                    </span>
                                    <div class="flex gap-sm">
                                        <a href="${pageContext.request.contextPath}/manager/promotions/edit/${promotion.promotionId}" 
                                           class="btn btn-sm btn-secondary">
                                            <i class="fas fa-edit"></i>
                                            <span>Sửa</span>
                                        </a>
                                <a href="${pageContext.request.contextPath}/manager/promotions/delete/${promotion.promotionId}"
                                           onclick="return confirm('Bạn có chắc muốn xóa khuyến mãi ${promotion.name}?')"
                                           class="btn btn-sm btn-danger">
                                            <i class="fas fa-trash"></i>
                                            <span>Xóa</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${empty promotions}">
                    <div class="card text-center p-xl">
                        <div style="color: var(--gray-400); font-size: 4rem; margin-bottom: var(--space-lg);">
                            <i class="fas fa-percent"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-gray-700 mb-md">Chưa có khuyến mãi nào</h3>
                        <p class="text-gray-500 mb-lg">Tạo khuyến mãi đầu tiên để thu hút khách hàng</p>
                        <a href="${pageContext.request.contextPath}/manager/promotions/new" class="btn btn-primary">
                            <i class="fas fa-plus"></i>
                            <span>Tạo khuyến mãi đầu tiên</span>
                        </a>
                    </div>
                </c:if>

                <!-- Back to dashboard -->
                <div class="text-center mt-xl">
                    <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        <span>Quay lại Dashboard</span>
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/promotion-list.js"></script>
        </body>
        </html>