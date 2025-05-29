<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Quản lý món ăn - Hệ thống POS</title>
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
                            <a href="${pageContext.request.contextPath}/manager/menus" class="sidebar-nav-link active">
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
                            <h1 class="page-title">Quản lý món ăn</h1>
                            <p class="page-subtitle">Quản lý thực đơn và giá cả</p>
                        </div>
                        <div class="header-actions">
                            <div class="search-container">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" placeholder="Tìm kiếm món ăn..." class="search-input">
                            </div>
                            <a href="${pageContext.request.contextPath}/manager/menus/new" class="btn btn-primary">
                                <i class="fas fa-plus"></i>
                                <span>Thêm món mới</span>
                            </a>
                        </div>
                    </div>

                    <!-- Content -->
                    <div class="manager-content">
                        <!-- Stats Cards -->
                        <div class="grid grid-cols-4 mb-xl">
                            <div class="card">
                                <div class="card-body text-center">
                                    <div class="text-2xl font-bold text-gray-900">${menus.size()}</div>
                                    <div class="text-sm text-gray-600">Tổng món ăn</div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-body text-center">
                                    <div class="text-2xl font-bold text-gray-900">
                                        <c:set var="availableCount" value="0"/>
                                        <c:forEach var="menu" items="${menus}">
                                            <c:if test="${menu.status == 'AVAILABLE'}">
                                                <c:set var="availableCount" value="${availableCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${availableCount}
                                    </div>
                                    <div class="text-sm text-gray-600">Món đang bán</div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-body text-center">
                                    <div class="text-2xl font-bold text-gray-900">
                                        <c:set var="unavailableCount" value="0"/>
                                        <c:forEach var="menu" items="${menus}">
                                            <c:if test="${menu.status == 'UNAVAILABLE'}">
                                                <c:set var="unavailableCount" value="${unavailableCount + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${unavailableCount}
                                    </div>
                                    <div class="text-sm text-gray-600">Món tạm ngưng</div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-body text-center">
                                    <div class="text-2xl font-bold text-gray-900">
                                        <c:set var="totalCategories" value="0"/>
                                        <c:set var="categorySet" value="${pageScope.categorySet = []}"/>
                                        <c:forEach var="menu" items="${menus}">
                                            <c:if test="${!categorySet.contains(menu.category.categoryId)}">
                                                <c:set var="categorySet" value="${categorySet.add(menu.category.categoryId)}"/>
                                                <c:set var="totalCategories" value="${totalCategories + 1}"/>
                                            </c:if>
                                        </c:forEach>
                                        ${totalCategories}
                                    </div>
                                    <div class="text-sm text-gray-600">Danh mục</div>
                                </div>
                            </div>
                        </div>

                        <!-- Menu Table -->
                        <div class="card">
                            <div class="card-header">
                                <div class="card-title">Danh sách món ăn</div>
                                <div class="card-subtitle">Tất cả món ăn trong hệ thống</div>
                            </div>
                            <div class="table-container">
                                <table class="table">
                                    <thead>
                <tr>
                    <th>ID</th>
                    <th>Ảnh</th>
                    <th>Tên món</th>
                    <th>Danh mục</th>
                                            <th>Giá bán</th>
                    <th>Trạng thái</th>
                                            <th>Thao tác</th>
                </tr>
                                    </thead>
                                    <tbody>
                <c:forEach var="menu" items="${menus}">
                    <tr>
                                                <td>
                                                    <span class="font-semibold text-gray-700">#${menu.dishId}</span>
                                                </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty menu.imageUrl}">
                                                            <div style="width: 60px; height: 60px; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                                                                <img src="${pageContext.request.contextPath}${menu.imageUrl}" 
                                                                     alt="${menu.name}"
                                                                     style="width: 100%; height: 100%; object-fit: cover;">
                                                            </div>
                                </c:when>
                                <c:otherwise>
                                                            <div style="width: 60px; height: 60px; background: var(--gray-100); border-radius: 8px; display: flex; align-items: center; justify-content: center; color: var(--gray-400);">
                                                                <i class="fas fa-image"></i>
                                                            </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                                                <td>
                                                    <div class="font-semibold text-gray-900">${menu.name}</div>
                                                </td>
                                                <td>
                                                    <span class="badge badge-info">${menu.category.name}</span>
                                                </td>
                                                <td>
                                                    <span class="font-semibold text-gray-900">${menu.price}đ</span>
                                                </td>
                        <td>
                            <c:choose>
                                <c:when test="${menu.status == 'AVAILABLE'}">
                                                            <span class="badge badge-success">
                                                                <i class="fas fa-check"></i>
                                                                <span>Đang bán</span>
                                                            </span>
                                </c:when>
                                <c:when test="${menu.status == 'UNAVAILABLE'}">
                                                            <span class="badge badge-warning">
                                                                <i class="fas fa-pause"></i>
                                                                <span>Tạm ngưng</span>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-gray">${menu.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="flex gap-sm">
                                                        <a href="${pageContext.request.contextPath}/manager/menus/edit/${menu.dishId}" 
                                                           class="btn btn-sm btn-secondary">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${menu.status == 'AVAILABLE'}">
                                    <a href="${pageContext.request.contextPath}/manager/menus/toggle-status/${menu.dishId}"
                                                                   class="btn btn-sm btn-warning"
                                                                   onclick="return confirm('Tạm ngưng bán món ${menu.name}?')">
                                                                    <i class="fas fa-pause"></i>
                                    </a>
                                </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/manager/menus/toggle-status/${menu.dishId}"
                                                                   class="btn btn-sm btn-success"
                                                                   onclick="return confirm('Mở lại bán món ${menu.name}?')">
                                                                    <i class="fas fa-play"></i>
                                                                </a>
                                                            </c:otherwise>
                            </c:choose>
                            <a href="${pageContext.request.contextPath}/manager/menus/delete/${menu.dishId}"
                                onclick="return confirm('Bạn có chắc muốn xóa món ${menu.name}?')"
                                                           class="btn btn-sm btn-danger">
                                                            <i class="fas fa-trash"></i>
                                                        </a>
                                                    </div>
                        </td>
                    </tr>
                </c:forEach>
                                    </tbody>
            </table>
                            </div>
                            <div class="card-footer">
                                <div class="flex justify-between items-center">
                                    <span class="text-sm text-gray-600">
                                        Hiển thị ${menus.size()} món ăn
                                    </span>
                                    <a href="${pageContext.request.contextPath}/manager/dashboard" class="btn btn-secondary">
                                        <i class="fas fa-arrow-left"></i>
                                        <span>Quay lại Dashboard</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="${pageContext.request.contextPath}/resources/js/menu-list.js"></script>
        </body>

        </html>