<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

            <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${promotion.promotionId == null ? 'Thêm khuyến mãi mới' : 'Chỉnh sửa khuyến mãi'} - Hệ thống POS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/promotion-form.css">
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
                    <h1 class="page-title">
                        <i class="fas fa-percent mr-2"></i>
                        ${promotion.promotionId == null ? 'Thêm khuyến mãi mới' : 'Chỉnh sửa khuyến mãi'}
                    </h1>
                    <p class="page-subtitle">
                        ${promotion.promotionId == null ? 'Tạo chương trình khuyến mãi mới' : 'Cập nhật thông tin khuyến mãi'}
                    </p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/manager/promotions" class="btn btn-secondary">
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
                            <i class="fas fa-${promotion.promotionId == null ? 'plus-circle' : 'edit'} mr-2"></i>
                            ${promotion.promotionId == null ? 'Thông tin khuyến mãi mới' : 'Chỉnh sửa thông tin khuyến mãi'}
                </h2>
                        <p class="form-subtitle">
                            ${promotion.promotionId == null ? 'Vui lòng điền đầy đủ thông tin để tạo khuyến mãi mới' : 'Cập nhật thông tin khuyến mãi trong hệ thống'}
                        </p>
                    </div>

                    <div class="form-body">
                        <form id="promotionForm" action="${pageContext.request.contextPath}/manager/promotions/save" method="post">
                            <input type="hidden" name="promotionId" value="${promotion.promotionId}">
                            
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label required" for="name">
                                        <i class="fas fa-tag mr-1"></i>
                                        Tên khuyến mãi
                                    </label>
                                    <input type="text" 
                                           id="name"
                                           name="name" 
                                           value="${promotion.name}" 
                                           class="form-input" 
                                           required
                                           placeholder="VD: Giảm giá cuối tuần, Happy Hour...">
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="voucherCode">
                                        <i class="fas fa-qrcode mr-1"></i>
                                        Mã khuyến mãi
                                    </label>
                                    <input type="text" 
                                           id="voucherCode"
                                           name="voucherCode" 
                                           value="${promotion.voucherCode}" 
                                           class="form-input" 
                                           required
                                           placeholder="VD: WEEKEND20, HAPPY50..."
                                           style="text-transform: uppercase;">
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="type">
                                        <i class="fas fa-percentage mr-1"></i>
                                        Loại khuyến mãi
                                    </label>
                                    <select id="type" name="type" class="form-select" required>
                                        <option value="">Chọn loại khuyến mãi</option>
                                        <option value="VOUCHER" ${promotion.type == 'VOUCHER' ? 'selected' : ''}>Voucher khuyến mãi</option>
                                        <option value="HOUR" ${promotion.type == 'HOUR' ? 'selected' : ''}>Khuyến mãi giờ vàng</option>
                                </select>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="discountPercent">
                                        <i class="fas fa-percentage mr-1"></i>
                                        Phần trăm giảm
                                    </label>
                                    <input type="number" 
                                           id="discountPercent"
                                           name="discountPercent" 
                                           value="${promotion.discountPercent}" 
                                           step="0.01"
                                           min="0"
                                           max="100"
                                           class="form-input" 
                                           placeholder="VD: 20.5">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="discountValue">
                                        <i class="fas fa-money-bill-wave mr-1"></i>
                                        Giá trị giảm (VNĐ)
                                    </label>
                                    <input type="number" 
                                           id="discountValue"
                                           name="discountValue" 
                                           value="${promotion.discountValue}" 
                                           step="1000"
                                           min="0"
                                           class="form-input" 
                                           placeholder="VD: 50000">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="startTime">
                                        <i class="fas fa-clock mr-1"></i>
                                        Giờ bắt đầu
                                    </label>
                                    <div class="datetime-input">
                                        <input type="time" 
                                               id="startTime"
                                               name="startTime" 
                                               value="${promotion.startTime}" 
                                               class="form-input"
                                               placeholder="VD: 14:00">
                                        <i class="fas fa-clock datetime-icon"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="endTime">
                                        <i class="fas fa-clock mr-1"></i>
                                        Giờ kết thúc
                                    </label>
                                    <div class="datetime-input">
                                        <input type="time" 
                                               id="endTime"
                                               name="endTime" 
                                               value="${promotion.endTime}" 
                                               class="form-input"
                                               placeholder="VD: 16:00">
                                        <i class="fas fa-clock datetime-icon"></i>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="expiryDate">
                                        <i class="fas fa-calendar-times mr-1"></i>
                                        Ngày hết hạn
                                    </label>
                                    <input type="date" 
                                           id="expiryDate"
                                           name="expiryDate" 
                                           value="<fmt:formatDate value='${promotion.expiryDate}' pattern='yyyy-MM-dd'/>" 
                                           class="form-input">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="maxUsage">
                                        <i class="fas fa-users mr-1"></i>
                                        Số lần sử dụng tối đa
                                    </label>
                                    <input type="number" 
                                           id="maxUsage"
                                           name="maxUsage" 
                                           value="${promotion.maxUsage}" 
                                           min="1"
                                           class="form-input"
                                           placeholder="VD: 100">
                                </div>

                                <div class="form-group">
                                    <label class="form-label">
                                        <i class="fas fa-check-square mr-1"></i>
                                        Loại giảm giá
                                    </label>
                                    <div class="checkbox-wrapper">
                                        <label class="checkbox-label">
                                            <input type="checkbox" 
                                                   id="isPercent"
                                                   name="isPercent" 
                                                   value="true"
                                                   ${promotion.isPercent ? 'checked' : ''}>
                                            <span class="checkbox-custom"></span>
                                            <span>Giảm theo phần trăm</span>
                                        </label>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label required" for="status">
                                        <i class="fas fa-toggle-on mr-1"></i>
                                        Trạng thái
                                    </label>
                                    <select id="status" name="status" class="form-select" required>
                                        <option value="ACTIVE" ${promotion.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                        <option value="INACTIVE" ${promotion.status == 'INACTIVE' ? 'selected' : ''}>Tạm dừng</option>
                                </select>
                                </div>
                            </div>

                            <!-- Description -->
                            <div class="form-group full-width">
                                <label class="form-label" for="description">
                                    <i class="fas fa-align-left mr-1"></i>
                                    Mô tả chi tiết
                                </label>
                                <textarea id="description"
                                         name="description" 
                                         class="form-textarea" 
                                         rows="4"
                                         placeholder="Mô tả chi tiết về chương trình khuyến mãi, điều kiện áp dụng..."></textarea>
                            </div>

                            <!-- Promotion Preview -->
                            <div class="form-group full-width">
                                <label class="form-label">
                                    <i class="fas fa-eye mr-1"></i>
                                    Xem trước loại khuyến mãi
                                </label>
                                <div class="promotion-preview">
                                    <div class="promotion-card promo-voucher">
                                        <div class="font-semibold">
                                            <i class="fas fa-ticket-alt mr-1"></i>
                                            Voucher khuyến mãi
                                        </div>
                                        <div class="text-xs text-gray-600 mt-1">
                                            Mã voucher có thể giảm theo % hoặc số tiền cố định. VD: Mã SAVE20 giảm 20% hoặc giảm 50,000đ
                                        </div>
                                    </div>
                                    <div class="promotion-card promo-hour">
                                        <div class="font-semibold">
                                            <i class="fas fa-clock mr-1"></i>
                                            Khuyến mãi giờ vàng
                                        </div>
                                        <div class="text-xs text-gray-600 mt-1">
                                            Khuyến mãi theo khung giờ cụ thể trong ngày. VD: Giảm 30% từ 14h-16h hàng ngày
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-actions">
                                <div>
                                    <a href="${pageContext.request.contextPath}/manager/promotions" class="btn btn-secondary">
                                        <i class="fas fa-times mr-1"></i>
                                        <span>Hủy bỏ</span>
                                    </a>
                                </div>
                                <div>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save mr-1"></i>
                                        <span>${promotion.promotionId == null ? 'Tạo khuyến mãi' : 'Cập nhật khuyến mãi'}</span>
                                    </button>
                                </div>
                            </div>
                </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/promotion-form.js"></script>
            </body>

            </html>