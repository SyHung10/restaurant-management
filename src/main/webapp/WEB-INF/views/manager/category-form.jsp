<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${category.categoryId == null ? 'Thêm danh mục mới' : 'Sửa danh mục'} - HT Restaurant Manager</title>
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
                            <i class="fas fa-tags"></i> 
                            ${category.categoryId == null ? 'Thêm danh mục mới' : 'Sửa danh mục'}
                        </h1>
                        <p class="page-subtitle">
                            ${category.categoryId == null ? 'Tạo danh mục món ăn mới' : 'Chỉnh sửa thông tin danh mục'}
                        </p>
                    </div>
                    <div class="category-header-right">
                        <a href="${pageContext.request.contextPath}/manager/categories" class="btn-secondary">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>
                    </div>
                </div>
            </div>

            <div class="manager-content category-management-container">
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

                <!-- Form Container -->
                <div class="form-container fade-in">
                    <form action="${pageContext.request.contextPath}/manager/categories/save" method="post">
                        <input type="hidden" name="categoryId" value="${category.categoryId}">

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-code"></i>
                                Mã danh mục:
                            </label>
                            <input type="text" 
                                   name="code" 
                                   value="${category.code}" 
                                   class="form-control" 
                                   placeholder="Nhập mã danh mục (ví dụ: APPETIZER, MAIN_COURSE)" 
                                   required
                                   ${category.categoryId != null ? 'readonly' : ''}>
                            <c:if test="${category.categoryId != null}">
                                <div class="form-help-text">
                                    <i class="fas fa-info-circle"></i>
                                    Mã danh mục không thể thay đổi sau khi đã tạo
                                </div>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-tag"></i>
                                Tên danh mục:
                            </label>
                            <input type="text" 
                                   name="name" 
                                   value="${category.name}" 
                                   class="form-control" 
                                   placeholder="Nhập tên danh mục (ví dụ: Khai vị, Món chính)" 
                                   required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-sort-numeric-up"></i>
                                Thứ tự hiển thị:
                            </label>
                            <input type="number" 
                                   name="displayOrder" 
                                   value="${category.displayOrder}" 
                                   class="form-control" 
                                   placeholder="Nhập số thứ tự (1, 2, 3...)" 
                                   min="0">
                            <div class="form-help-text">
                                <i class="fas fa-info-circle"></i>
                                Số nhỏ hơn sẽ hiển thị trước trong menu
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-toggle-on"></i>
                                Trạng thái:
                            </label>
                            <select name="status" class="form-control" required>
                                <option value="ACTIVE" ${category.status == 'ACTIVE' ? 'selected' : ''}>
                                    <i class="fas fa-check-circle"></i> Kích hoạt
                                </option>
                                <option value="INACTIVE" ${category.status == 'INACTIVE' ? 'selected' : ''}>
                                    <i class="fas fa-pause-circle"></i> Tạm ngưng
                                </option>
                            </select>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn-primary btn-submit">
                                <i class="fas fa-save"></i>
                                <span>${category.categoryId == null ? 'Tạo danh mục' : 'Cập nhật'}</span>
                            </button>
                            <a href="${pageContext.request.contextPath}/manager/categories" class="btn-secondary">
                                <i class="fas fa-times"></i>
                                <span>Hủy bỏ</span>
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/resources/js/manager/category-management.js"></script>
</body>
</html>