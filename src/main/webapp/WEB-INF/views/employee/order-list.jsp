<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Danh sách món đã đặt</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
            <style>
                .badge-pending {
                    background-color: #ffc107;
                    color: #212529;
                }

                .badge-processing {
                    background-color: #ff9800;
                    color: white;
                }

                .badge-served {
                    background-color: #28a745;
                    color: white;
                }

                .badge-cancelled {
                    background-color: #dc3545;
                    color: white;
                }
            </style>
        </head>

        <body>
            <div class="container mt-3">
                <h1>Danh sách món đã đặt cho bàn số ${tableId}</h1>
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Tên món</th>
                            <th>Danh mục</th>
                            <th>Giá</th>
                            <th>Số lượng</th>
                            <th>Trạng thái</th>
                            <th>Ghi chú</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="odv" items="${orderDetailViews}">
                            <tr>
                                <td>${odv.menu.name}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${odv.menu.category == 'APPETIZER_AND_SIDE'}">Khai vị & Ăn kèm
                                        </c:when>
                                        <c:when test="${odv.menu.category == 'BEEF'}">Thịt bò</c:when>
                                        <c:when test="${odv.menu.category == 'PORK'}">Thịt heo</c:when>
                                        <c:when test="${odv.menu.category == 'SEAFOOD'}">Hải sản</c:when>
                                        <c:when test="${odv.menu.category == 'RICE_AND_SOUP_AND_NOODLES'}">Cơm & Canh &
                                            Mỳ
                                        </c:when>
                                        <c:when test="${odv.menu.category == 'HOT_POT'}">Lẩu</c:when>
                                        <c:when test="${odv.menu.category == 'DRINK'}">Đồ uống</c:when>
                                        <c:when test="${odv.menu.category == 'DESSERT'}">Tráng miệng</c:when>
                                        <c:otherwise>${odv.menu.category}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${odv.orderDetail.price}</td>
                                <td>${odv.orderDetail.quantity}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${odv.orderDetail.status == 'PENDING'}">
                                            <span class="badge badge-pending">Chờ chế biến</span>
                                        </c:when>
                                        <c:when test="${odv.orderDetail.status == 'PROCESSING'}">
                                            <span class="badge badge-processing">Đang chế biến</span>
                                        </c:when>
                                        <c:when test="${odv.orderDetail.status == 'SERVED'}">
                                            <span class="badge badge-served">Đã phục vụ</span>
                                        </c:when>
                                        <c:when test="${odv.orderDetail.status == 'CANCELLED'}">
                                            <span class="badge badge-cancelled">Đã hủy</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${odv.orderDetail.isGift}">Món tặng</c:if>
                                    <c:if test="${not empty odv.orderDetail.cancelReason}">
                                        <p class="text-danger">Lý do hủy: ${odv.orderDetail.cancelReason}</p>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/employee/table/list" class="btn btn-secondary">Quay lại
                        danh sách bàn</a>
                    <a href="${pageContext.request.contextPath}/employee/table/${tableId}/menu"
                        class="btn btn-primary">Đặt thêm món</a>
                </div>
            </div>
            <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
            <script>
                // Tự động làm mới trang sau mỗi 30 giây để cập nhật trạng thái
                setTimeout(function () {
                    location.reload();
                }, 30000);
            </script>
        </body>

        </html>