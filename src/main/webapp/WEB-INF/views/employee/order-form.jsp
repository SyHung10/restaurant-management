<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Đặt món cho bàn</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        </head>

        <body>
            <h1>Đặt món cho bàn số ${table.tableNumber}</h1>
            <form action="${pageContext.request.contextPath}/employee/table/${table.tableId}/order" method="post">
                <label>Số người:</label>
                <input type="number" name="numPeople" value="${table.capacity}" min="1" required><br><br>
                <table border="1">
                    <tr>
                        <th>Chọn</th>
                        <th>Tên món</th>
                        <th>Danh mục</th>
                        <th>Giá</th>
                        <th>Số lượng</th>
                    </tr>
                    <c:forEach var="menu" items="${menuList}">
                        <tr>
                            <td><input type="checkbox" name="dishIds" value="${menu.dishId}"
                                    onclick="toggleQuantity(this)"></td>
                            <td>${menu.name}</td>
                            <td>${menu.category}</td>
                            <td>${menu.price}</td>
                            <td><input type="number" name="quantities" value="0" min="0" disabled></td>
                        </tr>
                    </c:forEach>
                </table>
                <br>
                <button type="submit">Đặt món</button>
                <a href="${pageContext.request.contextPath}/employee/table/list">Quay lại danh sách bàn</a>
            </form>
            <script>
                // Enable/disable quantity input when checkbox is checked/unchecked
                function toggleQuantity(checkbox) {
                    var quantityInput = checkbox.parentElement.parentElement.querySelector('input[name="quantities"]');
                    if (checkbox.checked) {
                        quantityInput.disabled = false;
                        quantityInput.value = 1;
                    } else {
                        quantityInput.disabled = true;
                        quantityInput.value = 0;
                    }
                }
            </script>
        </body>

        </html>