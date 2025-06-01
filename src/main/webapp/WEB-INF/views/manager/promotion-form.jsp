<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

            <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${promotion.promotionId == null ? 'Thêm mới' : 'Chỉnh sửa'} khuyến mãi - Nhà hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/form.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/promotion-form.css">
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
                    <h1 class="page-title">${promotion.promotionId == null ? 'Thêm mới' : 'Chỉnh sửa'} khuyến mãi</h1>
                    <p class="page-subtitle">${promotion.promotionId == null ? 'Tạo chương trình khuyến mãi mới' : 'Cập nhật thông tin khuyến mãi'}</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/manager/promotions" class="btn btn-secondary">
                        <i class="fas fa-arrow-left mr-1"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                </div>
            </div>

            <!-- Content -->
            <div class="manager-content">
                <!-- Flash messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle mr-2"></i>
                        ${success}
                    </div>
                </c:if>
                
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
                            <input type="hidden" name="isPercent" id="isPercent" value="${promotion.isPercent}">
                            
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
                                    <label class="form-label required" for="scopeType">
                                        <i class="fas fa-bullseye mr-1"></i>
                                        Phạm vi áp dụng
                                    </label>
                                    <select id="scopeType" name="scopeType" class="form-select" required onchange="toggleTargetId()">
                                        <option value="ALL" ${promotion.scopeType == 'ALL' ? 'selected' : ''}>Tất cả món ăn</option>
                                        <option value="CATEGORY" ${promotion.scopeType == 'CATEGORY' ? 'selected' : ''}>Theo danh mục</option>
                                        <option value="DISH" ${promotion.scopeType == 'DISH' ? 'selected' : ''}>Theo món ăn</option>
                                    </select>
                                </div>

                                <div class="form-group" id="targetIdGroup">
                    <c:choose>
                                        <c:when test="${promotion.scopeType != 'ALL'}">
                                            <style>
                                                #targetIdGroup { display: block; }
                                            </style>
                                        </c:when>
                                        <c:otherwise>
                                            <style>
                                                #targetIdGroup { display: none; }
                                            </style>
                                        </c:otherwise>
                    </c:choose>
                                    <label class="form-label" for="targetId">
                                        <i class="fas fa-target mr-1"></i>
                                        ID đối tượng
                                    </label>
                                    <input type="number" 
                                           id="targetId"
                                           name="targetId" 
                                           value="${promotion.targetId}" 
                                           min="1"
                                           class="form-input" 
                                           placeholder="ID danh mục hoặc món ăn">
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
                                           placeholder="VD: 20.5"
                                           onchange="updateDiscountType('percent')">
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
                                           placeholder="VD: 50000"
                                           onchange="updateDiscountType('value')">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="orderMinimum">
                                        <i class="fas fa-shopping-cart mr-1"></i>
                                        Giá trị đơn hàng tối thiểu
                                    </label>
                                    <input type="number" 
                                           id="orderMinimum"
                                           name="orderMinimum" 
                                           value="${promotion.orderMinimum}" 
                                           step="1000"
                                           min="0"
                                           class="form-input" 
                                           placeholder="VD: 100000">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="startTime">
                                        <i class="fas fa-calendar-plus mr-1"></i>
                                        Thời gian bắt đầu
                                    </label>
                                    <input type="datetime-local" 
                                           id="startTime"
                                           name="startTime" 
                                           value="<fmt:formatDate value='${promotion.startTime}' pattern='yyyy-MM-dd&apos;T&apos;HH:mm'/>" 
                                           class="form-input">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="endTime">
                                        <i class="fas fa-calendar-times mr-1"></i>
                                        Thời gian kết thúc
                                    </label>
                                    <input type="datetime-local" 
                                           id="endTime"
                                           name="endTime" 
                                           value="<fmt:formatDate value='${promotion.endTime}' pattern='yyyy-MM-dd&apos;T&apos;HH:mm'/>" 
                                           class="form-input">
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="maxUsage">
                                        <i class="fas fa-user-check mr-1"></i>
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

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save mr-1"></i>
                                    <span>${promotion.promotionId == null ? 'Tạo khuyến mãi' : 'Cập nhật khuyến mãi'}</span>
                                </button>
                                <a href="${pageContext.request.contextPath}/manager/promotions" class="btn btn-secondary">
                                    <i class="fas fa-times mr-1"></i>
                                    <span>Hủy bỏ</span>
                                </a>
                            </div>
                </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/manager/promotion-form.js"></script>
            </body>

            </html>