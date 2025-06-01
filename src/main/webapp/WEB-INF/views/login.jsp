<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Đăng nhập - Hệ thống POS Nhà hàng</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/common/login.css"
    />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  </head>

  <body>
    <div class="login-container">
      <div class="login-header">
        <div class="restaurant-logo">🍴</div>
        <h1 class="login-title">Hệ thống POS</h1>
        <p class="login-subtitle">Nhà hàng Hưng Tuấn</p>
      </div>

      <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
      </c:if>

      <form
        action="${pageContext.request.contextPath}/login"
        method="post"
        class="login-form"
      >
        <div class="form-group">
          <label for="username" class="form-label">Tên đăng nhập</label>
          <input
            type="text"
            id="username"
            name="username"
            class="form-input"
            placeholder="Nhập tên đăng nhập"
            autocomplete="username"
            required
          />
        </div>

        <div class="form-group">
          <label for="password" class="form-label">Mật khẩu</label>
          <input
            type="password"
            id="password"
            name="password"
            class="form-input"
            placeholder="Nhập mật khẩu"
            autocomplete="current-password"
            required
          />
        </div>

        <button type="submit" class="submit-btn">Đăng nhập</button>
      </form>

      <div class="login-footer">
        <p>&copy; 2024 Nhà hàng Hưng Tuấn. Phiên bản 2.0</p>
      </div>
    </div>

    <script>
      // Simple form validation and UX improvements
      document.addEventListener("DOMContentLoaded", function () {
        const form = document.querySelector(".login-form");
        const inputs = document.querySelectorAll(".form-input");

        // Add floating label effect
        inputs.forEach((input) => {
          input.addEventListener("focus", function () {
            this.parentElement.classList.add("focused");
          });

          input.addEventListener("blur", function () {
            if (!this.value) {
              this.parentElement.classList.remove("focused");
            }
          });

          // Check if input has value on page load
          if (input.value) {
            input.parentElement.classList.add("focused");
          }
        });

        // Submit button loading state
        form.addEventListener("submit", function () {
          const submitBtn = document.querySelector(".submit-btn");
          submitBtn.innerHTML = "Đang đăng nhập...";
          submitBtn.disabled = true;
        });
      });
    </script>
  </body>
</html>
