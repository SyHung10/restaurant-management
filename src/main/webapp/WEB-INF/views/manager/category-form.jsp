<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>${category.categoryId == null ? 'Thêm danh mục mới' : 'Sửa danh mục'}</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
            <style>
                .form-container {
                    max-width: 800px;
                    margin: 0 auto;
                    padding: 20px;
                    background-color: #f9f9f9;
                    border-radius: 8px;
                    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                }

                .form-group {
                    margin-bottom: 15px;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: bold;
                }

                .form-control {
                    width: 100%;
                    padding: 8px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    box-sizing: border-box;
                }

                .btn {
                    padding: 10px 20px;
                    background-color: #4CAF50;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                }

                .btn:hover {
                    background-color: #45a049;
                }

                .btn-back {
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
            </style>
        </head>

        <body>
            <div class="form-container">
                <h1>${category.categoryId == null ? 'Thêm danh mục mới' : 'Sửa danh mục'}</h1>

                <c:if test="${not empty param.error}">
                    <div class="error-message">
                        ${param.error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/categories/save" method="post">
                    <input type="hidden" name="categoryId" value="${category.categoryId}">

                    <div class="form-group">
                        <label>Mã danh mục:</label>
                        <input type="text" name="code" value="${category.code}" class="form-control" required
                            ${category.categoryId !=null ? 'readonly' : '' }>
                        <c:if test="${category.categoryId != null}">
                            <small>Mã danh mục không thể thay đổi sau khi đã tạo.</small>
                        </c:if>
                    </div>

                    <div class="form-group">
                        <label>Tên danh mục:</label>
                        <input type="text" name="name" value="${category.name}" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label>Thứ tự hiển thị:</label>
                        <input type="number" name="displayOrder" value="${category.displayOrder}" class="form-control"
                            min="0">
                    </div>

                    <div class="form-group">
                        <label>Trạng thái:</label>
                        <select name="status" class="form-control" required>
                            <option value="ACTIVE" ${category.status=='ACTIVE' ? 'selected' : '' }>Kích hoạt</option>
                            <option value="INACTIVE" ${category.status=='INACTIVE' ? 'selected' : '' }>Không kích hoạt
                            </option>
                        </select>
                    </div>

                    <button type="submit" class="btn">Lưu</button>
                </form>
                <a href="${pageContext.request.contextPath}/manager/categories" class="btn-back">Quay lại danh sách</a>
            </div>
        </body>

        </html>