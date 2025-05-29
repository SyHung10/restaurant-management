# 📁 Cấu trúc thư mục Resources - Nhà hàng Hùng Tuấn

## 🎯 Mục đích
Tài liệu này mô tả cách tổ chức CSS và JavaScript trong dự án để dễ dàng bảo trì và phát triển.

## 📂 Cấu trúc thư mục

```
src/main/webapp/resources/
├── css/
│   ├── manager/           # CSS cho giao diện quản lý
│   │   ├── global.css     # CSS chung cho tất cả trang manager
│   │   ├── dashboard.css  # Dashboard specific
│   │   ├── menu-list.css  # Danh sách món ăn (chưa tạo)
│   │   ├── menu-form.css  # Form món ăn
│   │   ├── table-list.css # Danh sách bàn
│   │   ├── table-form.css # Form bàn
│   │   ├── employee-list.css  # Danh sách nhân viên (chưa tạo)
│   │   ├── employee-form.css  # Form nhân viên
│   │   ├── promotion-list.css # Danh sách khuyến mãi
│   │   ├── promotion-form.css # Form khuyến mãi
│   │   ├── form.css       # CSS chung cho các form
│   │   └── common.css     # CSS components chung
│   │
│   ├── employee/          # CSS cho giao diện nhân viên
│   │   ├── menu-style.css # Giao diện menu/order
│   │   ├── tables.css     # Quản lý bàn nhân viên
│   │   ├── payment-modal.css      # Modal thanh toán
│   │   ├── add-table-modal.css    # Modal thêm bàn
│   │   ├── kitchen.css    # Giao diện bếp
│   │   └── menu-order-status.css  # Trạng thái order
│   │
│   └── common/            # CSS dùng chung toàn ứng dụng
│       ├── style.css      # CSS base chung
│       └── login.css      # Trang đăng nhập
│
├── js/
│   ├── manager/           # JavaScript cho giao diện quản lý
│   │   ├── dashboard.js
│   │   ├── menu-list.js
│   │   ├── menu-form.js
│   │   ├── table-list.js
│   │   ├── table-form.js
│   │   ├── employee-list.js
│   │   ├── employee-form.js
│   │   ├── promotion-list.js
│   │   └── promotion-form.js
│   │
│   ├── employee/          # JavaScript cho giao diện nhân viên
│   │   ├── menu-no-ajax.js     # Menu không dùng AJAX
│   │   ├── payment-modal.js    # Logic thanh toán
│   │   └── add-table-modal.js  # Logic thêm bàn
│   │
│   └── common/            # JavaScript dùng chung
│       └── script.js      # JS utilities chung
│
└── images/                # Thư mục ảnh resources
```

## 🔧 Cách sử dụng trong JSP

### Manager Pages
```jsp
<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/global.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/manager/dashboard.css">

<!-- JavaScript -->
<script src="${pageContext.request.contextPath}/resources/js/manager/dashboard.js"></script>
```

### Employee Pages
```jsp
<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/employee/menu-style.css">

<!-- JavaScript -->
<script src="${pageContext.request.contextPath}/resources/js/employee/menu-no-ajax.js"></script>
```

### Common Resources
```jsp
<!-- CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common/login.css">

<!-- JavaScript -->
<script src="${pageContext.request.contextPath}/resources/js/common/script.js"></script>
```

## ✅ Đã cập nhật
- ✅ Tất cả JSP files trong `/manager/` đã cập nhật đường dẫn
- ✅ Promotion-list.jsp và promotion-form.jsp đã đúng cấu trúc
- ✅ Di chuyển tất cả CSS/JS vào thư mục con tương ứng
- ✅ CSS global đổi tên từ `manager-global.css` thành `global.css`

## 🚀 Lợi ích
1. **Dễ bảo trì**: Tách biệt rõ ràng giữa manager và employee
2. **Tái sử dụng**: CSS/JS chung ở common folder
3. **Mở rộng**: Dễ thêm module mới mà không ảnh hưởng hiện tại
4. **Team work**: Nhiều người có thể làm việc song song trên các module khác nhau

## 📝 Ghi chú
- Các file CSS specific cho từng trang (VD: menu-list.css, employee-list.css) có thể tạo thêm khi cần
- Font Awesome và external libraries vẫn load từ CDN
- Tất cả đường dẫn đã được cập nhật trong các JSP files

## 🔄 Cập nhật trong tương lai
Khi thêm trang mới:
1. Tạo CSS trong thư mục con tương ứng
2. Tạo JS trong thư mục con tương ứng  
3. Include đúng đường dẫn trong JSP
4. Cập nhật tài liệu này 