<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<div id="cancelModal" class="modal" style="display: none">
  <div class="modal-content">
    <span class="close" onclick="closeCancelModal()">&times;</span>
    <h3>Lý do hủy món</h3>
    <form id="cancelForm" method="post">
      <input type="hidden" name="status" value="CANCELLED" />
      <input type="hidden" name="redirectQuery" id="cancelModalRedirectQuery" />
      <textarea
        name="reason"
        id="cancelReason"
        required
        placeholder="Nhập lý do hủy món..."
      ></textarea>
      <div
        style="
          margin-top: 12px;
          text-align: right;
          display: flex;
          justify-content: flex-end;
          gap: 8px;
        "
      >
        <button type="button" onclick="closeCancelModal()">Đóng</button>
        <button type="button" class="btn" onclick="submitCancelReason()">
          Xác nhận
        </button>
      </div>
    </form>
  </div>
</div>
