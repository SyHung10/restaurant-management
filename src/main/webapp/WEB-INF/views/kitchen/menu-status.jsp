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
      href="${pageContext.request.contextPath}/resources/css/employee/menu-style.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/employee/kitchen.css"
    />
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
              href="${pageContext.request.contextPath}/kitchen/kanban?fromDate=<%= java.time.LocalDate.now() %>&toDate=<%= java.time.LocalDate.now() %>&filterStatus="
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
          <div class="card menu-status-card">

            <!-- Filter date range and category -->
            <form method="get" action="${pageContext.request.contextPath}/kitchen/menu-status" class="order-filter">
              <label>Từ:</label>
              <input type="date" name="fromDate" value="${fromDate}" />
              <label>Đến:</label>
              <input type="date" name="toDate" value="${toDate}" />
              <label>Danh mục:</label>
              <select name="categoryId" class="pastel-status-dropdown">
                <option value="" <c:if test="${selectedCategory == null}">selected</c:if>>Tất cả</option>
                <c:forEach var="cat" items="${categories}">
                  <option value="${cat.categoryId}" <c:if test="${cat.categoryId == selectedCategory}">selected</c:if>>${cat.name}</option>
                </c:forEach>
              </select>
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
                      <td style="width:60px;"><img src="${menu.imageUrl}" alt="${menu.name}" style="width:100%; height:auto; object-fit:cover; border-radius:6px;"/></td>
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
