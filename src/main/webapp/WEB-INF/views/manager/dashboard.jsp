<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Dashboard - Hệ thống POS Nhà hàng</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager-global.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
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
                            <a href="${pageContext.request.contextPath}/manager/dashboard" class="sidebar-nav-link active">
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
                            <h1 class="page-title">Dashboard</h1>
                            <p class="page-subtitle">Tổng quan hệ thống quản lý nhà hàng</p>
                        </div>
                        <div class="header-actions">
                            <div class="search-container">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" placeholder="Tìm kiếm..." class="search-input">
                            </div>
                            <button class="btn btn-secondary">
                                <i class="fas fa-sync-alt"></i>
                                <span>Làm mới</span>
                            </button>
                        </div>
                    </div>

                    <!-- Content -->
                    <div class="manager-content">
                        <!-- Welcome Section -->
                        <div class="dashboard-welcome">
                            <div class="welcome-content">
                                <h2 class="welcome-title">Chào mừng đến với Hệ thống POS</h2>
                                <p class="welcome-subtitle">Nhà hàng Hùng Tuấn - Quản lý hiệu quả, phục vụ tận tâm</p>
                            </div>
                        </div>

                        <!-- Stats Section -->
                        <div class="grid grid-cols-4 gap-lg mb-xl">
                            <div class="stat-card">
                                <div class="stat-header">
                                    <div>
                                        <div class="stat-value">${tables.size()}</div>
                                        <div class="stat-label">Tổng số bàn</div>
                                    </div>
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));">
                                        <i class="fas fa-th"></i>
                                    </div>
                                </div>
                                <div class="stat-change positive">
                                    <i class="fas fa-arrow-up"></i>
                                    <span>5% so với tháng trước</span>
                                </div>
                            </div>

                            <div class="stat-card">
                                <div class="stat-header">
                                    <div>
                        <div class="stat-value">${menus.size()}</div>
                                        <div class="stat-label">Tổng số món ăn</div>
                                    </div>
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--success-color), #38a169);">
                                        <i class="fas fa-utensils"></i>
                                    </div>
                                </div>
                                <div class="stat-change positive">
                                    <i class="fas fa-arrow-up"></i>
                                    <span>12% so với tháng trước</span>
                        </div>
                    </div>

                            <div class="stat-card">
                                <div class="stat-header">
                                    <div>
                                        <div class="stat-value">${employees.size()}</div>
                                        <div class="stat-label">Tổng số nhân viên</div>
                                    </div>
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--warning-color), #dd6b20);">
                            <i class="fas fa-users"></i>
                        </div>
                                </div>
                                <div class="stat-change neutral">
                                    <i class="fas fa-equals"></i>
                                    <span>Không thay đổi</span>
                        </div>
                    </div>

                            <div class="stat-card">
                                <div class="stat-header">
                                    <div>
                                        <div class="stat-value">2.5M</div>
                                        <div class="stat-label">Doanh thu hôm nay</div>
                                    </div>
                                    <div class="stat-icon" style="background: linear-gradient(135deg, var(--info-color), #2b77c7);">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                                </div>
                        <div class="stat-change negative">
                                    <i class="fas fa-arrow-down"></i>
                                    <span>3% so với hôm qua</span>
                        </div>
                    </div>
                </div>

                        <!-- Quick Actions Section -->
                        <div class="card mb-xl">
                            <div class="card-header">
                                <div class="card-title">Truy cập nhanh</div>
                                <div class="card-subtitle">Các tác vụ thường dùng</div>
                            </div>
                            <div class="card-body">
                                <div class="grid grid-cols-4 gap-lg">
                                    <a href="${pageContext.request.contextPath}/manager/tables/new" class="quick-action-card">
                                        <div class="quick-action-icon" style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));">
                            <i class="fas fa-plus-circle"></i>
                                        </div>
                                        <div class="quick-action-title">Thêm bàn mới</div>
                                        <div class="quick-action-desc">Thêm bàn vào hệ thống</div>
                        </a>

                                    <a href="${pageContext.request.contextPath}/manager/menus/new" class="quick-action-card">
                                        <div class="quick-action-icon" style="background: linear-gradient(135deg, var(--success-color), #38a169);">
                            <i class="fas fa-hamburger"></i>
                                        </div>
                                        <div class="quick-action-title">Thêm món ăn</div>
                                        <div class="quick-action-desc">Cập nhật thực đơn</div>
                        </a>

                                    <a href="${pageContext.request.contextPath}/manager/employees/new" class="quick-action-card">
                                        <div class="quick-action-icon" style="background: linear-gradient(135deg, var(--warning-color), #dd6b20);">
                            <i class="fas fa-user-plus"></i>
                                        </div>
                                        <div class="quick-action-title">Thêm nhân viên</div>
                                        <div class="quick-action-desc">Quản lý nhân sự</div>
                        </a>

                                    <a href="${pageContext.request.contextPath}/manager/promotions/new" class="quick-action-card">
                                        <div class="quick-action-icon" style="background: linear-gradient(135deg, var(--info-color), #2b77c7);">
                                            <i class="fas fa-percent"></i>
                                        </div>
                                        <div class="quick-action-title">Thêm khuyến mãi</div>
                                        <div class="quick-action-desc">Chương trình ưu đãi</div>
                        </a>
                                </div>
                    </div>
                </div>

                <!-- Recent Activity Section -->
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Hoạt động gần đây</div>
                                <div class="card-subtitle">Các thay đổi mới nhất trong hệ thống</div>
                            </div>
                            <div class="card-body p-0">
                                <div class="activity-item">
                                    <div class="activity-icon" style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));">
                                <i class="fas fa-utensils"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Thêm món ăn mới: Phở Bò Đặc Biệt</div>
                                <div class="activity-time">30 phút trước</div>
                            </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon" style="background: linear-gradient(135deg, var(--success-color), #38a169);">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Thêm nhân viên mới: Nguyễn Văn A</div>
                                <div class="activity-time">2 giờ trước</div>
                            </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon" style="background: linear-gradient(135deg, var(--warning-color), #dd6b20);">
                                <i class="fas fa-th"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Cập nhật trạng thái bàn #12</div>
                                <div class="activity-time">3 giờ trước</div>
                            </div>
                                </div>
                                
                                <div class="activity-item">
                                    <div class="activity-icon" style="background: linear-gradient(135deg, var(--info-color), #2b77c7);">
                                <i class="fas fa-percent"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Tạo khuyến mãi mới: Giảm 10% buổi trưa</div>
                                <div class="activity-time">Hôm qua</div>
                            </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/resources/js/dashboard.js"></script>
        </body>

        </html>