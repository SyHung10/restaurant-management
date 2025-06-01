<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Danh sách bàn cần thanh toán</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/style.css">
        </head>

        <body>
            <h1>Danh sách bàn cần thanh toán</h1>
            <table border="1">
                <tr>
                    <th>ID</th>
                    <th>Tầng</th>
                    <th>Số bàn</th>
                    <th>Sức chứa</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                <c:forEach var="table" items="${tables}">
                    <tr>
                        <td>${table.tableId}</td>
                        <td>${table.floor}</td>
                        <td>${table.tableNumber}</td>
                        <td>${table.capacity}</td>
                        <td>${table.status}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/employee/payment/${table.tableId}">Thanh
                                toán</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <a href="${pageContext.request.contextPath}/employee/table/list">Quay lại trang bàn</a>
        </body>

        </html>