<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${menu.dishId == null ? 'Thêm món mới' : 'Chỉnh sửa món ăn'} - Hệ thống POS</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/menu-form.css">
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
                    <!-- Header -->
                    <div class="manager-header">
                        <div class="page-header">
                            <h1 class="page-title">
                                <i class="fas fa-utensils mr-2"></i>
                                ${menu.dishId == null ? 'Thêm món mới' : 'Chỉnh sửa món ăn'}
                            </h1>
                            <p class="page-subtitle">
                                ${menu.dishId == null ? 'Tạo món ăn mới cho thực đơn' : 'Cập nhật thông tin món ăn'}
                            </p>
                        </div>
                        <div class="header-actions">
                            <a href="${pageContext.request.contextPath}/manager/menus" class="btn btn-secondary">
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
                                    <i class="fas fa-${menu.dishId == null ? 'plus-circle' : 'edit'} mr-2"></i>
                                    ${menu.dishId == null ? 'Thông tin món ăn mới' : 'Chỉnh sửa thông tin món ăn'}
                                </h2>
                                <p class="form-subtitle">
                                    ${menu.dishId == null ? 'Vui lòng điền đầy đủ thông tin để tạo món ăn mới' : 'Cập nhật thông tin món ăn trong thực đơn'}
                                </p>
                            </div>

                            <div class="form-body">
                <c:if test="${not empty errorMessage}">
                    <div class="error-message">
                                        <i class="fas fa-exclamation-triangle mr-2"></i>
                        ${errorMessage}
                    </div>
                </c:if>

                                <form id="menuForm" action="${pageContext.request.contextPath}/manager/menus/save" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="dishId" value="${menu.dishId}">
                                    <input type="hidden" name="imageUrl" value="${menu.imageUrl}">

                                    <div class="form-grid">
                    <div class="form-group">
                                            <label class="form-label required" for="name">
                                                <i class="fas fa-hamburger mr-1"></i>
                                                Tên món ăn
                                            </label>
                                            <input type="text" 
                                                   id="name"
                                                   name="name" 
                                                   value="${menu.name}" 
                                                   class="form-input" 
                                                   required
                                                   placeholder="Nhập tên món ăn">
                    </div>

                    <div class="form-group">
                                            <label class="form-label required" for="categoryId">
                                                <i class="fas fa-tags mr-1"></i>
                                                Danh mục
                                            </label>
                                            <select id="categoryId" name="category.categoryId" class="form-select" required>
                                                <option value="">Chọn danh mục</option>
                            <c:forEach items="${categories}" var="cat">
                                                    <option value="${cat.categoryId}" ${menu.category.categoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                                            <label class="form-label required" for="price">
                                                <i class="fas fa-money-bill-wave mr-1"></i>
                                                Giá bán
                                            </label>
                                            <div class="price-input-wrapper">
                                                <input type="number" 
                                                       id="price"
                                                       name="price" 
                                                       value="${menu.price}" 
                                                       step="1000"
                                                       min="0"
                                                       class="form-input price-input" 
                                                       required
                                                       placeholder="0">
                                            </div>
                    </div>

                    <div class="form-group">
                                            <label class="form-label required" for="status">
                                                <i class="fas fa-toggle-on mr-1"></i>
                                                Trạng thái
                                            </label>
                                            <select id="status" name="status" class="form-select" required>
                                                <option value="AVAILABLE" ${menu.status == 'AVAILABLE' ? 'selected' : ''}>Có sẵn</option>
                                                <option value="UNAVAILABLE" ${menu.status == 'UNAVAILABLE' ? 'selected' : ''}>Không có sẵn</option>
                        </select>
                    </div>
                                    </div>

                                    <!-- Image Upload Section -->
                                    <div class="form-group full-width">
                                        <label class="form-label" for="imageFile">
                                            <i class="fas fa-image mr-1"></i>
                                            Ảnh món ăn
                                        </label>
                                        
                                        <div class="image-upload-area" onclick="document.getElementById('imageFile').click()">
                                            <div id="uploadContent">
                                                <i class="fas fa-cloud-upload-alt" style="font-size: 2rem; color: var(--primary-color); margin-bottom: var(--space-md);"></i>
                                                <div class="font-semibold text-gray-700">Nhấp để chọn ảnh hoặc kéo thả vào đây</div>
                                                <div class="image-info">Định dạng: JPG, JPEG, PNG, GIF. Kích thước tối đa: 5MB</div>
                                            </div>
                                            <img id="preview" class="image-preview" src="#" alt="Xem trước ảnh">
                                        </div>
                                        
                                        <input type="file" 
                                               id="imageFile" 
                                               name="imageFile" 
                                               class="form-input" 
                                               accept="image/jpeg,image/png,image/gif"
                                               style="display: none;">

                        <c:if test="${not empty menu.imageUrl}">
                                            <div style="margin-top: var(--space-md); text-align: center;">
                                                <div class="font-semibold text-gray-700 mb-2">Ảnh hiện tại:</div>
                                                <img src="${pageContext.request.contextPath}${menu.imageUrl}" 
                                                     alt="${menu.name}" 
                                                     class="current-image">
                                                <div class="image-info">Nếu bạn chọn ảnh mới, ảnh cũ sẽ bị thay thế</div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="form-actions">
                                        <div>
                                            <a href="${pageContext.request.contextPath}/manager/menus" class="btn btn-secondary">
                                                <i class="fas fa-times mr-1"></i>
                                                <span>Hủy bỏ</span>
                                            </a>
                                        </div>
                            <div>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save mr-1"></i>
                                                <span>${menu.dishId == null ? 'Tạo món ăn' : 'Cập nhật món ăn'}</span>
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/resources/js/manager/menu-form.js"></script>
        </body>

        </html>