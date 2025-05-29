<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${employee.employeeId == null ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên'} - Hệ thống POS</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager-global.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee-form.css">
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
                            <a href="${pageContext.request.contextPath}/manager/employees" class="sidebar-nav-link active">
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
                                <i class="fas fa-users mr-2"></i>
                                ${employee.employeeId == null ? 'Thêm nhân viên mới' : 'Chỉnh sửa nhân viên'}
                            </h1>
                            <p class="page-subtitle">
                                ${employee.employeeId == null ? 'Tạo tài khoản nhân viên mới' : 'Cập nhật thông tin nhân viên'}
                            </p>
                        </div>
                        <div class="header-actions">
                            <a href="${pageContext.request.contextPath}/manager/employees" class="btn btn-secondary">
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
                                    <i class="fas fa-${employee.employeeId == null ? 'user-plus' : 'user-edit'} mr-2"></i>
                                    ${employee.employeeId == null ? 'Thông tin nhân viên mới' : 'Chỉnh sửa thông tin nhân viên'}
                                </h2>
                                <p class="form-subtitle">
                                    ${employee.employeeId == null ? 'Vui lòng điền đầy đủ thông tin để tạo tài khoản nhân viên' : 'Cập nhật thông tin nhân viên trong hệ thống'}
                                </p>
                            </div>

                            <div class="form-body">
                                <form id="employeeForm" action="${pageContext.request.contextPath}/manager/employees/save" method="post">
                <input type="hidden" name="employeeId" value="${employee.employeeId}">
                                    
                                    <div class="form-grid">
                                        <div class="form-group">
                                            <label class="form-label required" for="name">
                                                <i class="fas fa-user mr-1"></i>
                                                Họ và tên
                                            </label>
                                            <input type="text" 
                                                   id="name"
                                                   name="name" 
                                                   value="${employee.name}" 
                                                   class="form-input" 
                                                   required
                                                   placeholder="Nhập họ và tên đầy đủ">
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label required" for="role">
                                                <i class="fas fa-user-tag mr-1"></i>
                                                Vai trò
                                            </label>
                                            <select id="role" name="role" class="form-select" required>
                                                <option value="">Chọn vai trò</option>
                                                <option value="MANAGER" ${employee.role == 'MANAGER' ? 'selected' : ''}>Quản lý</option>
                                                <option value="COUNTER" ${employee.role == 'COUNTER' ? 'selected' : ''}>Nhân viên quầy</option>
                                                <option value="KITCHEN" ${employee.role == 'KITCHEN' ? 'selected' : ''}>Nhân viên bếp</option>
                                            </select>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label required" for="username">
                                                <i class="fas fa-at mr-1"></i>
                                                Tên đăng nhập
                                            </label>
                                            <input type="text" 
                                                   id="username"
                                                   name="username" 
                                                   value="${employee.username}" 
                                                   class="form-input" 
                                                   required
                                                   placeholder="Tên đăng nhập duy nhất">
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label required" for="password">
                                                <i class="fas fa-lock mr-1"></i>
                                                Mật khẩu
                                            </label>
                                            <input type="password" 
                                                   id="password"
                                                   name="password" 
                                                   value="${employee.password}" 
                                                   class="form-input" 
                                                   required
                                                   placeholder="Mật khẩu mạnh (tối thiểu 6 ký tự)">
                                            <div id="passwordStrength" class="password-strength" style="display: none;">
                                                <div id="strengthText">Độ mạnh mật khẩu: </div>
                                                <div id="strengthBar" class="strength-bar"></div>
                                            </div>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label required" for="status">
                                                <i class="fas fa-toggle-on mr-1"></i>
                                                Trạng thái
                                            </label>
                                            <select id="status" name="status" class="form-select" required>
                                                <option value="ACTIVE" ${employee.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                                <option value="INACTIVE" ${employee.status == 'INACTIVE' ? 'selected' : ''}>Đã khóa</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Role Preview -->
                                    <div class="form-group full-width">
                                        <label class="form-label">
                                            <i class="fas fa-info-circle mr-1"></i>
                                            Mô tả vai trò
                                        </label>
                                        <div class="role-preview">
                                            <div class="role-option role-manager">
                                                <div class="font-semibold">
                                                    <i class="fas fa-user-tie mr-1"></i>
                                                    Quản lý
                                                </div>
                                                <div class="text-xs text-gray-600 mt-1">
                                                    Quản lý nhà hàng, xem báo cáo, quản lý nhân viên và hệ thống
                                                </div>
                                            </div>
                                            <div class="role-option role-counter">
                                                <div class="font-semibold">
                                                    <i class="fas fa-cash-register mr-1"></i>
                                                    Nhân viên quầy
                                                </div>
                                                <div class="text-xs text-gray-600 mt-1">
                                                    Phục vụ khách hàng, nhận order, thanh toán
                                                </div>
                                            </div>
                                            <div class="role-option role-kitchen">
                                                <div class="font-semibold">
                                                    <i class="fas fa-utensils mr-1"></i>
                                                    Nhân viên bếp
                                                </div>
                                                <div class="text-xs text-gray-600 mt-1">
                                                    Xem và xử lý đơn hàng, cập nhật trạng thái món ăn
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-actions">
                                        <div>
                                            <a href="${pageContext.request.contextPath}/manager/employees" class="btn btn-secondary">
                                                <i class="fas fa-times mr-1"></i>
                                                <span>Hủy bỏ</span>
                                            </a>
                                        </div>
                                        <div>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save mr-1"></i>
                                                <span>${employee.employeeId == null ? 'Tạo nhân viên' : 'Cập nhật thông tin'}</span>
                                            </button>
                                        </div>
                                    </div>
            </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/resources/js/employee-form.js"></script>
        </body>

        </html>