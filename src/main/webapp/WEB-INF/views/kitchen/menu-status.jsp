<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Trạng thái Menu - Bếp</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/manager/global.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/table-list.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
      .order-table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 14px; box-shadow: 0 1px 6px rgba(80,120,200,0.08); overflow: hidden; }
      .order-table th, .order-table td { padding: 12px 10px; text-align: center; border-bottom: 1px solid #f0f0f0; }
      .order-table th { background: #f8fafc; color: #b0b0b0; font-weight: 500; border-top-left-radius: 14px; border-top-right-radius: 14px; }
      .order-table tr:hover { background: #f5f7fa; }
      .pastel-status-dropdown { border-radius: 7px; border: 1.5px solid #e0e7ef; background: #f8fafc; padding: 4px 10px; font-weight: 500; color: #333; }
      .order-filter { display: flex; gap: 12px; align-items: center; width: 100%; margin-bottom: 18px; }
      .order-filter label { color: #888; font-size: 1em; }
      .order-filter input[type=date] { padding: 6px 12px; border-radius: 7px; border: 1px solid #d1d5db; background: #f8fafc; font-size: 1em; height: 36px; }
      .order-filter .btn { background: linear-gradient(90deg, #667eea, #764ba2); color: #fff; border: none; border-radius: 7px; padding: 7px 32px; font-weight: 500; height: 36px; min-width: 120px; font-size: 1.08em; }
    </style>
  </head>
  <body>
    <div class="manager-layout">
      <!-- Sidebar -->
      <div class="manager-sidebar">
        <div class="sidebar-header">
          <div class="sidebar-logo">🍳</div>
          <div class="sidebar-subtitle">Quản lý bếp</div>
        </div>
        <nav class="sidebar-nav">
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/kitchen/kanban?fromDate=${fromDate}&toDate=${toDate}"
              class="sidebar-nav-link"
            >
              <i class="fas fa-receipt sidebar-nav-icon"></i>
              <span>Quản lý đơn hàng</span>
            </a>
          </div>
          <div class="sidebar-nav-item">
            <a
              href="${pageContext.request.contextPath}/kitchen/menu-status"
              class="sidebar-nav-link active"
            >
              <i class="fas fa-utensils sidebar-nav-icon"></i>
              <span>Trạng thái menu</span>
            </a>
          </div>
          <div class="sidebar-nav-item logout-item" style="margin-top: auto">
            <a
              href="${pageContext.request.contextPath}/logout"
              class="sidebar-nav-link"
            >
              <i class="fas fa-sign-out-alt sidebar-nav-icon"></i>
              <span>Đăng xuất</span>
            </a>
          </div>
        </nav>
      </div>
      <!-- Main Content -->
      <div class="manager-main">
        <div class="manager-header">
          <div class="page-header">
            <h1 class="page-title">
              <i class="fas fa-utensils"></i> Trạng thái Menu
            </h1>
            <p class="page-subtitle">Quản lý trạng thái các món trong menu</p>
          </div>
        </div>
        <div class="manager-content">
          <div class="card">
            <div class="card-header">
              <div class="card-title">Danh sách món ăn</div>
              <div class="card-subtitle">Đóng/mở món trên menu</div>
            </div>
            <!-- Filter date range -->
            <form method="get" action="${pageContext.request.contextPath}/kitchen/menu-status" class="order-filter">
              <label>Từ:</label>
              <input type="date" name="fromDate" value="${fromDate}" />
              <label>Đến:</label>
              <input type="date" name="toDate" value="${toDate}" />
              <button type="submit" class="btn">Lọc</button>
            </form>
            <div class="table-container">
              <table class="order-table">
                <thead>
                  <tr>
                    <th>Ảnh</th>
                    <th>Tên món</th>
                    <th>Danh mục</th>
                    <th>Giá</th>
                    <th>Doanh thu</th>
                    <th>Đã bán</th>
                    <th>Hủy</th>
                    <th>Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="menu" items="${menus}">
                    <tr>
                      <td style="width:60px;"><img src="${pageContext.request.contextPath}${menu.imageUrl}" alt="${menu.name}" style="width:100%; height:auto; object-fit:cover; border-radius:6px;"/></td>
                      <td>${menu.name}</td>
                      <td>${menu.category.name}</td>
                      <td><fmt:formatNumber value="${menu.price}" type="currency" currencySymbol="₫"/></td>
                      <td><fmt:formatNumber value="${revenueMap[menu.dishId]}" type="currency" currencySymbol="₫"/></td>
                      <td>${orderCountMap[menu.dishId]}</td>
                      <td>${cancelCountMap[menu.dishId]}</td>
                      <td style="text-align:center;">
                        <form method="post" action="${pageContext.request.contextPath}/kitchen/menu/${menu.dishId}/change-status" style="display:inline;">
                          <input type="hidden" name="fromDate" value="${fromDate}"/>
                          <input type="hidden" name="toDate" value="${toDate}"/>
                          <select name="status" class="pastel-status-dropdown" onchange="this.form.submit()">
                            <option value="AVAILABLE" ${menu.status=='AVAILABLE' ? 'selected' : ''}>Đang mở</option>
                            <option value="UNAVAILABLE" ${menu.status=='UNAVAILABLE' ? 'selected' : ''}>Đã đóng</option>
                          </select>
                        </form>
                      </td>
                    </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
