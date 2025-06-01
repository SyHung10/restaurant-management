<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Thanh toán thành công</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>

    <body>
        <h1>Thanh toán thành công!</h1>
        <p>Bàn số: ${table.tableNumber}</p>
        <p>Tổng tiền đã thanh toán: ${payment.finalAmount}</p>
        <p>Phương thức thanh toán: ${payment.paymentMethod}</p>
        <p>Thời gian: ${payment.paymentTime}</p>
        <a href="${pageContext.request.contextPath}/employee/payment/tables">Quay lại danh sách bàn cần thanh toán</a>
        <a href="${pageContext.request.contextPath}/employee/table/list">Về trang bàn</a>
    </body>

    </html>