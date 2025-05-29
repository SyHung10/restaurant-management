<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <div class="modal-header">
            <h5 class="modal-title">
                <i class="fas fa-ban"></i> Hủy món #${detailId}
            </h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <form id="cancelForm" action="${pageContext.request.contextPath}/kitchen/orderDetail/${detailId}/cancel"
                method="post">
                <div class="form-group">
                    <label for="reason">
                        <i class="fas fa-comment-alt"></i> Lý do hủy:
                    </label>
                    <textarea class="form-control" id="reason" name="reason" rows="3"
                        placeholder="Nhập lý do hủy món..." required></textarea>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                <i class="fas fa-times"></i> Đóng
            </button>
            <button type="submit" form="cancelForm" class="btn btn-danger">
                <i class="fas fa-check"></i> Xác nhận hủy
            </button>
        </div>