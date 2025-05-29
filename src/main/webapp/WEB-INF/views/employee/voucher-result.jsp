<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
    <c:when test="${not empty voucherError}">
        <div class="voucher-result error">
            <p class="text-danger">${voucherError}</p>
        </div>
    </c:when>
    <c:otherwise>
        <div class="voucher-result ${isValid ? 'success' : 'error'}">
            <p class="${isValid ? 'text-success' : 'text-danger'}">${message}</p>
            <!-- Ẩn dữ liệu để JavaScript có thể đọc -->
            <c:if test="${isValid}">
                <span class="voucher-discount" style="display: none;"><fmt:formatNumber value="${voucherDiscount}" pattern="#,###"/>đ</span>
                <span class="final-amount" style="display: none;"><fmt:formatNumber value="${finalAmount}" pattern="#,###"/>đ</span>
            </c:if>
        </div>
    </c:otherwise>
</c:choose> 