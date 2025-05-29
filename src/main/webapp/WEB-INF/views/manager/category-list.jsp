<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Quản lý danh mục</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 20px;
                    background-color: #f9f9f9;
                }

                h1 {
                    color: #333;
                    margin-bottom: 20px;
                }

                .btn-add {
                    display: inline-block;
                    margin-bottom: 20px;
                    padding: 10px 20px;
                    background-color: #4CAF50;
                    color: white;
                    text-decoration: none;
                    border-radius: 4px;
                }

                .btn-add:hover {
                    background-color: #45a049;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    background-color: white;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                }

                th,
                td {
                    padding: 12px 15px;
                    text-align: left;
                    border-bottom: 1px solid #ddd;
                }

                th {
                    background-color: #f2f2f2;
                    font-weight: bold;
                }

                tr:hover {
                    background-color: #f5f5f5;
                }

                .action-links a {
                    margin-right: 10px;
                    text-decoration: none;
                }

                .edit-link {
                    color: #2196F3;
                }

                .delete-link {
                    color: #F44336;
                }

                .back-link {
                    display: inline-block;
                    margin-top: 20px;
                    color: #333;
                    text-decoration: none;
                }

                .error-message {
                    color: #f44336;
                    padding: 10px;
                    margin-bottom: 15px;
                    background-color: #ffebee;
                    border-radius: 4px;
                    border-left: 4px solid #f44336;
                }

                .badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: bold;
                }

                .badge-active {
                    background-color: #4CAF50;
                    color: white;
                }

                .badge-inactive {
                    background-color: #F44336;
                    color: white;
                }
            </style>
        </head>

        <body>
            <h1>Danh sách danh mục</h1>

            <c:if test="${not empty param.error}">
                <div class="error-message">
                    ${param.error}
                </div>
            </c:if>

            <a href="${pageContext.request.contextPath}/manager/categories/new" class="btn-add">Thêm danh mục mới</a>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Mã</th>
                    <th>Tên danh mục</th>
                    <th>Thứ tự hiển thị</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
                <c:forEach var="category" items="${categories}">
                    <tr>
                        <td>${category.categoryId}</td>
                        <td>${category.code}</td>
                        <td>${category.name}</td>
                        <td>${category.displayOrder}</td>
                        <td>
                            <c:choose>
                                <c:when test="${category.status == 'ACTIVE'}">
                                    <span class="badge badge-active">Kích hoạt</span>
                                </c:when>
                                <c:when test="${category.status == 'INACTIVE'}">
                                    <span class="badge badge-inactive">Không kích hoạt</span>
                                </c:when>
                                <c:otherwise>${category.status}</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="action-links">
                            <a href="${pageContext.request.contextPath}/manager/categories/edit/${category.categoryId}"
                                class="edit-link">Sửa</a>
                            <a href="${pageContext.request.contextPath}/manager/categories/delete/${category.categoryId}"
                                onclick="return confirm('Bạn có chắc muốn xóa danh mục ${category.name}?')"
                                class="delete-link">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
            <a href="${pageContext.request.contextPath}/manager/dashboard" class="back-link">Quay lại Dashboard</a>
        </body>

        </html>