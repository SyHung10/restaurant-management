<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${table.tableId == null ? 'Thêm bàn mới' : 'Chỉnh sửa bàn'} - Hệ thống POS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/table-form.css">
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
                    <h1 class="page-title">
                        <i class="fas fa-th mr-2"></i>
                        ${table.tableId == null ? 'Thêm bàn mới' : 'Chỉnh sửa bàn'}
                    </h1>
                    <p class="page-subtitle">
                        ${table.tableId == null ? 'Tạo bàn mới cho nhà hàng' : 'Cập nhật thông tin bàn'}
                    </p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/manager/tables" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                </div>
            </div>

            <!-- Content -->
            <div class="manager-content">
                <div class="form-section">
                    <div class="form-header">
                        <h2 class="form-title">
                            <i class="fas fa-${table.tableId == null ? 'plus-circle' : 'edit'} mr-2"></i>
                            ${table.tableId == null ? 'Thông tin bàn mới' : 'Chỉnh sửa thông tin bàn'}
                        </h2>
                        <p class="form-subtitle">
                            ${table.tableId == null ? 'Vui lòng điền đầy đủ thông tin để tạo bàn mới' : 'Cập nhật thông tin bàn trong hệ thống'}
                        </p>
                    </div>

                    <div class="form-body">
                        <form id="tableForm" action="${pageContext.request.contextPath}/manager/tables/save" method="post">
        <input type="hidden" name="tableId" value="${table.tableId}">
                            
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label required" for="floor">
                                        <i class="fas fa-building mr-1"></i>
                                        Tầng
                                    </label>
                                    <input type="number" 
                                           id="floor"
                                           name="floor" 
                                           value="${table.floor}" 
                                           class="form-input" 
                                           min="1" 
                                           max="10"
                                           required
                                           placeholder="Nhập số tầng (1-10)">
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="tableNumber">
                                        <i class="fas fa-hashtag mr-1"></i>
                                        Số bàn
                                    </label>
                                    <input type="text" 
                                           id="tableNumber"
                                           name="tableNumber" 
                                           value="${table.tableNumber}" 
                                           class="form-input" 
                                           required
                                           placeholder="VD: 01, 02, A1, B1">
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="capacity">
                                        <i class="fas fa-users mr-1"></i>
                                        Sức chứa (người)
                                    </label>
                                    <input type="number" 
                                           id="capacity"
                                           name="capacity" 
                                           value="${table.capacity}" 
                                           class="form-input" 
                                           min="1" 
                                           max="20"
                                           required
                                           placeholder="Số người tối đa">
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="status">
                                        <i class="fas fa-info-circle mr-1"></i>
                                        Trạng thái
                                    </label>
                                    <select id="status" name="status" class="form-select" required>
                                        <option value="AVAILABLE" ${table.status == 'AVAILABLE' ? 'selected' : ''}>Sẵn sàng</option>
            <option value="RESERVED" ${table.status == 'RESERVED' ? 'selected' : ''}>Đã đặt</option>
            <option value="SERVING" ${table.status == 'SERVING' ? 'selected' : ''}>Đang phục vụ</option>
            <option value="PENDING_PAYMENT" ${table.status == 'PENDING_PAYMENT' ? 'selected' : ''}>Chờ thanh toán</option>
                                        <option value="CLEANING" ${table.status == 'CLEANING' ? 'selected' : ''}>Đang dọn</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Status Preview -->
                            <div class="form-group full-width">
                                <label class="form-label">
                                    <i class="fas fa-palette mr-1"></i>
                                    Xem trước trạng thái
                                </label>
                                <div class="status-preview">
                                    <div class="status-option status-available">
                                        <div class="font-semibold">Sẵn sàng</div>
                                        <div class="text-xs text-gray-600">Bàn trống, sẵn sàng phục vụ</div>
                                    </div>
                                    <div class="status-option status-serving">
                                        <div class="font-semibold">Đang phục vụ</div>
                                        <div class="text-xs text-gray-600">Khách đang ngồi, đang phục vụ</div>
                                    </div>
                                    <div class="status-option status-reserved">
                                        <div class="font-semibold">Đã đặt</div>
                                        <div class="text-xs text-gray-600">Bàn đã được đặt trước</div>
                                    </div>
                                    <div class="status-option status-cleaning">
                                        <div class="font-semibold">Đang dọn</div>
                                        <div class="text-xs text-gray-600">Đang dọn dẹp sau khách</div>
                                    </div>
                                    <div class="status-option status-pending-payment">
                                        <div class="font-semibold">Chờ thanh toán</div>
                                        <div class="text-xs text-gray-600">Khách chờ thanh toán</div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-actions">
                                <div>
                                    <a href="${pageContext.request.contextPath}/manager/tables" class="btn btn-secondary">
                                        <i class="fas fa-times mr-1"></i>
                                        <span>Hủy bỏ</span>
                                    </a>
                                </div>
                                <div>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save mr-1"></i>
                                        <span>${table.tableId == null ? 'Tạo bàn mới' : 'Cập nhật bàn'}</span>
                                    </button>
                                </div>
                            </div>
    </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/table-form.js"></script>
</body>

</html>