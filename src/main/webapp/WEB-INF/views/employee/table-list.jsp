<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Danh sách bàn - POS Nhà hàng</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/style.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/tables.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .filter-form {
                    margin-bottom: 20px;
                    padding: 15px;
                    background-color: #f8f8f8;
                    border-radius: 5px;
                    border: 1px solid #ddd;
                }

                .filter-form select,
                .filter-form button {
                    padding: 8px;
                    margin-right: 10px;
                    border-radius: 4px;
                    border: 1px solid #ccc;
                }

                .filter-form button {
                    background-color: #4CAF50;
                    color: white;
                    border: none;
                    cursor: pointer;
                }

                .filter-form button:hover {
                    background-color: #45a049;
                }

                .clear-filter {
                    background-color: #f44336 !important;
                }

                .clear-filter:hover {
                    background-color: #d32f2f !important;
                }
            </style>
            <script src="${pageContext.request.contextPath}/resources/js/script.js"></script>
        </head>

        <body>
            <!-- Header -->
            <header class="header">
                <div class="logo">
                    <span>RUSH</span>
                </div>
                <div class="header-right">
                    <div class="search-bar">
                        <input type="text" placeholder="Buscar...">
                        <button><i class="fas fa-search"></i></button>
                    </div>
                    <div class="user-profile">
                        <img src="https://ui-avatars.com/api/?name=User" alt="User Profile">
                        <span>Hans Miller</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>
            </header>

            <!-- Sidebar -->
            <div class="sidebar">
                <div class="site-info">
                    <h3>Margaritas site</h3>
                    <p>Av. La Habana 309, San Borja, Lima</p>
                </div>
                <ul class="menu-list">
                    <li class="active">
                        <i class="fas fa-th"></i>
                        <span>Tables</span>
                    </li>
                    <li>
                        <i class="fas fa-utensils"></i>
                        <span>Menu</span>
                    </li>
                    <li>
                        <i class="fas fa-clipboard-list"></i>
                        <span>Orders</span>
                    </li>
                </ul>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="page-title">
                    <h1>Tables</h1>
                </div>

                <!-- Tables Section with Filter and Grid -->
                <div class="tables-section">
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
                                            <option value="${floorOption}" ${selectedFloor == floorOption ? 'selected' : ''}>${floorOption}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="filter-group">
                                    <label for="status"><i class="fas fa-tag"></i> Trạng thái</label>
                                    <select name="status" id="status">
                                        <option value="">Tất cả</option>
                                        <c:forEach var="statusOption" items="${statuses}">
                                            <option value="${statusOption}" ${selectedStatus == statusOption ? 'selected' : ''}>${statusOption}</option>
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
                                    <div class="table-card ${table.status == 'AVAILABLE' ? 'empty' : table.status == 'SERVING' ? 'in-use' : table.status == 'RESERVED' ? 'reserved' : table.status == 'CLEANING' ? 'cleaning' : 'waiting'}">
                                </c:when>
                                <c:otherwise>
                                    <div class="table-card ${table.status == 'AVAILABLE' ? 'empty' : table.status == 'SERVING' ? 'in-use' : table.status == 'RESERVED' ? 'reserved' : table.status == 'CLEANING' ? 'cleaning' : 'waiting'}"
                                onclick="location.href='${pageContext.request.contextPath}/employee/table/${table.tableId}/menu'">
                                </c:otherwise>
                            </c:choose>
                                
                                <div class="table-number">${table.tableNumber}</div>
                                <div class="table-status">
                                    <c:if test="${table.status == 'SERVING'}">
                                        <i class="fas fa-utensils" style="color: var(--primary-color);"></i>
                                    </c:if>
                                    <c:if test="${table.status == 'RESERVED'}">
                                        <i class="fas fa-clock" style="color: var(--warning-color);"></i>
                                    </c:if>
                                    <c:if test="${table.status == 'AVAILABLE'}">
                                        <i class="fas fa-check" style="color: var(--success-color);"></i>
                                    </c:if>
                                    <c:if test="${table.status == 'CLEANING'}">
                                        <i class="fas fa-broom" style="color: var(--info-color);"></i>
                                    </c:if>
                                    <c:if test="${table.status == 'PENDING_PAYMENT'}">
                                        <i class="fas fa-credit-card" style="color: var(--danger-color);"></i>
                                    </c:if>
                                </div>
                                <div class="table-info">
                                    <div class="table-capacity">
                                        <i class="fas fa-users"></i> ${table.capacity}
                                    </div>
                                    <div>Tầng ${table.floor}</div>
                                    <div class="table-status-text">
                                        <c:choose>
                                            <c:when test="${table.status == 'AVAILABLE'}">Sẵn sàng</c:when>
                                            <c:when test="${table.status == 'RESERVED'}">Đã đặt</c:when>
                                            <c:when test="${table.status == 'SERVING'}">Đang phục vụ</c:when>
                                            <c:when test="${table.status == 'PENDING_PAYMENT'}">Chờ thanh toán</c:when>
                                            <c:when test="${table.status == 'CLEANING'}">Đang dọn dẹp</c:when>
                                            <c:otherwise>${table.status}</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <!-- Nút hoàn thành dọn dẹp chỉ hiện với bàn CLEANING -->
                                <c:if test="${table.status == 'CLEANING'}">
                                    <form action="${pageContext.request.contextPath}/employee/table/${table.tableId}/complete-cleaning" 
                                          method="post" style="margin-top: 10px;" onclick="event.stopPropagation();">
                                        <button type="submit" class="btn btn-success btn-sm" 
                                                onclick="return confirm('Hoàn thành dọn dẹp bàn ${table.tableNumber}?');">
                                            <i class="fas fa-check"></i> Hoàn thành dọn dẹp
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Phân trang">
                            <ul class="pagination">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="javascript:void(0)"
                                        onclick="goToPage(${currentPage - 1})" aria-label="Trang trước">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>

                                <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                    <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="javascript:void(0)"
                                            onclick="goToPage(${pageNumber})">
                                            ${pageNumber}
                                        </a>
                                    </li>
                                </c:forEach>

                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="javascript:void(0)"
                                        onclick="goToPage(${currentPage + 1})" aria-label="Trang sau">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>

            <script>
                function applyFilters() {
                    const floor = document.getElementById('floor').value;
                    const status = document.getElementById('status').value;

                    let url = '${pageContext.request.contextPath}/employee/table/list';
                    let params = [];

                    if (floor) {
                        params.push('floor=' + floor);
                    }

                    if (status) {
                        params.push('status=' + status);
                    }

                    if (params.length > 0) {
                        url += '?' + params.join('&');
                    }

                    window.location.href = url;
                }

                function clearFilters() {
                    window.location.href = '${pageContext.request.contextPath}/employee/table/list';
                }

                function goToPage(page) {
                    const floor = document.getElementById('floor').value;
                    const status = document.getElementById('status').value;

                    let url = '${pageContext.request.contextPath}/employee/table/list';
                    let params = [];

                    params.push('page=' + page);

                    if (floor) {
                        params.push('floor=' + floor);
                    }

                    if (status) {
                        params.push('status=' + status);
                    }

                    url += '?' + params.join('&');

                    window.location.href = url;
                }
            </script>
        </body>

        </html>

        <!-- Custom JavaScript -->
        <script src="${pageContext.request.contextPath}/resources/js/common/script.js"></script>