<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn Bàn Phụ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee-style.css">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <h2>Chọn Bàn Phụ cho Bàn ${currentTable.tableNumber}</h2>
                
                <!-- Hiển thị thông báo -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
                
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>
                
                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/employee/table/${currentTable.tableId}/add-additional-tables" method="post">
                            <p><strong>Bàn hiện tại:</strong> T${currentTable.tableNumber} (Tầng ${currentTable.floor})</p>
                            
                            <h5>Chọn các bàn phụ:</h5>
                            
                            <c:if test="${empty availableTables}">
                                <div class="alert alert-warning">
                                    Không có bàn trống nào để thêm vào phiên phục vụ này.
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty availableTables}">
                                <div class="row">
                                    <c:forEach var="table" items="${availableTables}">
                                        <div class="col-md-3 mb-3">
                                            <div class="card h-100">
                                                <div class="card-body text-center">
                                                    <h6>Bàn ${table.tableNumber}</h6>
                                                    <p class="small">
                                                        Tầng ${table.floor} - ${table.capacity} chỗ<br>
                                                        <span class="badge badge-success">${table.status}</span>
                                                    </p>
                                                    <div class="form-check">
                                                        <input class="form-check-input" 
                                                               type="checkbox" 
                                                               name="additionalTableIds" 
                                                               value="${table.tableId}" 
                                                               id="table_${table.tableId}">
                                                        <label class="form-check-label" for="table_${table.tableId}">
                                                            Chọn bàn này
                                                        </label>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <div class="mt-3">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-plus"></i> Thêm Bàn Phụ
                                    </button>
                                </div>
                            </c:if>
                            
                            <div class="mt-3">
                                <a href="${pageContext.request.contextPath}/employee/table/${currentTable.tableId}/menu" 
                                   class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại Menu
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap.min.js"></script>
</body>
</html> 