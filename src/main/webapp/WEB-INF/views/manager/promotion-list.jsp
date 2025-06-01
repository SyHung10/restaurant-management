<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
        <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý khuyến mãi - Nhà hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/promotion-list.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="${pageContext.request.contextPath}/resources/js/manager/promotion-list.js"></script>
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
            <!-- Header -->
            <div class="manager-header">
                <div class="page-header">
                    <h1 class="page-title">Quản lý khuyến mãi</h1>
                    <p class="page-subtitle">Quản lý các chương trình khuyến mãi của nhà hàng</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/manager/promotions/new" class="btn btn-primary">
                        <i class="fas fa-plus mr-1"></i>
                        <span>Thêm khuyến mãi</span>
                    </a>
                </div>
            </div>

            <!-- Content -->
            <div class="manager-content">
                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-primary-color">
                                ${promotions.size()}
                            </div>
                            <div class="text-sm text-gray-600">Tổng khuyến mãi</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-success-color">
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
                            <div class="text-2xl font-bold text-warning-color">
                                <c:set var="percentCount" value="0"/>
                                <c:forEach var="promotion" items="${promotions}">
                                    <c:if test="${promotion.isPercent}">
                                        <c:set var="percentCount" value="${percentCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${percentCount}
                            </div>
                            <div class="text-sm text-gray-600">Giảm theo %</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-info-color">
                                <c:set var="allScopeCount" value="0"/>
                                <c:forEach var="promotion" items="${promotions}">
                                    <c:if test="${promotion.scopeType == 'ALL'}">
                                        <c:set var="allScopeCount" value="${allScopeCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${allScopeCount}
                            </div>
                            <div class="text-sm text-gray-600">Áp dụng toàn bộ</div>
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
                                                <c:when test="${promotion.scopeType == 'ALL'}">
                                                    <i class="fas fa-globe text-primary-color"></i>
                                                </c:when>
                                                <c:when test="${promotion.scopeType == 'CATEGORY'}">
                                                    <i class="fas fa-list text-warning-color"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-utensils text-success-color"></i>
                                                </c:otherwise>
                                            </c:choose>
                                            <span>${promotion.name}</span>
                                        </div>
                                        <div class="card-subtitle">
                                            <c:if test="${not empty promotion.voucherCode}">
                                                Mã voucher: <strong>${promotion.voucherCode}</strong>
                                            </c:if>
                                            <c:if test="${promotion.scopeType != 'ALL'}">
                                                • Phạm vi: 
                                                <c:choose>
                                                    <c:when test="${promotion.scopeType == 'CATEGORY'}">Danh mục #${promotion.targetId}</c:when>
                                                    <c:when test="${promotion.scopeType == 'DISH'}">Món ăn #${promotion.targetId}</c:when>
                                                </c:choose>
                                            </c:if>
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
                                                    <c:when test="${promotion.isPercent}">
                                                        ${promotion.discountPercent}%
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${promotion.discountValue}" type="currency" currencySymbol="đ"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${promotion.orderMinimum > 0}">
                                            <div class="mb-md">
                                                <div class="text-sm font-semibold text-gray-700 mb-xs">Đơn hàng tối thiểu</div>
                                                <div class="flex items-center gap-sm">
                                                    <i class="fas fa-shopping-cart text-gray-400"></i>
                                                    <span><fmt:formatNumber value="${promotion.orderMinimum}" type="currency" currencySymbol="đ"/></span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Right column -->
                                    <div>
                                        <c:if test="${promotion.startTime != null || promotion.endTime != null}">
                                            <div class="mb-md">
                                                <div class="text-sm font-semibold text-gray-700 mb-xs">Thời gian áp dụng</div>
                                                <div class="flex items-center gap-sm">
                                                    <i class="fas fa-calendar text-gray-400"></i>
                                                    <span>
                                <c:if test="${promotion.startTime != null}">
                                                            <fmt:formatDate value="${promotion.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:if>
                                                        <c:if test="${promotion.startTime != null && promotion.endTime != null}"> - </c:if>
                                                        <c:if test="${promotion.endTime != null}">
                                                            <fmt:formatDate value="${promotion.endTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:if>
                                                    </span>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${promotion.maxUsage != null}">
                                            <div class="mb-md">
                                                <div class="text-sm font-semibold text-gray-700 mb-xs">Tình trạng sử dụng</div>
                                                <div class="flex items-center gap-sm">
                                                    <i class="fas fa-chart-bar text-gray-400"></i>
                                                    <span>
                                                        <c:set var="currentUsage" value="${usageCounts[promotion.promotionId]}" />
                                                        <c:set var="maxUsage" value="${promotion.maxUsage}" />
                                                        <strong style="color: var(--primary-color);">${currentUsage}</strong>/${maxUsage} lượt
                                                        
                                                        <c:choose>
                                                            <c:when test="${currentUsage >= maxUsage}">
                                                                <span class="badge badge-danger ml-sm">
                                                                    <i class="fas fa-ban"></i>
                                                                    Hết lượt
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${currentUsage >= maxUsage * 0.8}">
                                                                <span class="badge badge-warning ml-sm">
                                                                    <i class="fas fa-exclamation-triangle"></i>
                                                                    Sắp hết
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-success ml-sm">
                                                                    <i class="fas fa-check"></i>
                                                                    Khả dụng
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${promotion.maxUsage == null}">
                                            <div class="mb-md">
                                                <div class="text-sm font-semibold text-gray-700 mb-xs">Tình trạng sử dụng</div>
                                                <div class="flex items-center gap-sm">
                                                    <i class="fas fa-infinity text-gray-400"></i>
                                                    <span>
                                                        <c:set var="currentUsage" value="${usageCounts[promotion.promotionId]}" />
                                                        Đã dùng: <strong style="color: var(--primary-color);">${currentUsage}</strong> lượt
                                                        <span class="badge badge-info ml-sm">
                                                            <i class="fas fa-infinity"></i>
                                                            Không giới hạn
                                                        </span>
                                                    </span>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer">
                                <div class="flex justify-between items-center">
                                    <span class="text-xs text-gray-500">
                                        ID: #${promotion.promotionId} • 
                                        Phạm vi: 
                                <c:choose>
                                            <c:when test="${promotion.scopeType == 'ALL'}">Tất cả</c:when>
                                            <c:when test="${promotion.scopeType == 'CATEGORY'}">Danh mục</c:when>
                                            <c:when test="${promotion.scopeType == 'DISH'}">Món ăn</c:when>
                                </c:choose>
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
                            <i class="fas fa-tags"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-gray-700 mb-md">Chưa có khuyến mãi nào</h3>
                        <p class="text-gray-500 mb-lg">Tạo khuyến mãi đầu tiên để thu hút khách hàng</p>
                        <a href="${pageContext.request.contextPath}/manager/promotions/new" class="btn btn-primary">
                            <i class="fas fa-plus"></i>
                            <span>Tạo khuyến mãi đầu tiên</span>
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
        </body>
        </html>