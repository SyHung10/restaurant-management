# Hướng dẫn Validation Form Khuyến mãi

## 🎯 Tổng quan

Đã triển khai hệ thống validation hoàn chỉnh cho form thêm/sửa khuyến mãi tại:
`http://localhost:8081/NHAHANG_HUNGTUAN2/manager/promotions/new`

## 🔍 Các validation đã implement

### 1. **Client-side Validation (JavaScript)**

#### ✅ **Validation cơ bản:**
- **Tên khuyến mãi**: Bắt buộc nhập
- **Mã khuyến mãi**: 
  - Bắt buộc nhập
  - Chỉ chữ cái, số, dấu gạch ngang, gạch dưới
  - Từ 3-20 ký tự
  - Tự động uppercase
- **Phạm vi áp dụng**: Bắt buộc chọn
- **Trạng thái**: Bắt buộc chọn

#### ✅ **Validation logic phức tạp:**

**Thời gian:**
- Thời gian bắt đầu không được trong quá khứ (chỉ với khuyến mãi mới)
- Thời gian kết thúc không được trong quá khứ
- Thời gian kết thúc phải sau thời gian bắt đầu
- Khuyến mãi phải kéo dài ít nhất 1 giờ

**Giảm giá:**
- Phải nhập ít nhất một loại (phần trăm hoặc giá trị cố định)
- Không được nhập cả hai loại cùng lúc
- Phần trăm: 0.01% - 100%
- Giá trị cố định: > 0 và ≤ 10,000,000 VNĐ

**ID đối tượng:**
- Bắt buộc khi chọn phạm vi "Theo danh mục" hoặc "Theo món ăn"
- Phải là số nguyên dương
- Tự động ẩn/hiện khi thay đổi phạm vi

**Số lượng:**
- Số lần sử dụng tối đa: > 0 và ≤ 999,999
- Đơn hàng tối thiểu: ≥ 0 và ≤ 100,000,000 VNĐ

#### ✅ **UX Features:**
- **Real-time validation**: Kiểm tra ngay khi nhập/rời khỏi field
- **Visual feedback**: Đổi màu border, shake animation cho lỗi
- **Error messages**: Hiển thị cụ thể từng lỗi
- **Auto-correction**: Uppercase mã khuyến mãi, clear field khi chọn discount type
- **Confirm dialogs**: Cảnh báo với discount cao (>50% hoặc >1 triệu VNĐ)

### 2. **Server-side Validation (Java)**

#### ✅ **Security validation:**
- **Duplicate check**: Kiểm tra mã khuyến mãi trùng lặp
- **Input sanitization**: Trim spaces, validate format
- **Type safety**: NumberFormatException handling
- **SQL injection prevention**: Sử dụng prepared statements

#### ✅ **Business logic validation:**
- Tất cả validation của client-side
- **Database constraints**: Kiểm tra foreign key tồn tại
- **Comprehensive error messages**: Tổng hợp tất cả lỗi trong một message

## 📁 Files đã tạo/sửa

### 1. **JavaScript Validation**
```
src/main/webapp/resources/js/manager/promotion-form.js
```
- Form validation với 15+ rules
- Real-time validation 
- UX enhancements (auto-format, confirm dialogs)
- Accessibility support

### 2. **CSS Styling**
```
src/main/webapp/resources/css/manager/promotion-form.css
```
- Error states với animation
- Alert messages styling
- Responsive design
- Dark mode support

### 3. **Server Controller**
```
src/main/java/com/restaurant/controller/PromotionController.java
```
- Comprehensive server-side validation
- Flash message support
- Exception handling
- Duplicate voucher code check

### 4. **JSP Template**
```
src/main/webapp/WEB-INF/views/manager/promotion-form.jsp
```
- Flash message display
- Improved form structure
- Client-side integration

## 🧪 Test Cases

### Test Case 1: **Thời gian không hợp lệ**
```
Input:
- Thời gian bắt đầu: 2024-01-01 10:00
- Thời gian kết thúc: 2024-01-01 09:00

Expected:
❌ "Thời gian kết thúc phải sau thời gian bắt đầu"
```

### Test Case 2: **Discount logic**
```
Input:
- Phần trăm giảm: 25%
- Giá trị giảm: 50,000 VNĐ

Expected:
❌ "Chỉ được chọn một loại giảm giá"
```

### Test Case 3: **Mã khuyến mãi trùng**
```
Input:
- Mã khuyến mãi: "HAPPY20" (đã tồn tại)

Expected:
❌ "Mã khuyến mãi 'HAPPY20' đã tồn tại"
```

### Test Case 4: **Scope validation**
```
Input:
- Phạm vi: "Theo danh mục"
- ID đối tượng: (để trống)

Expected:
❌ "ID danh mục là bắt buộc khi chọn phạm vi áp dụng"
```

## ⚠️ Tuân thủ yêu cầu

### ✅ **Không vi phạm kiến trúc:**
- **KHÔNG dùng AJAX**: Tất cả validation là client-side thuần hoặc form submission
- **KHÔNG dùng API**: Server-side validation trong Spring MVC controller
- **Form submission truyền thống**: POST method với redirect
- **Server-side rendering**: Sử dụng JSP và RedirectAttributes

### ✅ **Spring MVC thuần:**
- Sử dụng `@RequestMapping`, `HttpServletRequest`
- RedirectAttributes cho flash messages
- Không dùng `@ResponseBody` hoặc JSON
- Traditional web app pattern

## 🚀 Cách sử dụng

### 1. **Tạo khuyến mãi mới:**
```
1. Truy cập: /manager/promotions/new
2. Điền form với validation real-time
3. Submit → Server validation
4. Redirect với success/error message
```

### 2. **Sửa khuyến mãi:**
```
1. Click "Sửa" từ danh sách khuyến mãi
2. Form load với dữ liệu cũ
3. Validation tương tự như tạo mới
4. Kiểm tra duplicate (trừ chính promotion đang sửa)
```

## 🎨 UI/UX Features

### Visual feedback:
- ✅ **Success state**: Border xanh, background nhạt
- ❌ **Error state**: Border đỏ, background đỏ nhạt, shake animation  
- ⚠️ **Warning icons**: Trong error messages
- 🎯 **Focus management**: Auto-scroll đến lỗi đầu tiên

### Accessibility:
- **Screen reader support**: ARIA labels
- **Keyboard navigation**: Tab order logical
- **High contrast mode**: Enhanced border width
- **Color blind friendly**: Icons + colors

### Responsive design:
- **Mobile optimized**: Single column layout
- **Touch friendly**: Larger buttons
- **Tablet support**: Adaptive grid

## 📊 Kết quả mong đợi

Sau khi implement validation này:

1. **Không thể tạo khuyến mãi không hợp lệ**
2. **User experience mượt mà** với feedback tức thì
3. **Dữ liệu database sạch** và đáng tin cậy
4. **Tuân thủ hoàn toàn** yêu cầu kiến trúc
5. **Maintainable code** dễ mở rộng và sửa chữa

## 🔮 Có thể mở rộng

- **Email notifications** khi tạo khuyến mãi
- **Bulk operations** với validation
- **Import/Export** với validation
- **Advanced scheduling** với cron validation
- **Multi-language** error messages 