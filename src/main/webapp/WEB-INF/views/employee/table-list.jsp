<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bàn - Nhân viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/table-list.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .filter-form.compact-filter {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px 0 rgba(80,120,200,0.07);
            border: 1px solid #e0e7ef;
            padding: 12px 18px;
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .filter-form .filter-group label {
            font-weight: 500;
            color: #333;
            margin-right: 6px;
        }

        .filter-form select {
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            background: #f8fafc;
            font-size: 1em;
        }

        .filter-form button {
            padding: 7px 14px;
            border-radius: 6px;
            border: none;
            background: #4CAF50;
            color: #fff;
            font-weight: 500;
            transition: background 0.2s;
        }

        .filter-form button:hover {
            background: #388e3c;
        }

        .filter-form .clear-filter {
            background: #f44336 !important;
        }

        .filter-form .clear-filter:hover {
            background: #d32f2f !important;
        }
    </style>
    <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
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
                    <a href="${pageContext.request.contextPath}/employee/dashboard" class="sidebar-nav-link">
                        <i class="fas fa-chart-line sidebar-nav-icon"></i>
                        <span>Tổng quan</span>
                    </a>
                </div>
                <div class="sidebar-nav-item">
                    <a href="${pageContext.request.contextPath}/employee/table/list" class="sidebar-nav-link active">
                        <i class="fas fa-table sidebar-nav-icon"></i>
                        <span>Quản lý bàn</span>
                    </a>
                </div>
                <div class="sidebar-nav-item logout-item" style="margin-top:auto;">
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
                <div class="header-content">
                    <h1 class="page-title">
                        <i class="fas fa-table"></i>
                        <span>Quản lý bàn</span>
                    </h1>
                    <p class="page-description">Quản lý và theo dõi trạng thái các bàn trong nhà hàng</p>
                </div>
            </div>

            <!-- Content -->
            <div class="manager-content">
                <!-- Header with Filters and Count -->
                <div class="tables-header">
                    <!-- Compact Filter Form -->
                    <div class="tables-filter">
                        <div class="filter-form compact-filter">
                            <div class="filter-group">
                                <label for="floor"><i class="fas fa-building"></i> Tầng</label>
                                <select name="floor" id="floor">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="floorOption" items="${floors}">
                                        <option value="${floorOption}" ${selectedFloor==floorOption ? 'selected' : ''}>${floorOption}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="filter-group">
                                <label for="status"><i class="fas fa-tag"></i> Trạng thái</label>
                                <select name="status" id="status">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="statusOption" items="${statuses}">
                                        <option value="${statusOption}" ${selectedStatus==statusOption ? 'selected' : ''}>${statusOption}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <button type="submit" onclick="applyFilters()" title="Lọc">
                                <i class="fas fa-filter"></i>
                            </button>
                            <button type="button" class="clear-filter" onclick="clearFilters()" title="Xóa bộ lọc">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Table Count Info -->
                    <div class="tables-count">
                        Hiển thị ${tables.size()} trong tổng số ${totalTables} bàn
                    </div>
                </div>

                <!-- Tables Grid -->
                <div class="tables-grid">
                    <c:forEach var="table" items="${tables}">
                        <c:choose>
                            <c:when test="${table.status == 'CLEANING'}">
                                <div class="table-card table-capacity-${table.capacity} cleaning">
                            </c:when>
                            <c:otherwise>
                                <div class="table-card table-capacity-${table.capacity} ${table.status == 'AVAILABLE' ? 'empty' : table.status == 'SERVING' ? 'in-use' : table.status == 'RESERVED' ? 'reserved' : table.status == 'CLEANING' ? 'cleaning' : 'waiting'}" 
                                     onclick="location.href='${pageContext.request.contextPath}/employee/table/${table.tableId}/menu'">
                            </c:otherwise>
                        </c:choose>
                        
                            <!-- Table Body -->
                            <div class="table-body">
                                <!-- Seats Layout -->
                                <div class="table-seats top-seats">
                                    <c:forEach var="i" begin="1" end="${table.capacity/2}">
                                        <div class="seat seat-${table.status}"></div>
                                    </c:forEach>
                                </div>
                                
                                <!-- Table Main -->
                                <div class="table-main table-main-${table.status}">
                                    <div class="table-main-inner" style="font-size:1.1rem;font-weight:700;text-align:center;line-height:1.2;">
                                        <div>${table.tableNumber}</div>
                                        <div style="font-size:0.95em;font-weight:400;margin-top:2px;">
                                            <i class="fas fa-building"></i> Tầng ${table.floor}
                                        </div>
                                        <div style="font-size:0.95em;font-weight:400;margin-top:2px;">
                                            <c:choose>
                                                <c:when test="${table.status == 'AVAILABLE'}">
                                                    <i class="fas fa-check" style="color: var(--success-color);"></i> Sẵn sàng
                                                </c:when>
                                                <c:when test="${table.status == 'RESERVED'}">
                                                    <i class="fas fa-clock" style="color: var(--warning-color);"></i> Đã đặt
                                                </c:when>
                                                <c:when test="${table.status == 'SERVING'}">
                                                    <i class="fas fa-utensils" style="color: var(--primary-color);"></i> Đang phục vụ
                                                </c:when>
                                                <c:when test="${table.status == 'PENDING_PAYMENT'}">
                                                    <i class="fas fa-credit-card" style="color: var(--danger-color);"></i> Chờ thanh toán
                                                </c:when>
                                                <c:when test="${table.status == 'CLEANING'}">
                                                    <i class="fas fa-broom" style="color: var(--gray-500);"></i> Đang dọn dẹp
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-info-circle"></i> ${table.status}
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <c:if test="${table.status == 'CLEANING'}">
                                            <form action="${pageContext.request.contextPath}/employee/table/${table.tableId}/complete-cleaning" method="post" class="btn-main-action" onclick="event.stopPropagation();">
                                                <button type="submit" class="btn-soft-outline-success" onclick="return confirm('Hoàn thành dọn dẹp bàn ${table.tableNumber}?');">
                                                    <i class="fas fa-check"></i> Hoàn thành
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Bottom Seats -->
                                <div class="table-seats">
                                    <c:forEach var="i" begin="1" end="${table.capacity/2}">
                                        <div class="seat seat-${table.status}"></div>
                                    </c:forEach>
                                </div>
                            </div>
                            
                            <!-- Table Info -->
                            <div class="table-info">
                                <!-- capacity-info đã bị loại bỏ -->
                                <!-- floor-info và status-text đã chuyển vào table-main -->
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Phân trang">
                        <ul class="pagination">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&floor=${selectedFloor}&status=${selectedStatus}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${pageNum}&floor=${selectedFloor}&status=${selectedStatus}">
                                        ${pageNum}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&floor=${selectedFloor}&status=${selectedStatus}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        function applyFilters() {
            const floor = document.getElementById('floor').value;
            const status = document.getElementById('status').value;
            
            let url = window.location.pathname + '?';
            const params = [];
            
            if (floor) params.push('floor=' + encodeURIComponent(floor));
            if (status) params.push('status=' + encodeURIComponent(status));
            
            url += params.join('&');
            window.location.href = url;
        }

        function clearFilters() {
            window.location.href = window.location.pathname;
        }

        // Search functionality
        document.querySelector('.search-input').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const tableCards = document.querySelectorAll('.table-card');
            
            tableCards.forEach(card => {
                const tableNumber = card.querySelector('.table-number').textContent;
                const floor = card.querySelector('.floor-info').textContent;
                const status = card.querySelector('.status-text').textContent;
                
                const matchesSearch = tableNumber.includes(searchTerm) || 
                                    floor.toLowerCase().includes(searchTerm) || 
                                    status.toLowerCase().includes(searchTerm);
                
                card.style.display = matchesSearch ? 'flex' : 'none';
            });
        });
    </script>
</body>
</html>
