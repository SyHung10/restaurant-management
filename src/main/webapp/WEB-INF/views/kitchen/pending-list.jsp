<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Bếp - Quản lý Món Ăn</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/kitchen.css">
            <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        </head>

        <body>
            <div class="kitchen-container">
                <div class="kitchen-header">
                    <h1 class="kitchen-title">
                        <i class="fas fa-utensils"></i> Quản lý Bếp
                    </h1>
                    <div class="kitchen-stats">
                        <div class="stat-item">
                            <i class="fas fa-clock"></i>
                            <span>Đang chờ: </span>
                            <span class="stat-count pending-count">
                                ${pendingList.stream().filter(odv -> odv.orderDetail.status == 'PENDING').count()}
                            </span>
                        </div>
                        <div class="stat-item">
                            <i class="fas fa-fire"></i>
                            <span>Đang nấu: </span>
                            <span class="stat-count processing-count">
                                ${pendingList.stream().filter(odv -> odv.orderDetail.status == 'PROCESSING').count()}
                            </span>
                        </div>
                    </div>
                </div>

                <div class="kitchen-content">
                    <div class="orders-container">
                        <c:if test="${empty pendingList}">
                            <div class="empty-state">
                                <i class="fas fa-utensils"></i>
                                <p class="empty-state-text">Không có món ăn nào đang chờ hoặc đang nấu</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty pendingList}">
                            <%-- Nhóm các món ăn theo orderId --%>
                                <jsp:useBean id="orderMap" class="java.util.HashMap" scope="request" />
                                <c:forEach items="${pendingList}" var="odv">
                                    <c:set target="${orderMap}" property="${odv.orderDetail.orderId}"
                                        value="${odv.orderDetail.orderId}" />
                                </c:forEach>

                                <c:forEach items="${orderMap}" var="orderEntry">
                                    <div class="order-group">
                                        <div class="order-header">
                                            <div class="order-id">
                                                <i class="fas fa-receipt"></i> Đơn #${orderEntry.key}
                                            </div>
                                            <%-- Đếm số lượng món theo trạng thái --%>
                                                <c:set var="pendingCount" value="0" />
                                                <c:set var="processingCount" value="0" />
                                                <c:forEach items="${pendingList}" var="odv">
                                                    <c:if test="${odv.orderDetail.orderId == orderEntry.key}">
                                                        <c:if test="${odv.orderDetail.status == 'PENDING'}">
                                                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                                                        </c:if>
                                                        <c:if test="${odv.orderDetail.status == 'PROCESSING'}">
                                                            <c:set var="processingCount"
                                                                value="${processingCount + 1}" />
                                                        </c:if>
                                                    </c:if>
                                                </c:forEach>

                                                <div>
                                                    <c:if test="${pendingCount > 0}">
                                                        <span class="order-badge badge-pending">${pendingCount}
                                                            chờ</span>
                                                    </c:if>
                                                    <c:if test="${processingCount > 0}">
                                                        <span class="order-badge badge-processing">${processingCount}
                                                            đang nấu</span>
                                                    </c:if>
                                                </div>
                                        </div>

                                        <div class="order-body">
                                            <ul class="order-items-list">
                                                <c:forEach items="${pendingList}" var="odv">
                                                    <c:if test="${odv.orderDetail.orderId == orderEntry.key}">
                                                        <li class="order-item">
                                                            <div class="item-name">
                                                                ${odv.menu.name}
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${odv.orderDetail.status == 'PENDING'}">
                                                                        <span
                                                                            class="status-pill status-pending">Chờ</span>
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${odv.orderDetail.status == 'PROCESSING'}">
                                                                        <span class="status-pill status-processing">Đang
                                                                            nấu</span>
                                                                    </c:when>
                                                                </c:choose>
                                                            </div>
                                                            <div class="item-details">
                                                                <span
                                                                    class="item-category">${odv.menu.category.name}</span>
                                                                <span class="item-quantity">SL:
                                                                    ${odv.orderDetail.quantity}</span>
                                                            </div>
                                                            <c:if test="${not empty odv.orderDetail.cancelReason}">
                                                                <div class="item-note">
                                                                    <i class="fas fa-sticky-note"></i>
                                                                    ${odv.orderDetail.cancelReason}
                                                                </div>
                                                            </c:if>

                                                            <div class="order-actions"
                                                                style="padding: 5px 0; background: none; border: none;">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${odv.orderDetail.status == 'PENDING'}">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/kitchen/orderDetail/${odv.orderDetail.orderDetailId}/startCooking"
                                                                            method="post" style="flex: 1;">
                                                                            <button type="submit"
                                                                                class="btn btn-primary">
                                                                                <i class="fas fa-fire"></i> Bắt đầu
                                                                            </button>
                                                                        </form>
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${odv.orderDetail.status == 'PROCESSING'}">
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/kitchen/orderDetail/${odv.orderDetail.orderDetailId}/done"
                                                                            method="post" style="flex: 1;">
                                                                            <button type="submit"
                                                                                class="btn btn-success">
                                                                                <i class="fas fa-check"></i> Hoàn thành
                                                                            </button>
                                                                        </form>
                                                                    </c:when>
                                                                </c:choose>
                                                                <button type="button" class="btn btn-danger"
                                                                    data-toggle="modal" data-target="#cancelModal"
                                                                    data-id="${odv.orderDetail.orderDetailId}">
                                                                    <i class="fas fa-times"></i> Hủy
                                                                </button>
                                                            </div>
                                                        </li>
                                                    </c:if>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </c:forEach>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Modal Cancel -->
            <div class="modal fade" id="cancelModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content" id="cancelModalContent">Loading...</div>
                </div>
            </div>

            <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                $(document).ready(function () {
                    $('#cancelModal').on('show.bs.modal', function (e) {
                        var detailId = $(e.relatedTarget).data('id');
                        var url = '${pageContext.request.contextPath}/kitchen/orderDetail/' + detailId + '/cancelForm';
                        $('#cancelModalContent').load(url);
                    });

                    // Tự động refresh trang sau mỗi 30 giây
                    setInterval(function () {
                        location.reload();
                    }, 30000);
                });
            </script>
        </body>

        </html>