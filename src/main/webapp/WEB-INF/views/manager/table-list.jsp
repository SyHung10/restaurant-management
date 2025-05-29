<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!DOCTYPE html>
<html lang="vi">

        <head>
            <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bàn - Hệ thống POS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/table-list.css">
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
                    <a href="${pageContext.request.contextPath}/manager/tables" class="sidebar-nav-link active">
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
            </nav>
        </div>

        <!-- Main Content -->
        <div class="manager-main">
            <!-- Header -->
            <div class="manager-header">
                <div class="page-header">
                    <h1 class="page-title">Quản lý bàn</h1>
                    <p class="page-subtitle">Quản lý layout và trạng thái bàn</p>
                </div>
                <div class="header-actions">
                    <div class="search-container">
                        <i class="fas fa-search search-icon"></i>
                        <input type="text" placeholder="Tìm kiếm bàn..." class="search-input">
                    </div>
                    <a href="${pageContext.request.contextPath}/manager/tables/new" class="btn btn-primary">
                        <i class="fas fa-plus"></i>
                        <span>Thêm bàn mới</span>
                    </a>
                </div>
            </div>

            <!-- Content -->
            <div class="manager-content">
                <!-- Stats Cards -->
                <div class="grid grid-cols-4 mb-xl">
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">${tables.size()}</div>
                            <div class="text-sm text-gray-600">Tổng số bàn</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">
                                <c:set var="availableCount" value="0"/>
                                <c:forEach var="table" items="${tables}">
                                    <c:if test="${table.status == 'AVAILABLE'}">
                                        <c:set var="availableCount" value="${availableCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${availableCount}
                            </div>
                            <div class="text-sm text-gray-600">Bàn trống</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">
                                <c:set var="servingCount" value="0"/>
                                <c:forEach var="table" items="${tables}">
                                    <c:if test="${table.status == 'SERVING'}">
                                        <c:set var="servingCount" value="${servingCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${servingCount}
                            </div>
                            <div class="text-sm text-gray-600">Đang phục vụ</div>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-body text-center">
                            <div class="text-2xl font-bold text-gray-900">
                                <c:set var="totalCapacity" value="0"/>
                                <c:forEach var="table" items="${tables}">
                                    <c:set var="totalCapacity" value="${totalCapacity + table.capacity}"/>
                                </c:forEach>
                                ${totalCapacity}
                            </div>
                            <div class="text-sm text-gray-600">Tổng chỗ ngồi</div>
                        </div>
                    </div>
                </div>

                <!-- Tables by Floor -->
                <c:set var="processedFloors" value=""/>
                <c:forEach var="table" items="${tables}">
                    <c:set var="currentFloor" value="${table.floor}"/>
                    <c:set var="floorFound" value="false"/>
                    
                    <!-- Check if floor already processed -->
                    <c:forEach var="processedTable" items="${tables}">
                        <c:if test="${processedTable.floor == currentFloor && processedTable.tableId < table.tableId}">
                            <c:set var="floorFound" value="true"/>
                        </c:if>
                    </c:forEach>
                    
                    <!-- Process floor if not found before -->
                    <c:if test="${!floorFound}">
                        <div class="card mb-xl">
                            <div class="card-header">
                                <div class="card-title flex items-center gap-md">
                                    <i class="fas fa-building"></i>
                                    <span>Tầng ${currentFloor}</span>
                                </div>
                                <div class="card-subtitle">
                                    <c:set var="floorTableCount" value="0"/>
                                    <c:forEach var="countTable" items="${tables}">
                                        <c:if test="${countTable.floor == currentFloor}">
                                            <c:set var="floorTableCount" value="${floorTableCount + 1}"/>
                                        </c:if>
                                    </c:forEach>
                                    ${floorTableCount} bàn
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="grid grid-cols-4 gap-lg">
                                    <c:forEach var="floorTable" items="${tables}">
                                        <c:if test="${floorTable.floor == currentFloor}">
                                            <div class="table-card" data-table-number="${floorTable.tableNumber}" data-status="${floorTable.status}">
                                                <!-- Status Indicator -->
                                                <div class="table-status-indicator status-${fn:toLowerCase(fn:replace(floorTable.status, '_', '-'))}"></div>
                                                
                                                <div class="table-header">
                                                    <div class="table-number">T${floorTable.tableNumber}</div>
                                                    <c:choose>
                                                        <c:when test="${floorTable.status == 'AVAILABLE'}">
                                                            <span class="badge badge-success">Sẵn sàng</span>
                                                        </c:when>
                                                        <c:when test="${floorTable.status == 'SERVING'}">
                                                            <span class="badge badge-warning">Đang phục vụ</span>
                                                        </c:when>
                                                        <c:when test="${floorTable.status == 'RESERVED'}">
                                                            <span class="badge badge-info">Đã đặt</span>
                                                        </c:when>
                                                        <c:when test="${floorTable.status == 'CLEANING'}">
                                                            <span class="badge badge-gray">Đang dọn</span>
                                                        </c:when>
                                                        <c:when test="${floorTable.status == 'PENDING_PAYMENT'}">
                                                            <span class="badge badge-danger">Chờ thanh toán</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-gray">${floorTable.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <div class="table-body">
                                                    <div class="table-info-item">
                                                        <i class="fas fa-hashtag"></i>
                                                        <span>ID: ${floorTable.tableId}</span>
                                                    </div>
                                                    <div class="table-info-item">
                                                        <i class="fas fa-users"></i>
                                                        <span>${floorTable.capacity} chỗ ngồi</span>
                                                    </div>
                                                    <div class="table-info-item">
                                                        <i class="fas fa-building"></i>
                                                        <span>Tầng ${floorTable.floor}</span>
                                                    </div>
                                                </div>
                                                
                                                <div class="table-footer">
                                                    <div class="flex gap-sm justify-center">
                                                        <a href="${pageContext.request.contextPath}/manager/tables/edit/${floorTable.tableId}" 
                                                           class="btn btn-sm btn-secondary"
                                                           title="Chỉnh sửa bàn">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                <a href="${pageContext.request.contextPath}/manager/tables/delete/${floorTable.tableId}"
                                                           onclick="return confirm('Bạn có chắc muốn xóa bàn ${floorTable.tableNumber}? Hành động này không thể hoàn tác!')"
                                                           class="btn btn-sm btn-danger"
                                                           title="Xóa bàn">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                                         </c:if>
                </c:forEach>

                <!-- Empty State -->
                <c:if test="${empty tables}">
                    <div class="card text-center p-xl">
                        <div style="color: var(--gray-400); font-size: 4rem; margin-bottom: var(--space-lg);">
                            <i class="fas fa-th"></i>
                        </div>
                        <h3 class="text-xl font-semibold text-gray-700 mb-md">Chưa có bàn nào</h3>
                        <p class="text-gray-500 mb-lg">Thêm bàn đầu tiên để bắt đầu phục vụ khách hàng</p>
                        <a href="${pageContext.request.contextPath}/manager/tables/new" class="btn btn-primary">
                            <i class="fas fa-plus"></i>
                            <span>Thêm bàn đầu tiên</span>
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

    <script src="${pageContext.request.contextPath}/resources/js/manager/table-list.js"></script>
        </body>

        </html>